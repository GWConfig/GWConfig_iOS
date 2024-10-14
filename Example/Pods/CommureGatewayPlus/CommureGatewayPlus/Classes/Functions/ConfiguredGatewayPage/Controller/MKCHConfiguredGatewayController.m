//
//  MKCHConfiguredGatewayController.m
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/10/18.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import "MKCHConfiguredGatewayController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import <SGQRCode/SGQRCode.h>

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"
#import "MKAlertView.h"

#import "MKHudManager.h"
#import "MKCustomUIAdopter.h"

#import "MKCHDeviceDatabaseManager.h"

#import "MKCHExcelDataManager.h"

#import "MKCHMQTTDataManager.h"

#import "MKCHDeviceModel.h"

#import "MKCHConfiguredGatewayHeaderView.h"
#import "MKCHConfiguredGatewayCell.h"

#import "MKCHConfiguredGatewayModel.h"

#import "MKCHImportServerController.h"
#import "MKCHQRCodeController.h"

@interface MKCHConfiguredGatewayController ()<UITableViewDelegate,
UITableViewDataSource,
MKCHImportServerControllerDelegate,
MKCHConfiguredGatewayHeaderViewDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)MKCHConfiguredGatewayModel *dataModel;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)MKCHConfiguredGatewayHeaderView *headerView;

@property (nonatomic, strong)NSMutableDictionary *macCache;

@property (nonatomic, strong)UIView *addView;

@property (nonatomic, strong)UIButton *addButton;

@end

@implementation MKCHConfiguredGatewayController

- (void)dealloc {
    NSLog(@"MKCHConfiguredGatewayController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    
    NSString *pubTopic = [[NSUserDefaults standardUserDefaults] objectForKey:@"ch_configGateway_pubTopic"];
    if (!ValidStr(pubTopic)) {
        pubTopic = @"/provision/gateway/data";
    }
    NSString *subTopic = [[NSUserDefaults standardUserDefaults] objectForKey:@"ch_configGateway_subTopic"];
    if (!ValidStr(subTopic)) {
        subTopic = @"/provision/gateway/cmds";
    }
    [self.headerView updateSubTopic:subTopic pubTopic:pubTopic];
    
    self.dataModel.subTopic = subTopic;
    self.dataModel.pubTopic = pubTopic;
}

#pragma mark - super method
- (void)rightButtonMethod {
    if (!ValidStr(self.dataModel.pubTopic) || self.dataModel.pubTopic.length > 128) {
        [self.view showCentralToast:@"Gateway publish topic error!"];
        return;
    }
    if (!ValidStr(self.dataModel.subTopic) || self.dataModel.subTopic.length > 128) {
        [self.view showCentralToast:@"Gateway subscribe topic error!"];
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:self.dataModel.pubTopic forKey:@"ch_configGateway_pubTopic"];
    [[NSUserDefaults standardUserDefaults] setObject:self.dataModel.subTopic forKey:@"ch_configGateway_subTopic"];
    
    [self.view showCentralToast:@"Save Success!"];
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
    MKCHConfiguredGatewayCell *cell = [MKCHConfiguredGatewayCell initCellWithTableView:tableView];
    cell.dataModel = self.dataList[indexPath.row];
    return cell;
}

#pragma mark - MKCHImportServerControllerDelegate
- (void)ch_selectedServerParams:(NSString *)fileName {
    [[MKHudManager share] showHUDWithTitle:@"Loading..." inView:self.view isPenetration:NO];
    [MKCHExcelDataManager parseBeaconOtaExcel:fileName sucBlock:^(NSArray<NSString *> * _Nonnull beaconList) {
        [[MKHudManager share] hide];
        [self.dataList removeAllObjects];
        [self.macCache removeAllObjects];
        NSInteger number = 50;
        if (beaconList.count < 50) {
            number = beaconList.count;
        }
        for (NSInteger i = 0; i < number; i ++) {
            MKCHConfiguredGatewayCellModel *cellModel = [[MKCHConfiguredGatewayCellModel alloc] init];
            cellModel.macAddress = [beaconList[i] lowercaseString];
            cellModel.index = i;
            cellModel.added = NO;
            [self.dataList addObject:cellModel];
            [self.macCache setObject:@(i) forKey:beaconList[i]];
        }
        [self.tableView reloadData];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - MKCHConfiguredGatewayHeaderViewDelegate

- (void)ch_topicValueChanged:(NSString *)topic type:(NSInteger)type {
    if (type == 0) {
        //Gateway subscribe topic
        self.dataModel.subTopic = topic;
        return;
    }
    if (type == 1) {
        //Gateway publish topic
        self.dataModel.pubTopic = topic;
        return;
    }
}

- (void)ch_listButtonPressed {
    MKCHImportServerController *vc = [[MKCHImportServerController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)ch_scanCodeButtonPressed {
    [SGPermission permissionWithType:SGPermissionTypeCamera completion:^(SGPermission * _Nonnull permission, SGPermissionStatus status) {
        if (status == SGPermissionStatusNotDetermined) {
            [permission request:^(BOOL granted) {
                if (granted) {
                    MKCHQRCodeController *vc = [[MKCHQRCodeController alloc] init];
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
            MKCHQRCodeController *vc = [[MKCHQRCodeController alloc] init];
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
- (void)receiveDeviceOnline:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user) || !ValidStr(user[@"macAddress"])) {
        return;
    }
    //接收到设备的网络状态上报，认为设备入网成功
    
    for (NSInteger i = 0; i < self.dataList.count; i ++) {
        MKCHConfiguredGatewayCellModel *cellModel = self.dataList[i];
        if ([cellModel.macAddress isEqual:user[@"macAddress"]]) {
            cellModel.added = YES;
            break;
        }
    }
    [self.tableView reloadData];
}

#pragma mark - event method
- (void)addConfiguredDevice {
    //c8f09ebecd88
    if ([self.addButton.titleLabel.text isEqualToString:@"Start"]) {
        if (!ValidStr(self.dataModel.pubTopic) || self.dataModel.pubTopic.length > 128) {
            [self.view showCentralToast:@"Gateway publish topic error!"];
            return;
        }
        if (!ValidStr(self.dataModel.subTopic) || self.dataModel.subTopic.length > 128) {
            [self.view showCentralToast:@"Gateway subscribe topic error!"];
            return;
        }
        if ([self.dataModel.pubTopic isEqualToString:self.dataModel.subTopic]) {
            [self.view showCentralToast:@"Gateway publish topic must be different to the subscribe topic"];
            return;
        }
        if (self.dataList.count == 0) {
            [self.view showCentralToast:@"Gateway list is empty!"];
            return;
        }
        [self.addButton setTitle:@"Done" forState:UIControlStateNormal];
        [self.view showCentralToast:@"Add Device..."];
        [[MKCHMQTTDataManager shared] subscriptions:@[self.dataModel.pubTopic]];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveDeviceOnline:)
                                                     name:MKCHReceiveDeviceOnlineNotification
                                                   object:nil];
        return;
    }
    //Done
    [self addDeviceToLocal];
}

#pragma mark - interface

#pragma mark - private method
- (void)addQRCode:(NSString *)macAddress {
    if (self.dataList.count >= 50) {
        [self.view showCentralToast:@"Max 50 gateways are allowed!"];
        return;
    }
    NSNumber *contain = self.macCache[macAddress];
    if (contain) {
        //已经包含，重复添加
        [self.view showCentralToast:@"The current device is already in the list."];
        return;
    }
    MKCHConfiguredGatewayCellModel *cellModel = [[MKCHConfiguredGatewayCellModel alloc] init];
    cellModel.macAddress = macAddress;
    cellModel.added = NO;
    
    if (self.dataList.count > 0) {
        [self.dataList insertObject:cellModel atIndex:0];
    }else {
        [self.dataList addObject:cellModel];
    }
    
    [self.macCache removeAllObjects];
    
    for (NSInteger i = 0; i < self.dataList.count; i ++) {
        MKCHConfiguredGatewayCellModel *cellModel = self.dataList[i];
        cellModel.index = i;
        
        [self.macCache setObject:@(i) forKey:cellModel.macAddress];
    }
    [self.tableView reloadData];
}

- (void)updateCellWithMac:(NSString *)macAddress status:(BOOL)added {
    NSNumber *index = self.macCache[macAddress];
    if (!ValidNum(index)) {
        [self.view showCentralToast:@"Current Device is not exsit!"];
        return;
    }
    MKCHConfiguredGatewayCellModel *cellModel = self.dataList[[index integerValue]];
    cellModel.added = added;
    [self.tableView mk_reloadRow:[index integerValue] inSection:0 withRowAnimation:UITableViewRowAnimationNone];
}

- (void)failed {
    MKAlertViewAction *confirmAction = [[MKAlertViewAction alloc] initWithTitle:@"OK" handler:^{
    }];
    NSString *msg = @"[Go to: Settings - Privacy - Camera - SGQRCode] Turn on the access switch.";
    MKAlertView *alertView = [[MKAlertView alloc] init];
    [alertView addAction:confirmAction];
    [alertView showAlertWithTitle:@"" message:msg notificationName:@"mk_ch_needDismissAlert"];
}

- (void)unknown {
    MKAlertViewAction *confirmAction = [[MKAlertViewAction alloc] initWithTitle:@"OK" handler:^{
    }];
    NSString *msg = @"We couldn't detect your camera.";
    MKAlertView *alertView = [[MKAlertView alloc] init];
    [alertView addAction:confirmAction];
    [alertView showAlertWithTitle:@"" message:msg notificationName:@"mk_ch_needDismissAlert"];
}

- (void)addDeviceToLocal {
    if (self.dataList.count == 0) {
        return;
    }
    
    NSMutableArray *deviceList = [NSMutableArray array];
    for (NSInteger i = 0; i < self.dataList.count; i ++) {
        MKCHConfiguredGatewayCellModel *cellModel = self.dataList[i];
        if (cellModel.added) {
            //已经接收到设备数据了
            MKCHDeviceModel *model = [self loadDeviceModel:cellModel.macAddress];
            [deviceList addObject:model];
        }
    }
    if (deviceList.count == 0) {
        [super leftButtonMethod];
        return;
    }
    [[MKHudManager share] showHUDWithTitle:@"Save..." inView:self.view isPenetration:NO];
    [MKCHDeviceDatabaseManager insertDeviceList:deviceList sucBlock:^{
        [[MKHudManager share] hide];
        [self popToViewControllerWithClassName:@"MKCHDeviceListController"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_ch_addBatchDeviceNotification"
                                                            object:nil
                                                          userInfo:@{@"deviceList":deviceList}];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (MKCHDeviceModel *)loadDeviceModel:(NSString *)macAddress {
    MKCHDeviceModel *deviceModel = [[MKCHDeviceModel alloc] init];
    deviceModel.deviceType = @"20";
    deviceModel.clientID = macAddress;
    deviceModel.deviceName = [self deviceName:macAddress];
    deviceModel.subscribedTopic = self.dataModel.subTopic;
    deviceModel.publishedTopic = self.dataModel.pubTopic;
    deviceModel.macAddress = macAddress;
    deviceModel.onLineState = MKCHDeviceModelStateOnline;
    
    return deviceModel;
}

- (NSString *)deviceName:(NSString *)macAddress {
    NSString *temp = [[macAddress substringFromIndex:8] uppercaseString];
    return [@"MK110 Plus 03-" stringByAppendingString:temp];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Add Device";
    [self.rightButton setImage:LOADICON(@"CommureGatewayPlus", @"MKCHConfiguredGatewayController", @"ch_saveIcon.png") forState:UIControlStateNormal];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.addView];
    [self.addView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        make.height.mas_equalTo(60.f);
    }];
    
    [self.addView addSubview:self.addButton];
    [self.addButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.centerY.mas_equalTo(self.addView.mas_centerY);
        make.height.mas_equalTo(35);
    }];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.right.mas_equalTo(-10.f);
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.bottom.mas_equalTo(self.addView.mas_top);
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

- (MKCHConfiguredGatewayHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[MKCHConfiguredGatewayHeaderView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 190.f)];
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

- (MKCHConfiguredGatewayModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKCHConfiguredGatewayModel alloc] init];
    }
    return _dataModel;
}

- (UIView *)addView {
    if (!_addView) {
        _addView = [[UIView alloc] init];
        _addView.backgroundColor = COLOR_WHITE_MACROS;
    }
    return _addView;
}

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [MKCustomUIAdopter customButtonWithTitle:@"Start"
                                                       target:self
                                                       action:@selector(addConfiguredDevice)];
    }
    return _addButton;
}

@end
