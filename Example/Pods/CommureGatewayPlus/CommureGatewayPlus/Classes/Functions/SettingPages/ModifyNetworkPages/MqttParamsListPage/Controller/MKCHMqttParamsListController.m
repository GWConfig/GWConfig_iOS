//
//  MKCHMqttParamsListController.m
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/2/14.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCHMqttParamsListController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "NSString+MKAdd.h"
#import "UITableView+MKAdd.h"

#import "MKHudManager.h"
#import "MKCustomUIAdopter.h"
#import "MKSettingTextCell.h"
#import "MKAlertView.h"

#import "MKCHMQTTDataManager.h"
#import "MKCHMQTTInterface.h"

#import "MKCHDeviceModeManager.h"
#import "MKCHDeviceModel.h"

#import "MKCHDeviceDatabaseManager.h"

#import "MKCHModifyNetworkDataModel.h"

#import "MKCHMqttParamsModel.h"

#import "MKCHMqttWifiSettingsController.h"
#import "MKCHMqttServerController.h"
#import "MKCHMqttNetworkSettingsController.h"

@interface MKCHMqttParamsListController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)UIView *footerView;

@property (nonatomic, strong)MKCHMqttParamsModel *dataModel;

@end

@implementation MKCHMqttParamsListController

- (void)dealloc {
    NSLog(@"MKCHMqttParamsListController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //本页面禁止右划退出手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self readDataFromDevice];
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

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        //WIFI Settings
        MKCHMqttWifiSettingsController *vc = [[MKCHMqttWifiSettingsController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        //MQTT Settings
        MKCHMqttServerController *vc = [[MKCHMqttServerController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 0 && indexPath.row == 2) {
        //Network Settings
        MKCHMqttNetworkSettingsController *vc = [[MKCHMqttNetworkSettingsController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKSettingTextCell *cell = [MKSettingTextCell initCellWithTableView:tableView];
    cell.dataModel = self.dataList[indexPath.row];
    return cell;
}

#pragma mark - event method
- (void)connectButtonPressed {
    
    if ([MKCHModifyNetworkDataModel shared].cloud) {
        //云端下载参数
        [[MKHudManager share] showHUDWithTitle:@"Waiting..." inView:self.view isPenetration:NO];
        @weakify(self);
        [self.dataModel configDataWithSucBlock:^{
            @strongify(self);
            [[MKHudManager share] hide];
            [self updateLocaDeviceData];
        } failedBlock:^(NSError * _Nonnull error) {
            @strongify(self);
            [[MKHudManager share] hide];
            [self.view showCentralToast:@"setup failed!"];
        }];
        return;
    }
    
    @weakify(self);
    MKAlertViewAction *cancelAction = [[MKAlertViewAction alloc] initWithTitle:@"Cancel" handler:^{
        
    }];
    
    MKAlertViewAction *confirmAction = [[MKAlertViewAction alloc] initWithTitle:@"Confirm" handler:^{
        @strongify(self);
        [self deviceReboot];
    }];
    NSString *msg = @"If confirm, device will reboot and use new settings to reconnect.";
    MKAlertView *alertView = [[MKAlertView alloc] init];
    [alertView addAction:cancelAction];
    [alertView addAction:confirmAction];
    [alertView showAlertWithTitle:@"" message:msg notificationName:@"mk_ch_needDismissAlert"];
}

#pragma mark - interface
- (void)readDataFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel readDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        [self performSelector:@selector(leftButtonMethod) withObject:nil afterDelay:0.5f];
    }];
}

- (void)deviceReboot {
    [[MKHudManager share] showHUDWithTitle:@"Waiting..." inView:self.view isPenetration:NO];
    [MKCHMQTTInterface ch_rebootDeviceWithMacAddress:[MKCHDeviceModeManager shared].macAddress topic:[MKCHDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        [self updateLocaDeviceData];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"setup failed!"];
    }];
}

#pragma mark - private method
- (void)updateLocaDeviceData {
    [[MKHudManager share] showHUDWithTitle:@"Waiting..." inView:self.view isPenetration:NO];
    [MKCHDeviceDatabaseManager updateClientID:self.dataModel.clientID subscribedTopic:self.dataModel.subscribeTopic publishedTopic:self.dataModel.publishTopic macAddress:[MKCHDeviceModeManager shared].macAddress sucBlock:^{
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Setup succeed!"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_ch_deviceModifyMQTTServerSuccessNotification"
                                                            object:nil
                                                          userInfo:@{
            @"macAddress":SafeStr([MKCHDeviceModeManager shared].macAddress),
            @"clientID":SafeStr(self.dataModel.clientID),
            @"subscribedTopic":SafeStr(self.dataModel.subscribeTopic),
            @"publishedTopic":SafeStr(self.dataModel.publishTopic),
        }];
        [self performSelector:@selector(gotoHomePage) withObject:nil afterDelay:0.5f];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"setup failed!"];
    }];
}

- (void)gotoHomePage {
    [self popToViewControllerWithClassName:@"MKCHDeviceListController"];
}

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    MKSettingTextCellModel *cellModel1 = [[MKSettingTextCellModel alloc] init];
    cellModel1.leftMsg = @"WIFI Settings";
    [self.dataList addObject:cellModel1];
    
    MKSettingTextCellModel *cellModel2 = [[MKSettingTextCellModel alloc] init];
    cellModel2.leftMsg = @"MQTT Settings";
    [self.dataList addObject:cellModel2];
    
    MKSettingTextCellModel *cellModel3 = [[MKSettingTextCellModel alloc] init];
    cellModel3.leftMsg = @"Network Settings";
    [self.dataList addObject:cellModel3];
    
    [self.tableView reloadData];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Modify network settings";
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

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 150.f)];
        
        UIButton *connectButton = [MKCustomUIAdopter customButtonWithTitle:@"Connect"
                                                                    target:self
                                                                    action:@selector(connectButtonPressed)];
        
        connectButton.frame = CGRectMake(30.f, 40.f, kViewWidth - 2 * 30.f, 40.f);
        [_footerView addSubview:connectButton];
    }
    return _footerView;
}

- (MKCHMqttParamsModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKCHMqttParamsModel alloc] init];
    }
    return _dataModel;
}

@end
