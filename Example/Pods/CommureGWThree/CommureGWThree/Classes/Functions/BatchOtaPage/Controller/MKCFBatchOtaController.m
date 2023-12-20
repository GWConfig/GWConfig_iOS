//
//  MKCFBatchOtaController.m
//  CommureGWThree_Example
//
//  Created by aa on 2023/7/7.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCFBatchOtaController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import <SGQRCode/SGQRCode.h>

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"
#import "MKAlertView.h"

#import "MKHudManager.h"

#import "MKCFExcelDataManager.h"

#import "MKCFBatchOtaTableHeader.h"
#import "MKCFBatchUpdateCell.h"

#import "MKCFBatchOtaManager.h"
#import "MKCFBatchOtaModel.h"

#import "MKCFImportServerController.h"
#import "MKCFQRCodeController.h"

@interface MKCFBatchOtaController ()<UITableViewDelegate,
UITableViewDataSource,
MKCFImportServerControllerDelegate,
MKCFBatchOtaTableHeaderDelegate,
MKCFBatchUpdateCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)MKCFBatchOtaTableHeader *headerView;

@property (nonatomic, strong)NSMutableDictionary *macCache;

@property (nonatomic, strong)MKCFBatchOtaManager *otaManager;

@end

@implementation MKCFBatchOtaController

- (void)dealloc {
    NSLog(@"MKCFBatchOtaController销毁");
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
        MKCFBatchUpdateCellModel *cellModel = self.dataList[i];
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
    [self.otaManager startBatchOta:macList statusChangedBlock:^(NSString * _Nonnull macAddress, cf_batchOtaStatus status) {
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
    MKCFBatchUpdateCell *cell = [MKCFBatchUpdateCell initCellWithTableView:tableView];
    cell.dataModel = self.dataList[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - MKCFImportServerControllerDelegate
- (void)cf_selectedServerParams:(NSString *)fileName {
    [[MKHudManager share] showHUDWithTitle:@"Loading..." inView:self.view isPenetration:NO];
    [MKCFExcelDataManager parseBeaconOtaExcel:fileName sucBlock:^(NSArray<NSString *> * _Nonnull beaconList) {
        [[MKHudManager share] hide];
        [self.dataList removeAllObjects];
        [self.macCache removeAllObjects];
        NSInteger number = 20;
        if (beaconList.count < 20) {
            number = beaconList.count;
        }
        for (NSInteger i = 0; i < number; i ++) {
            MKCFBatchUpdateCellModel *cellModel = [[MKCFBatchUpdateCellModel alloc] init];
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

#pragma mark - MKCFBatchOtaTableHeaderDelegate
- (void)cf_urlValueChanged:(NSString *)url {
    self.otaManager.filePath = url;
}

- (void)cf_topicValueChanged:(NSString *)topic type:(NSInteger)type {
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

- (void)cf_listButtonPressed {
    MKCFImportServerController *vc = [[MKCFImportServerController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)cf_scanCodeButtonPressed {
    [SGPermission permissionWithType:SGPermissionTypeCamera completion:^(SGPermission * _Nonnull permission, SGPermissionStatus status) {
        if (status == SGPermissionStatusNotDetermined) {
            [permission request:^(BOOL granted) {
                if (granted) {
                    MKCFQRCodeController *vc = [[MKCFQRCodeController alloc] init];
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
            MKCFQRCodeController *vc = [[MKCFQRCodeController alloc] init];
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

#pragma mark - MKCFBatchUpdateCellDelegate
- (void)cf_batchUpdateCell_delete:(NSInteger)index {
    if (index >= self.dataList.count) {
        return;
    }
    @weakify(self);
    MKAlertViewAction *confirmAction = [[MKAlertViewAction alloc] initWithTitle:@"Confirm" handler:^{
        @strongify(self);
        MKCFBatchUpdateCellModel *cellModel = self.dataList[index];
        [self.dataList removeObject:cellModel];
        [self.macCache removeAllObjects];
        for (NSInteger i = 0; i < self.dataList.count; i ++) {
            MKCFBatchUpdateCellModel *cellModel = self.dataList[i];
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
    [alertView showAlertWithTitle:@"Waring!" message:msg notificationName:@"mk_cf_needDismissAlert"];
}

- (void)cf_batchUpdateCell_retry:(NSInteger)index {
    MKCFBatchUpdateCellModel *cellModel = self.dataList[index];
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
    MKCFBatchUpdateCellModel *cellModel = [[MKCFBatchUpdateCellModel alloc] init];
    cellModel.macAddress = macAddress;
    cellModel.status = 0;
    
    if (self.dataList.count > 0) {
        [self.dataList insertObject:cellModel atIndex:0];
    }else {
        [self.dataList addObject:cellModel];
    }
    
    [self.macCache removeAllObjects];
    
    for (NSInteger i = 0; i < self.dataList.count; i ++) {
        MKCFBatchUpdateCellModel *cellModel = self.dataList[i];
        cellModel.index = i;
        
        [self.macCache setObject:@(i) forKey:cellModel.macAddress];
    }
    [self.tableView reloadData];
}

- (void)updateCellWithMac:(NSString *)macAddress status:(cf_batchOtaStatus)status {
    NSNumber *index = self.macCache[macAddress];
    if (!ValidNum(index)) {
        [self.view showCentralToast:@"Current Device is not exsit!"];
        return;
    }
    MKCFBatchUpdateCellModel *cellModel = self.dataList[[index integerValue]];
    cellModel.status = status;
    [self.tableView mk_reloadRow:[index integerValue] inSection:0 withRowAnimation:UITableViewRowAnimationNone];
}

- (void)failed {
    MKAlertViewAction *confirmAction = [[MKAlertViewAction alloc] initWithTitle:@"OK" handler:^{
    }];
    NSString *msg = @"[Go to: Settings - Privacy - Camera - SGQRCode] Turn on the access switch.";
    MKAlertView *alertView = [[MKAlertView alloc] init];
    [alertView addAction:confirmAction];
    [alertView showAlertWithTitle:@"" message:msg notificationName:@"mk_cf_needDismissAlert"];
}

- (void)unknown {
    MKAlertViewAction *confirmAction = [[MKAlertViewAction alloc] initWithTitle:@"OK" handler:^{
    }];
    NSString *msg = @"We couldn't detect your camera.";
    MKAlertView *alertView = [[MKAlertView alloc] init];
    [alertView addAction:confirmAction];
    [alertView showAlertWithTitle:@"" message:msg notificationName:@"mk_cf_needDismissAlert"];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Batch OTA";
    [self.rightButton setImage:LOADICON(@"CommureGWThree", @"MKCFBatchOtaController", @"cf_saveIcon.png") forState:UIControlStateNormal];
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

- (MKCFBatchOtaTableHeader *)headerView {
    if (!_headerView) {
        _headerView = [[MKCFBatchOtaTableHeader alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 190.f)];
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

- (MKCFBatchOtaManager *)otaManager {
    if (!_otaManager) {
        _otaManager = [[MKCFBatchOtaManager alloc] init];
    }
    return _otaManager;
}

@end
