//
//  MKCHDeviceListController.m
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/2/7.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCHDeviceListController.h"

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

#import "MKCHDeviceModeManager.h"
#import "MKCHDeviceModel.h"

#import "MKCHMQTTServerManager.h"

#import "MKCHMQTTDataManager.h"

#import "MKCHDeviceDatabaseManager.h"

#import "CTMediator+MKCHAdd.h"

#import "MKCHDeviceListModel.h"

#import "MKCHAddDeviceView.h"
#import "MKCHDeviceListCell.h"
#import "MKCHEasyShowView.h"
#import "MKCHDeviceListTableHeader.h"

#import "MKCHServerForAppController.h"
#import "MKCHScanPageController.h"
#import "MKCHDeviceDataController.h"
#import "MKCHAboutController.h"
#import "MKCHBatchOtaController.h"
#import "MKCHDownLoadModifyController.h"

static NSTimeInterval const kRefreshInterval = 0.5f;

@interface MKCHDeviceListController ()<UITableViewDelegate,
UITableViewDataSource,
MKCHDeviceListCellDelegate,
MKCHDeviceModelDelegate,
MKCHDeviceListTableHeaderDelegate>

/// 没有添加设备的时候显示
@property (nonatomic, strong)MKCHAddDeviceView *addView;

/// 本地有设备的时候显示
@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)MKCHDeviceListTableHeader *headerView;

@property (nonatomic, strong)UIView *footerView;

@property (nonatomic, strong)MKCHEasyShowView *loadingView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)NSMutableArray *onlineList;

/// 是不是显示在线列表
@property (nonatomic, assign)BOOL showOnline;

/// 定时刷新
@property (nonatomic, assign)CFRunLoopObserverRef observerRef;
//不能立即刷新列表，降低刷新频率
@property (nonatomic, assign)BOOL isNeedRefresh;

@end

@implementation MKCHDeviceListController

- (void)dealloc {
    NSLog(@"MKCHDeviceListController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //移除runloop的监听
    CFRunLoopRemoveObserver(CFRunLoopGetCurrent(), self.observerRef, kCFRunLoopCommonModes);
    [[MKCHMQTTDataManager shared] clearAllSubscriptions];
    [[MKCHMQTTDataManager shared] disconnect];
    [MKCHMQTTDataManager singleDealloc];
    [MKCHMQTTServerManager singleDealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    if (self.connectServer) {
        //对于从壳工程进来的时候，需要走本地联网流程
        [[MKCHMQTTServerManager shared] startWork];
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
    KxMenuItem *modifyItem = [KxMenuItem menuItem:@"BatchModify"
                                            image:nil
                                           target:self
                                           action:@selector(pushDownLoadModifyPage)];
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
    NSArray *itemList = @[aboutItem,serverItem,batchOtaItem,modifyItem];
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
    
    MKCHDeviceListModel *deviceModel = nil;
    
    if (self.showOnline) {
        deviceModel = self.onlineList[indexPath.row];
    }else {
        deviceModel = self.dataList[indexPath.row];
    }
     
    if (deviceModel.onLineState != MKCHDeviceModelStateOnline) {
        [self.view showCentralToast:@"Device is off-line!"];
        return;
    }
    [[MKCHDeviceModeManager shared] addDeviceModel:deviceModel];
    MKCHDeviceDataController *vc = [[MKCHDeviceDataController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.showOnline) {
        return self.onlineList.count;
    }
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKCHDeviceListCell *cell = [MKCHDeviceListCell initCellWithTableView:tableView];
    cell.indexPath = indexPath;
    if (self.showOnline) {
        cell.dataModel = self.onlineList[indexPath.row];
    }else {
        cell.dataModel = self.dataList[indexPath.row];
    }
    cell.delegate = self;
    return cell;
}

#pragma mark - MKCHDeviceListCellDelegate
/**
 删除
 
 @param index 所在index
 */
- (void)ch_cellDeleteButtonPressed:(NSInteger)index {
    
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
    [alertView showAlertWithTitle:@"Remove Device" message:msg notificationName:@"mk_ch_needDismissAlert"];
}

#pragma mark - MKCHDeviceModelDelegate
/// 当前设备离线
/// @param deviceID 当前设备的deviceID
- (void)ch_deviceOfflineWithMacAddress:(NSString *)macAddress {
    [self deviceModelOnlineStateChanged:MKCHDeviceModelStateOffline macAddress:macAddress];
}

#pragma mark - MKCHDeviceListTableHeaderDelegate

/// 过滤
/// - Parameter type: 0:All   1:Online
- (void)ch_deviceListFilter:(NSInteger)type {
    self.showOnline = (type == 1);
    [self.onlineList removeAllObjects];
    [self loadMainViews];
    if (type == 0) {
        //全部
        [[MKHudManager share] showHUDWithTitle:@"Loading..." inView:self.view isPenetration:NO];
        [self.tableView reloadData];
        [[MKHudManager share] hide];
        return;
    }
    //筛选在线
    [[MKHudManager share] showHUDWithTitle:@"Loading..." inView:self.view isPenetration:NO];
    NSInteger totalNumber = self.dataList.count;
    for (NSInteger i = 0; i < totalNumber; i ++) {
        MKCHDeviceModel *deviceModel = self.dataList[i];
        if (deviceModel.onLineState == MKCHDeviceModelStateOnline) {
            [self.onlineList addObject:deviceModel];
        }
    }
    [[MKHudManager share] hide];
    [self.tableView reloadData];
}

#pragma mark - event method
- (void)pushAboutPage {
    MKCHAboutController *vc = [[MKCHAboutController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushServerForApp {
    MKCHServerForAppController *vc = [[MKCHServerForAppController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushBatchOtaPage {
    MKCHBatchOtaController *vc = [[MKCHBatchOtaController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushDownLoadModifyPage {
    MKCHDownLoadModifyController *vc = [[MKCHDownLoadModifyController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - note
- (void)receiveNewDevice:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user)) {
        return;
    }
    MKCHDeviceModel *receiveModel = user[@"deviceModel"];
    MKCHDeviceListModel *deviceModel = [[MKCHDeviceListModel alloc] init];
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
    
    [self addDeviceToList:deviceModel list:self.dataList];
    if (self.showOnline) {
        [self addDeviceToList:deviceModel list:self.onlineList];
    }
    
    [self loadMainViews];
    NSMutableArray *topicList = [NSMutableArray array];
    [topicList addObject:[deviceModel currentPublishedTopic]];
    [[MKCHMQTTDataManager shared] subscriptions:topicList];
}

- (void)receiveDeviceOnlineState:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user) || !ValidStr(user[@"macAddress"]) || self.dataList.count == 0) {
        return;
    }
    [self deviceModelOnlineStateChanged:MKCHDeviceModelStateOnline macAddress:user[@"macAddress"]];
}

- (void)receiveDeviceNetworkState:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user) || !ValidStr(user[@"macAddress"]) || self.dataList.count == 0) {
        return;
    }
    MKCHDeviceListModel *deviceModel = nil;
    for (NSInteger i = 0; i < self.dataList.count; i ++) {
        MKCHDeviceListModel *tempDevice = self.dataList[i];
        if ([tempDevice.macAddress isEqualToString:user[@"macAddress"]]) {
            tempDevice.onLineState = MKCHDeviceModelStateOnline;
            [tempDevice startStateMonitoringTimer];
            tempDevice.wifiLevel = [user[@"data"][@"net_status"] integerValue];
            deviceModel = tempDevice;
            break;
        }
    }
    if (!deviceModel) {
        return;
    }
    if (!self.showOnline) {
        [self needRefreshList];
        return;
    }
    //当前显示的是在线列表
    BOOL contain = NO;
    for (NSInteger i = 0; i < self.onlineList.count; i ++) {
        MKCHDeviceListModel *tempDevice = self.onlineList[i];
        if ([tempDevice.macAddress isEqualToString:deviceModel.macAddress]) {
            tempDevice.onLineState = MKCHDeviceModelStateOnline;
            [tempDevice startStateMonitoringTimer];
            tempDevice.wifiLevel = [user[@"data"][@"net_status"] integerValue];
            deviceModel = tempDevice;
            contain = YES;
            break;
        }
    }
    if (!contain) {
        //在线列表没有包含
        if (self.onlineList.count > 0) {
            //插入
            [self.onlineList insertObject:deviceModel atIndex:0];
        }else {
            //天津
            [self.onlineList addObject:deviceModel];
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
        MKCHDeviceListModel *deviceModel = self.dataList[i];
        if ([deviceModel.macAddress isEqualToString:user[@"macAddress"]]) {
            deviceModel.deviceName = user[@"deviceName"];
            index = i;
            break;
        }
    }
    if (!self.showOnline) {
        [self.tableView mk_reloadRow:index inSection:0 withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
    //显示的是在线列表
    NSInteger onlineIndex = 0;
    for (NSInteger i = 0; i < self.onlineList.count; i ++) {
        MKCHDeviceListModel *deviceModel = self.onlineList[i];
        if ([deviceModel.macAddress isEqualToString:user[@"macAddress"]]) {
            deviceModel.deviceName = user[@"deviceName"];
            onlineIndex = i;
            break;
        }
    }
    [self.tableView mk_reloadRow:onlineIndex inSection:0 withRowAnimation:UITableViewRowAnimationNone];
}

- (void)receiveDeleteDevice:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user) || !ValidStr(user[@"macAddress"]) || self.dataList.count == 0) {
        return;
    }
    MKCHDeviceListModel *deviceModel = nil;
    for (NSInteger i = 0; i < self.dataList.count; i ++) {
        MKCHDeviceListModel *model = self.dataList[i];
        if ([model.macAddress isEqualToString:user[@"macAddress"]]) {
            deviceModel = model;
            break;
        }
    }
    
    if (!deviceModel) {
        return;
    }
    
    if (self.showOnline) {
        //在线列表
        for (NSInteger i = 0; i < self.onlineList.count; i ++) {
            MKCHDeviceListModel *model = self.onlineList[i];
            if ([model.macAddress isEqualToString:user[@"macAddress"]]) {
                [self.onlineList removeObject:model];
                break;
            }
        }
    }
    
    NSMutableArray *unSubTopicList = [NSMutableArray array];
    [unSubTopicList addObject:[deviceModel currentPublishedTopic]];
    [[MKCHMQTTDataManager shared] unsubscriptions:unSubTopicList];
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
        MKCHDeviceModel *model = self.dataList[i];
        if ([model.macAddress isEqualToString:user[@"macAddress"]]) {
            model.clientID = user[@"clientID"];
            model.subscribedTopic = user[@"subscribedTopic"];
            model.publishedTopic = user[@"publishedTopic"];
            model.onLineState = MKCHDeviceModelStateOffline;
            [subTopicList addObject:[model currentPublishedTopic]];
            contain = YES;
            break;
        }
    }
    if (!contain) {
        return;
    }
    
    if (self.showOnline) {
        //在线列表
        for (NSInteger i = 0; i < self.onlineList.count; i ++) {
            MKCHDeviceModel *model = self.onlineList[i];
            if ([model.macAddress isEqualToString:user[@"macAddress"]]) {
                [subTopicList removeObject:model];
                contain = YES;
                break;
            }
        }
    }
    
    [[MKCHMQTTDataManager shared] unsubscriptions:unsubTopicList];
    [self performSelector:@selector(resubTopics:) withObject:subTopicList afterDelay:1.f];
}

- (void)resubTopics:(NSArray *)subTopicList {
    [self loadMainViews];
    [[MKCHMQTTDataManager shared] subscriptions:subTopicList];
}

/// 当前MQTT服务器连接状态发生改变
- (void)serverManagerStateChanged {
    if ([MKCHMQTTDataManager shared].state == MKCHMQTTSessionManagerStateConnecting) {
        [self.loadingView showText:@"Connecting..." superView:self.titleLabel animated:YES];
        return;
    }
    if ([MKCHMQTTDataManager shared].state == MKCHMQTTSessionManagerStateConnected) {
        [self.loadingView hidden];
        self.defaultTitle = @"Gateway Config";
        return;
    }
    if ([MKCHMQTTDataManager shared].state == MKCHMQTTSessionManagerStateError) {
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
        MKCHDeviceListModel *deviceModel = self.dataList[i];
        if ([deviceModel.macAddress isEqualToString:macAddress]) {
            deviceModel.onLineState = MKCHDeviceModelStateOffline;
            [unSubTopicList addObject:[deviceModel currentPublishedTopic]];
            break;
        }
    }
    if (self.showOnline) {
        for (NSInteger i = 0; i < self.onlineList.count; i ++) {
            MKCHDeviceListModel *deviceModel = self.onlineList[i];
            if ([deviceModel.macAddress isEqualToString:macAddress]) {
                [self.onlineList removeObject:deviceModel];
                break;
            }
        }
    }
    [[MKCHMQTTDataManager shared] unsubscriptions:unSubTopicList];
    [self needRefreshList];
}

- (void)reloadDeviceTopics {
    //切网之后需要重新加载topic
    //先取消当前所有订阅
    [[MKCHMQTTDataManager shared] clearAllSubscriptions];
    //重新加载需要订阅的topic
    NSMutableArray *topicList = [NSMutableArray array];
    for (NSInteger i = 0; i < self.dataList.count; i ++) {
        MKCHDeviceModel *deviceModel = self.dataList[i];
        [topicList addObject:[deviceModel currentPublishedTopic]];
    }
    [[MKCHMQTTDataManager shared] subscriptions:topicList];
}

- (void)receiveBatchDevices:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user)) {
        return;
    }
    NSArray *deviceList = user[@"deviceList"];
    NSString *publishedTopic = @"";
    for (NSInteger i = 0; i < deviceList.count; i ++) {
        MKCHDeviceModel *receiveModel = deviceList[i];
        MKCHDeviceListModel *deviceModel = [[MKCHDeviceListModel alloc] init];
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
            MKCHDeviceListModel *model = self.dataList[i];
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
    
    if (self.showOnline) {
        for (NSInteger i = 0; i < deviceList.count; i ++) {
            MKCHDeviceModel *receiveModel = deviceList[i];
            MKCHDeviceListModel *deviceModel = [[MKCHDeviceListModel alloc] init];
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
            for (NSInteger i = 0; i < self.onlineList.count; i ++) {
                MKCHDeviceListModel *model = self.onlineList[i];
                if ([model.macAddress isEqualToString:deviceModel.macAddress]) {
                    index = i;
                    contain = YES;
                    break;
                }
            }
            if (contain) {
                //当前设备列表存在deviceID相同的设备，替换，本地数据库已经替换过了
                [self.onlineList replaceObjectAtIndex:index withObject:deviceModel];
            }else {
                //不存在，则添加到设备列表
                if (self.onlineList.count > 0) {
                    [self.onlineList insertObject:deviceModel atIndex:0];
                }else {
                    [self.onlineList addObject:deviceModel];
                }
            }
        }
    }
    
    [self loadMainViews];
    [[MKCHMQTTDataManager shared] subscriptions:@[publishedTopic]];
}

#pragma mark - event method
- (void)addButtonPressed {
    if (!ValidStr([MKCHMQTTDataManager shared].serverParams.host)) {
        //如果MQTT服务器参数不存在，则去引导用户添加服务器参数，让app连接MQTT服务器
        MKCHServerForAppController *vc = [[MKCHServerForAppController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    //MQTT服务器参数存在，则添加设备
    MKCHScanPageController *vc = [[MKCHScanPageController alloc] init];
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
    if (self.showOnline) {
        [self.view addSubview:self.tableView];
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(self.headerView.mas_bottom);
            make.bottom.mas_equalTo(self.footerView.mas_top);
        }];
        [self.tableView reloadData];
        return;
    }
    if (!ValidArray(self.dataList)) {
        //没有设备的情况下，隐藏设备列表，显示添加设备页面
        [self.view addSubview:self.addView];
        [self.addView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(self.headerView.mas_bottom);
            make.bottom.mas_equalTo(self.footerView.mas_top);
        }];
        return;
    }
    //有设备了，显示设备列表
    [self.view addSubview:self.tableView];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.headerView.mas_bottom);
        make.bottom.mas_equalTo(self.footerView.mas_top);
    }];
    [self.tableView reloadData];
}

- (void)readDataFromDatabase {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    [MKCHDeviceDatabaseManager readLocalDeviceWithSucBlock:^(NSArray<MKCHDeviceModel *> * _Nonnull deviceList) {
        [[MKHudManager share] hide];
        [self loadTopics:deviceList];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)loadTopics:(NSArray <MKCHDeviceModel *>*)deviceList {
    NSMutableArray *topicList = [NSMutableArray array];
    for (NSInteger i = 0; i < deviceList.count; i ++) {
        MKCHDeviceModel *tempModel = deviceList[i];
        MKCHDeviceListModel *deviceModel = [[MKCHDeviceListModel alloc] init];
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
    [[MKCHMQTTDataManager shared] subscriptions:topicList];
}

- (void)deviceModelOnlineStateChanged:(MKCHDeviceModelState)state macAddress:(NSString *)macAddress {
    MKCHDeviceListModel *currentModel = nil;
    for (NSInteger i = 0; i < self.dataList.count; i ++) {
        MKCHDeviceListModel *deviceModel = self.dataList[i];
        if ([deviceModel.macAddress isEqualToString:macAddress]) {
            deviceModel.onLineState = state;
            if (state == MKCHDeviceModelStateOnline) {
                //在线状态开启监听
                [deviceModel startStateMonitoringTimer];
            }
            currentModel = deviceModel;
            break;
        }
    }
    if (!self.showOnline) {
        [self needRefreshList];
        return;
    }
    if (!currentModel) {
        return;
    }
    //当前显示的在线列表
    if (state == MKCHDeviceModelStateOffline) {
        //设备离线
        NSInteger onlineCount = self.onlineList.count;
        for (NSInteger i = 0; i < onlineCount; i ++) {
            MKCHDeviceListModel *deviceModel = self.onlineList[i];
            if ([deviceModel.macAddress isEqualToString:macAddress]) {
                [self.onlineList removeObject:deviceModel];
                break;
            }
        }
    }else {
        //设备在线
        BOOL contain = NO;
        NSInteger onlineCount = self.onlineList.count;
        for (NSInteger i = 0; i < onlineCount; i ++) {
            MKCHDeviceListModel *deviceModel = self.onlineList[i];
            if ([deviceModel.macAddress isEqualToString:macAddress]) {
                [self.onlineList replaceObjectAtIndex:i withObject:currentModel];
                contain = YES;
                break;
            }
        }
        if (!contain) {
            if (self.onlineList.count > 0) {
                [self.onlineList insertObject:currentModel atIndex:0];
            }else {
                [self.onlineList addObject:currentModel];
            }
        }
    }
}

- (void)removeDeviceFromLocal:(NSInteger)index {
    MKCHDeviceListModel *deviceModel = nil;
    if (self.showOnline) {
        deviceModel = self.onlineList[index];
    }else {
        deviceModel = self.dataList[index];
    }
     
    [[MKHudManager share] showHUDWithTitle:@"Delete..." inView:self.view isPenetration:NO];
    [MKCHDeviceDatabaseManager deleteDeviceWithMacAddress:deviceModel.macAddress sucBlock:^{
        [self deleteDeviceWithMac:deviceModel.macAddress];
        [[MKHudManager share] hide];
        [[MKCHMQTTDataManager shared] unsubscriptions:@[[deviceModel currentPublishedTopic]]];
        [self loadMainViews];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)deleteDeviceWithMac:(NSString *)macAddress {
    NSInteger onlineCount = self.onlineList.count;
    for (NSInteger i = 0; i < onlineCount; i ++) {
        MKCHDeviceListModel *deviceModel = self.onlineList[i];
        if ([deviceModel.macAddress isEqualToString:macAddress]) {
            [self.onlineList removeObject:deviceModel];
            break;
        }
    }
    NSInteger allCount = self.dataList.count;
    for (NSInteger i = 0; i < allCount; i ++) {
        MKCHDeviceListModel *deviceModel = self.dataList[i];
        if ([deviceModel.macAddress isEqualToString:macAddress]) {
            [self.dataList removeObject:deviceModel];
            break;
        }
    }
}

- (void)addDeviceToList:(MKCHDeviceModel *)deviceModel list:(NSMutableArray *)list{
    NSInteger index = 0;
    BOOL contain = NO;
    for (NSInteger i = 0; i < list.count; i ++) {
        MKCHDeviceListModel *model = list[i];
        if ([model.macAddress isEqualToString:deviceModel.macAddress]) {
            index = i;
            contain = YES;
            break;
        }
    }
    if (contain) {
        //当前设备列表存在deviceID相同的设备，替换，本地数据库已经替换过了
        [list replaceObjectAtIndex:index withObject:deviceModel];
    }else {
        //不存在，则添加到设备列表
        if (list.count > 0) {
            [list insertObject:deviceModel atIndex:0];
        }else {
            [list addObject:deviceModel];
        }
    }
}

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNewDevice:)
                                                 name:@"mk_ch_addNewDeviceSuccessNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveDeviceOnlineState:)
                                                 name:MKCHReceiveDeviceOnlineNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveDeviceNameChanged:)
                                                 name:@"mk_ch_deviceNameChangedNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveDeleteDevice:)
                                                 name:@"mk_ch_deleteDeviceNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveDeviceModifyMQTTServer:)
                                                 name:@"mk_ch_deviceModifyMQTTServerSuccessNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(serverManagerStateChanged)
                                                 name:MKCHMQTTSessionManagerStateChangedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkStatusChanged)
                                                 name:MKNetworkStatusChangedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveDeviceNetworkState:)
                                                 name:MKCHReceiveDeviceNetStateNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceResetByButton:)
                                                 name:MKCHReceiveDeviceResetByButtonNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadDeviceTopics)
                                                 name:@"mk_ch_needReloadTopicsNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveBatchDevices:)
                                                 name:@"mk_ch_addBatchDeviceNotification"
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
    [self.rightButton setImage:LOADICON(@"CommureGatewayPlus", @"MKCHDeviceListController", @"ch_menuIcon.png") forState:UIControlStateNormal];
    [self.view addSubview:self.footerView];
    [self.footerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        make.height.mas_equalTo(60.f);
    }];
    [self.view addSubview:self.headerView];
    [self.headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
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

- (MKCHDeviceListTableHeader *)headerView {
    if (!_headerView) {
        _headerView = [[MKCHDeviceListTableHeader alloc] init];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (MKCHAddDeviceView *)addView {
    if (!_addView) {
        _addView = [[MKCHAddDeviceView alloc] init];
    }
    return _addView;
}

- (MKCHEasyShowView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[MKCHEasyShowView alloc] init];
    }
    return _loadingView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (NSMutableArray *)onlineList {
    if (!_onlineList) {
        _onlineList = [NSMutableArray array];
    }
    return _onlineList;
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
