//
//  MKCMDeviceConnectedController.m
//  MKCommureApp_Example
//
//  Created by aa on 2023/4/21.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCMDeviceConnectedController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "NSString+MKAdd.h"
#import "UITableView+MKAdd.h"
#import "NSDictionary+MKAdd.h"

#import "MKHudManager.h"
#import "MKCustomUIAdopter.h"
#import "MKTableSectionLineHeader.h"
#import "MKAlertView.h"
#import "MKSettingTextCell.h"
#import "MKNormalTextCell.h"
#import "MKTextSwitchCell.h"

#import "MKCMMQTTDataManager.h"
#import "MKCMMQTTInterface.h"

#import "MKCMDeviceModeManager.h"
#import "MKCMDeviceModel.h"

#import "MKCMDeviceConnectedModel.h"

#import "MKCMDeviceConnectedButtonCell.h"
#import "MKCMReminderAlertView.h"

#import "MKCMBeaconOTAController.h"
#import "MKCMSosTriggerController.h"
#import "MKCMSelfTestTriggerController.h"
#import "MKCMBatteryTestController.h"
#import "MKCMAccelerometerController.h"
#import "MKCMSleepModeController.h"
#import "MKAdvParamsConfigController.h"

@interface MKCMDeviceConnectedController ()<UITableViewDelegate,
UITableViewDataSource,
mk_textSwitchCellDelegate,
MKCMDeviceConnectedButtonCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)NSMutableArray *section3List;

@property (nonatomic, strong)NSMutableArray *section4List;

@property (nonatomic, strong)NSMutableArray *section5List;

@property (nonatomic, strong)NSMutableArray *section6List;

@property (nonatomic, strong)NSMutableArray *section7List;

@property (nonatomic, strong)NSMutableArray *section8List;

@property (nonatomic, strong)NSMutableArray *headerList;

@property (nonatomic, strong)MKCMDeviceConnectedModel *dataModel;

@property (nonatomic, copy)NSString *targetTagId;

@property (nonatomic, copy)NSString *encryptionKey;

@property (nonatomic, copy)NSString *password;

@end

@implementation MKCMDeviceConnectedController

- (void)dealloc {
    NSLog(@"MKCMDeviceConnectedController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self readDataFromDevice];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self loadSectionDatas];
    [self addNotifications];
}

#pragma mark - super method
- (void)rightButtonMethod {
    @weakify(self);
    MKAlertViewAction *cancelAction = [[MKAlertViewAction alloc] initWithTitle:@"Cancel" handler:^{
        
    }];
    
    MKAlertViewAction *confirmAction = [[MKAlertViewAction alloc] initWithTitle:@"Confirm" handler:^{
        @strongify(self);
        [self disconnect];
    }];
    NSString *msg = @"Please confirm agian whether to disconnect the gateway from BLE devices?";
    MKAlertView *alertView = [[MKAlertView alloc] init];
    [alertView addAction:cancelAction];
    [alertView addAction:confirmAction];
    [alertView showAlertWithTitle:@"" message:msg notificationName:@"mk_cm_needDismissAlert"];
}

- (void)leftButtonMethod {
    //用户点击左上角，则需要返回MKCMDeviceDataController
    [self popToViewControllerWithClassName:@"MKCMDeviceDataController"];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 2 || section == 4 || section == 6) {
        return 20.f;
    }
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MKTableSectionLineHeader *headerView = [MKTableSectionLineHeader initHeaderViewWithTableView:tableView];
    headerView.headerModel = self.headerList[section];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 2) {
        //Tag ID
        [self showTagIDAlert];
        return;
    }
    if (indexPath.section == 3 && indexPath.row == 0) {
        //LED Reminder
        [self showLedReminderAlert];
        return;
    }
    if (indexPath.section == 3 && indexPath.row == 1) {
        //Buzzer Reminder
        [self showBuzzerReminderAlert];
        return;
    }
    if (indexPath.section == 5 && indexPath.row == 0) {
        //Update encryption key
        [self showEncryptionKeyAlert];
        return;
    }
    if (indexPath.section == 5 && indexPath.row == 1) {
        //SOS triggered by button
        MKCMSosTriggerController *vc = [[MKCMSosTriggerController alloc] init];
        vc.bleMac = self.deviceBleInfo[@"data"][@"mac"];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 5 && indexPath.row == 2) {
        //Self test triggered by button
        MKCMSelfTestTriggerController *vc = [[MKCMSelfTestTriggerController alloc] init];
        vc.bleMac = self.deviceBleInfo[@"data"][@"mac"];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 5 && indexPath.row == 3) {
        //Battery test parameters
        MKCMBatteryTestController *vc = [[MKCMBatteryTestController alloc] init];
        vc.bleMac = self.deviceBleInfo[@"data"][@"mac"];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 5 && indexPath.row == 4) {
        //Accelerometer parameters
        MKCMAccelerometerController *vc = [[MKCMAccelerometerController alloc] init];
        vc.bleMac = self.deviceBleInfo[@"data"][@"mac"];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 5 && indexPath.row == 5) {
        //Sleep mode parameters
        MKCMSleepModeController *vc = [[MKCMSleepModeController alloc] init];
        vc.bleMac = self.deviceBleInfo[@"data"][@"mac"];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 5 && indexPath.row == 6) {
        //Power off
        [self showPowerOffAlert];
        return;
    }
    if (indexPath.section == 5 && indexPath.row == 7) {
        //Restore to factory settings
        [self showResetAlert];
        return;
    }
    if (indexPath.section == 6 && indexPath.row == 0) {
        //ADV parameters
        MKAdvParamsConfigController *vc = [[MKAdvParamsConfigController alloc] init];
        vc.bleMac = self.deviceBleInfo[@"data"][@"mac"];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 8 && indexPath.row == 0) {
        //Change password
        [self showPasswordAlert];
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
    if (section == 2) {
        return self.section2List.count;
    }
    if (section == 3) {
        return self.section3List.count;
    }
    if (section == 4) {
        return self.section4List.count;
    }
    if (section == 5) {
        return self.section5List.count;
    }
    if (section == 6) {
        return self.section6List.count;
    }
    if (section == 7) {
        return self.section7List.count;
    }
    if (section == 8) {
        return (self.dataModel.passwordVerification ? self.section8List.count : 0);
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        return cell;
    }
    if (indexPath.section == 1) {
        MKCMDeviceConnectedButtonCell *cell = [MKCMDeviceConnectedButtonCell initCellWithTableView:tableView];
        cell.dataModel = self.section1List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 2) {
        MKCMDeviceConnectedButtonCell *cell = [MKCMDeviceConnectedButtonCell initCellWithTableView:tableView];
        cell.dataModel = self.section2List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 3) {
        MKSettingTextCell *cell = [MKSettingTextCell initCellWithTableView:tableView];
        cell.dataModel = self.section3List[indexPath.row];
        return cell;
    }
    if (indexPath.section == 4) {
        MKCMDeviceConnectedButtonCell *cell = [MKCMDeviceConnectedButtonCell initCellWithTableView:tableView];
        cell.dataModel = self.section4List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 5) {
        MKSettingTextCell *cell = [MKSettingTextCell initCellWithTableView:tableView];
        cell.dataModel = self.section5List[indexPath.row];
        return cell;
    }
    if (indexPath.section == 6) {
        MKSettingTextCell *cell = [MKSettingTextCell initCellWithTableView:tableView];
        cell.dataModel = self.section6List[indexPath.row];
        return cell;
    }
    if (indexPath.section == 7) {
        MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:tableView];
        cell.dataModel = self.section7List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKSettingTextCell *cell = [MKSettingTextCell initCellWithTableView:tableView];
    cell.dataModel = self.section8List[indexPath.row];
    return cell;
}

#pragma mark - mk_textSwitchCellDelegate
/// 开关状态发生改变了
/// @param isOn 当前开关状态
/// @param index 当前cell所在的index
- (void)mk_textSwitchCellStatusChanged:(BOOL)isOn index:(NSInteger)index {
    if (index == 0) {
        //Password verification
        [self sendPasswordVerificationToDevice:isOn];
        return;
    }
}

#pragma mark - MKCMDeviceConnectedButtonCellDelegate
- (void)cm_deviceConnectedButtonCell_buttonPressed:(NSInteger)index {
    if (index == 0) {
        //DFU
        MKCMBeaconOTAController *vc = [[MKCMBeaconOTAController alloc] init];
        vc.bleMac = self.deviceBleInfo[@"data"][@"mac"];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (index == 1) {
        //Battery
        [self readDataFromDevice];
        return;
    }
    if (index == 2) {
        //Alarm status
        [self dismissAlarmStatus];
        return;
    }
    if (index == 3) {
        //Timestamp
        [self syncTimestamp];
        return;
    }
}

#pragma mark - notes
- (void)receiveDisconnect:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user) || !ValidStr(user[@"device_info"][@"mac"]) || ![[MKCMDeviceModeManager shared].macAddress isEqualToString:user[@"device_info"][@"mac"]]) {
        return;
    }
    NSDictionary *dataDic = user[@"data"];
    if (![dataDic[@"mac"] isEqualToString:self.deviceBleInfo[@"data"][@"mac"]]) {
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_cm_needDismissAlert" object:nil];
    //返回上一级页面
    [self gotoLastPage];
}

#pragma mark - interface
- (void)readDataFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel readDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self updateCellState];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)disconnect {
    [[MKHudManager share] showHUDWithTitle:@"Waiting..." inView:self.view isPenetration:NO];
    [MKCMMQTTInterface cm_disconnectBleDeviceWithBleMac:self.deviceBleInfo[@"data"][@"mac"] macAddress:[MKCMDeviceModeManager shared].macAddress topic:[MKCMDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        [self.navigationController popViewControllerAnimated:YES];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)dismissAlarmStatus {
    [[MKHudManager share] showHUDWithTitle:@"Waiting..." inView:self.view isPenetration:NO];
    [MKCMMQTTInterface cm_dismissBXPButtonAlarmStatusWithBleMacAddress:self.deviceBleInfo[@"data"][@"mac"] macAddress:[MKCMDeviceModeManager shared].macAddress topic:[MKCMDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        if ([returnData[@"data"][@"result_code"] integerValue] != 0) {
            [self.view showCentralToast:@"Read Failed"];
            return;
        }
        [self readDataFromDevice];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)sendTagIDToDevice {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    [MKCMMQTTInterface cm_configTagID:self.targetTagId bleMac:self.deviceBleInfo[@"data"][@"mac"] macAddress:[MKCMDeviceModeManager shared].macAddress topic:[MKCMDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        if ([returnData[@"data"][@"result_code"] integerValue] != 0) {
            [self.view showCentralToast:@"setup failed!"];
            return;
        }
        [self readDataFromDevice];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"setup failed!"];
    }];
}

- (void)sendLedReminder:(NSString *)interval duration:(NSString *)duration color:(NSInteger)color {
    if (!ValidStr(interval) || !ValidStr(duration)) {
        [self.view showCentralToast:@"Params Cannot Be Empty!"];
        return;
    }
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    [MKCMMQTTInterface cm_configDeviceLedReminderWithBleMac:self.deviceBleInfo[@"data"][@"mac"] color:color interval:[interval integerValue] duration:[duration integerValue] macAddress:[MKCMDeviceModeManager shared].macAddress topic:[MKCMDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        if ([returnData[@"data"][@"result_code"] integerValue] != 0) {
            [self.view showCentralToast:@"setup failed!"];
            return;
        }
        [self.view showCentralToast:@"setup success!"];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"setup failed!"];
    }];
}

- (void)sendBuzzerReminder:(NSString *)interval duration:(NSString *)duration {
    if (!ValidStr(interval) || !ValidStr(duration)) {
        [self.view showCentralToast:@"Params Cannot Be Empty!"];
        return;
    }
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    [MKCMMQTTInterface cm_configDeviceBuzzerReminderWithBleMac:self.deviceBleInfo[@"data"][@"mac"] interval:[interval integerValue] duration:[duration integerValue] macAddress:[MKCMDeviceModeManager shared].macAddress topic:[MKCMDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        if ([returnData[@"data"][@"result_code"] integerValue] != 0) {
            [self.view showCentralToast:@"setup failed!"];
            return;
        }
        [self.view showCentralToast:@"setup success!"];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"setup failed!"];
    }];
}

- (void)syncTimestamp {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    long timestamp = [[NSDate date] timeIntervalSince1970] * 1000;
    [MKCMMQTTInterface cm_configDeviceTimestampWithBleMac:self.deviceBleInfo[@"data"][@"mac"] timestamp:timestamp macAddress:[MKCMDeviceModeManager shared].macAddress topic:[MKCMDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        if ([returnData[@"data"][@"result_code"] integerValue] != 0) {
            [self.view showCentralToast:@"setup failed!"];
            return;
        }
        [self.view showCentralToast:@"setup success!"];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"setup failed!"];
    }];
}

- (void)sendEncryptionKeyToDevice {
    if (!ValidStr(self.encryptionKey) || self.encryptionKey.length != 64 || [self.encryptionKey regularExpressions:isHexadecimal]) {
        [self.view showCentralToast:@"Params Error"];
        return;
    }
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    [MKCMMQTTInterface cm_batchUpdateKey:self.encryptionKey beaconList:@[@{
        @"macAddress":SafeStr(self.deviceBleInfo[@"data"][@"mac"]),
        @"password":@""
    }] macAddress:[MKCMDeviceModeManager shared].macAddress topic:[MKCMDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        if ([returnData[@"data"][@"result_code"] integerValue] != 0) {
            [self.view showCentralToast:@"setup failed!"];
            return;
        }
        [self.view showCentralToast:@"setup success!"];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"setup failed!"];
    }];
}

- (void)sendPowerOffToDevice {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    [MKCMMQTTInterface cm_powerOffConnectedDeviceWithBleMac:self.deviceBleInfo[@"data"][@"mac"] macAddress:[MKCMDeviceModeManager shared].macAddress topic:[MKCMDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        if ([returnData[@"data"][@"result_code"] integerValue] != 0) {
            [self.view showCentralToast:@"setup failed!"];
            return;
        }
        [self.view showCentralToast:@"setup success!"];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"setup failed!"];
    }];
}

- (void)sendResetToDevice {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    [MKCMMQTTInterface cm_resetConnectedDeviceWithBleMac:self.deviceBleInfo[@"data"][@"mac"] macAddress:[MKCMDeviceModeManager shared].macAddress topic:[MKCMDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        if ([returnData[@"data"][@"result_code"] integerValue] != 0) {
            [self.view showCentralToast:@"setup failed!"];
            return;
        }
        [self.view showCentralToast:@"setup success!"];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"setup failed!"];
    }];
}

- (void)sendPasswordToDevice {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    [MKCMMQTTInterface cm_configPasswordVerificationWithBleMacAddress:self.deviceBleInfo[@"data"][@"mac"] password:self.password macAddress:[MKCMDeviceModeManager shared].macAddress topic:[MKCMDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        if ([returnData[@"data"][@"result_code"] integerValue] != 0) {
            [self.view showCentralToast:@"setup failed!"];
            return;
        }
        [self.view showCentralToast:@"setup success!"];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"setup failed!"];
    }];
}

- (void)sendPasswordVerificationToDevice:(BOOL)isOn {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    [MKCMMQTTInterface cm_configPasswordVerificationStatusWithBleMacAddress:self.deviceBleInfo[@"data"][@"mac"] isOn:isOn macAddress:[MKCMDeviceModeManager shared].macAddress topic:[MKCMDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        if ([returnData[@"data"][@"result_code"] integerValue] != 0) {
            [self.view showCentralToast:@"setup failed!"];
            return;
        }
        [self.view showCentralToast:@"setup success!"];
        self.dataModel.passwordVerification = isOn;
        MKTextSwitchCellModel *cellModel = self.section7List[0];
        cellModel.isOn = isOn;
        [self.tableView mk_reloadSection:8 withRowAnimation:UITableViewRowAnimationNone];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"setup failed!"];
        [self.tableView mk_reloadSection:7 withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (void)updateCellState {
    MKNormalTextCellModel *tagIDModel = self.section0List[2];
    tagIDModel.rightMsg = SafeStr(self.dataModel.tagID);
    
    MKCMDeviceConnectedButtonCellModel *batteryModel = self.section1List[1];
    batteryModel.valueMsg = [SafeStr(self.dataModel.battery) stringByAppendingString:@"mV"];
    
    MKCMDeviceConnectedButtonCellModel *alarmModel = self.section2List[0];
    alarmModel.showButton = (self.dataModel.alarmStatus == 1);
    if (self.dataModel.alarmStatus == 0) {
        alarmModel.valueMsg = @"Not triggered";
    }else if (self.dataModel.alarmStatus == 1) {
        alarmModel.valueMsg = @"Triggered";
    }else if (self.dataModel.alarmStatus == 2) {
        alarmModel.valueMsg = @"Triggered&Dismissed";
    }else if (self.dataModel.alarmStatus == 3) {
        alarmModel.valueMsg = @"Self testing";
    }
    
    MKTextSwitchCellModel *passCellModel = self.section7List[0];
    passCellModel.isOn = self.dataModel.passwordVerification;
    
    [self.tableView reloadData];
}

#pragma mark - Private method
- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveDisconnect:)
                                                 name:MKCMReceiveGatewayDisconnectDeviceNotification
                                               object:nil];
}

- (void)showTagIDAlert {
    @weakify(self);
    MKAlertViewAction *cancelAction = [[MKAlertViewAction alloc] initWithTitle:@"Cancel" handler:^{
        @strongify(self);
    }];
    
    MKAlertViewAction *confirmAction = [[MKAlertViewAction alloc] initWithTitle:@"OK" handler:^{
        @strongify(self);
        [self sendTagIDToDevice];
    }];
    MKAlertViewTextField *textField = [[MKAlertViewTextField alloc] initWithTextValue:@""
                                                                          placeholder:@"3 Bytes"
                                                                        textFieldType:mk_hexCharOnly
                                                                            maxLength:6
                                                                              handler:^(NSString * _Nonnull text) {
        @strongify(self);
        self.targetTagId = text;
    }];
    
    MKAlertView *alertView = [[MKAlertView alloc] init];
    [alertView addAction:cancelAction];
    [alertView addAction:confirmAction];
    [alertView addTextField:textField];
    [alertView showAlertWithTitle:@"Modify Tag ID" message:@"" notificationName:@"mk_cm_needDismissAlert"];
}

- (void)showLedReminderAlert {
    MKCMReminderAlertViewModel *dataModel = [[MKCMReminderAlertViewModel alloc] init];
    dataModel.needColor = YES;
    dataModel.title = @"LED Reminder";
    dataModel.intervalMsg = @"Blinking interval";
    dataModel.durationMsg = @"Blinking duration";
    MKCMReminderAlertView *alertView = [[MKCMReminderAlertView alloc] init];
    [alertView showAlertWithModel:dataModel confirmAction:^(NSString * _Nonnull interval, NSString * _Nonnull duration, NSInteger color) {
        [self sendLedReminder:interval duration:duration color:color];
    }];
}

- (void)showBuzzerReminderAlert {
    MKCMReminderAlertViewModel *dataModel = [[MKCMReminderAlertViewModel alloc] init];
    dataModel.title = @"Buzzer Reminder";
    dataModel.intervalMsg = @"Ring interval";
    dataModel.durationMsg = @"Ring duration";
    MKCMReminderAlertView *alertView = [[MKCMReminderAlertView alloc] init];
    [alertView showAlertWithModel:dataModel confirmAction:^(NSString * _Nonnull interval, NSString * _Nonnull duration, NSInteger color) {
        [self sendBuzzerReminder:interval duration:duration];
    }];
}

- (void)showEncryptionKeyAlert {
    @weakify(self);
    MKAlertViewAction *cancelAction = [[MKAlertViewAction alloc] initWithTitle:@"Cancel" handler:^{
        @strongify(self);
    }];
    
    MKAlertViewAction *confirmAction = [[MKAlertViewAction alloc] initWithTitle:@"OK" handler:^{
        @strongify(self);
        [self sendEncryptionKeyToDevice];
    }];
    MKAlertViewTextField *textField = [[MKAlertViewTextField alloc] initWithTextValue:@""
                                                                          placeholder:@"32 Bytes"
                                                                        textFieldType:mk_hexCharOnly
                                                                            maxLength:64
                                                                              handler:^(NSString * _Nonnull text) {
        @strongify(self);
        self.encryptionKey = text;
    }];
    
    MKAlertView *alertView = [[MKAlertView alloc] init];
    [alertView addAction:cancelAction];
    [alertView addAction:confirmAction];
    [alertView addTextField:textField];
    [alertView showAlertWithTitle:@"Update encryption key" message:@"" notificationName:@"mk_cm_needDismissAlert"];
}

- (void)showPowerOffAlert {
    @weakify(self);
    MKAlertViewAction *cancelAction = [[MKAlertViewAction alloc] initWithTitle:@"Cancel" handler:^{
        
    }];
    
    MKAlertViewAction *confirmAction = [[MKAlertViewAction alloc] initWithTitle:@"Confirm" handler:^{
        @strongify(self);
        [self sendPowerOffToDevice];
    }];
    NSString *msg = @"Please confirm whether to power off the beacon?";
    MKAlertView *alertView = [[MKAlertView alloc] init];
    [alertView addAction:cancelAction];
    [alertView addAction:confirmAction];
    [alertView showAlertWithTitle:@"" message:msg notificationName:@"mk_cm_needDismissAlert"];
}

- (void)showResetAlert {
    @weakify(self);
    MKAlertViewAction *cancelAction = [[MKAlertViewAction alloc] initWithTitle:@"Cancel" handler:^{
        
    }];
    
    MKAlertViewAction *confirmAction = [[MKAlertViewAction alloc] initWithTitle:@"Confirm" handler:^{
        @strongify(self);
        [self sendResetToDevice];
    }];
    NSString *msg = @"Please confirm whether to reset the beacon?";
    MKAlertView *alertView = [[MKAlertView alloc] init];
    [alertView addAction:cancelAction];
    [alertView addAction:confirmAction];
    [alertView showAlertWithTitle:@"" message:msg notificationName:@"mk_cm_needDismissAlert"];
}

- (void)showPasswordAlert {
    @weakify(self);
    MKAlertViewAction *cancelAction = [[MKAlertViewAction alloc] initWithTitle:@"Cancel" handler:^{
        @strongify(self);
    }];
    
    MKAlertViewAction *confirmAction = [[MKAlertViewAction alloc] initWithTitle:@"OK" handler:^{
        @strongify(self);
        [self sendPasswordToDevice];
    }];
    MKAlertViewTextField *textField = [[MKAlertViewTextField alloc] initWithTextValue:@""
                                                                          placeholder:@"1~16 Characters"
                                                                        textFieldType:mk_normal
                                                                            maxLength:16
                                                                              handler:^(NSString * _Nonnull text) {
        @strongify(self);
        self.password = text;
    }];
    
    MKAlertView *alertView = [[MKAlertView alloc] init];
    [alertView addAction:cancelAction];
    [alertView addAction:confirmAction];
    [alertView addTextField:textField];
    [alertView showAlertWithTitle:@"Change password" message:@"" notificationName:@"mk_cm_needDismissAlert"];
}

- (void)gotoLastPage {
    //返回上一级页面
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:NSClassFromString(@"MKCMManageBleDevicesController")]) {
            //如果是从Manage BLE devices页面进来的
            [self popToViewControllerWithClassName:@"MKCMManageBleDevicesController"];
            break;
        }
        if ([vc isKindOfClass:NSClassFromString(@"MKCMDeviceDataController")]) {
            //如果是从扫描页面进来的
            [self popToViewControllerWithClassName:@"MKCMDeviceDataController"];
            break;
        }
    }
}

#pragma mark - loadSections
- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    [self loadSection2Datas];
    [self loadSection3Datas];
    [self loadSection4Datas];
    [self loadSection5Datas];
    [self loadSection6Datas];
    [self loadSection7Datas];
    [self loadSection8Datas];
    
    for (NSInteger i = 0; i < 9; i ++) {
        MKTableSectionLineHeaderModel *headerModel = [[MKTableSectionLineHeaderModel alloc] init];
        if (i == 0) {
            headerModel.text = @"Device info and battery";
        }else if (i == 2) {
            headerModel.text = @"Alarm response";
        }else if (i == 4) {
            headerModel.text = @"System parameters";
        }else if (i == 6) {
            headerModel.text = @"BLE parameters";
        }
        [self.headerList addObject:headerModel];
    }
        
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKNormalTextCellModel *cellModel1 = [[MKNormalTextCellModel alloc] init];
    cellModel1.leftMsg = @"Product name";
    cellModel1.rightMsg = SafeStr(self.deviceBleInfo[@"data"][@"product_model"]);
    [self.section0List addObject:cellModel1];
    
    MKNormalTextCellModel *cellModel2 = [[MKNormalTextCellModel alloc] init];
    cellModel2.leftMsg = @"MAC address";
    cellModel2.rightMsg = SafeStr(self.deviceBleInfo[@"data"][@"mac"]);
    [self.section0List addObject:cellModel2];
    
    MKNormalTextCellModel *cellModel3 = [[MKNormalTextCellModel alloc] init];
    cellModel3.leftMsg = @"Tag ID";
    cellModel3.showRightIcon = YES;
    [self.section0List addObject:cellModel3];
}

- (void)loadSection1Datas {
    MKCMDeviceConnectedButtonCellModel *cellModel1 = [[MKCMDeviceConnectedButtonCellModel alloc] init];
    cellModel1.index = 0;
    cellModel1.msg = @"Firmware version";
    cellModel1.valueMsg = SafeStr(self.deviceBleInfo[@"data"][@"firmware_version"]);
    cellModel1.buttonTitle = @"DFU";
    cellModel1.showButton = YES;
    [self.section1List addObject:cellModel1];
    
    MKCMDeviceConnectedButtonCellModel *cellModel2 = [[MKCMDeviceConnectedButtonCellModel alloc] init];
    cellModel2.index = 1;
    cellModel2.msg = @"Battery voltage";
    cellModel2.buttonTitle = @"Read";
    cellModel2.showButton = YES;
    [self.section1List addObject:cellModel2];
}

- (void)loadSection2Datas {
    MKCMDeviceConnectedButtonCellModel *cellModel = [[MKCMDeviceConnectedButtonCellModel alloc] init];
    cellModel.index = 2;
    cellModel.msg = @"Alarm status";
    cellModel.buttonTitle = @"Dismiss";
    cellModel.showButton = YES;
    [self.section2List addObject:cellModel];
}

- (void)loadSection3Datas {
    MKSettingTextCellModel *cellModel1 = [[MKSettingTextCellModel alloc] init];
    cellModel1.leftMsg = @"LED reminder";
    [self.section3List addObject:cellModel1];
    
    MKSettingTextCellModel *cellModel2 = [[MKSettingTextCellModel alloc] init];
    cellModel2.leftMsg = @"Buzzer reminder";
    [self.section3List addObject:cellModel2];
}

- (void)loadSection4Datas {
    MKCMDeviceConnectedButtonCellModel *cellModel = [[MKCMDeviceConnectedButtonCellModel alloc] init];
    cellModel.index = 3;
    cellModel.msg = @"Timestamp";
    cellModel.buttonTitle = @"Sync";
    cellModel.showButton = YES;
    [self.section4List addObject:cellModel];
}

- (void)loadSection5Datas {
//    MKSettingTextCellModel *cellModel1 = [[MKSettingTextCellModel alloc] init];
//    cellModel1.leftMsg = @"Device information";
//    [self.section5List addObject:cellModel1];
//
    MKSettingTextCellModel *cellModel2 = [[MKSettingTextCellModel alloc] init];
    cellModel2.leftMsg = @"Update encryption key";
    [self.section5List addObject:cellModel2];
    
    MKSettingTextCellModel *cellModel3 = [[MKSettingTextCellModel alloc] init];
    cellModel3.leftMsg = @"SOS triggered by button";
    [self.section5List addObject:cellModel3];
    
    MKSettingTextCellModel *cellModel4 = [[MKSettingTextCellModel alloc] init];
    cellModel4.leftMsg = @"Self test triggered by button";
    [self.section5List addObject:cellModel4];
    
    MKSettingTextCellModel *cellModel5 = [[MKSettingTextCellModel alloc] init];
    cellModel5.leftMsg = @"Battery test parameters";
    [self.section5List addObject:cellModel5];
    
    MKSettingTextCellModel *cellModel6 = [[MKSettingTextCellModel alloc] init];
    cellModel6.leftMsg = @"Accelerometer parameters";
    [self.section5List addObject:cellModel6];
    
    MKSettingTextCellModel *cellModel7 = [[MKSettingTextCellModel alloc] init];
    cellModel7.leftMsg = @"Sleep mode parameters";
    [self.section5List addObject:cellModel7];
    
    MKSettingTextCellModel *cellModel8 = [[MKSettingTextCellModel alloc] init];
    cellModel8.leftMsg = @"Power off";
    [self.section5List addObject:cellModel8];
    
    MKSettingTextCellModel *cellModel9 = [[MKSettingTextCellModel alloc] init];
    cellModel9.leftMsg = @"Restore to factory settings";
    [self.section5List addObject:cellModel9];
}

- (void)loadSection6Datas {
    MKSettingTextCellModel *cellModel = [[MKSettingTextCellModel alloc] init];
    cellModel.leftMsg = @"ADV parameters";
    [self.section6List addObject:cellModel];
}

- (void)loadSection7Datas {
    MKTextSwitchCellModel *cellModel = [[MKTextSwitchCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = @"Password verification";
    cellModel.isOn = self.dataModel.passwordVerification;
    [self.section7List addObject:cellModel];
}
- (void)loadSection8Datas {
    MKSettingTextCellModel *cellModel = [[MKSettingTextCellModel alloc] init];
    cellModel.leftMsg = @"Change password";
    [self.section8List addObject:cellModel];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = [MKCMDeviceModeManager shared].deviceName;
    [self.rightButton setTitle:@"Disconnect" forState:UIControlStateNormal];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(defaultTopInset);
        make.bottom.mas_equalTo(-VirtualHomeHeight);
    }];
}

#pragma mark - getter
- (MKBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = RGBCOLOR(242, 242, 242);
        _tableView.delegate = self;
        _tableView.dataSource = self;
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

- (NSMutableArray *)section2List {
    if (!_section2List) {
        _section2List = [NSMutableArray array];
    }
    return _section2List;
}

- (NSMutableArray *)section3List {
    if (!_section3List) {
        _section3List = [NSMutableArray array];
    }
    return _section3List;
}

- (NSMutableArray *)section4List {
    if (!_section4List) {
        _section4List = [NSMutableArray array];
    }
    return _section4List;
}

- (NSMutableArray *)section5List {
    if (!_section5List) {
        _section5List = [NSMutableArray array];
    }
    return _section5List;
}

- (NSMutableArray *)section6List {
    if (!_section6List) {
        _section6List = [NSMutableArray array];
    }
    return _section6List;
}

- (NSMutableArray *)section7List {
    if (!_section7List) {
        _section7List = [NSMutableArray array];
    }
    return _section7List;
}

- (NSMutableArray *)section8List {
    if (!_section8List) {
        _section8List = [NSMutableArray array];
    }
    return _section8List;
}

- (NSMutableArray *)headerList {
    if (!_headerList) {
        _headerList = [NSMutableArray array];
    }
    return _headerList;
}

- (MKCMDeviceConnectedModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKCMDeviceConnectedModel alloc] init];
        _dataModel.deviceBleMacAddress = self.deviceBleInfo[@"data"][@"mac"];
    }
    return _dataModel;
}

@end
