//
//  MKCGScanPageController.m
//  CommureGateway_Example
//
//  Created by aa on 2023/2/7.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCGScanPageController.h"

#import <CoreBluetooth/CoreBluetooth.h>

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "NSObject+MKModel.h"

#import "MKHudManager.h"
#import "MKCustomUIAdopter.h"
#import "MKAlertView.h"

#import "MKBLEBaseSDKAdopter.h"

#import "MKCGBLESDK.h"

#import "MKCGBleMqttConfigSelectController.h"
#import "MKCGConfiguredGatewayController.h"

#import "MKCGScanPageCell.h"

#import "MKCGScanPageModel.h"

static NSString *const localPasswordKey = @"mk_cg_passwordKey";

static NSTimeInterval const kRefreshInterval = 0.5f;

@interface MKCGScanPageController ()<UITableViewDelegate,
UITableViewDataSource,
mk_cg_centralManagerScanDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)UIImageView *refreshIcon;

@property (nonatomic, strong)dispatch_source_t scanTimer;

/// 定时刷新
@property (nonatomic, assign)CFRunLoopObserverRef observerRef;
//扫描到新的设备不能立即刷新列表，降低刷新频率
@property (nonatomic, assign)BOOL isNeedRefresh;

@property (nonatomic, strong)NSMutableDictionary *deviceCache;

/// 保存当前密码输入框ascii字符部分
@property (nonatomic, copy)NSString *asciiText;

@property (nonatomic, strong)UIView *addView;

@end

@implementation MKCGScanPageController

- (void)dealloc {
    NSLog(@"MKCGScanPageController销毁");
    //移除runloop的监听
    CFRunLoopRemoveObserver(CFRunLoopGetCurrent(), self.observerRef, kCFRunLoopCommonModes);
    [[MKCGCentralManager shared] stopScan];
    [MKCGCentralManager sharedDealloc];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self rightButtonMethod];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self runloopObserver];
    [MKCGCentralManager shared].delegate = self;
}

#pragma mark - super method
- (void)rightButtonMethod {
    if ([MKCGCentralManager shared].centralStatus != mk_cg_centralManagerStatusEnable) {
        [self.view showCentralToast:@"The current system of bluetooth is not available!"];
        return;
    }
    self.rightButton.selected = !self.rightButton.selected;
    [self.refreshIcon.layer removeAnimationForKey:@"mk_refreshAnimationKey"];
    if (!self.rightButton.isSelected) {
        //停止扫描
        [[MKCGCentralManager shared] stopScan];
        if (self.scanTimer) {
            dispatch_cancel(self.scanTimer);
        }
        return;
    }
    [self.dataList removeAllObjects];
    [self.deviceCache removeAllObjects];
    [self.tableView reloadData];
    [self.refreshIcon.layer addAnimation:[MKCustomUIAdopter refreshAnimation:2.f] forKey:@"mk_refreshAnimationKey"];
    [self scanTimerRun];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self connectDeviceWithModel:self.dataList[indexPath.row]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MKCGScanPageCell *cell = [MKCGScanPageCell initCellWithTableView:tableView];
    cell.dataModel = self.dataList[indexPath.row];
    return cell;
}

#pragma mark - mk_cg_centralManagerScanDelegate

- (void)mk_cg_receiveDevice:(NSDictionary *)deviceModel {
    MKCGScanPageModel *dataModel = [MKCGScanPageModel mk_modelWithJSON:deviceModel];
    
    [self updateDataWithDeviceModel:dataModel];
}

- (void)mk_cg_stopScan {
    if (self.rightButton.isSelected) {
        [self.refreshIcon.layer removeAnimationForKey:@"mk_refreshAnimationKey"];
        [self.rightButton setSelected:NO];
    }
}

#pragma mark - event method
- (void)addConfiguredDevice {
    MKCGConfiguredGatewayController *vc = [[MKCGConfiguredGatewayController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 刷新
- (void)startScanDevice {
    self.rightButton.selected = NO;
    [self rightButtonMethod];
}

- (void)scanTimerRun{
    if (self.scanTimer) {
        dispatch_cancel(self.scanTimer);
    }
    [[MKCGCentralManager shared] startScan];
    self.scanTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,dispatch_get_global_queue(0, 0));
    //开始时间
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, 60 * NSEC_PER_SEC);
    //间隔时间
    uint64_t interval = 60 * NSEC_PER_SEC;
    dispatch_source_set_timer(self.scanTimer, start, interval, 0);
    @weakify(self);
    dispatch_source_set_event_handler(self.scanTimer, ^{
        @strongify(self);
        [[MKCGCentralManager shared] stopScan];
        [self needRefreshList];
    });
    dispatch_resume(self.scanTimer);
}

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
                self.isNeedRefresh = NO;
            }
        }
    });
    //添加监听，模式为kCFRunLoopCommonModes
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), self.observerRef, kCFRunLoopCommonModes);
}

- (void)updateDataWithDeviceModel:(MKCGScanPageModel *)deviceModel{
    [self.deviceCache setObject:deviceModel forKey:deviceModel.peripheral.identifier];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"rssi" ascending:NO];
    NSArray *objList = [[self.deviceCache allValues] sortedArrayUsingDescriptors:@[sortDescriptor]];
    [self.dataList removeAllObjects];
    [self.dataList addObjectsFromArray:objList];
    
    [self needRefreshList];
}

#pragma mark - 连接部分
- (void)connectDeviceWithModel:(MKCGScanPageModel *)deviceModel {
    //停止扫描
    [self.refreshIcon.layer removeAnimationForKey:@"mk_refreshAnimationKey"];
    [[MKCGCentralManager shared] stopScan];
    if (self.scanTimer) {
        dispatch_cancel(self.scanTimer);
    }
    
    @weakify(self);
    MKAlertViewAction *cancelAction = [[MKAlertViewAction alloc] initWithTitle:@"Cancel" handler:^{
        @strongify(self);
        self.rightButton.selected = NO;
        [self rightButtonMethod];
    }];
    
    MKAlertViewAction *confirmAction = [[MKAlertViewAction alloc] initWithTitle:@"OK" handler:^{
        @strongify(self);
        [self connectDevice:deviceModel];
    }];
    NSString *localPassword = [[NSUserDefaults standardUserDefaults] objectForKey:localPasswordKey];
    self.asciiText = localPassword;
    MKAlertViewTextField *textField = [[MKAlertViewTextField alloc] initWithTextValue:SafeStr(localPassword)
                                                                          placeholder:@"The password is 6 ~ 10 characters."
                                                                        textFieldType:mk_normal
                                                                            maxLength:10
                                                                              handler:^(NSString * _Nonnull text) {
        @strongify(self);
        self.asciiText = text;
    }];
    
    NSString *msg = @"Please enter connection password.";
    MKAlertView *alertView = [[MKAlertView alloc] init];
    [alertView addAction:cancelAction];
    [alertView addAction:confirmAction];
    [alertView addTextField:textField];
    [alertView showAlertWithTitle:@"Enter password" message:msg notificationName:@"mk_sp_needDismissAlert"];
}

- (void)connectDevice:(MKCGScanPageModel *)deviecModel {
    NSString *password = self.asciiText;
    if (!ValidStr(password) || password.length > 10 || password.length < 6) {
        [self.view showCentralToast:@"The password should be 6-10 characters."];
        return;
    }
    [[MKHudManager share] showHUDWithTitle:@"Connecting..." inView:self.view isPenetration:NO];
    [[MKCGCentralManager shared] connectPeripheral:deviecModel.peripheral password:password sucBlock:^(CBPeripheral * _Nonnull peripheral) {
        [[NSUserDefaults standardUserDefaults] setObject:password forKey:localPasswordKey];
        [[MKHudManager share] hide];
        self.rightButton.selected = NO;
        [self pushMQTTForDevicePage:deviecModel.deviceType];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKCGCentralManager shared] disconnect];
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        [self connectFailed];
    }];
}

- (void)pushMQTTForDevicePage:(NSString *)deviceType {
    if (![deviceType isEqualToString:@"00"]) {
        return;
    }
    //MK110
    MKCGBleMqttConfigSelectController *vc = [[MKCGBleMqttConfigSelectController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)connectFailed {
    self.rightButton.selected = NO;
    [self rightButtonMethod];
}

#pragma mark - UI
- (void)loadSubViews {
    self.titleLabel.text = @"Add Device";
    [self.rightButton setImage:nil forState:UIControlStateNormal];
    [self.rightButton addSubview:self.refreshIcon];
    [self.refreshIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.rightButton.mas_centerX);
        make.width.mas_equalTo(22.f);
        make.centerY.mas_equalTo(self.rightButton.mas_centerY);
        make.height.mas_equalTo(22.f);
    }];
    [self.view addSubview:self.addView];
    [self.addView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-VirtualHomeHeight);
        make.height.mas_equalTo(60.f);
    }];
    UIButton *addButton = [MKCustomUIAdopter customButtonWithTitle:@"Add configured device"
                                                            target:self
                                                            action:@selector(addConfiguredDevice)];
    [self.addView addSubview:addButton];
    [addButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.centerY.mas_equalTo(self.addView.mas_centerY);
        make.height.mas_equalTo(35);
    }];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.right.mas_equalTo(-10.f);
        make.top.mas_equalTo(defaultTopInset);
        make.bottom.mas_equalTo(self.addView.mas_top);
    }];
}

#pragma mark - getter
- (MKBaseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIImageView *)refreshIcon {
    if (!_refreshIcon) {
        _refreshIcon = [[UIImageView alloc] init];
        _refreshIcon.image = LOADICON(@"CommureGateway", @"MKCGScanPageController", @"cg_scanRefresh.png");
    }
    return _refreshIcon;
}

- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (NSMutableDictionary *)deviceCache {
    if (!_deviceCache) {
        _deviceCache = [NSMutableDictionary dictionary];
    }
    return _deviceCache;
}

- (UIView *)addView {
    if (!_addView) {
        _addView = [[UIView alloc] init];
        _addView.backgroundColor = COLOR_WHITE_MACROS;
    }
    return _addView;
}

@end
