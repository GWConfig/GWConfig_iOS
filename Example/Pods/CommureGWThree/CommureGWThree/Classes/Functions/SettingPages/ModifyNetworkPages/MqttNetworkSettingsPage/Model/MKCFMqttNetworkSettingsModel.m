//
//  MKCFMqttNetworkSettingsModel.m
//  CommureGWThree_Example
//
//  Created by aa on 2023/2/14.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCFMqttNetworkSettingsModel.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKCFDeviceModeManager.h"

#import "MKCFMQTTInterface.h"

#import "MKCFModifyNetworkDataModel.h"

@interface MKCFWifiNetworkSettingModel : NSObject<mk_cf_mqttModifyNetworkProtocol>

@property (nonatomic, assign)BOOL dhcp;

/// 47.104.81.55
@property (nonatomic, copy)NSString *ip;

/// 47.104.81.55
@property (nonatomic, copy)NSString *mask;

/// 47.104.81.55
@property (nonatomic, copy)NSString *gateway;

/// 47.104.81.55
@property (nonatomic, copy)NSString *dns;

@end

@implementation MKCFWifiNetworkSettingModel

@end

@interface MKCFMqttNetworkSettingsModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKCFMqttNetworkSettingsModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if ([MKCFModifyNetworkDataModel shared].cloud) {
            //云端下载
            self.security = [[MKCFModifyNetworkDataModel shared].params[@"security"] integerValue];
            self.ssid = [MKCFModifyNetworkDataModel shared].params[@"wifiSSID"];
            self.wifiPassword = [MKCFModifyNetworkDataModel shared].params[@"wifiPassword"];
            self.eapType = [[MKCFModifyNetworkDataModel shared].params[@"eap"] integerValue];
            self.eapUserName = [MKCFModifyNetworkDataModel shared].params[@"eapUsername"];
            self.eapPassword = [MKCFModifyNetworkDataModel shared].params[@"eapPassword"];
            self.domainID = [MKCFModifyNetworkDataModel shared].params[@"domainID"];
            self.verifyServer = [[MKCFModifyNetworkDataModel shared].params[@"verifyServer"] boolValue];
            self.caFilePath = [MKCFModifyNetworkDataModel shared].params[@"wifiCaPath"];
            self.clientKeyPath = [MKCFModifyNetworkDataModel shared].params[@"wifiClientKeyPath"];
            self.clientCertPath = [MKCFModifyNetworkDataModel shared].params[@"wifiClientCertPath"];
            
            self.networkType = [[MKCFModifyNetworkDataModel shared].params[@"networkType"] integerValue];
            
            self.wifi_dhcp = [[MKCFModifyNetworkDataModel shared].params[@"wifiDHCP"] boolValue];
            self.wifi_ip = [MKCFModifyNetworkDataModel shared].params[@"wifiIP"];
            self.wifi_mask = [MKCFModifyNetworkDataModel shared].params[@"wifiMask"];
            self.wifi_gateway = [MKCFModifyNetworkDataModel shared].params[@"wifiGateway"];
            self.wifi_dns = [MKCFModifyNetworkDataModel shared].params[@"wifiDNS"];
            
            self.ethernet_dhcp = [[MKCFModifyNetworkDataModel shared].params[@"ethernetDHCP"] boolValue];
            self.ethernet_ip = [MKCFModifyNetworkDataModel shared].params[@"ethernetIP"];
            self.ethernet_mask = [MKCFModifyNetworkDataModel shared].params[@"ethernetMask"];
            self.ethernet_gateway = [MKCFModifyNetworkDataModel shared].params[@"ethernetGateway"];
            self.ethernet_dns = [MKCFModifyNetworkDataModel shared].params[@"ethernetDNS"];
            
            moko_dispatch_main_safe(^{
                sucBlock();
            });
            return;
        }
        
        if (![self readWifiInfos]) {
            [self operationFailedBlockWithMsg:@"Read Wifi Infos Error" block:failedBlock];
            return;
        }
        if (![self readWifiNetworkInfos]) {
            [self operationFailedBlockWithMsg:@"Read Wifi Network Infos Error" block:failedBlock];
            return;
        }
        if (![self readNetworkType]) {
            [self operationFailedBlockWithMsg:@"Read Network Type Error" block:failedBlock];
            return;
        }
        if (![self readEthernetNetworkInfos]) {
            [self operationFailedBlockWithMsg:@"Read Ethernet Network Infos Error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            sucBlock();
        });
    });
}

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        NSInteger status = [self readOTAState];
        if (status == -1) {
            [self operationFailedBlockWithMsg:@"Read OTA Status Error" block:failedBlock];
            return;
        }
        if (status == 1) {
            [self operationFailedBlockWithMsg:@"Device is busy now!" block:failedBlock];
            return;
        }
        if (![self configNetworkType]) {
            [self operationFailedBlockWithMsg:@"Config Network Type Error" block:failedBlock];
            return;
        }
        if (self.networkType == 0) {
            //Network Type 为Ethernet
            if (![self configEthernetNetworkInfos]) {
                [self operationFailedBlockWithMsg:@"Config Ethernet Infos Error" block:failedBlock];
                return;
            }
            
            [self updateValues];
            
            moko_dispatch_main_safe(^{
                if (sucBlock) {
                    sucBlock();
                }
            });
            return;
        }
        if (![self configWifiInfos]) {
            [self operationFailedBlockWithMsg:@"Config Wifi Infos Error" block:failedBlock];
            return;
        }
        if (![self configWifiNetworkInfos]) {
            [self operationFailedBlockWithMsg:@"Config Wifi Infos Error" block:failedBlock];
            return;
        }
        if (self.security == 1 && !(!ValidStr(self.caFilePath) && !ValidStr(self.clientKeyPath) && !ValidStr(self.clientCertPath))) {
            //三个证书同时为空，则不需要发送
            if (((self.eapType == 0 || self.eapType == 1) && self.verifyServer) || self.eapType == 2) {
                //TLS需要设置这个，0:PEAP-MSCHAPV2  1:TTLS-MSCHAPV2这两种必须验证服务器打开的情况下才设置
                if (![self configEAPCerts]) {
                    [self operationFailedBlockWithMsg:@"Config EAP Certs Error" block:failedBlock];
                    return;
                }
            }
        }
        
        [self updateValues];
        
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

#pragma mark - interface
- (NSInteger)readOTAState {
    __block NSInteger status = -1;
    [MKCFMQTTInterface cf_readOtaStatusWithMacAddress:[MKCFDeviceModeManager shared].macAddress topic:[MKCFDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        status = [returnData[@"data"][@"status"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return status;
}

- (BOOL)readWifiInfos {
    __block BOOL success = NO;
    [MKCFMQTTInterface cf_readWifiInfosWithMacAddress:[MKCFDeviceModeManager shared].macAddress topic:[MKCFDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.security = [returnData[@"data"][@"security_type"] integerValue];
        self.ssid = returnData[@"data"][@"ssid"];
        self.wifiPassword = returnData[@"data"][@"passwd"];
        self.eapType = [returnData[@"data"][@"eap_type"] integerValue];
        self.domainID = returnData[@"data"][@"eap_id"];
        self.eapUserName = returnData[@"data"][@"eap_username"];
        self.eapPassword = returnData[@"data"][@"eap_passwd"];
        self.verifyServer = ([returnData[@"data"][@"eap_verify_server"] integerValue] == 1);
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configWifiInfos {
    __block BOOL success = NO;
    [MKCFMQTTInterface cf_modifyWifiInfos:self macAddress:[MKCFDeviceModeManager shared].macAddress topic:[MKCFDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readWifiNetworkInfos {
    __block BOOL success = NO;
    [MKCFMQTTInterface cf_readWifiNetworkInfosWithMacAddress:[MKCFDeviceModeManager shared].macAddress topic:[MKCFDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.wifi_dhcp = ([returnData[@"data"][@"dhcp_en"] integerValue] == 1);
        self.wifi_ip = returnData[@"data"][@"ip"];
        self.wifi_mask = returnData[@"data"][@"netmask"];
        self.wifi_gateway = returnData[@"data"][@"gw"];
        self.wifi_dns = returnData[@"data"][@"dns"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configWifiNetworkInfos {
    __block BOOL success = NO;
    MKCFWifiNetworkSettingModel *settingModel = [[MKCFWifiNetworkSettingModel alloc] init];
    settingModel.dhcp = self.wifi_dhcp;
    settingModel.ip = self.wifi_ip;
    settingModel.mask = self.wifi_mask;
    settingModel.gateway = self.wifi_gateway;
    settingModel.dns = self.wifi_dns;
    [MKCFMQTTInterface cf_modifyWifiNetworkInfos:settingModel macAddress:[MKCFDeviceModeManager shared].macAddress topic:[MKCFDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readNetworkType {
    __block BOOL success = NO;
    [MKCFMQTTInterface cf_readNetworkTypeWithMacAddress:[MKCFDeviceModeManager shared].macAddress topic:[MKCFDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.networkType = ([returnData[@"data"][@"net_interface"] integerValue] == 1);
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configNetworkType {
    __block BOOL success = NO;
    [MKCFMQTTInterface cf_modifyNetworkType:self.networkType macAddress:[MKCFDeviceModeManager shared].macAddress topic:[MKCFDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readEthernetNetworkInfos {
    __block BOOL success = NO;
    [MKCFMQTTInterface cf_readEthernetNetworkInfosWithMacAddress:[MKCFDeviceModeManager shared].macAddress topic:[MKCFDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.ethernet_dhcp = ([returnData[@"data"][@"dhcp_en"] integerValue] == 1);
        self.ethernet_ip = returnData[@"data"][@"ip"];
        self.ethernet_mask = returnData[@"data"][@"netmask"];
        self.ethernet_gateway = returnData[@"data"][@"gw"];
        self.ethernet_dns = returnData[@"data"][@"dns"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configEthernetNetworkInfos {
    __block BOOL success = NO;
    MKCFWifiNetworkSettingModel *settingModel = [[MKCFWifiNetworkSettingModel alloc] init];
    settingModel.dhcp = self.ethernet_dhcp;
    settingModel.ip = self.ethernet_ip;
    settingModel.mask = self.ethernet_mask;
    settingModel.gateway = self.ethernet_gateway;
    settingModel.dns = self.ethernet_dns;
    [MKCFMQTTInterface cf_modifyEthernetNetworkInfos:settingModel macAddress:[MKCFDeviceModeManager shared].macAddress topic:[MKCFDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configEAPCerts {
    __block BOOL success = NO;
    [MKCFMQTTInterface cf_modifyWifiCerts:self macAddress:[MKCFDeviceModeManager shared].macAddress topic:[MKCFDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - private method
- (void)updateValues {
    if (![MKCFModifyNetworkDataModel shared].cloud) {
        return;
    }
    //从云端导入
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[MKCFModifyNetworkDataModel shared].params];
    
    [dic setObject:@(self.networkType) forKey:@"networkType"];
    
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)self.security] forKey:@"security"];
    [dic setObject:SafeStr(self.ssid) forKey:@"wifiSSID"];
    [dic setObject:SafeStr(self.wifiPassword) forKey:@"wifiPassword"];
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)self.eapType] forKey:@"eap"];
    [dic setObject:SafeStr(self.eapUserName) forKey:@"eapUsername"];
    [dic setObject:SafeStr(self.eapPassword) forKey:@"eapPassword"];
    [dic setObject:SafeStr(self.domainID) forKey:@"domainID"];
    [dic setObject:@(self.verifyServer) forKey:@"verifyServer"];
    [dic setObject:SafeStr(self.caFilePath) forKey:@"wifiCaPath"];
    [dic setObject:SafeStr(self.clientKeyPath) forKey:@"wifiClientKeyPath"];
    [dic setObject:SafeStr(self.clientCertPath) forKey:@"wifiClientCertPath"];
    
    [dic setObject:@(self.wifi_dhcp) forKey:@"wifiDHCP"];
    [dic setObject:SafeStr(self.wifi_ip) forKey:@"wifiIP"];
    [dic setObject:SafeStr(self.wifi_mask) forKey:@"wifiMask"];
    [dic setObject:SafeStr(self.wifi_gateway) forKey:@"wifiGateway"];
    [dic setObject:SafeStr(self.wifi_dns) forKey:@"wifiDNS"];
    
    [dic setObject:@(self.ethernet_dhcp) forKey:@"ethernetDHCP"];
    [dic setObject:SafeStr(self.ethernet_ip) forKey:@"ethernetIP"];
    [dic setObject:SafeStr(self.ethernet_mask) forKey:@"ethernetMask"];
    [dic setObject:SafeStr(self.ethernet_gateway) forKey:@"ethernetGateway"];
    [dic setObject:SafeStr(self.ethernet_dns) forKey:@"ethernetDNS"];
    
    [MKCFModifyNetworkDataModel shared].params = dic;
}

- (NSString *)checkMsg {
    if (self.networkType == 1) {
        //Wifi
        NSString *wifiMsg = [self checkWifiMsg];
        if (ValidStr(wifiMsg)) {
            return wifiMsg;
        }
    }
    
    NSString *networkMsg = [self checkNetworkMsg];
    if (ValidStr(networkMsg)) {
        return networkMsg;
    }
    return @"";
}

- (NSString *)checkNetworkMsg {
    if (self.networkType == 0) {
        //ethernet
        if (self.ethernet_dhcp) {
            return @"";
        }
        if (![self.ethernet_ip regularExpressions:isIPAddress]) {
            return @"IP Error";
        }
        if (![self.ethernet_mask regularExpressions:isIPAddress]) {
            return @"Mask Error";
        }
        if (![self.ethernet_gateway regularExpressions:isIPAddress]) {
            return @"Gateway Error";
        }
        if (![self.ethernet_dns regularExpressions:isIPAddress]) {
            return @"DNS Error";
        }
        return @"";
    }
    if (self.wifi_dhcp) {
        return @"";
    }
    if (![self.wifi_ip regularExpressions:isIPAddress]) {
        return @"IP Error";
    }
    if (![self.wifi_mask regularExpressions:isIPAddress]) {
        return @"Mask Error";
    }
    if (![self.wifi_gateway regularExpressions:isIPAddress]) {
        return @"Gateway Error";
    }
    if (![self.wifi_dns regularExpressions:isIPAddress]) {
        return @"DNS Error";
    }
    return @"";
}

- (NSString *)checkWifiMsg {
    if (!ValidStr(self.ssid) || self.ssid.length > 32) {
        return @"ssid error";
    }
    if (self.security == 0) {
        //Personal
        if (self.wifiPassword.length > 64) {
            return @"password error";
        }
        return @"";
    }
    //Enterprise
    if (self.eapType == 0 || self.eapType == 1) {
        //PEAP-MSCHAPV2/TTLS-MSCHAPV2
        if (self.eapUserName.length > 32) {
            return @"username error";
        }
        if (self.eapPassword.length > 64) {
            return @"password error";
        }
        if (self.verifyServer) {
            if (self.caFilePath.length > 256) {
                return @"CA File Path Error";
            }
        }
    }
    if (self.eapType == 2) {
        //TLS
        if (self.caFilePath.length > 256 || self.clientKeyPath.length > 256 || self.clientCertPath.length > 256) {
            return @"File Path Error";
        }
        if (self.domainID.length > 64) {
            return @"domain ID error";
        }
    }
    return @"";
}

- (void)operationFailedBlockWithMsg:(NSString *)msg block:(void (^)(NSError *error))block {
    moko_dispatch_main_safe(^{
        NSError *error = [[NSError alloc] initWithDomain:@"MqttWifiSettings"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    });
}

#pragma mark - getter
- (dispatch_semaphore_t)semaphore {
    if (!_semaphore) {
        _semaphore = dispatch_semaphore_create(0);
    }
    return _semaphore;
}

- (dispatch_queue_t)readQueue {
    if (!_readQueue) {
        _readQueue = dispatch_queue_create("MqttWifiSettingsQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
