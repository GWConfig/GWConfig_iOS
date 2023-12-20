//
//  MKCFDeviceDataController.m
//  CommureGWThree_Example
//
//  Created by aa on 2023/2/4.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCFDeviceDataController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"
#import "NSDictionary+MKAdd.h"

#import "MKHudManager.h"

#import "MKCFMQTTDataManager.h"
#import "MKCFMQTTInterface.h"

#import "MKCFDeviceModeManager.h"
#import "MKCFDeviceModel.h"

#import "MKCFDeviceDataPageHeaderView.h"
#import "MKCFDeviceDataPageCell.h"
#import "MKCFFilterTestAlert.h"
#import "MKCFFilterTestResultAlert.h"

#import "MKCFSettingController.h"
#import "MKCFUploadOptionController.h"
#import "MKCFManageBleDevicesController.h"
#import "MKCFDeviceConnectedController.h"

static NSTimeInterval const kRefreshInterval = 0.5f;

@interface MKCFDeviceDataController ()<UITableViewDelegate,
UITableViewDataSource,
MKCFDeviceDataPageHeaderViewDelegate,
MKCFReceiveDeviceDatasDelegate>

@property (nonatomic, strong)MKCFDeviceDataPageHeaderView *headerView;

@property (nonatomic, strong)MKCFDeviceDataPageHeaderViewModel *headerModel;

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

/// 定时刷新
@property (nonatomic, assign)CFRunLoopObserverRef observerRef;
//不能立即刷新列表，降低刷新频率
@property (nonatomic, assign)BOOL isNeedRefresh;

@property (nonatomic, strong)dispatch_source_t filterTimer;

@property (nonatomic, assign)NSInteger filterTime;

@property (nonatomic, assign)NSInteger alermStatus;

@property (nonatomic, assign)NSInteger totalAlarmStatus;

@end

@implementation MKCFDeviceDataController

- (void)dealloc {
    NSLog(@"MKCFDeviceDataController销毁");
    [MKCFDeviceModeManager sharedDealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //移除runloop的监听
    CFRunLoopRemoveObserver(CFRunLoopGetCurrent(), self.observerRef, kCFRunLoopCommonModes);
    if (self.filterTimer) {
        dispatch_cancel(self.filterTimer);
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [MKCFMQTTDataManager shared].dataDelegate = nil;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
    if (self.headerModel.isOn) {
        [MKCFMQTTDataManager shared].dataDelegate = self;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDataFromServer];
    [self runloopObserver];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveDeviceNameChanged:)
                                                 name:@"mk_cf_deviceNameChangedNotification"
                                               object:nil];
}

#pragma mark - super method
- (void)rightButtonMethod {
    MKCFSettingController *vc = [[MKCFSettingController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKCFDeviceDataPageCellModel *cellModel = self.dataList[indexPath.row];
    return [cellModel fetchCellHeight];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKCFDeviceDataPageCell *cell = [MKCFDeviceDataPageCell initCellWithTableView:tableView];
    cell.dataModel = self.dataList[indexPath.row];
    return cell;
}

#pragma mark - MKCFDeviceDataPageHeaderViewDelegate

- (void)cf_updateLoadButtonAction {
    MKCFUploadOptionController *vc = [[MKCFUploadOptionController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)cf_scannerStatusChanged:(BOOL)isOn {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    [MKCFMQTTInterface cf_configScanSwitchStatus:isOn
                                      macAddress:[MKCFDeviceModeManager shared].macAddress
                                           topic:[MKCFDeviceModeManager shared].subscribedTopic
                                        sucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        self.headerModel.isOn = isOn;
        [self updateStatus];
    }
                                     failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)cf_manageBleDeviceAction {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    [MKCFMQTTInterface cf_readGatewayBleConnectStatusWithMacAddress:[MKCFDeviceModeManager shared].macAddress
                                                              topic:[MKCFDeviceModeManager shared].subscribedTopic
                                                           sucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        NSArray *deviceList = returnData[@"data"][@"mac"];
        if (ValidArray(deviceList)) {
            //网关已经连接设备
            [self readConnectedDeviceInfoWithBleMac:deviceList[0]];
            return;
        }
        //网关没有连接设备
        MKCFManageBleDevicesController *vc = [[MKCFManageBleDevicesController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
                                                        failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)cf_filterTestButtonAction {
    MKCFFilterTestAlert *alertView = [[MKCFFilterTestAlert alloc] init];
    [alertView showWithHandler:^(NSString * duration, NSString * alarmStatus) {
        if (!ValidStr(duration) || [duration integerValue] < 10 || [duration integerValue] > 600) {
            [self.view showCentralToast:@"The duration must be 10-600"];
            return;
        }
        if (!ValidStr(alarmStatus) || !([alarmStatus isEqualToString:@"01"] || [alarmStatus isEqualToString:@"02"] || [alarmStatus isEqualToString:@"03"])) {
            [self.view showCentralToast:@"The alarm status must be 01/02/03"];
            return;
        }
        self.filterTime = [duration integerValue];
        self.alermStatus = [alarmStatus integerValue];
        [self operatefilterTimer];
    }];
}

#pragma mark - MKCFReceiveDeviceDatasDelegate
- (void)mk_cf_receiveDeviceDatas:(NSDictionary *)data {
    if (!ValidDict(data) || !ValidStr(data[@"device_info"][@"mac"]) || ![[MKCFDeviceModeManager shared].macAddress isEqualToString:data[@"device_info"][@"mac"]]) {
        return;
    }
    NSArray *tempList = data[@"data"];
    if (!ValidArray(tempList)) {
        return;
    }
    for (NSDictionary *dic in tempList) {
        if (self.alermStatus > 0 && [dic[@"alarm_status"] integerValue] == self.alermStatus) {
            self.totalAlarmStatus ++;
        }
        NSString *jsonString = [self convertToJsonData:dic];
        if (ValidStr(jsonString)) {
            MKCFDeviceDataPageCellModel *cellModel = [[MKCFDeviceDataPageCellModel alloc] init];
            cellModel.msg = jsonString;
            if (self.dataList.count == 0) {
                [self.dataList addObject:cellModel];
            }else {
                [self.dataList insertObject:cellModel atIndex:0];
            }
        }
    }
    [self needRefreshList];
}

- (NSString *)convertToJsonData:(NSDictionary *)dict{
    NSError *error = nil;
    NSData *policyData = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:&error];
    if(!policyData && error){
        return @"";
    }
    //NSJSONSerialization converts a URL string from http://... to http:\/\/... remove the extra escapes
    NSString *policyStr = [[NSString alloc] initWithData:policyData encoding:NSUTF8StringEncoding];
    policyStr = [policyStr stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
    return policyStr;
}


- (void)receiveDeviceNameChanged:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user) || !ValidStr(user[@"macAddress"]) || ![[MKCFDeviceModeManager shared].macAddress isEqualToString:user[@"macAddress"]]) {
        return;
    }
    self.defaultTitle = user[@"deviceName"];
}

#pragma mark - interface
- (void)readDataFromServer {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    [MKCFMQTTInterface cf_readScanSwitchStatusWithMacAddress:[MKCFDeviceModeManager shared].macAddress
                                                       topic:[MKCFDeviceModeManager shared].subscribedTopic
                                                    sucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        self.headerModel.isOn = ([returnData[@"data"][@"scan_switch"] integerValue] == 1);
        self.headerView.dataModel = self.headerModel;
        [self updateStatus];
    }
                                                 failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)readConnectedDeviceInfoWithBleMac:(NSString *)bleMac {
    //BXP-Button
    [[MKHudManager share] showHUDWithTitle:@"Connecting..." inView:self.view isPenetration:NO];
    [MKCFMQTTInterface cf_readBXPButtonConnectedDeviceInfoWithBleMacAddress:bleMac macAddress:[MKCFDeviceModeManager shared].macAddress topic:[MKCFDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        MKCFDeviceConnectedController *vc = [[MKCFDeviceConnectedController alloc] init];
        vc.deviceBleInfo = returnData;
        [self.navigationController pushViewController:vc animated:YES];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - private method

/// 当扫描状态发生改变的时候，需要动态刷新UI，如果打开则添加扫描数据监听，如果关闭，则移除扫描数据监听
- (void)updateStatus {
    [self.dataList removeAllObjects];
    [self.headerView setDataModel:self.headerModel];
    [self.headerView updateTotalNumbers:0];
    [self.tableView reloadData];
    if (self.headerModel.isOn) {
        //打开
        [MKCFMQTTDataManager shared].dataDelegate = self;
        return;
    }
    //关闭状态
    [MKCFMQTTDataManager shared].dataDelegate = nil;
}

- (void)operatefilterTimer {
    if (self.filterTimer) {
        dispatch_cancel(self.filterTimer);
    }
    [[MKHudManager share] showHUDWithTitle:@"Waiting..." inView:self.view isPenetration:NO];
    self.totalAlarmStatus = 0;
    self.filterTimer = nil;
    self.filterTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(self.filterTimer, dispatch_time(DISPATCH_TIME_NOW, self.filterTime * NSEC_PER_SEC), DISPATCH_TIME_FOREVER, 0);
    @weakify(self);
    dispatch_source_set_event_handler(self.filterTimer, ^{
        @strongify(self);
        dispatch_cancel(self.filterTimer);
        moko_dispatch_main_safe((^{
            [[MKHudManager share] hide];
            self.filterTime = 0;
            self.alermStatus = 0;
            MKCFFilterTestResultAlert *alertView = [[MKCFFilterTestResultAlert alloc] init];
            [alertView show:self.totalAlarmStatus];
        }));
    });
    dispatch_resume(self.filterTimer);
}

#pragma mark - 定时刷新

- (void)needRefreshList {
    //标记需要刷新
    self.isNeedRefresh = YES;
    //唤醒runloop
    CFRunLoopWakeUp(CFRunLoopGetMain());
}

- (void)runloopObserver {
    @weakify(self);
    __block NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    self.observerRef = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        @strongify(self);
        if (activity == kCFRunLoopBeforeWaiting) {
            //runloop空闲的时候刷新需要处理的列表,但是需要控制刷新频率
            NSTimeInterval currentInterval = [[NSDate date] timeIntervalSince1970];
            if (currentInterval - timeInterval < kRefreshInterval) {
                return;
            }
            timeInterval = currentInterval;
            if (self.isNeedRefresh) {
                [self.tableView reloadData];
                self.headerView.dataModel = self.headerModel;
                [self.headerView updateTotalNumbers:self.dataList.count];
                self.isNeedRefresh = NO;
            }
        }
    });
    //添加监听，模式为kCFRunLoopCommonModes
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), self.observerRef, kCFRunLoopCommonModes);
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = [MKCFDeviceModeManager shared].deviceName;
    [self.rightButton setImage:LOADICON(@"CommureGWThree", @"MKCFDeviceDataController", @"cf_moreIcon.png") forState:UIControlStateNormal];
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

- (MKCFDeviceDataPageHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[MKCFDeviceDataPageHeaderView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 200.f)];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (MKCFDeviceDataPageHeaderViewModel *)headerModel {
    if (!_headerModel) {
        _headerModel = [[MKCFDeviceDataPageHeaderViewModel alloc] init];
    }
    return _headerModel;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

@end
