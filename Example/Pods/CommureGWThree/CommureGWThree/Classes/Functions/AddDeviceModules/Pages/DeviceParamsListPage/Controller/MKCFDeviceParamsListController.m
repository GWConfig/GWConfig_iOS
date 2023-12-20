//
//  MKCFDeviceParamsListController.m
//  CommureGWThree_Example
//
//  Created by aa on 2023/1/29.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCFDeviceParamsListController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "NSString+MKAdd.h"
#import "UITableView+MKAdd.h"

#import "MKHudManager.h"
#import "MKCustomUIAdopter.h"
#import "MKSettingTextCell.h"
#import "MKTableSectionLineHeader.h"
#import "MKProgressView.h"

#import "MKCFCentralManager.h"
#import "MKCFInterface+MKCFConfig.h"

#import "MKCFMQTTDataManager.h"

#import "MKCFDeviceModel.h"

#import "MKCFDeviceMQTTParamsModel.h"

#import "MKCFDeviceParamListModel.h"

#import "MKCFServerForDeviceController.h"
#import "MKCFBleNetworkSettingsController.h"
#import "MKCFBleNTPTimezoneController.h"
#import "MKCFBleDeviceInfoController.h"
#import "MKCFConnectSuccessController.h"

static NSString *const noteMsg = @"Please note the WIFI settings and MQTT settings are required,the other settings are optional.";

@interface MKCFDeviceParamsListController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *headerList;

@property (nonatomic, strong)UIView *footerView;

@property (nonatomic, strong)MKProgressView *progressView;

@property (nonatomic, strong)dispatch_source_t connectTimer;

@property (nonatomic, assign)NSInteger timeCount;

@property (nonatomic, strong)MKCFDeviceParamListModel *dataModel;

@end

@implementation MKCFDeviceParamsListController

- (void)dealloc {
    NSLog(@"MKCFDeviceParamsListController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
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
    [MKCFDeviceMQTTParamsModel shared].deviceModel.deviceType = @"10";
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceConnectStateChanged)
                                                 name:mk_cf_peripheralConnectStateChangedNotification
                                               object:nil];
}

#pragma mark - super method
- (void)leftButtonMethod {
    [self popToViewControllerWithClassName:@"MKCFScanPageController"];
    [[MKCFCentralManager shared] disconnect];
    [MKCFDeviceMQTTParamsModel sharedDealloc];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 20.f;
    }
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MKTableSectionLineHeader *header = [MKTableSectionLineHeader initHeaderViewWithTableView:tableView];
    header.headerModel = self.headerList[section];
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        //Network Settings
        MKCFBleNetworkSettingsController *vc = [[MKCFBleNetworkSettingsController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        //MQTT settings
        MKCFServerForDeviceController *vc = [[MKCFServerForDeviceController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        //NTP & Timezone
        MKCFBleNTPTimezoneController *vc = [[MKCFBleNTPTimezoneController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 1 && indexPath.row == 1) {
        //Device Information
        MKCFBleDeviceInfoController *vc = [[MKCFBleDeviceInfoController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.headerList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.section0List.count;
    }
    if (section == 1) {
        return self.section1List.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKSettingTextCell *cell = [MKSettingTextCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        return cell;
    }
    MKSettingTextCell *cell = [MKSettingTextCell initCellWithTableView:tableView];
    cell.dataModel = self.section1List[indexPath.row];
    return cell;
}

#pragma mark - note
- (void)deviceConnectStateChanged {
    if ([MKCFCentralManager shared].connectStatus == mk_cf_centralConnectStatusConnected) {
        return;
    }
    //设备断开连接，返回上一级页面
    if (self.progressView) {
        [self.progressView dismiss];
    }
    [self.view showCentralToast:@"Device disconnect!"];
    [self performSelector:@selector(leftButtonMethod) withObject:nil afterDelay:0.5f];
}

- (void)receiveDeviceOnline:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user) || !ValidStr(user[@"macAddress"]) || ![[MKCFDeviceMQTTParamsModel shared].deviceModel.macAddress isEqualToString:user[@"macAddress"]]) {
        return;
    }
    //接收到设备的网络状态上报，认为设备入网成功
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MKCFReceiveDeviceOnlineNotification
                                                  object:nil];
    if (self.connectTimer) {
        dispatch_cancel(self.connectTimer);
    }
    self.timeCount = 0;
    [self.progressView setProgress:1.f animated:YES];
    [self performSelector:@selector(connectSuccess) withObject:nil afterDelay:.5f];
}

#pragma mark - event method
- (void)retainButtonPressed {
    if (![MKCFDeviceMQTTParamsModel shared].cloud) {
        [self.view showCentralToast:@"Only import config file from cloud support!"];
        return;
    }
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel configDataWithSucBlock:^{
        [[MKHudManager share] hide];
        [self leftButtonMethod];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)connectButtonPressed {
    
    if ([MKCFDeviceMQTTParamsModel shared].cloud) {
        [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
        @weakify(self);
        [self.dataModel configDataWithSucBlock:^{
            [[MKHudManager share] hide];
            [self startMqttProcess];
        } failedBlock:^(NSError * _Nonnull error) {
            [[MKHudManager share] hide];
            [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        }];
        return;
    }
    
    if (![MKCFDeviceMQTTParamsModel shared].wifiConfig || ![MKCFDeviceMQTTParamsModel shared].mqttConfig) {
        [self.view showCentralToast:@"Please configure WIFI and MQTT settings first!"];
        return;
    }
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    [MKCFInterface cf_enterSTAModeWithSucBlock:^{
        [[MKHudManager share] hide];
        [self startMqttProcess];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - connect process
- (void)startMqttProcess {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:mk_cf_peripheralConnectStateChangedNotification
                                                  object:nil];
    NSString *topic = [MKCFDeviceMQTTParamsModel shared].deviceModel.publishedTopic;
    [self.progressView show];
    [[MKCFMQTTDataManager shared] subscriptions:@[topic]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveDeviceOnline:)
                                                 name:MKCFReceiveDeviceOnlineNotification
                                               object:nil];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.connectTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    self.timeCount = 0;
    dispatch_source_set_timer(self.connectTimer, dispatch_walltime(NULL, 0), 1 * NSEC_PER_SEC, 0);
    @weakify(self);
    dispatch_source_set_event_handler(self.connectTimer, ^{
        @strongify(self);
        if (self.timeCount >= 90) {
            //接受数据超时
            dispatch_cancel(self.connectTimer);
            self.timeCount = 0;
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:MKCFReceiveDeviceOnlineNotification
                                                          object:nil];
            moko_dispatch_main_safe(^{
                [self.progressView dismiss];
                [self.view showCentralToast:@"Connect Failed!"];
            });
            return ;
        }
        self.timeCount ++;
        moko_dispatch_main_safe(^{
            [self.progressView setProgress:(self.timeCount / 90.f) animated:NO];
        });
    });
    dispatch_resume(self.connectTimer);
}

- (void)connectSuccess {
    if (self.progressView) {
        [self.progressView dismiss];
    }
    
    MKCFDeviceModel *deviceModel = [[MKCFDeviceModel alloc] init];
    deviceModel.deviceType = @"10";
    deviceModel.clientID = [MKCFDeviceMQTTParamsModel shared].deviceModel.clientID;
    deviceModel.subscribedTopic = [MKCFDeviceMQTTParamsModel shared].deviceModel.subscribedTopic;
    deviceModel.publishedTopic = [MKCFDeviceMQTTParamsModel shared].deviceModel.publishedTopic;
    deviceModel.macAddress = [MKCFDeviceMQTTParamsModel shared].deviceModel.macAddress;
    deviceModel.deviceName = [MKCFDeviceMQTTParamsModel shared].deviceModel.deviceName;
    
        
    MKCFConnectSuccessController *vc = [[MKCFConnectSuccessController alloc] init];
    vc.deviceModel = deviceModel;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    for (NSInteger i = 0; i < 2; i ++) {
        MKTableSectionLineHeaderModel *model = [[MKTableSectionLineHeaderModel alloc] init];
        [self.headerList addObject:model];
    }
    
    [self loadSection0Datas];
    [self loadSection1Datas];
    
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKSettingTextCellModel *cellModel1 = [[MKSettingTextCellModel alloc] init];
    cellModel1.leftMsg = @"Network Settings";
    [self.section0List addObject:cellModel1];
    
    MKSettingTextCellModel *cellModel2 = [[MKSettingTextCellModel alloc] init];
    cellModel2.leftMsg = @"MQTT Settings";
    [self.section0List addObject:cellModel2];
}

- (void)loadSection1Datas {
    MKSettingTextCellModel *cellModel1 = [[MKSettingTextCellModel alloc] init];
    cellModel1.leftMsg = @"NTP & Timezone";
    [self.section1List addObject:cellModel1];
    
    MKSettingTextCellModel *cellModel2 = [[MKSettingTextCellModel alloc] init];
    cellModel2.leftMsg = @"Device Information";
    [self.section1List addObject:cellModel2];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Settings for Device";
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
        
        _tableView.tableFooterView = self.footerView;
    }
    return _tableView;
}

- (NSMutableArray *)section0List {
    if (!_section0List) {
        _section0List = [NSMutableArray array];
    }
    return _section0List;
}

- (NSMutableArray *)section1List {
    if (!_section1List) {
        _section1List = [NSMutableArray array];
    }
    return _section1List;
}

- (NSMutableArray *)headerList {
    if (!_headerList) {
        _headerList = [NSMutableArray array];
    }
    return _headerList;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 250.f)];
        
        CGSize noteSize = [NSString sizeWithText:noteMsg
                                         andFont:MKFont(12.f)
                                      andMaxSize:CGSizeMake(kViewWidth - 2 * 15.f, MAXFLOAT)];
        UILabel *noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f,
                                                                       15.f,
                                                                       kViewWidth - 2 * 15.f,
                                                                       noteSize.height)];
        noteLabel.textColor = DEFAULT_TEXT_COLOR;
        noteLabel.textAlignment = NSTextAlignmentLeft;
        noteLabel.font = MKFont(12.f);
        noteLabel.text = noteMsg;
        noteLabel.numberOfLines = 0;
        [_footerView addSubview:noteLabel];
        
        UIButton *retainButton = [MKCustomUIAdopter customButtonWithTitle:@"Retain parameters"
                                                                   target:self
                                                                   action:@selector(retainButtonPressed)];
        
        retainButton.frame = CGRectMake(30.f, 15.f + noteSize.height + 20.f, kViewWidth - 2 * 30.f, 40.f);
        [_footerView addSubview:retainButton];
        retainButton.hidden = ![MKCFDeviceMQTTParamsModel shared].cloud;
        
        UIButton *connectButton = [MKCustomUIAdopter customButtonWithTitle:@"Connect"
                                                                    target:self
                                                                    action:@selector(connectButtonPressed)];
        
        connectButton.frame = CGRectMake(30.f, 15.f + noteSize.height + 20.f + 60.f, kViewWidth - 2 * 30.f, 40.f);
        [_footerView addSubview:connectButton];
    }
    return _footerView;
}

- (MKProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[MKProgressView alloc] initWithTitle:@"Connecting now!"
                                                      message:@"Make sure your device is as close to your router as possible"];
    }
    return _progressView;
}

- (MKCFDeviceParamListModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKCFDeviceParamListModel alloc] init];
    }
    return _dataModel;
}

@end
