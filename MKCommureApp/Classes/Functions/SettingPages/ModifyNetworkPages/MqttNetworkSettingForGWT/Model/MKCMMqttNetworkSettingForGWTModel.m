//
//  MKCMMqttNetworkSettingForGWTModel.m
//  MKCommureApp_Example
//
//  Created by aa on 2023/7/27.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import "MKCMMqttNetworkSettingForGWTModel.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKCMDeviceModeManager.h"

#import "MKCMMQTTInterface.h"

@interface MKCMWifiNetworkSettingModel : NSObject<mk_cm_mqttModifyNetworkProtocol>

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

@implementation MKCMWifiNetworkSettingModel

@end

@interface MKCMMqttNetworkSettingForGWTModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKCMMqttNetworkSettingForGWTModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
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
    [MKCMMQTTInterface cm_readOtaStatusWithMacAddress:[MKCMDeviceModeManager shared].macAddress topic:[MKCMDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
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
    [MKCMMQTTInterface cm_readWifiInfosWithMacAddress:[MKCMDeviceModeManager shared].macAddress topic:[MKCMDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
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
    [MKCMMQTTInterface cm_modifyWifiInfos:self macAddress:[MKCMDeviceModeManager shared].macAddress topic:[MKCMDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
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
    [MKCMMQTTInterface cm_readWifiNetworkInfosWithMacAddress:[MKCMDeviceModeManager shared].macAddress topic:[MKCMDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
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
    MKCMWifiNetworkSettingModel *settingModel = [[MKCMWifiNetworkSettingModel alloc] init];
    settingModel.dhcp = self.wifi_dhcp;
    settingModel.ip = self.wifi_ip;
    settingModel.mask = self.wifi_mask;
    settingModel.gateway = self.wifi_gateway;
    settingModel.dns = self.wifi_dns;
    [MKCMMQTTInterface cm_modifyWifiNetworkInfos:settingModel macAddress:[MKCMDeviceModeManager shared].macAddress topic:[MKCMDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
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
    [MKCMMQTTInterface cm_readNetworkTypeWithMacAddress:[MKCMDeviceModeManager shared].macAddress topic:[MKCMDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
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
    [MKCMMQTTInterface cm_modifyNetworkType:self.networkType macAddress:[MKCMDeviceModeManager shared].macAddress topic:[MKCMDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
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
    [MKCMMQTTInterface cm_readEthernetNetworkInfosWithMacAddress:[MKCMDeviceModeManager shared].macAddress topic:[MKCMDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
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
    MKCMWifiNetworkSettingModel *settingModel = [[MKCMWifiNetworkSettingModel alloc] init];
    settingModel.dhcp = self.ethernet_dhcp;
    settingModel.ip = self.ethernet_ip;
    settingModel.mask = self.ethernet_mask;
    settingModel.gateway = self.ethernet_gateway;
    settingModel.dns = self.ethernet_dns;
    [MKCMMQTTInterface cm_modifyEthernetNetworkInfos:settingModel macAddress:[MKCMDeviceModeManager shared].macAddress topic:[MKCMDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
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
    [MKCMMQTTInterface cm_modifyWifiCerts:self macAddress:[MKCMDeviceModeManager shared].macAddress topic:[MKCMDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - private method
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
