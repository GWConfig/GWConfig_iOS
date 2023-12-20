//
//  MKCFMqttNetworkSettingsController.m
//  CommureGWThree_Example
//
//  Created by aa on 2023/2/14.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCFMqttNetworkSettingsController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"
#import "NSString+MKAdd.h"

#import "MKTableSectionLineHeader.h"

#import "MKHudManager.h"
#import "MKTextButtonCell.h"
#import "MKTextFieldCell.h"
#import "MKTextSwitchCell.h"

#import "MKCFMQTTDataManager.h"

#import "MKCFDeviceModeManager.h"

#import "MKCFMqttNetworkSettingsModel.h"

static NSString *const noteMsg = @"Please note the CA certificate is required, the client certificate and client key are optional.";

@interface MKCFMqttNetworkSettingsController ()<UITableViewDelegate,
UITableViewDataSource,
MKTextButtonCellDelegate,
MKTextFieldCellDelegate,
mk_textSwitchCellDelegate>

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

@property (nonatomic, strong)NSMutableArray *section9List;

@property (nonatomic, strong)NSMutableArray *section10List;

@property (nonatomic, strong)NSMutableArray *section11List;

@property (nonatomic, strong)NSMutableArray *section12List;

@property (nonatomic, strong)NSMutableArray *section13List;

@property (nonatomic, strong)NSMutableArray *section14List;

@property (nonatomic, strong)NSMutableArray *section15List;

@property (nonatomic, strong)NSMutableArray *headerList;

@property (nonatomic, strong)UILabel *noteLabel;

@property (nonatomic, strong)MKCFMqttNetworkSettingsModel *dataModel;

@end

@implementation MKCFMqttNetworkSettingsController

- (void)dealloc {
    NSLog(@"MKCFMqttNetworkSettingsController销毁");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];

    //本页面禁止右划退出手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDatasFromDevice];
}

#pragma mark - super method
- (void)rightButtonMethod {
    [self saveDataToDevice];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MKTableSectionLineHeader *headerView = [MKTableSectionLineHeader initHeaderViewWithTableView:tableView];
    headerView.headerModel = self.headerList[section];
    return headerView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.headerList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self cellForRowAtIndexPath:indexPath];
}

#pragma mark - MKTextButtonCellDelegate
/// 右侧按钮点击触发的回调事件
/// @param index 当前cell所在的index
/// @param dataListIndex 点击按钮选中的dataList里面的index
/// @param value dataList[dataListIndex]
- (void)mk_loraTextButtonCellSelected:(NSInteger)index
                        dataListIndex:(NSInteger)dataListIndex
                                value:(NSString *)value {
    if (index == 0) {
        //Type
        self.dataModel.networkType = dataListIndex;
        MKTextButtonCellModel *cellModel = self.section0List[0];
        cellModel.dataListIndex = dataListIndex;
        [self.tableView reloadData];
        return;
    }
    if (index == 1) {
        //Security
        self.dataModel.security = dataListIndex;
        MKTextButtonCellModel *cellModel = self.section1List[0];
        cellModel.dataListIndex = dataListIndex;
        [self.tableView reloadData];
        return;
    }
    if (index == 2) {
        //EAP type
        self.dataModel.eapType = dataListIndex;
        MKTextButtonCellModel *cellModel = self.section2List[0];
        cellModel.dataListIndex = dataListIndex;
        self.noteLabel.hidden = (self.dataModel.eapType != 2);
        [self.tableView reloadData];
        return;
    }
}

#pragma mark - MKTextFieldCellDelegate
/// textField内容发送改变时的回调事件
/// @param index 当前cell所在的index
/// @param value 当前textField的值
- (void)mk_deviceTextCellValueChanged:(NSInteger)index textValue:(NSString *)value {
    if (index == 0) {
        //SSID
        self.dataModel.ssid = value;
        MKTextFieldCellModel *cellModel = self.section3List[0];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 1) {
        //WIFI Password
        self.dataModel.wifiPassword = value;
        MKTextFieldCellModel *cellModel = self.section4List[0];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 2) {
        //EAP Username
        self.dataModel.eapUserName = value;
        MKTextFieldCellModel *cellModel = self.section5List[0];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 3) {
        //Password
        self.dataModel.eapPassword = value;
        MKTextFieldCellModel *cellModel = self.section6List[0];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 4) {
        //Domain ID
        self.dataModel.domainID = value;
        MKTextFieldCellModel *cellModel = self.section7List[0];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 5) {
        //CA certificate path
        self.dataModel.caFilePath = value;
        MKTextFieldCellModel *cellModel = self.section9List[0];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 6) {
        //Client cert path
        self.dataModel.clientCertPath = value;
        MKTextFieldCellModel *cellModel = self.section10List[0];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 7) {
        //Client key path
        self.dataModel.clientKeyPath = value;
        MKTextFieldCellModel *cellModel = self.section11List[0];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 8) {
        //Ethernet IP
        self.dataModel.ethernet_ip = value;
        MKTextFieldCellModel *cellModel = self.section13List[0];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 9) {
        //Mask
        self.dataModel.ethernet_mask = value;
        MKTextFieldCellModel *cellModel = self.section13List[1];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 10) {
        //Gateway
        self.dataModel.ethernet_gateway = value;
        MKTextFieldCellModel *cellModel = self.section13List[2];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 11) {
        //DNS
        self.dataModel.ethernet_dns = value;
        MKTextFieldCellModel *cellModel = self.section13List[3];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 12) {
        //IP
        self.dataModel.wifi_ip = value;
        MKTextFieldCellModel *cellModel = self.section15List[0];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 13) {
        //Mask
        self.dataModel.wifi_mask = value;
        MKTextFieldCellModel *cellModel = self.section15List[1];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 14) {
        //Gateway
        self.dataModel.wifi_gateway = value;
        MKTextFieldCellModel *cellModel = self.section15List[2];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 15) {
        //DNS
        self.dataModel.wifi_dns = value;
        MKTextFieldCellModel *cellModel = self.section15List[3];
        cellModel.textFieldValue = value;
        return;
    }
}

#pragma mark - mk_textSwitchCellDelegate
/// 开关状态发生改变了
/// @param isOn 当前开关状态
/// @param index 当前cell所在的index
- (void)mk_textSwitchCellStatusChanged:(BOOL)isOn index:(NSInteger)index {
    if (index == 0) {
        //Verify server
        self.dataModel.verifyServer = isOn;
        MKTextSwitchCellModel *cellModel = self.section8List[0];
        cellModel.isOn = isOn;
        
        [self.tableView mk_reloadSection:9 withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
    if (index == 1) {
        //Ethernet DHCP
        self.dataModel.ethernet_dhcp = isOn;
        MKTextSwitchCellModel *cellModel = self.section12List[0];
        cellModel.isOn = isOn;
        [self.tableView mk_reloadSection:13 withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
    if (index == 2) {
        //Wifi DHCP
        self.dataModel.wifi_dhcp = isOn;
        MKTextSwitchCellModel *cellModel = self.section14List[0];
        cellModel.isOn = isOn;
        [self.tableView mk_reloadSection:15 withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
}

#pragma mark - note
- (void)receiveUpdateEAPCerts:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user) || !ValidStr(user[@"device_info"][@"mac"]) || ![[MKCFDeviceModeManager shared].macAddress isEqualToString:user[@"device_info"][@"mac"]]) {
        return;
    }
    [[MKHudManager share] hide];
    NSInteger result = [user[@"data"][@"result_code"] integerValue];
    self.leftButton.enabled = YES;
    if (result == 1) {
        [self.view showCentralToast:@"setup succeed!"];
        [self performSelector:@selector(leftButtonMethod) withObject:nil afterDelay:0.5f];
        return;
    }
    [self.view showCentralToast:@"setup failed"];
}

#pragma mark - interface
- (void)readDatasFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel readDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self loadSectionDatas];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)saveDataToDevice {
    [[MKHudManager share] showHUDWithTitle:@"Waiting..." inView:self.view isPenetration:NO];
    @weakify(self);
    self.leftButton.enabled = NO;
    [self.dataModel configDataWithSucBlock:^{
        @strongify(self);
        if (self.dataModel.networkType == 0) {
            //Network Type为Ethernet
            [[MKHudManager share] hide];
            self.leftButton.enabled = YES;
            [self.view showCentralToast:@"setup succeed!"];
            [self performSelector:@selector(leftButtonMethod) withObject:nil afterDelay:0.5f];
            return;
        }
        //Network Type为Wifi
        //先判断是否下载证书
        if (self.dataModel.security == 1 && !(!ValidStr(self.dataModel.caFilePath) && !ValidStr(self.dataModel.clientKeyPath) && !ValidStr(self.dataModel.clientCertPath))) {
            if (((self.dataModel.eapType == 0 || self.dataModel.eapType == 1) && self.dataModel.verifyServer) || self.dataModel.eapType == 2) {
                //TLS需要配置证书，PEAP-MSCHAPV2和TTLS-MSCHAPV2这两种必须验证服务器打开的情况下才配置证书
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(receiveUpdateEAPCerts:)
                                                             name:MKCFReceiveDeviceUpdateEapCertsResultNotification
                                                           object:nil];
                return;
            }
        }
        
        //不需要证书
        [[MKHudManager share] hide];
        self.leftButton.enabled = YES;
        [self.view showCentralToast:@"setup succeed!"];
        [self performSelector:@selector(leftButtonMethod) withObject:nil afterDelay:0.5f];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"setup failed!"];
        self.leftButton.enabled = YES;
    }];
}

#pragma mark - table数据处理方法
- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        //Type
        return self.section0List.count;
    }
    if (section == 1) {
        //Security
        if (self.dataModel.networkType == 0) {
            return 0;
        }
        return self.section1List.count;
    }
    if (section == 2) {
        //EAP type
        if (self.dataModel.networkType == 0) {
            return 0;
        }
        return (self.dataModel.security == 1 ? self.section2List.count : 0);
    }
    if (section == 3) {
        //SSID
        if (self.dataModel.networkType == 0) {
            return 0;
        }
        return self.section3List.count;
    }
    if (section == 4) {
        //WIFI Password.Security为Personal有效
        if (self.dataModel.networkType == 0) {
            return 0;
        }
        return (self.dataModel.security == 0 ? self.section4List.count : 0);
    }
    if (section == 5) {
        //EAP Username   Security为Enterprise && EAP type为PEAP-MSCHAPV2或者TTLS -MSCHAPV2
        if (self.dataModel.networkType == 0) {
            return 0;
        }
        if (self.dataModel.security == 1 && (self.dataModel.eapType == 0 || self.dataModel.eapType == 1)) {
            return self.section5List.count;
        }
        return 0;
    }
    if (section == 6) {
        //EAP Password
        if (self.dataModel.networkType == 0) {
            return 0;
        }
        if ((self.dataModel.security == 0) || (self.dataModel.security == 1 && self.dataModel.eapType == 2)) {
            //Security为Personal和TLS没有此选项
            return 0;
        }
        return self.section6List.count;
    }
    if (section == 7) {
        //Domain ID. TLS特有
        if (self.dataModel.networkType == 0) {
            return 0;
        }
        return ((self.dataModel.security == 1 && self.dataModel.eapType == 2) ? self.section7List.count : 0);
    }
    if (section == 8) {
        //Verify server. Security为Enterprise && EAP type为PEAP-MSCHAPV2或者TTLS -MSCHAPV2
        if (self.dataModel.networkType == 0) {
            return 0;
        }
        if (self.dataModel.security == 1 && (self.dataModel.eapType == 0 || self.dataModel.eapType == 1)) {
            return self.section8List.count;
        }
        
    }
    if (section == 9) {
        //CA certificate.Security为Enterprise有效
        if (self.dataModel.networkType == 0) {
            return 0;
        }
        if (self.dataModel.security == 1) {
            if (!self.dataModel.verifyServer && (self.dataModel.eapType == 0 || self.dataModel.eapType == 1)) {
                return 0;
            }
            return self.section9List.count;
        }
    }
    if (section == 10) {
        //Client certificate.TLS特有
        if (self.dataModel.networkType == 0) {
            return 0;
        }
        return ((self.dataModel.security == 1 && self.dataModel.eapType == 2) ? self.section10List.count : 0);
    }
    if (section == 11) {
        //Client key.TLS特有
        if (self.dataModel.networkType == 0) {
            return 0;
        }
        return ((self.dataModel.security == 1 && self.dataModel.eapType == 2) ? self.section11List.count : 0);
    }
    if (section == 12) {
        //Ethernet DHCP
        return (self.dataModel.networkType == 0) ? self.section12List.count : 0;
    }
    if (section == 13) {
        if (self.dataModel.networkType == 0) {
            //Ethernet IP
            return (self.dataModel.ethernet_dhcp ? 0 : self.section13List.count);
        }
    }
    
    if (section == 14) {
        //Ethernet DHCP
        return (self.dataModel.networkType == 0) ? 0 : self.section14List.count;
    }
    if (section == 15) {
        if (self.dataModel.networkType == 1) {
            //Ethernet IP
            return (self.dataModel.wifi_dhcp ? 0 : self.section15List.count);
        }
    }
    
    return 0;
}

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        //Type
        MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section0List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 1) {
        //Security
        MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section1List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 2) {
        //EAP type
        MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section2List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 3) {
        //SSID
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section3List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 4) {
        //WIFI Password
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section4List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 5) {
        //EAP Username
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section5List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 6) {
        //EAP Password
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section6List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 7) {
        //Domain ID.
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section7List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 8) {
        //Verify server.
        MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section8List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 9) {
        //CA certificate.
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section9List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 10) {
        //Client certificate.TLS特有
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section10List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 11) {
        //CA certificate
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section11List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 12) {
        //Ethernet DHCP
        MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section12List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 13) {
        //Ethernet IP
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section13List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 14) {
        //Wifi DHCP
        MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section14List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    //Wifi IP
    MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:self.tableView];
    cell.dataModel = self.section15List[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - loadSectionDatas
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
    [self loadSection9Datas];
    [self loadSection10Datas];
    [self loadSection11Datas];
    [self loadSection12Datas];
    [self loadSection13Datas];
    [self loadSection14Datas];
    [self loadSection15Datas];
    
    for (NSInteger i = 0; i < 16; i ++) {
        MKTableSectionLineHeaderModel *headerModel = [[MKTableSectionLineHeaderModel alloc] init];
        [self.headerList addObject:headerModel];
    }
    
    self.noteLabel.hidden = (self.dataModel.eapType != 2);
    
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKTextButtonCellModel *cellModel = [[MKTextButtonCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = @"Type";
    cellModel.buttonLabelFont = MKFont(13.f);
    cellModel.dataList = @[@"Ethernet",@"WiFi"];
    cellModel.dataListIndex = self.dataModel.networkType;
    [self.section0List addObject:cellModel];
}

- (void)loadSection1Datas {
    MKTextButtonCellModel *cellModel = [[MKTextButtonCellModel alloc] init];
    cellModel.index = 1;
    cellModel.msg = @"Security";
    cellModel.buttonLabelFont = MKFont(13.f);
    cellModel.dataList = @[@"Personal",@"Enterprise"];
    cellModel.dataListIndex = self.dataModel.security;
    [self.section1List addObject:cellModel];
}

- (void)loadSection2Datas {
    MKTextButtonCellModel *cellModel = [[MKTextButtonCellModel alloc] init];
    cellModel.index = 2;
    cellModel.msg = @"EAP type";
    cellModel.buttonLabelFont = MKFont(13.f);
    cellModel.dataList = @[@"PEAP-MSCHAPV2",@"TTLS-MSCHAPV2",@"TLS"];
    cellModel.dataListIndex = self.dataModel.eapType;
    [self.section2List addObject:cellModel];
}

- (void)loadSection3Datas {
    MKTextFieldCellModel *cellModel = [[MKTextFieldCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = @"SSID";
    cellModel.maxLength = 32;
    cellModel.textPlaceholder = @"1-32 Characters";
    cellModel.textFieldType = mk_normal;
    cellModel.textFieldValue = self.dataModel.ssid;
    [self.section3List addObject:cellModel];
}

- (void)loadSection4Datas {
    MKTextFieldCellModel *cellModel = [[MKTextFieldCellModel alloc] init];
    cellModel.index = 1;
    cellModel.msg = @"Password";
    cellModel.maxLength = 64;
    cellModel.textPlaceholder = @"0-64 Characters";
    cellModel.textFieldType = mk_normal;
    cellModel.textFieldValue = self.dataModel.wifiPassword;
    [self.section4List addObject:cellModel];
}

- (void)loadSection5Datas {
    MKTextFieldCellModel *cellModel = [[MKTextFieldCellModel alloc] init];
    cellModel.index = 2;
    cellModel.msg = @"Username";
    cellModel.maxLength = 32;
    cellModel.textPlaceholder = @"0-32 Characters";
    cellModel.textFieldType = mk_normal;
    cellModel.textFieldValue = self.dataModel.eapUserName;
    [self.section5List addObject:cellModel];
}

- (void)loadSection6Datas {
    MKTextFieldCellModel *cellModel = [[MKTextFieldCellModel alloc] init];
    cellModel.index = 3;
    cellModel.msg = @"Password";
    cellModel.maxLength = 64;
    cellModel.textPlaceholder = @"0-64 Characters";
    cellModel.textFieldType = mk_normal;
    cellModel.textFieldValue = self.dataModel.eapPassword;
    [self.section6List addObject:cellModel];
}

- (void)loadSection7Datas {
    MKTextFieldCellModel *cellModel = [[MKTextFieldCellModel alloc] init];
    cellModel.index = 4;
    cellModel.msg = @"Domain ID";
    cellModel.maxLength = 64;
    cellModel.textPlaceholder = @"0-64 Characters";
    cellModel.textFieldType = mk_normal;
    cellModel.textFieldValue = self.dataModel.domainID;
    [self.section7List addObject:cellModel];
}

- (void)loadSection8Datas {
    MKTextSwitchCellModel *cellModel = [[MKTextSwitchCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = @"Verify server";
    cellModel.isOn = self.dataModel.verifyServer;
    [self.section8List addObject:cellModel];
}

- (void)loadSection9Datas {
    MKTextFieldCellModel *cellModel = [[MKTextFieldCellModel alloc] init];
    cellModel.index = 5;
    cellModel.msg = @"CA cert file URL";
    cellModel.maxLength = 256;
    cellModel.textPlaceholder = @"0-256 Characters";
    cellModel.textFieldType = mk_normal;
    [self.section9List addObject:cellModel];
}

- (void)loadSection10Datas {
    MKTextFieldCellModel *cellModel = [[MKTextFieldCellModel alloc] init];
    cellModel.index = 6;
    cellModel.msg = @"Client cert file URL";
    cellModel.maxLength = 256;
    cellModel.textPlaceholder = @"0-256 Characters";
    cellModel.textFieldType = mk_normal;
    [self.section10List addObject:cellModel];
}

- (void)loadSection11Datas {
    MKTextFieldCellModel *cellModel = [[MKTextFieldCellModel alloc] init];
    cellModel.index = 7;
    cellModel.msg = @"Client key file URL";
    cellModel.maxLength = 256;
    cellModel.textPlaceholder = @"0-256 Characters";
    cellModel.textFieldType = mk_normal;
    [self.section11List addObject:cellModel];
}

- (void)loadSection12Datas {
    MKTextSwitchCellModel *cellModel = [[MKTextSwitchCellModel alloc] init];
    cellModel.index = 1;
    cellModel.msg = @"DHCP";
    cellModel.isOn = self.dataModel.ethernet_dhcp;
    [self.section12List addObject:cellModel];
}

- (void)loadSection13Datas {
    MKTextFieldCellModel *cellModel1 = [[MKTextFieldCellModel alloc] init];
    cellModel1.index = 5;
    cellModel1.msg = @"IP";
    cellModel1.textFieldType = mk_normal;
    cellModel1.textFieldValue = self.dataModel.ethernet_ip;
    [self.section13List addObject:cellModel1];
    
    MKTextFieldCellModel *cellModel2 = [[MKTextFieldCellModel alloc] init];
    cellModel2.index = 6;
    cellModel2.msg = @"Mask";
    cellModel2.textFieldType = mk_normal;
    cellModel2.textFieldValue = self.dataModel.ethernet_mask;
    [self.section13List addObject:cellModel2];
    
    MKTextFieldCellModel *cellModel3 = [[MKTextFieldCellModel alloc] init];
    cellModel3.index = 7;
    cellModel3.msg = @"Gateway";
    cellModel3.textFieldType = mk_normal;
    cellModel3.textFieldValue = self.dataModel.ethernet_gateway;
    [self.section13List addObject:cellModel3];
    
    MKTextFieldCellModel *cellModel4 = [[MKTextFieldCellModel alloc] init];
    cellModel4.index = 8;
    cellModel4.msg = @"DNS";
    cellModel4.textFieldType = mk_normal;
    cellModel4.textFieldValue = self.dataModel.ethernet_dns;
    [self.section13List addObject:cellModel4];
}

- (void)loadSection14Datas {
    MKTextSwitchCellModel *cellModel = [[MKTextSwitchCellModel alloc] init];
    cellModel.index = 2;
    cellModel.msg = @"DHCP";
    cellModel.isOn = self.dataModel.wifi_dhcp;
    [self.section14List addObject:cellModel];
}

- (void)loadSection15Datas {
    MKTextFieldCellModel *cellModel1 = [[MKTextFieldCellModel alloc] init];
    cellModel1.index = 9;
    cellModel1.msg = @"IP";
    cellModel1.textFieldType = mk_normal;
    cellModel1.textFieldValue = self.dataModel.wifi_ip;
    [self.section15List addObject:cellModel1];
    
    MKTextFieldCellModel *cellModel2 = [[MKTextFieldCellModel alloc] init];
    cellModel2.index = 10;
    cellModel2.msg = @"Mask";
    cellModel2.textFieldType = mk_normal;
    cellModel2.textFieldValue = self.dataModel.wifi_mask;
    [self.section15List addObject:cellModel2];
    
    MKTextFieldCellModel *cellModel3 = [[MKTextFieldCellModel alloc] init];
    cellModel3.index = 11;
    cellModel3.msg = @"Gateway";
    cellModel3.textFieldType = mk_normal;
    cellModel3.textFieldValue = self.dataModel.wifi_gateway;
    [self.section15List addObject:cellModel3];
    
    MKTextFieldCellModel *cellModel4 = [[MKTextFieldCellModel alloc] init];
    cellModel4.index = 12;
    cellModel4.msg = @"DNS";
    cellModel4.textFieldType = mk_normal;
    cellModel4.textFieldValue = self.dataModel.wifi_dns;
    [self.section15List addObject:cellModel4];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"WIFI Settings";
    [self.rightButton setImage:LOADICON(@"CommureGWThree", @"MKCFMqttNetworkSettingsController", @"cf_saveIcon.png") forState:UIControlStateNormal];
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
        
        _tableView.backgroundColor = RGBCOLOR(242, 242, 242);
//        _tableView.tableFooterView = [self tableFooterView];
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

- (NSMutableArray *)section9List {
    if (!_section9List) {
        _section9List = [NSMutableArray array];
    }
    return _section9List;
}

- (NSMutableArray *)section10List {
    if (!_section10List) {
        _section10List = [NSMutableArray array];
    }
    return _section10List;
}

- (NSMutableArray *)section11List {
    if (!_section11List) {
        _section11List = [NSMutableArray array];
    }
    return _section11List;
}

- (NSMutableArray *)section12List {
    if (!_section12List) {
        _section12List = [NSMutableArray array];
    }
    return _section12List;
}

- (NSMutableArray *)section13List {
    if (!_section13List) {
        _section13List = [NSMutableArray array];
    }
    return _section13List;
}

- (NSMutableArray *)section14List {
    if (!_section14List) {
        _section14List = [NSMutableArray array];
    }
    return _section14List;
}

- (NSMutableArray *)section15List {
    if (!_section15List) {
        _section15List = [NSMutableArray array];
    }
    return _section15List;
}

- (NSMutableArray *)headerList {
    if (!_headerList) {
        _headerList = [NSMutableArray array];
    }
    return _headerList;
}

- (MKCFMqttNetworkSettingsModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKCFMqttNetworkSettingsModel alloc] init];
    }
    return _dataModel;
}

- (UILabel *)noteLabel {
    if (!_noteLabel) {
        _noteLabel = [[UILabel alloc] init];
        _noteLabel.textColor = DEFAULT_TEXT_COLOR;
        _noteLabel.textAlignment = NSTextAlignmentLeft;
        _noteLabel.font = MKFont(12.f);
        _noteLabel.numberOfLines = 0;
        _noteLabel.text = noteMsg;
    }
    return _noteLabel;
}

- (UIView *)tableFooterView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 60.f)];
    footerView.backgroundColor = RGBCOLOR(242, 242, 242);
    
    [footerView addSubview:self.noteLabel];
    [self.noteLabel setHidden:YES];
    CGSize msgSize = [NSString sizeWithText:noteMsg
                                    andFont:MKFont(12.f)
                                 andMaxSize:CGSizeMake(kViewWidth - 2 * 15.f, MAXFLOAT)];
    [self.noteLabel setFrame:CGRectMake(15.f, 15.f, kViewWidth - 2 * 15.f, msgSize.height)];
    
    return footerView;
}

@end
