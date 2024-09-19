//
//  MKCGBatchDfuBeaconController.m
//  CommureGateway_Example
//
//  Created by aa on 2023/4/21.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCGBatchDfuBeaconController.h"

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

#import "MKCGMQTTDataManager.h"
#import "MKCGMQTTInterface.h"

#import "MKCGDeviceModeManager.h"
#import "MKCGDeviceModel.h"

#import "MKCGBatchUpdateCell.h"

#import "MKCGExcelDataManager.h"

#import "MKCGImportServerController.h"
#import "MKCGQRCodeController.h"

#import "MKCGBatchDfuBeaconModel.h"

#import "MKCGBatchDfuBeaconHeaderView.h"

@interface MKCGBatchDfuBeaconController ()<UITableViewDelegate,
UITableViewDataSource,
MKCGImportServerControllerDelegate,
MKCGBatchDfuBeaconHeaderViewDelegate,
MKCGBatchUpdateCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)MKCGBatchDfuBeaconModel *dataModel;

@property (nonatomic, strong)MKCGBatchDfuBeaconHeaderView *tableHeaderView;

@property (nonatomic, strong)NSMutableDictionary *macCache;

@property (nonatomic, strong)dispatch_source_t updateTimer;

@property (nonatomic, assign)NSInteger updateCount;

@end

@implementation MKCGBatchDfuBeaconController

- (void)dealloc {
    NSLog(@"MKCGBatchDfuBeaconController销毁");
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
    MKCGBatchUpdateCell *cell = [MKCGBatchUpdateCell initCellWithTableView:tableView];
    cell.dataModel = self.dataList[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - MKCGImportServerControllerDelegate
- (void)cg_selectedServerParams:(NSString *)fileName {
    [[MKHudManager share] showHUDWithTitle:@"Loading..." inView:self.view isPenetration:NO];
    [MKCGExcelDataManager parseBeaconExcel:fileName sucBlock:^(NSArray<NSDictionary *> * _Nonnull beaconInfoList) {
        [[MKHudManager share] hide];
        [self.dataList removeAllObjects];
        [self.macCache removeAllObjects];
        NSInteger number = 20;
        if (beaconInfoList.count < 20) {
            number = beaconInfoList.count;
        }
        for (NSInteger i = 0; i < number; i ++) {
            NSDictionary *beaconDic = beaconInfoList[i];
            MKCGBatchUpdateCellModel *cellModel = [[MKCGBatchUpdateCellModel alloc] init];
            cellModel.macAddress = beaconDic[@"macAddress"];
            cellModel.status = mk_cg_batchUpdateStatus_normal;
            [self.dataList addObject:cellModel];
            [self.macCache setObject:@(i) forKey:beaconDic[@"macAddress"]];
        }
        [self.tableView reloadData];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
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

#pragma mark - MKCGBatchDfuBeaconHeaderViewDelegate
- (void)cg_firmwareUrlChanged:(NSString *)url {
    self.dataModel.firmwareUrl = url;
}

- (void)cg_dataFileUrlChanged:(NSString *)url {
    self.dataModel.dataUrl = url;
}

- (void)cg_dataPasswordChanged:(NSString *)password {
    self.dataModel.password = password;
}

- (void)cg_beaconListButtonPressed {
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

#pragma mark - note
- (void)receiveBeaconDfuResult:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user) || !ValidStr(user[@"device_info"][@"mac"]) || ![[MKCGDeviceModeManager shared].macAddress isEqualToString:user[@"device_info"][@"mac"]]) {
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
    MKCGBatchUpdateCellModel *cellModel = self.dataList[[indexNumber integerValue]];
    if (result == 0) {
        cellModel.status = mk_cg_batchUpdateStatus_upgrading;
    }else if (result == 1) {
        cellModel.status = mk_cg_batchUpdateStatus_success;
    }
    [self.tableView mk_reloadRow:[indexNumber integerValue] inSection:0 withRowAnimation:UITableViewRowAnimationNone];
}

- (void)receiveBeaconBatchDfuResult:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user) || !ValidStr(user[@"device_info"][@"mac"]) || ![[MKCGDeviceModeManager shared].macAddress isEqualToString:user[@"device_info"][@"mac"]]) {
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
            MKCGBatchUpdateCellModel *cellModel = self.dataList[i];
            cellModel.status = mk_cg_batchUpdateStatus_success;
        }
    }else {
        //有部分升级失败
        for (NSInteger i = 0; i < failureList.count; i ++) {
            NSDictionary *dic = failureList[i];
            NSNumber *indexNumber = self.macCache[dic[@"mac"]];
            if (ValidNum(indexNumber) && [indexNumber integerValue] < self.dataList.count) {
                NSInteger reason = [dic[@"reason"] integerValue];
                MKCGBatchUpdateCellModel *cellModel = self.dataList[[indexNumber integerValue]];
                cellModel.status = (reason == 3 ? mk_cg_batchUpdateStatus_failed : mk_cg_batchUpdateStatus_timeout);
            }
        }
    }
    [self.tableView reloadData];
}

#pragma mark - event method
- (void)configDataToDevice {
    NSMutableArray *list = [NSMutableArray array];
    for (NSInteger i = 0; i < self.dataList.count; i ++) {
        MKCGBatchUpdateCellModel *cellModel = self.dataList[i];
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
                                                 name:MKCGReceiveBxpButtonDfuResultNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveBeaconBatchDfuResult:)
                                                 name:MKCGReceiveBxpButtonBatchDfuResultNotification
                                               object:nil];
}

- (void)addQRCode:(NSString *)macAddress {
    NSString *tempMac = macAddress;
    if ([macAddress containsString:@"/"] && [macAddress containsString:@"//"]) {
        NSArray *stringList = [macAddress componentsSeparatedByString:@"/"];
        if (stringList.count > 0) {
            tempMac = stringList.lastObject;
        }
    }
    if (self.dataList.count >= 20) {
        [self.view showCentralToast:@"Max 20 gateways are allowed!"];
        return;
    }
    NSNumber *contain = self.macCache[tempMac];
    if (contain) {
        //已经包含，重复添加
        [self.view showCentralToast:@"The current device is already in the list."];
        return;
    }
    MKCGBatchUpdateCellModel *cellModel = [[MKCGBatchUpdateCellModel alloc] init];
    cellModel.macAddress = tempMac;
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

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    
    
    [self.tableView reloadData];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Batch DFU Beacon";
    [self.rightButton setImage:LOADICON(@"CommureGateway", @"MKCGBatchDfuBeaconController", @"cg_saveIcon.png") forState:UIControlStateNormal];
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

- (MKCGBatchDfuBeaconModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKCGBatchDfuBeaconModel alloc] init];
    }
    return _dataModel;
}

- (MKCGBatchDfuBeaconHeaderView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[MKCGBatchDfuBeaconHeaderView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 190.f)];
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
