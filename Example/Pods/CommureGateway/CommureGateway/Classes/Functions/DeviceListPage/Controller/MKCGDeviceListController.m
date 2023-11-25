//
//  MKCGDeviceListController.m
//  CommureGateway_Example
//
//  Created by aa on 2023/2/7.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCGDeviceListController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"

#import "MKHudManager.h"
#import "MKCustomUIAdopter.h"
#import "MKAlertView.h"
#import "NirKxMenu.h"

#import "MKNetworkManager.h"

#import "MKCGDeviceModeManager.h"
#import "MKCGDeviceModel.h"

#import "MKCGMQTTServerManager.h"

#import "MKCGMQTTDataManager.h"

#import "MKCGDeviceDatabaseManager.h"

#import "CTMediator+MKCGAdd.h"

#import "MKCGDeviceListModel.h"

#import "MKCGAddDeviceView.h"
#import "MKCGDeviceListCell.h"
#import "MKCGEasyShowView.h"

#import "MKCGServerForAppController.h"
#import "MKCGScanPageController.h"
#import "MKCGDeviceDataController.h"
#import "MKCGAboutController.h"
#import "MKCGBatchOtaController.h"

static NSTimeInterval const kRefreshInterval = 0.5f;

@interface MKCGDeviceListController ()<UITableViewDelegate,
UITableViewDataSource,
MKCGDeviceListCellDelegate,
MKCGDeviceModelDelegate>

/// 没有添加设备的时候显示
@property (nonatomic, strong)MKCGAddDeviceView *addView;

/// 本地有设备的时候显示
@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)UIView *footerView;

@property (nonatomic, strong)MKCGEasyShowView *loadingView;

@property (nonatomic, strong)NSMutableArray *dataList;

/// 定时刷新
@property (nonatomic, assign)CFRunLoopObserverRef observerRef;
//不能立即刷新列表，降低刷新频率
@property (nonatomic, assign)BOOL isNeedRefresh;

@end

@implementation MKCGDeviceListController

- (void)dealloc {
    NSLog(@"MKCGDeviceListController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //移除runloop的监听
    CFRunLoopRemoveObserver(CFRunLoopGetCurrent(), self.observerRef, kCFRunLoopCommonModes);
    [[MKCGMQTTDataManager shared] clearAllSubscriptions];
    [[MKCGMQTTDataManager shared] disconnect];
    [MKCGMQTTDataManager singleDealloc];
    [MKCGMQTTServerManager singleDealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    if (self.connectServer) {
        //对于从壳工程进来的时候，需要走本地联网流程
        [[MKCGMQTTServerManager shared] startWork];
    }
    
    [self readDataFromDatabase];
    [self runloopObserver];
    [self addNotifications];
}

#pragma mark - super method
- (void)rightButtonMethod {
    KxMenuItem *aboutItem = [KxMenuItem menuItem:@"About"
                                           image:nil
                                          target:self
                                          action:@selector(pushAboutPage)];
    KxMenuItem *serverItem = [KxMenuItem menuItem:@"Server"
                                            image:nil
                                           target:self
                                           action:@selector(pushServerForApp)];
    KxMenuItem *batchOtaItem = [KxMenuItem menuItem:@"BatchOta"
                                              image:nil
                                             target:self
                                             action:@selector(pushBatchOtaPage)];
    Color textColor = {
        R:1,
        G:1,
        B:1
    };
    Color menuBackgroundColor = {
        R:(47.f / 255.0),
        G:(132.f / 255.0),
        B:(208.f / 255.0)
    };
    OptionalConfiguration options = {
                arrowSize: 9,  //指示箭头大小
                marginXSpacing: 5,  //MenuItem左右边距
                marginYSpacing: 9,  //MenuItem上下边距
                intervalSpacing: 25,  //MenuItemImage与MenuItemTitle的间距
                menuCornerRadius: 6.5,  //菜单圆角半径
                maskToBackground: true,  //是否添加覆盖在原View上的半透明遮罩
                shadowOfMenu: false,  //是否添加菜单阴影
                hasSeperatorLine: true,  //是否设置分割线
                seperatorLineHasInsets: false,  //是否在分割线两侧留下Insets
                textColor: textColor,  //menuItem字体颜色
                menuBackgroundColor:menuBackgroundColor   //菜单的底色
    };
    
    CGRect rect = CGRectMake(kViewWidth - self.rightButton.frame.size.width - 15.f, self.rightButton.frame.origin.y + 52.f, self.rightButton.frame.size.width, self.rightButton.frame.size.height);
    NSArray *itemList = @[aboutItem,serverItem,batchOtaItem];
    [KxMenu showMenuInView:self.view
                  fromRect:rect
                 menuItems:itemList
               withOptions:options];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MKCGDeviceListModel *deviceModel = self.dataList[indexPath.row];
    if (deviceModel.onLineState != MKCGDeviceModelStateOnline) {
        [self.view showCentralToast:@"Device is off-line!"];
        return;
    }
    [[MKCGDeviceModeManager shared] addDeviceModel:deviceModel];
    MKCGDeviceDataController *vc = [[MKCGDeviceDataController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKCGDeviceListCell *cell = [MKCGDeviceListCell initCellWithTableView:tableView];
    cell.indexPath = indexPath;
    cell.dataModel = self.dataList[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - MKCGDeviceListCellDelegate
/**
 删除
 
 @param index 所在index
 */
- (void)cg_cellDeleteButtonPressed:(NSInteger)index {
    if (index >= self.dataList.count) {
        return;
    }
    
    @weakify(self);
    MKAlertViewAction *cancelAction = [[MKAlertViewAction alloc] initWithTitle:@"Cancel" handler:^{
        
    }];
    
    MKAlertViewAction *confirmAction = [[MKAlertViewAction alloc] initWithTitle:@"Confirm" handler:^{
        @strongify(self);
        [self removeDeviceFromLocal:index];
    }];
    NSString *msg = @"Please confirm again whether to remove the device.";
    MKAlertView *alertView = [[MKAlertView alloc] init];
    [alertView addAction:cancelAction];
    [alertView addAction:confirmAction];
    [alertView showAlertWithTitle:@"Remove Device" message:msg notificationName:@"mk_cg_needDismissAlert"];
}

#pragma mark - MKCGDeviceModelDelegate
/// 当前设备离线
/// @param deviceID 当前设备的deviceID
- (void)cg_deviceOfflineWithMacAddress:(NSString *)macAddress {
    [self deviceModelOnlineStateChanged:MKCGDeviceModelStateOffline macAddress:macAddress];
}

#pragma mark - event method
- (void)pushAboutPage {
    MKCGAboutController *vc = [[MKCGAboutController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushServerForApp {
    MKCGServerForAppController *vc = [[MKCGServerForAppController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushBatchOtaPage {
    MKCGBatchOtaController *vc = [[MKCGBatchOtaController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - note
- (void)receiveNewDevice:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user)) {
        return;
    }
    MKCGDeviceModel *receiveModel = user[@"deviceModel"];
    MKCGDeviceListModel *deviceModel = [[MKCGDeviceListModel alloc] init];
    deviceModel.deviceType = receiveModel.deviceType;
    deviceModel.clientID = receiveModel.clientID;
    deviceModel.deviceName = receiveModel.deviceName;
    deviceModel.subscribedTopic = receiveModel.subscribedTopic;
    deviceModel.publishedTopic = receiveModel.publishedTopic;
    deviceModel.macAddress = receiveModel.macAddress;
    deviceModel.onLineState = receiveModel.onLineState;
    deviceModel.wifiLevel = 2;
    deviceModel.delegate = self;
    [deviceModel startStateMonitoringTimer];
    
    NSInteger index = 0;
    BOOL contain = NO;
    for (NSInteger i = 0; i < self.dataList.count; i ++) {
        MKCGDeviceListModel *model = self.dataList[i];
        if ([model.macAddress isEqualToString:deviceModel.macAddress]) {
            index = i;
            contain = YES;
            break;
        }
    }
    if (contain) {
        //当前设备列表存在deviceID相同的设备，替换，本地数据库已经替换过了
        [self.dataList replaceObjectAtIndex:index withObject:deviceModel];
    }else {
        //不存在，则添加到设备列表
        if (self.dataList.count > 0) {
            [self.dataList insertObject:deviceModel atIndex:0];
        }else {
            [self.dataList addObject:deviceModel];
        }
    }
    
    [self loadMainViews];
    NSMutableArray *topicList = [NSMutableArray array];
    [topicList addObject:[deviceModel currentPublishedTopic]];
    [[MKCGMQTTDataManager shared] subscriptions:topicList];
}

- (void)receiveDeviceOnlineState:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user) || !ValidStr(user[@"macAddress"]) || self.dataList.count == 0) {
        return;
    }
    [self deviceModelOnlineStateChanged:MKCGDeviceModelStateOnline macAddress:user[@"macAddress"]];
}

- (void)receiveDeviceNetworkState:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user) || !ValidStr(user[@"macAddress"]) || self.dataList.count == 0) {
        return;
    }
    for (NSInteger i = 0; i < self.dataList.count; i ++) {
        MKCGDeviceListModel *deviceModel = self.dataList[i];
        if ([deviceModel.macAddress isEqualToString:user[@"macAddress"]]) {
            deviceModel.onLineState = MKCGDeviceModelStateOnline;
            [deviceModel startStateMonitoringTimer];
            deviceModel.wifiLevel = [user[@"data"][@"net_status"] integerValue];
            break;
        }
    }
    [self needRefreshList];
}

- (void)receiveDeviceNameChanged:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user) || !ValidStr(user[@"macAddress"]) || self.dataList.count == 0) {
        return;
    }
    NSInteger index = 0;
    for (NSInteger i = 0; i < self.dataList.count; i ++) {
        MKCGDeviceListModel *deviceModel = self.dataList[i];
        if ([deviceModel.macAddress isEqualToString:user[@"macAddress"]]) {
            deviceModel.deviceName = user[@"deviceName"];
            index = i;
            break;
        }
    }
    [self.tableView mk_reloadRow:index inSection:0 withRowAnimation:UITableViewRowAnimationNone];
}

- (void)receiveDeleteDevice:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user) || !ValidStr(user[@"macAddress"]) || self.dataList.count == 0) {
        return;
    }
    MKCGDeviceListModel *deviceModel = nil;
    for (NSInteger i = 0; i < self.dataList.count; i ++) {
        MKCGDeviceListModel *model = self.dataList[i];
        if ([model.macAddress isEqualToString:user[@"macAddress"]]) {
            deviceModel = model;
            break;
        }
    }
    
    if (!deviceModel) {
        return;
    }
    NSMutableArray *unSubTopicList = [NSMutableArray array];
    [unSubTopicList addObject:[deviceModel currentPublishedTopic]];
    [[MKCGMQTTDataManager shared] unsubscriptions:unSubTopicList];
    [self.dataList removeObject:deviceModel];
    
    [self loadMainViews];
}

- (void)receiveDeviceModifyMQTTServer:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user)) {
        return;
    }
    
    BOOL contain = NO;
    NSMutableArray *unsubTopicList = [NSMutableArray array];
    NSMutableArray *subTopicList = [NSMutableArray array];
    for (NSInteger i = 0; i < self.dataList.count; i ++) {
        MKCGDeviceModel *model = self.dataList[i];
        if ([model.macAddress isEqualToString:user[@"macAddress"]]) {
            model.clientID = user[@"clientID"];
            model.subscribedTopic = user[@"subscribedTopic"];
            model.publishedTopic = user[@"publishedTopic"];
            model.onLineState = MKCGDeviceModelStateOffline;
            [subTopicList addObject:[model currentPublishedTopic]];
            contain = YES;
            break;
        }
    }
    if (!contain) {
        return;
    }
    [[MKCGMQTTDataManager shared] unsubscriptions:unsubTopicList];
    [self performSelector:@selector(resubTopics:) withObject:subTopicList afterDelay:1.f];
}

- (void)resubTopics:(NSArray *)subTopicList {
    [self loadMainViews];
    [[MKCGMQTTDataManager shared] subscriptions:subTopicList];
}

/// 当前MQTT服务器连接状态发生改变
- (void)serverManagerStateChanged {
    if ([MKCGMQTTDataManager shared].state == MKCGMQTTSessionManagerStateConnecting) {
        [self.loadingView showText:@"Connecting..." superView:self.titleLabel animated:YES];
        return;
    }
    if ([MKCGMQTTDataManager shared].state == MKCGMQTTSessionManagerStateConnected) {
        [self.loadingView hidden];
        self.defaultTitle = @"Gateway Config";
        return;
    }
    if ([MKCGMQTTDataManager shared].state == MKCGMQTTSessionManagerStateError) {
        [self.loadingView hidden];
        self.defaultTitle = @"Connect Failed";
        return;
    }
}

- (void)networkStatusChanged {
    if (![[MKNetworkManager sharedInstance] currentNetworkAvailable]) {
        self.defaultTitle = @"Network Unreachable";
        return;
    }
}

- (void)deviceResetByButton:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user) || self.dataList.count == 0) {
        return;
    }
    NSString *macAddress = user[@"device_info"][@"mac"];
    if (!ValidStr(macAddress)) {
        return;
    }
    NSMutableArray *unSubTopicList = [NSMutableArray array];
    for (NSInteger i = 0; i < self.dataList.count; i ++) {
        MKCGDeviceListModel *deviceModel = self.dataList[i];
        if ([deviceModel.macAddress isEqualToString:macAddress]) {
            deviceModel.onLineState = MKCGDeviceModelStateOffline;
            [unSubTopicList addObject:[deviceModel currentPublishedTopic]];
            break;
        }
    }
    [[MKCGMQTTDataManager shared] unsubscriptions:unSubTopicList];
    [self needRefreshList];
}

- (void)reloadDeviceTopics {
    //切网之后需要重新加载topic
    //先取消当前所有订阅
    [[MKCGMQTTDataManager shared] clearAllSubscriptions];
    //重新加载需要订阅的topic
    NSMutableArray *topicList = [NSMutableArray array];
    for (NSInteger i = 0; i < self.dataList.count; i ++) {
        MKCGDeviceModel *deviceModel = self.dataList[i];
        [topicList addObject:[deviceModel currentPublishedTopic]];
    }
    [[MKCGMQTTDataManager shared] subscriptions:topicList];
}

- (void)receiveBatchDevices:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user)) {
        return;
    }
    NSArray *deviceList = user[@"deviceList"];
    NSString *publishedTopic = @"";
    for (NSInteger i = 0; i < deviceList.count; i ++) {
        MKCGDeviceModel *receiveModel = deviceList[i];
        MKCGDeviceListModel *deviceModel = [[MKCGDeviceListModel alloc] init];
        deviceModel.deviceType = receiveModel.deviceType;
        deviceModel.clientID = receiveModel.clientID;
        deviceModel.deviceName = receiveModel.deviceName;
        deviceModel.subscribedTopic = receiveModel.subscribedTopic;
        deviceModel.publishedTopic = receiveModel.publishedTopic;
        deviceModel.macAddress = receiveModel.macAddress;
        deviceModel.onLineState = receiveModel.onLineState;
        deviceModel.wifiLevel = 2;
        deviceModel.delegate = self;
        [deviceModel startStateMonitoringTimer];
        
        publishedTopic = [deviceModel currentPublishedTopic];
        
        NSInteger index = 0;
        BOOL contain = NO;
        for (NSInteger i = 0; i < self.dataList.count; i ++) {
            MKCGDeviceListModel *model = self.dataList[i];
            if ([model.macAddress isEqualToString:deviceModel.macAddress]) {
                index = i;
                contain = YES;
                break;
            }
        }
        if (contain) {
            //当前设备列表存在deviceID相同的设备，替换，本地数据库已经替换过了
            [self.dataList replaceObjectAtIndex:index withObject:deviceModel];
        }else {
            //不存在，则添加到设备列表
            if (self.dataList.count > 0) {
                [self.dataList insertObject:deviceModel atIndex:0];
            }else {
                [self.dataList addObject:deviceModel];
            }
        }
    }
    
    [self loadMainViews];
    [[MKCGMQTTDataManager shared] subscriptions:@[publishedTopic]];
}

#pragma mark - event method
- (void)addButtonPressed {
    if (!ValidStr([MKCGMQTTDataManager shared].serverParams.host)) {
        //如果MQTT服务器参数不存在，则去引导用户添加服务器参数，让app连接MQTT服务器
        MKCGServerForAppController *vc = [[MKCGServerForAppController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    //MQTT服务器参数存在，则添加设备
    MKCGScanPageController *vc = [[MKCGScanPageController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - private method
- (void)loadMainViews {
    if (self.tableView.superview) {
        [self.tableView removeFromSuperview];
    }
    if (self.addView.superview) {
        [self.addView removeFromSuperview];
    }
    if (!ValidArray(self.dataList)) {
        //没有设备的情况下，隐藏设备列表，显示添加设备页面
        [self.view addSubview:self.addView];
        [self.addView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(defaultTopInset);
            make.bottom.mas_equalTo(self.footerView.mas_top);
        }];
        return;
    }
    //有设备了，显示设备列表
    [self.view addSubview:self.tableView];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(defaultTopInset);
        make.bottom.mas_equalTo(self.footerView.mas_top);
    }];
    [self.tableView reloadData];
}

- (void)readDataFromDatabase {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    [MKCGDeviceDatabaseManager readLocalDeviceWithSucBlock:^(NSArray<MKCGDeviceModel *> * _Nonnull deviceList) {
        [[MKHudManager share] hide];
        [self loadTopics:deviceList];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)loadTopics:(NSArray <MKCGDeviceModel *>*)deviceList {
    NSMutableArray *topicList = [NSMutableArray array];
    for (NSInteger i = 0; i < deviceList.count; i ++) {
        MKCGDeviceModel *tempModel = deviceList[i];
        MKCGDeviceListModel *deviceModel = [[MKCGDeviceListModel alloc] init];
        deviceModel.deviceType = tempModel.deviceType;
        deviceModel.clientID = tempModel.clientID;
        deviceModel.deviceName = tempModel.deviceName;
        deviceModel.subscribedTopic = tempModel.subscribedTopic;
        deviceModel.publishedTopic = tempModel.publishedTopic;
        deviceModel.macAddress = tempModel.macAddress;
        deviceModel.delegate = self;
        if (i == 0) {
            [self.dataList addObject:deviceModel];
        }else {
            [self.dataList insertObject:deviceModel atIndex:0];
        }
        [topicList addObject:[deviceModel currentPublishedTopic]];
    }
    [self loadMainViews];
    [[MKCGMQTTDataManager shared] subscriptions:topicList];
}

- (void)deviceModelOnlineStateChanged:(MKCGDeviceModelState)state macAddress:(NSString *)macAddress {
    for (NSInteger i = 0; i < self.dataList.count; i ++) {
        MKCGDeviceListModel *deviceModel = self.dataList[i];
        if ([deviceModel.macAddress isEqualToString:macAddress]) {
            deviceModel.onLineState = state;
            if (state == MKCGDeviceModelStateOnline) {
                //在线状态开启监听
                [deviceModel startStateMonitoringTimer];
            }
            break;
        }
    }
    [self needRefreshList];
}

- (void)removeDeviceFromLocal:(NSInteger)index {
    MKCGDeviceListModel *deviceModel = self.dataList[index];
    [[MKHudManager share] showHUDWithTitle:@"Delete..." inView:self.view isPenetration:NO];
    [MKCGDeviceDatabaseManager deleteDeviceWithMacAddress:deviceModel.macAddress sucBlock:^{
        [[MKHudManager share] hide];
        [self.dataList removeObject:deviceModel];
        [[MKCGMQTTDataManager shared] unsubscriptions:@[[deviceModel currentPublishedTopic]]];
        [self loadMainViews];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNewDevice:)
                                                 name:@"mk_cg_addNewDeviceSuccessNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveDeviceOnlineState:)
                                                 name:MKCGReceiveDeviceOnlineNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveDeviceNameChanged:)
                                                 name:@"mk_cg_deviceNameChangedNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveDeleteDevice:)
                                                 name:@"mk_cg_deleteDeviceNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveDeviceModifyMQTTServer:)
                                                 name:@"mk_cg_deviceModifyMQTTServerSuccessNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(serverManagerStateChanged)
                                                 name:MKCGMQTTSessionManagerStateChangedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkStatusChanged)
                                                 name:MKNetworkStatusChangedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveDeviceNetworkState:)
                                                 name:MKCGReceiveDeviceNetStateNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceResetByButton:)
                                                 name:MKCGReceiveDeviceResetByButtonNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadDeviceTopics)
                                                 name:@"mk_cg_needReloadTopicsNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveBatchDevices:)
                                                 name:@"mk_cg_addBatchDeviceNotification"
                                               object:nil];
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
                self.isNeedRefresh = NO;
            }
        }
    });
    //添加监听，模式为kCFRunLoopCommonModes
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), self.observerRef, kCFRunLoopCommonModes);
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Gateway Config";
    [self.rightButton setImage:LOADICON(@"CommureGateway", @"MKCGDeviceListController", @"cg_menuIcon.png") forState:UIControlStateNormal];
    [self.view addSubview:self.footerView];
    [self.footerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-VirtualHomeHeight);
        make.height.mas_equalTo(60.f);
    }];
}

#pragma mark - getter
- (MKBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = RGBCOLOR(242, 242, 242);
    }
    return _tableView;
}

- (MKCGAddDeviceView *)addView {
    if (!_addView) {
        _addView = [[MKCGAddDeviceView alloc] init];
    }
    return _addView;
}

- (MKCGEasyShowView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[MKCGEasyShowView alloc] init];
    }
    return _loadingView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] init];
        _footerView.backgroundColor = COLOR_WHITE_MACROS;
        UIButton *addButton = [MKCustomUIAdopter customButtonWithTitle:@"Add Devices"
                                                                target:self
                                                                action:@selector(addButtonPressed)];
        [_footerView addSubview:addButton];
        [addButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30.f);
            make.right.mas_equalTo(-30.f);
            make.centerY.mas_equalTo(_footerView.mas_centerY);
            make.height.mas_equalTo(40.f);
        }];
    }
    return _footerView;
}

@end
