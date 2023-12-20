//
//  MKCGBatchOtaController.m
//  CommureGateway_Example
//
//  Created by aa on 2023/7/7.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCGBatchOtaController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import <SGQRCode/SGQRCode.h>

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"
#import "MKAlertView.h"

#import "MKHudManager.h"

#import "MKCGExcelDataManager.h"

#import "MKCGBatchOtaTableHeader.h"
#import "MKCGBatchUpdateCell.h"

#import "MKCGBatchOtaManager.h"
#import "MKCGBatchOtaModel.h"

#import "MKCGImportServerController.h"
#import "MKCGQRCodeController.h"

@interface MKCGBatchOtaController ()<UITableViewDelegate,
UITableViewDataSource,
MKCGImportServerControllerDelegate,
MKCGBatchOtaTableHeaderDelegate,
MKCGBatchUpdateCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)MKCGBatchOtaTableHeader *headerView;

@property (nonatomic, strong)NSMutableDictionary *macCache;

@property (nonatomic, strong)MKCGBatchOtaManager *otaManager;

@end

@implementation MKCGBatchOtaController

- (void)dealloc {
    NSLog(@"MKCGBatchOtaController销毁");
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
    
    //本页面禁止右划退出手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
}

#pragma mark - super method
- (void)rightButtonMethod {
    NSMutableArray *macList = [NSMutableArray array];
    for (NSInteger i = 0; i < self.dataList.count; i ++) {
        MKCGBatchUpdateCellModel *cellModel = self.dataList[i];
        if (cellModel.status == 0) {
            //Wait
            [macList addObject:cellModel.macAddress];
        }
    }
    if (macList.count == 0 || macList.count > 20) {
        [self.view showCentralToast:@"Gateway list error"];
        return;
    }
    if (!ValidStr(self.otaManager.filePath) || self.otaManager.filePath.length > 256) {
        [self.view showCentralToast:@"Firmware file URL must be 1 - 256 Characters"];
        return;
    }
    if (!ValidStr(self.otaManager.subTopic) || self.otaManager.subTopic.length > 128) {
        [self.view showCentralToast:@"Gateway subscribe topic must be 1 - 128 Characters"];
        return;
    }
    if (!ValidStr(self.otaManager.pubTopic) || self.otaManager.pubTopic.length > 128) {
        [self.view showCentralToast:@"Gateway publish topic must be 1 - 128 Characters"];
        return;
    }
    [[MKHudManager share] showHUDWithTitle:@"Waiting..." inView:self.view isPenetration:NO];
    self.leftButton.enabled = NO;
    self.rightButton.enabled = NO;
    
    @weakify(self);
    [self.otaManager startBatchOta:macList statusChangedBlock:^(NSString * _Nonnull macAddress, cg_batchOtaStatus status) {
        @strongify(self);
        [self updateCellWithMac:macAddress status:status];
    } completeBlock:^(BOOL complete) {
        @strongify(self);
        self.leftButton.enabled = YES;
        self.rightButton.enabled = YES;
        [[MKHudManager share] hide];
        if (!complete) {
            [self.view showCentralToast:@"Without Respond!"];
        }
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKCGBatchUpdateCell *cell = [MKCGBatchUpdateCell initCellWithTableView:tableView];
    cell.dataModel = self.dataList[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - MKCGImportServerControllerDelegate
- (void)cg_selectedServerParams:(NSString *)fileName {
    [[MKHudManager share] showHUDWithTitle:@"Loading..." inView:self.view isPenetration:NO];
    [MKCGExcelDataManager parseBeaconOtaExcel:fileName sucBlock:^(NSArray<NSString *> * _Nonnull beaconList) {
        [[MKHudManager share] hide];
        [self.dataList removeAllObjects];
        [self.macCache removeAllObjects];
        NSInteger number = 20;
        if (beaconList.count < 20) {
            number = beaconList.count;
        }
        for (NSInteger i = 0; i < number; i ++) {
            MKCGBatchUpdateCellModel *cellModel = [[MKCGBatchUpdateCellModel alloc] init];
            cellModel.macAddress = [beaconList[i] lowercaseString];
            cellModel.index = i;
            cellModel.status = 0;
            [self.dataList addObject:cellModel];
            [self.macCache setObject:@(i) forKey:beaconList[i]];
        }
        [self.tableView reloadData];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - MKCGBatchOtaTableHeaderDelegate
- (void)cg_urlValueChanged:(NSString *)url {
    self.otaManager.filePath = url;
}

- (void)cg_topicValueChanged:(NSString *)topic type:(NSInteger)type {
    if (type == 0) {
        //Gateway subscribe topic
        self.otaManager.subTopic = topic;
        return;
    }
    if (type == 1) {
        //Gateway publish topic
        self.otaManager.pubTopic = topic;
        return;
    }
}

- (void)cg_listButtonPressed {
    MKCGImportServerController *vc = [[MKCGImportServerController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)cg_scanCodeButtonPressed {
    [SGPermission permissionWithType:SGPermissionTypeCamera completion:^(SGPermission * _Nonnull permission, SGPermissionStatus status) {
        if (status == SGPermissionStatusNotDetermined) {
            [permission request:^(BOOL granted) {
                if (granted) {
                    MKCGQRCodeController *vc = [[MKCGQRCodeController alloc] init];
                    @weakify(self);
                    vc.scanMacAddressBlock = ^(NSString * _Nonnull macAddress) {
                        @strongify(self);
                        [self addQRCode:macAddress];
                    };
                    [self.navigationController pushViewController:vc animated:YES];

                } else {
                    NSLog(@"第一次授权失败");
                }
            }];
        } else if (status == SGPermissionStatusAuthorized) {
            NSLog(@"SGPermissionStatusAuthorized");
            MKCGQRCodeController *vc = [[MKCGQRCodeController alloc] init];
            @weakify(self);
            vc.scanMacAddressBlock = ^(NSString * _Nonnull macAddress) {
                @strongify(self);
                [self addQRCode:macAddress];
            };
            [self.navigationController pushViewController:vc animated:YES];

        } else if (status == SGPermissionStatusDenied) {
            NSLog(@"SGPermissionStatusDenied");
            [self failed];
        } else if (status == SGPermissionStatusRestricted) {
            NSLog(@"SGPermissionStatusRestricted");
            [self unknown];
        }

    }];
}

#pragma mark - MKCGBatchUpdateCellDelegate
- (void)cg_batchUpdateCell_delete:(NSInteger)index {
    if (index >= self.dataList.count) {
        return;
    }
    @weakify(self);
    MKAlertViewAction *confirmAction = [[MKAlertViewAction alloc] initWithTitle:@"Confirm" handler:^{
        @strongify(self);
        MKCGBatchUpdateCellModel *cellModel = self.dataList[index];
        [self.dataList removeObject:cellModel];
        [self.macCache removeAllObjects];
        for (NSInteger i = 0; i < self.dataList.count; i ++) {
            MKCGBatchUpdateCellModel *cellModel = self.dataList[i];
            cellModel.index = i;
            [self.macCache setObject:@(i) forKey:cellModel.macAddress];
        }
        [self.tableView reloadData];
    }];
    MKAlertViewAction *cancelAction = [[MKAlertViewAction alloc] initWithTitle:@"Cancel" handler:^{
    }];
    NSString *msg = @"Please confirm again whether to delete the MAC？";
    MKAlertView *alertView = [[MKAlertView alloc] init];
    [alertView addAction:confirmAction];
    [alertView addAction:cancelAction];
    [alertView showAlertWithTitle:@"Waring!" message:msg notificationName:@"mk_cg_needDismissAlert"];
}

- (void)cg_batchUpdateCell_retry:(NSInteger)index {
    MKCGBatchUpdateCellModel *cellModel = self.dataList[index];
    cellModel.status = 0;
    [self.tableView mk_reloadRow:index inSection:0 withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - interface

#pragma mark - private method
- (void)addQRCode:(NSString *)macAddress {
    if (self.dataList.count >= 20) {
        [self.view showCentralToast:@"Max 20 gateways are allowed!"];
        return;
    }
    NSNumber *contain = self.macCache[macAddress];
    if (contain) {
        //已经包含，重复添加
        [self.view showCentralToast:@"The current device is already in the list."];
        return;
    }
    MKCGBatchUpdateCellModel *cellModel = [[MKCGBatchUpdateCellModel alloc] init];
    cellModel.macAddress = macAddress;
    cellModel.status = 0;
    
    if (self.dataList.count > 0) {
        [self.dataList insertObject:cellModel atIndex:0];
    }else {
        [self.dataList addObject:cellModel];
    }
    
    [self.macCache removeAllObjects];
    
    for (NSInteger i = 0; i < self.dataList.count; i ++) {
        MKCGBatchUpdateCellModel *cellModel = self.dataList[i];
        cellModel.index = i;
        
        [self.macCache setObject:@(i) forKey:cellModel.macAddress];
    }
    [self.tableView reloadData];
}

- (void)updateCellWithMac:(NSString *)macAddress status:(cg_batchOtaStatus)status {
    NSNumber *index = self.macCache[macAddress];
    if (!ValidNum(index)) {
        [self.view showCentralToast:@"Current Device is not exsit!"];
        return;
    }
    MKCGBatchUpdateCellModel *cellModel = self.dataList[[index integerValue]];
    cellModel.status = status;
    [self.tableView mk_reloadRow:[index integerValue] inSection:0 withRowAnimation:UITableViewRowAnimationNone];
}

- (void)failed {
    MKAlertViewAction *confirmAction = [[MKAlertViewAction alloc] initWithTitle:@"OK" handler:^{
    }];
    NSString *msg = @"[Go to: Settings - Privacy - Camera - SGQRCode] Turn on the access switch.";
    MKAlertView *alertView = [[MKAlertView alloc] init];
    [alertView addAction:confirmAction];
    [alertView showAlertWithTitle:@"" message:msg notificationName:@"mk_cg_needDismissAlert"];
}

- (void)unknown {
    MKAlertViewAction *confirmAction = [[MKAlertViewAction alloc] initWithTitle:@"OK" handler:^{
    }];
    NSString *msg = @"We couldn't detect your camera.";
    MKAlertView *alertView = [[MKAlertView alloc] init];
    [alertView addAction:confirmAction];
    [alertView showAlertWithTitle:@"" message:msg notificationName:@"mk_cg_needDismissAlert"];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Batch OTA";
    [self.rightButton setImage:LOADICON(@"CommureGateway", @"MKCGBatchOtaController", @"cg_saveIcon.png") forState:UIControlStateNormal];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
    }];
}

#pragma mark - getter
- (MKBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = RGBCOLOR(242, 242, 242);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableHeaderView = self.headerView;
    }
    return _tableView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (MKCGBatchOtaTableHeader *)headerView {
    if (!_headerView) {
        _headerView = [[MKCGBatchOtaTableHeader alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 190.f)];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (NSMutableDictionary *)macCache {
    if (!_macCache) {
        _macCache = [NSMutableDictionary dictionary];
    }
    return _macCache;
}

- (MKCGBatchOtaManager *)otaManager {
    if (!_otaManager) {
        _otaManager = [[MKCGBatchOtaManager alloc] init];
    }
    return _otaManager;
}

@end
