//
//  MKCFDeviceParamListModel.m
//  CommureGWThree_Example
//
//  Created by aa on 2023/11/23.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import "MKCFDeviceParamListModel.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKCFInterface.h"
#import "MKCFInterface+MKCFConfig.h"

#import "MKCFDeviceModel.h"

#import "MKCFDeviceMQTTParamsModel.h"

@interface MKCFDeviceParamListModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@property (nonatomic, copy)NSString *macAddress;

@property (nonatomic, copy)NSString *deviceName;


#pragma mark - MQTT
@property (nonatomic, copy)NSString *host;

@property (nonatomic, copy)NSString *port;

@property (nonatomic, copy)NSString *clientID;

@property (nonatomic, copy)NSString *subscribeTopic;

@property (nonatomic, copy)NSString *publishTopic;

@property (nonatomic, assign)BOOL cleanSession;

@property (nonatomic, assign)NSInteger qos;

@property (nonatomic, copy)NSString *keepAlive;

@property (nonatomic, copy)NSString *userName;

@property (nonatomic, copy)NSString *password;

@property (nonatomic, assign)BOOL sslIsOn;

/// 0:CA signed server certificate     1:CA certificate     2:Self signed certificates
@property (nonatomic, assign)NSInteger certificate;

@property (nonatomic, copy)NSString *caFileName;

@property (nonatomic, copy)NSString *clientKeyName;

@property (nonatomic, copy)NSString *clientCertName;


#pragma mark - Network Settings
/// 0:Ethernet    1:WiFi
@property (nonatomic, assign)NSInteger networkType;

/// 0:personal  1:enterprise
@property (nonatomic, assign)NSInteger security;

/// security为enterprise的时候才有效。0:PEAP-MSCHAPV2  1:TTLS-MSCHAPV2  2:TLS
@property (nonatomic, assign)NSInteger eapType;

/// 1-32 Characters.
@property (nonatomic, copy)NSString *ssid;

/// 0-64 Characters.security为personal的时候才有效
@property (nonatomic, copy)NSString *wifiPassword;

/// 0-32 Characters.  eapType为PEAP-MSCHAPV2/TTLS-MSCHAPV2才有效
@property (nonatomic, copy)NSString *eapUserName;

/// 0-64 Characters.eapType为TLS的时候无此参数
@property (nonatomic, copy)NSString *eapPassword;

/// 0-64 Characters.eapType为TLS的时候有效
@property (nonatomic, copy)NSString *domainID;

/// eapType为PEAP-MSCHAPV2/TTLS-MSCHAPV2才有效
@property (nonatomic, assign)BOOL verifyServer;

/// security为personal无此参数
@property (nonatomic, copy)NSString *wifi_ca;

/// eapType为TLS有效
@property (nonatomic, copy)NSString *wifi_clientKey;

/// eapType为TLS有效
@property (nonatomic, copy)NSString *wifi_clientCert;

#pragma mark - Ethernet Network Settings

@property (nonatomic, assign)BOOL ethernet_dhcp;

@property (nonatomic, copy)NSString *ethernet_ip;

@property (nonatomic, copy)NSString *ethernet_mask;

@property (nonatomic, copy)NSString *ethernet_gateway;

@property (nonatomic, copy)NSString *ethernet_dns;

#pragma mark - Wifi Network Settings

@property (nonatomic, assign)BOOL wifi_dhcp;

@property (nonatomic, copy)NSString *wifi_ip;

@property (nonatomic, copy)NSString *wifi_mask;

@property (nonatomic, copy)NSString *wifi_gateway;

@property (nonatomic, copy)NSString *wifi_dns;


#pragma mark - Ntp server
/// 0-64 Characters
@property (nonatomic, copy)NSString *ntpHost;

/// -24~28(半小时为单位)
@property (nonatomic, assign)NSInteger timeZone;


@end

@implementation MKCFDeviceParamListModel

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    [self loadParams];
    dispatch_async(self.readQueue, ^{
        NSString *wifiMsg = [self checkWifiMsg];
        if (ValidStr(wifiMsg)) {
            [self operationFailedBlockWithMsg:wifiMsg block:failedBlock];
            return;
        }
        
        NSString *mqttMsg = [self checkParams];
        if (ValidStr(mqttMsg)) {
            [self operationFailedBlockWithMsg:mqttMsg block:failedBlock];
            return;
        }
        
        NSString *networkSettingMsg = [self checkWifiMsg];
        if (ValidStr(networkSettingMsg)) {
            [self operationFailedBlockWithMsg:networkSettingMsg block:failedBlock];
            return;
        }
        
        NSString *ntpMsg = [self checkNtpServerMsg];
        if (ValidStr(ntpMsg)) {
            [self operationFailedBlockWithMsg:ntpMsg block:failedBlock];
            return;
        }
        
        if (![self readDeviceMac]) {
            [self operationFailedBlockWithMsg:@"Read Mac Address Timeout" block:failedBlock];
            return;
        }
        if (![self readDeviceName]) {
            [self operationFailedBlockWithMsg:@"Read Device Name Timeout" block:failedBlock];
            return;
        }
        
#pragma mark - MQTT
        if (![self configHost]) {
            [self operationFailedBlockWithMsg:@"Config Host Timeout" block:failedBlock];
            return;
        }
        if (![self configPort]) {
            [self operationFailedBlockWithMsg:@"Config Port Timeout" block:failedBlock];
            return;
        }
        if (![self configClientID]) {
            [self operationFailedBlockWithMsg:@"Config Client Id Timeout" block:failedBlock];
            return;
        }
        if (![self configUserName]) {
            [self operationFailedBlockWithMsg:@"Config UserName Timeout" block:failedBlock];
            return;
        }
        if (![self configPassword]) {
            [self operationFailedBlockWithMsg:@"Config Password Timeout" block:failedBlock];
            return;
        }
        if (![self configCleanSession]) {
            [self operationFailedBlockWithMsg:@"Config Clean Session Timeout" block:failedBlock];
            return;
        }
        if (![self configKeepAlive]) {
            [self operationFailedBlockWithMsg:@"Config Keep Alive Timeout" block:failedBlock];
            return;
        }
        if (![self configQos]) {
            [self operationFailedBlockWithMsg:@"Config Qos Timeout" block:failedBlock];
            return;
        }
        if (![self configSubscribe]) {
            [self operationFailedBlockWithMsg:@"Config Subscribe Topic Timeout" block:failedBlock];
            return;
        }
        if (![self configPublish]) {
            [self operationFailedBlockWithMsg:@"Config Publish Topic Timeout" block:failedBlock];
            return;
        }
        if (![self configSSLStatus]) {
            [self operationFailedBlockWithMsg:@"Config SSL Status Timeout" block:failedBlock];
            return;
        }
        if (self.sslIsOn && self.certificate > 0) {
            if (![self configCAFile]) {
                [self operationFailedBlockWithMsg:@"Config CA File Error" block:failedBlock];
                return;
            }
            if (self.certificate == 2) {
                //双向验证
                if (![self configClientKey]) {
                    [self operationFailedBlockWithMsg:@"Config Client Key Error" block:failedBlock];
                    return;
                }
                if (![self configClientCert]) {
                    [self operationFailedBlockWithMsg:@"Config Client Cert Error" block:failedBlock];
                    return;
                }
            }
        }
        
#pragma mark - Network Setting
        if (![self configNetworkType]) {
            [self operationFailedBlockWithMsg:@"Config Network Type Error" block:failedBlock];
            return;
        }
        
        if (self.networkType == 0) {
            //Network Type 为Ethernet
            
            if (![self configEthernetDHCPStatus]) {
                [self operationFailedBlockWithMsg:@"Config DHCP Error" block:failedBlock];
                return;
            }
            if (!self.ethernet_dhcp) {
                if (![self configEthernetIpAddress]) {
                    [self operationFailedBlockWithMsg:@"Config IP Error" block:failedBlock];
                    return;
                }
            }
        } else {
            //Network Type 为Wifi
            if (![self configSecurityType]) {
                [self operationFailedBlockWithMsg:@"Config Security Type Error" block:failedBlock];
                return;
            }
            if (![self configWifiSSID]) {
                [self operationFailedBlockWithMsg:@"Config WIFI SSID Error" block:failedBlock];
                return;
            }
            if (self.security == 0) {
                //Personal
                if (![self configWifiPassword]) {
                    [self operationFailedBlockWithMsg:@"Config WIFI Password Error" block:failedBlock];
                    return;
                }
            }
            if (self.security == 1) {
               //Enterprise
                if (![self configEAPType]) {
                    [self operationFailedBlockWithMsg:@"Config EAP Type Error" block:failedBlock];
                    return;
                }
                if (self.eapType == 0 || self.eapType == 1) {
                    //PEAP-MSCHAPV2/TTLS-MSCHAPV2
                    if (![self configEAPUsername]) {
                        [self operationFailedBlockWithMsg:@"Config EAP Username Error" block:failedBlock];
                        return;
                    }
                    if (![self configEAPPassword]) {
                        [self operationFailedBlockWithMsg:@"Config EAP Password Error" block:failedBlock];
                        return;
                    }
                    if (![self configVerifyServer]) {
                        [self operationFailedBlockWithMsg:@"Config Verify Server Error" block:failedBlock];
                        return;
                    }
                    if (self.verifyServer) {
                        if (![self configWIfiCAFile]) {
                            [self operationFailedBlockWithMsg:@"Config WIfi CA File Error" block:failedBlock];
                            return;
                        }
                    }
                }
                if (self.eapType == 2) {
                    //TLS
                    if (![self configEAPDomainID]) {
                        [self operationFailedBlockWithMsg:@"Config EAP Domain ID Error" block:failedBlock];
                        return;
                    }
                    if (![self configWIfiCAFile]) {
                        [self operationFailedBlockWithMsg:@"Config Wifi CA File Error" block:failedBlock];
                        return;
                    }
                    if (ValidStr(self.wifi_clientKey)) {
                        if (![self configWifiClientKey]) {
                            [self operationFailedBlockWithMsg:@"Config Wifi Client Key Error" block:failedBlock];
                            return;
                        }
                    }
                    if (ValidStr(self.wifi_clientCert)) {
                        if (![self configWifiClientCert]) {
                            [self operationFailedBlockWithMsg:@"Config Wifi Client Cert Error" block:failedBlock];
                            return;
                        }
                    }
                }
            }
            if (![self configWifiDHCPStatus]) {
                [self operationFailedBlockWithMsg:@"Config DHCP Error" block:failedBlock];
                return;
            }
            if (!self.wifi_dhcp) {
                if (![self configWifiIpAddress]) {
                    [self operationFailedBlockWithMsg:@"Config IP Error" block:failedBlock];
                    return;
                }
            }
        }
        
        
#pragma mark - Ntp Server
        if (![self configNTPHost]) {
            [self operationFailedBlockWithMsg:@"Config NTP Host Error" block:failedBlock];
            return;
        }
        if (![self configTimezone]) {
            [self operationFailedBlockWithMsg:@"Config Timezone Error" block:failedBlock];
            return;
        }
        
        if (![self enterSTAMode]) {
            [self operationFailedBlockWithMsg:@"Enter STA Mode Error" block:failedBlock];
            return;
        }
        
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

#pragma mark - 读取mac地址和设备名称
- (BOOL)readDeviceMac {
    __block BOOL success = NO;
    [MKCFInterface cf_readDeviceWifiSTAMacAddressWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.macAddress = returnData[@"result"][@"macAddress"];
        self.macAddress = [self.macAddress stringByReplacingOccurrencesOfString:@":" withString:@""];
        self.macAddress = [self.macAddress lowercaseString];
        
        [MKCFDeviceMQTTParamsModel shared].deviceModel.macAddress = self.macAddress;
        
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readDeviceName {
    __block BOOL success = NO;
    [MKCFInterface cf_readDeviceNameWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.deviceName = returnData[@"result"][@"deviceName"];
        
        [MKCFDeviceMQTTParamsModel shared].deviceModel.deviceName = self.deviceName;
        
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - 进入配网模式
- (BOOL)enterSTAMode {
    __block BOOL success = NO;
    
    [MKCFInterface cf_enterSTAModeWithSucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}





#pragma mark - MQTT
- (NSString *)checkParams {
    if (!ValidStr(self.host) || self.host.length > 64 || ![self.host isAsciiString]) {
        return @"Host error";
    }
    if (!ValidStr(self.port) || [self.port integerValue] < 1 || [self.port integerValue] > 65535) {
        return @"Port error";
    }
    if (!ValidStr(self.clientID) || self.clientID.length > 64 || ![self.clientID isAsciiString]) {
        return @"ClientID error";
    }
    if (!ValidStr(self.publishTopic) || self.publishTopic.length > 128 || ![self.publishTopic isAsciiString]) {
        return @"PublishTopic error";
    }
    if (!ValidStr(self.subscribeTopic) || self.subscribeTopic.length > 128 || ![self.subscribeTopic isAsciiString]) {
        return @"SubscribeTopic error";
    }
    if (self.qos < 0 || self.qos > 2) {
        return @"Qos error";
    }
    if (!ValidStr(self.keepAlive) || [self.keepAlive integerValue] < 10 || [self.keepAlive integerValue] > 120) {
        return @"KeepAlive error";
    }
    if (self.userName.length > 256 || (ValidStr(self.userName) && ![self.userName isAsciiString])) {
        return @"UserName error";
    }
    if (self.password.length > 256 || (ValidStr(self.password) && ![self.password isAsciiString])) {
        return @"Password error";
    }
    if (self.sslIsOn) {
        if (self.certificate < 0 || self.certificate > 2) {
            return @"Certificate error";
        }
        if (self.certificate == 0) {
            return @"";
        }
        if (!ValidStr(self.caFileName)) {
            return @"CA File cannot be empty.";
        }
        if (self.certificate == 2 && (!ValidStr(self.clientKeyName) || !ValidStr(self.clientCertName))) {
            return @"Client File cannot be empty.";
        }
    }
    return @"";
}

- (BOOL)configHost {
    __block BOOL success = NO;
    [MKCFInterface cf_configServerHost:self.host sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configPort {
    __block BOOL success = NO;
    [MKCFInterface cf_configServerPort:[self.port integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configClientID {
    __block BOOL success = NO;
    [MKCFInterface cf_configClientID:self.clientID sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configUserName {
    __block BOOL success = NO;
    [MKCFInterface cf_configServerUserName:self.userName sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configPassword {
    __block BOOL success = NO;
    [MKCFInterface cf_configServerPassword:self.password sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configCleanSession {
    __block BOOL success = NO;
    [MKCFInterface cf_configServerCleanSession:self.cleanSession sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configKeepAlive {
    __block BOOL success = NO;
    [MKCFInterface cf_configServerKeepAlive:[self.keepAlive integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configQos {
    __block BOOL success = NO;
    [MKCFInterface cf_configServerQos:self.qos sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configSubscribe {
    __block BOOL success = NO;
    
    [MKCFInterface cf_configSubscibeTopic:self.subscribeTopic sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configPublish {
    __block BOOL success = NO;
    
    [MKCFInterface cf_configPublishTopic:self.publishTopic sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configSSLStatus {
    __block BOOL success = NO;
    mk_cf_connectMode mode = mk_cf_connectMode_TCP;
    if (self.sslIsOn) {
        if (self.certificate == 0) {
            mode = mk_cf_connectMode_CASignedServerCertificate;
        }else if (self.certificate == 1) {
            mode = mk_cf_connectMode_CACertificate;
        }else if (self.certificate == 2) {
            mode = mk_cf_connectMode_SelfSignedCertificates;
        }
    }
    [MKCFInterface cf_configConnectMode:mode sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configCAFile {
    __block BOOL success = NO;
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [document stringByAppendingPathComponent:self.caFileName];
    NSData *caData = [NSData dataWithContentsOfFile:filePath];
    if (!ValidData(caData)) {
        return NO;
    }
    [MKCFInterface cf_configCAFile:caData sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configClientKey {
    __block BOOL success = NO;
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [document stringByAppendingPathComponent:self.clientKeyName];
    NSData *clientKeyData = [NSData dataWithContentsOfFile:filePath];
    if (!ValidData(clientKeyData)) {
        return NO;
    }
    [MKCFInterface cf_configClientPrivateKey:clientKeyData sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configClientCert {
    __block BOOL success = NO;
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [document stringByAppendingPathComponent:self.clientCertName];
    NSData *clientCertData = [NSData dataWithContentsOfFile:filePath];
    if (!ValidData(clientCertData)) {
        return NO;
    }
    [MKCFInterface cf_configClientCert:clientCertData sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - Network Settings
- (NSString *)checkWifiMsg {
    if (self.networkType == 1) {
        //Wifi
        NSString *wifiMsg = [self checkWifiNetworkMsg];
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

- (NSString *)checkWifiNetworkMsg {
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
        if (self.verifyServer && !ValidStr(self.caFileName)) {
            return @"CA File cannot be empty.";
        }
    }
    if (self.eapType == 2) {
        //TLS
        if (self.domainID.length > 64) {
            return @"domain ID error";
        }
        if (!ValidStr(self.caFileName)) {
            return @"CA File cannot be empty.";
        }
//        if (!ValidStr(self.clientKeyName) || !ValidStr(self.clientCertName)) {
//            return @"Client File cannot be empty.";
//        }
    }
    return @"";
}

- (BOOL)configNetworkType {
    __block BOOL success = NO;
    [MKCFInterface cf_configNetworkType:self.networkType sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configSecurityType {
    __block BOOL success = NO;
    [MKCFInterface cf_configWIFISecurity:self.security sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configWifiSSID {
    __block BOOL success = NO;
    [MKCFInterface cf_configWIFISSID:self.ssid sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configWifiPassword {
    __block BOOL success = NO;
    [MKCFInterface cf_configWIFIPassword:self.wifiPassword sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configEAPType {
    __block BOOL success = NO;
    [MKCFInterface cf_configWIFIEAPType:self.eapType sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configEAPUsername {
    __block BOOL success = NO;
    [MKCFInterface cf_configWIFIEAPUsername:self.eapUserName sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configEAPPassword {
    __block BOOL success = NO;
    [MKCFInterface cf_configWIFIEAPPassword:self.eapPassword sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configEAPDomainID {
    __block BOOL success = NO;
    [MKCFInterface cf_configWIFIEAPDomainID:self.domainID sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configVerifyServer {
    __block BOOL success = NO;
    [MKCFInterface cf_configWIFIVerifyServerStatus:self.verifyServer sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configWIfiCAFile {
    __block BOOL success = NO;
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [document stringByAppendingPathComponent:self.wifi_ca];
    NSData *caData = [NSData dataWithContentsOfFile:filePath];
    if (!ValidData(caData)) {
        return NO;
    }
    [MKCFInterface cf_configWIFICAFile:caData sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configWifiClientKey {
    __block BOOL success = NO;
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [document stringByAppendingPathComponent:self.wifi_clientKey];
    NSData *clientKeyData = [NSData dataWithContentsOfFile:filePath];
    if (!ValidData(clientKeyData)) {
        return NO;
    }
    [MKCFInterface cf_configWIFIClientPrivateKey:clientKeyData sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configWifiClientCert {
    __block BOOL success = NO;
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [document stringByAppendingPathComponent:self.wifi_clientCert];
    NSData *clientCertData = [NSData dataWithContentsOfFile:filePath];
    if (!ValidData(clientCertData)) {
        return NO;
    }
    [MKCFInterface cf_configWIFIClientCert:clientCertData sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - Wifi Network Settings
- (BOOL)readWifiDHCPStatus {
    __block BOOL success = NO;
    [MKCFInterface cf_readWIFIDHCPStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.wifi_dhcp = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configWifiDHCPStatus {
    __block BOOL success = NO;
    [MKCFInterface cf_configWIFIDHCPStatus:self.wifi_dhcp sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readWifiIpAddress {
    __block BOOL success = NO;
    [MKCFInterface cf_readWIFINetworkIpInfosWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.wifi_ip = returnData[@"result"][@"ip"];
        self.wifi_mask = returnData[@"result"][@"mask"];
        self.wifi_gateway = returnData[@"result"][@"gateway"];
        self.wifi_dns = returnData[@"result"][@"dns"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configWifiIpAddress {
    __block BOOL success = NO;
    [MKCFInterface cf_configWIFIIpAddress:self.wifi_ip
                                     mask:self.wifi_mask
                                  gateway:self.wifi_gateway
                                      dns:self.wifi_dns
                                 sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    }
                          failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - Ethernet Network Settings
- (BOOL)readEthernetDHCPStatus {
    __block BOOL success = NO;
    [MKCFInterface cf_readEthernetDHCPStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.ethernet_dhcp = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configEthernetDHCPStatus {
    __block BOOL success = NO;
    [MKCFInterface cf_configEthernetDHCPStatus:self.ethernet_dhcp sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readEthernetIpAddress {
    __block BOOL success = NO;
    [MKCFInterface cf_readEthernetNetworkIpInfosWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.ethernet_ip = returnData[@"result"][@"ip"];
        self.ethernet_mask = returnData[@"result"][@"mask"];
        self.ethernet_gateway = returnData[@"result"][@"gateway"];
        self.ethernet_dns = returnData[@"result"][@"dns"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configEthernetIpAddress {
    __block BOOL success = NO;
    [MKCFInterface cf_configWIFIIpAddress:self.ethernet_ip
                                     mask:self.ethernet_mask
                                  gateway:self.ethernet_gateway
                                      dns:self.ethernet_dns
                                 sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    }
                          failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - NtpServer
- (NSString *)checkNtpServerMsg {
    if (self.ntpHost.length > 64) {
        return @"NTP Host Error";
    }
    return @"";
}

- (BOOL)configNTPHost {
    __block BOOL success = NO;
    [MKCFInterface cf_configNTPServerHost:self.ntpHost sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configTimezone {
    __block BOOL success = NO;
    [MKCFInterface cf_configTimeZone:(self.timeZone - 24) sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - private method
- (void)loadParams {
    if (![MKCFDeviceMQTTParamsModel shared].cloud) {
        return;
    }
    //从云端导入
    
    
    //MQTT
    self.host = [MKCFDeviceMQTTParamsModel shared].params[@"host"];
    self.port = [MKCFDeviceMQTTParamsModel shared].params[@"port"];
    self.clientID = [MKCFDeviceMQTTParamsModel shared].params[@"clientID"];
    self.subscribeTopic = [MKCFDeviceMQTTParamsModel shared].params[@"subscribeTopic"];
    self.publishTopic = [MKCFDeviceMQTTParamsModel shared].params[@"publishTopic"];
    self.cleanSession = [[MKCFDeviceMQTTParamsModel shared].params[@"cleanSession"] boolValue];
    
    self.qos = [[MKCFDeviceMQTTParamsModel shared].params[@"qos"] integerValue];
    self.keepAlive = [MKCFDeviceMQTTParamsModel shared].params[@"keepAlive"];
    self.userName = [MKCFDeviceMQTTParamsModel shared].params[@"userName"];
    self.password = [MKCFDeviceMQTTParamsModel shared].params[@"password"];
    self.sslIsOn = [[MKCFDeviceMQTTParamsModel shared].params[@"sslIsOn"] boolValue];
    self.certificate = [[MKCFDeviceMQTTParamsModel shared].params[@"certificate"] integerValue];
    self.caFileName = @"gw3_ca.pem";
    self.clientKeyName = @"gw3_private.pem.key";
    self.clientCertName = @"gw3_certificate.pem.crt";
    
    //Network Settings
    
    self.security = [[MKCFDeviceMQTTParamsModel shared].params[@"security"] integerValue];
    self.ssid = [MKCFDeviceMQTTParamsModel shared].params[@"wifiSSID"];
    self.wifiPassword = [MKCFDeviceMQTTParamsModel shared].params[@"wifiPassword"];
    self.eapType = [[MKCFDeviceMQTTParamsModel shared].params[@"eap"] integerValue];
    self.eapUserName = [MKCFDeviceMQTTParamsModel shared].params[@"eapUsername"];
    self.eapPassword = [MKCFDeviceMQTTParamsModel shared].params[@"eapPassword"];
    self.domainID = [MKCFDeviceMQTTParamsModel shared].params[@"domainID"];
    self.verifyServer = [[MKCFDeviceMQTTParamsModel shared].params[@"verifyServer"] boolValue];
    //参考MKCFBleMqttConfigSelectModel里面写死的证书名字
    self.wifi_ca = @"gw3_wifi_ca.pem";
    self.wifi_clientCert = @"gw3_wifi_client.crt";
    self.wifi_clientKey = @"gw3_wifi_client.key";
    
    self.networkType = [[MKCFDeviceMQTTParamsModel shared].params[@"networkType"] integerValue];
    
    self.wifi_dhcp = [[MKCFDeviceMQTTParamsModel shared].params[@"wifiDHCP"] boolValue];
    self.wifi_ip = [MKCFDeviceMQTTParamsModel shared].params[@"wifiIP"];
    self.wifi_mask = [MKCFDeviceMQTTParamsModel shared].params[@"wifiMask"];
    self.wifi_gateway = [MKCFDeviceMQTTParamsModel shared].params[@"wifiGateway"];
    self.wifi_dns = [MKCFDeviceMQTTParamsModel shared].params[@"wifiDNS"];
    
    self.ethernet_dhcp = [[MKCFDeviceMQTTParamsModel shared].params[@"ethernetDHCP"] boolValue];
    self.ethernet_ip = [MKCFDeviceMQTTParamsModel shared].params[@"ethernetIP"];
    self.ethernet_mask = [MKCFDeviceMQTTParamsModel shared].params[@"ethernetMask"];
    self.ethernet_gateway = [MKCFDeviceMQTTParamsModel shared].params[@"ethernetGateway"];
    self.ethernet_dns = [MKCFDeviceMQTTParamsModel shared].params[@"ethernetDNS"];
    
    //NtpServer
    self.ntpHost = [MKCFDeviceMQTTParamsModel shared].params[@"ntpServer"];
    self.timeZone = [[MKCFDeviceMQTTParamsModel shared].params[@"timezone"] integerValue] + 24;
    
    [MKCFDeviceMQTTParamsModel shared].deviceModel.publishedTopic = [MKCFDeviceMQTTParamsModel shared].params[@"publishTopic"];
    [MKCFDeviceMQTTParamsModel shared].deviceModel.subscribedTopic = [MKCFDeviceMQTTParamsModel shared].params[@"subscribeTopic"];
    [MKCFDeviceMQTTParamsModel shared].deviceModel.clientID = [MKCFDeviceMQTTParamsModel shared].params[@"clientID"];
}

- (void)operationFailedBlockWithMsg:(NSString *)msg block:(void (^)(NSError *error))block {
    moko_dispatch_main_safe(^{
        NSError *error = [[NSError alloc] initWithDomain:@"MQTTSettings"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    })
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
        _readQueue = dispatch_queue_create("MQTTSettingsQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
