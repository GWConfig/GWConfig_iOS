//
//  MKCFBatchDfuBeaconController.m
//  CommureGWThree_Example
//
//  Created by aa on 2023/4/21.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCFBatchDfuBeaconController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import <SGQRCode/SGQRCode.h>

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "NSString+MKAdd.h"
#import "UITableView+MKAdd.h"

#import "MKHudManager.h"
#import "MKCustomUIAdopter.h"
#import "MKAlertView.h"

#import "MKCFMQTTDataManager.h"
#import "MKCFMQTTInterface.h"

#import "MKCFDeviceModeManager.h"
#import "MKCFDeviceModel.h"

#import "MKCFBatchUpdateCell.h"

#import "MKCFExcelDataManager.h"

#import "MKCFImportServerController.h"
#import "MKCFQRCodeController.h"

#import "MKCFBatchDfuBeaconModel.h"

#import "MKCFBatchDfuBeaconHeaderView.h"

@interface MKCFBatchDfuBeaconController ()<UITableViewDelegate,
UITableViewDataSource,
MKCFImportServerControllerDelegate,
MKCFBatchDfuBeaconHeaderViewDelegate,
MKCFBatchUpdateCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)MKCFBatchDfuBeaconModel *dataModel;

@property (nonatomic, strong)MKCFBatchDfuBeaconHeaderView *tableHeaderView;

@property (nonatomic, strong)NSMutableDictionary *macCache;

@property (nonatomic, strong)dispatch_source_t updateTimer;

@property (nonatomic, assign)NSInteger updateCount;

@end

@implementation MKCFBatchDfuBeaconController

- (void)dealloc {
    NSLog(@"MKCFBatchDfuBeaconController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.updateTimer) {
        dispatch_cancel(self.updateTimer);
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];

    //本页面禁止右划退出手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self loadSectionDatas];
}

#pragma mark - super method
- (void)rightButtonMethod {
    [self configDataToDevice];
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
    [MKCFExcelDataManager parseBeaconExcel:fileName sucBlock:^(NSArray<NSDictionary *> * _Nonnull beaconInfoList) {
        [[MKHudManager share] hide];
        [self.dataList removeAllObjects];
        [self.macCache removeAllObjects];
        NSInteger number = 20;
        if (beaconInfoList.count < 20) {
            number = beaconInfoList.count;
        }
        for (NSInteger i = 0; i < beaconInfoList.count; i ++) {
            NSDictionary *beaconDic = beaconInfoList[i];
            MKCFBatchUpdateCellModel *cellModel = [[MKCFBatchUpdateCellModel alloc] init];
            cellModel.macAddress = beaconDic[@"macAddress"];
            cellModel.status = mk_cf_batchUpdateStatus_normal;
            [self.dataList addObject:cellModel];
            [self.macCache setObject:@(i) forKey:beaconDic[@"macAddress"]];
        }
        [self.tableView reloadData];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
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

#pragma mark - MKCFBatchDfuBeaconHeaderViewDelegate
- (void)cf_firmwareUrlChanged:(NSString *)url {
    self.dataModel.firmwareUrl = url;
}

- (void)cf_dataFileUrlChanged:(NSString *)url {
    self.dataModel.dataUrl = url;
}

- (void)cf_dataPasswordChanged:(NSString *)password {
    self.dataModel.password = password;
}

- (void)cf_beaconListButtonPressed {
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

#pragma mark - note
- (void)receiveBeaconDfuResult:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user) || !ValidStr(user[@"device_info"][@"mac"]) || ![[MKCFDeviceModeManager shared].macAddress isEqualToString:user[@"device_info"][@"mac"]]) {
        return;
    }
    NSString *macAddress = user[@"data"][@"mac"];
    if (!ValidStr(macAddress)) {
        return;
    }
    NSNumber *indexNumber = self.macCache[macAddress];
    if (!ValidNum(indexNumber) || [indexNumber integerValue] >= self.dataList.count) {
        return;
    }
    
    self.updateCount = 0;
    
    NSInteger result = [user[@"data"][@"status"] integerValue];
    MKCFBatchUpdateCellModel *cellModel = self.dataList[[indexNumber integerValue]];
    if (result == 0) {
        cellModel.status = mk_cf_batchUpdateStatus_upgrading;
    }else if (result == 1) {
        cellModel.status = mk_cf_batchUpdateStatus_success;
    }
    [self.tableView mk_reloadRow:[indexNumber integerValue] inSection:0 withRowAnimation:UITableViewRowAnimationNone];
}

- (void)receiveBeaconBatchDfuResult:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user) || !ValidStr(user[@"device_info"][@"mac"]) || ![[MKCFDeviceModeManager shared].macAddress isEqualToString:user[@"device_info"][@"mac"]]) {
        return;
    }
    if (self.updateTimer) {
        dispatch_cancel(self.updateTimer);
    }
    self.updateCount = 0;
    [[MKHudManager share] hide];
    self.leftButton.enabled = YES;
    self.rightButton.enabled = YES;
    NSDictionary *dataDic = user[@"data"];
    NSInteger result = [dataDic[@"multi_dfu_result_code"] integerValue];
    NSArray *failureList = dataDic[@"fail_dev"];
    if (result == 1 && !ValidArray(failureList)) {
        //批量升级全部成功
        for (NSInteger i = 0; i < self.dataList.count; i ++) {
            MKCFBatchUpdateCellModel *cellModel = self.dataList[i];
            cellModel.status = mk_cf_batchUpdateStatus_success;
        }
    }else {
        //有部分升级失败
        for (NSInteger i = 0; i < failureList.count; i ++) {
            NSDictionary *dic = failureList[i];
            NSNumber *indexNumber = self.macCache[dic[@"mac"]];
            if (ValidNum(indexNumber) && [indexNumber integerValue] < self.dataList.count) {
                NSInteger reason = [dic[@"reason"] integerValue];
                MKCFBatchUpdateCellModel *cellModel = self.dataList[[indexNumber integerValue]];
                cellModel.status = (reason == 3 ? mk_cf_batchUpdateStatus_failed : mk_cf_batchUpdateStatus_timeout);
            }
        }
    }
    [self.tableView reloadData];
}

#pragma mark - event method
- (void)configDataToDevice {
    NSMutableArray *list = [NSMutableArray array];
    for (NSInteger i = 0; i < self.dataList.count; i ++) {
        MKCFBatchUpdateCellModel *cellModel = self.dataList[i];
        if (cellModel.status == 0) {
            //Wait
            [list addObject:cellModel.macAddress];
        }
    }
    if (list.count == 0 || list.count > 20) {
        [self.view showCentralToast:@"Beacon list MAC error"];
        return;
    }
    if (!ValidStr(self.dataModel.firmwareUrl) || self.dataModel.firmwareUrl.length > 256) {
        [self.view showCentralToast:@"Firmware file URL must be 1 - 256 Characters"];
        return;
    }
    if (!ValidStr(self.dataModel.dataUrl) || self.dataModel.dataUrl.length > 256) {
        [self.view showCentralToast:@"Init data file URL must be 1 - 256 Characters"];
        return;
    }
    if (self.dataModel.password.length > 16) {
        [self.view showCentralToast:@"Beacon password must be 0 - 16 Characters"];
        return;
    }
    [[MKHudManager share] showHUDWithTitle:@"Waiting..." inView:self.view isPenetration:NO];
    
    self.leftButton.enabled = NO;
    self.rightButton.enabled = NO;
    @weakify(self);
    [self.dataModel configDataWithBeaconList:list sucBlock:^{
        @strongify(self);
        [self addNotes];
        [self operateUpdateTimer];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        self.leftButton.enabled = YES;
        self.rightButton.enabled = YES;
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - private method
- (void)addNotes {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveBeaconDfuResult:)
                                                 name:MKCFReceiveBxpButtonDfuResultNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveBeaconBatchDfuResult:)
                                                 name:MKCFReceiveBxpButtonBatchDfuResultNotification
                                               object:nil];
}

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

- (void)operateUpdateTimer {
    if (self.updateTimer) {
        dispatch_cancel(self.updateTimer);
    }
    [[MKHudManager share] showHUDWithTitle:@"Waiting..." inView:self.view isPenetration:NO];
    self.updateCount = 0;
    self.updateTimer = nil;
    self.updateTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(self.updateTimer, dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), DISPATCH_TIME_FOREVER, 0);
    @weakify(self);
    dispatch_source_set_event_handler(self.updateTimer, ^{
        @strongify(self);
        if (self.updateCount == 300) {
            dispatch_cancel(self.updateTimer);
            self.updateCount = 0;
            moko_dispatch_main_safe((^{
                [[MKHudManager share] hide];
                self.leftButton.enabled = YES;
                self.rightButton.enabled = YES;
            }));
            return;
        }
        self.updateCount ++;
    });
    dispatch_resume(self.updateTimer);
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

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    
    
    [self.tableView reloadData];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Batch DFU Beacon";
    [self.rightButton setImage:LOADICON(@"CommureGWThree", @"MKCFBatchDfuBeaconController", @"cf_saveIcon.png") forState:UIControlStateNormal];
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
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableHeaderView = self.tableHeaderView;
    }
    return _tableView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (MKCFBatchDfuBeaconModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKCFBatchDfuBeaconModel alloc] init];
    }
    return _dataModel;
}

- (MKCFBatchDfuBeaconHeaderView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[MKCFBatchDfuBeaconHeaderView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 190.f)];
        _tableHeaderView.delegate = self;
    }
    return _tableHeaderView;
}

- (NSMutableDictionary *)macCache {
    if (!_macCache) {
        _macCache = [NSMutableDictionary dictionary];
    }
    return _macCache;
}

@end
