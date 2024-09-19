//
//  MKCHDeviceParamListModel.m
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/11/23.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import "MKCHDeviceParamListModel.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKCHInterface.h"
#import "MKCHInterface+MKCHConfig.h"

#import "MKCHDeviceModel.h"

#import "MKCHDeviceMQTTParamsModel.h"

@interface MKCHDeviceParamListModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@property (nonatomic, copy)NSString *macAddress;

@property (nonatomic, copy)NSString *deviceName;


#pragma mark - WIFI
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
@property (nonatomic, assign)BOOL dhcp;

@property (nonatomic, copy)NSString *ip;

@property (nonatomic, copy)NSString *mask;

@property (nonatomic, copy)NSString *gateway;

@property (nonatomic, copy)NSString *dns;


#pragma mark - Ntp server
/// 0-64 Characters
@property (nonatomic, copy)NSString *ntpHost;

/// -24~28(半小时为单位)
@property (nonatomic, assign)NSInteger timeZone;


@end

@implementation MKCHDeviceParamListModel

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    [self loadParams];
    dispatch_async(self.readQueue, ^{
        if (![self readDeviceMac]) {
            [self operationFailedBlockWithMsg:@"Read Mac Address Timeout" block:failedBlock];
            return;
        }
        if (![self readDeviceName]) {
            [self operationFailedBlockWithMsg:@"Read Device Name Timeout" block:failedBlock];
            return;
        }
        if (![self readClientID]) {
            [self operationFailedBlockWithMsg:@"Read Client ID Timeout" block:failedBlock];
            return;
        }
        
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
        
        NSString *networkSettingMsg = [self checkNetworkMsg];
        if (ValidStr(networkSettingMsg)) {
            [self operationFailedBlockWithMsg:networkSettingMsg block:failedBlock];
            return;
        }
        
        NSString *ntpMsg = [self checkNtpServerMsg];
        if (ValidStr(ntpMsg)) {
            [self operationFailedBlockWithMsg:ntpMsg block:failedBlock];
            return;
        }
        
#pragma mark - WIFI
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
                        [self operationFailedBlockWithMsg:@"Config CA File Error" block:failedBlock];
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
                    [self operationFailedBlockWithMsg:@"Config CA File Error" block:failedBlock];
                    return;
                }
                if (ValidStr(self.wifi_clientKey)) {
                    if (![self configWifiClientKey]) {
                        [self operationFailedBlockWithMsg:@"Config Client Key Error" block:failedBlock];
                        return;
                    }
                }
                if (ValidStr(self.wifi_clientCert)) {
                    if (![self configWifiClientCert]) {
                        [self operationFailedBlockWithMsg:@"Config Client Cert Error" block:failedBlock];
                        return;
                    }
                }
            }
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
        if (![self configDHCPStatus]) {
            [self operationFailedBlockWithMsg:@"Config DHCP Error" block:failedBlock];
            return;
        }
        if (!self.dhcp) {
            if (![self configIpAddress]) {
                [self operationFailedBlockWithMsg:@"Config IP Error" block:failedBlock];
                return;
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
    [MKCHInterface ch_readDeviceWifiSTAMacAddressWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.macAddress = returnData[@"result"][@"macAddress"];
        self.macAddress = [self.macAddress stringByReplacingOccurrencesOfString:@":" withString:@""];
        self.macAddress = [self.macAddress lowercaseString];
        
        [MKCHDeviceMQTTParamsModel shared].deviceModel.macAddress = self.macAddress;
        
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readDeviceName {
    __block BOOL success = NO;
    [MKCHInterface ch_readDeviceNameWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.deviceName = returnData[@"result"][@"deviceName"];
        
        [MKCHDeviceMQTTParamsModel shared].deviceModel.deviceName = self.deviceName;
        
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readClientID {
    __block BOOL success = NO;
    [MKCHInterface ch_readClientIDWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.clientID = returnData[@"result"][@"clientID"];
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
    
    [MKCHInterface ch_enterSTAModeWithSucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - Wifi 配置

- (BOOL)configSecurityType {
    __block BOOL success = NO;
    [MKCHInterface ch_configWIFISecurity:self.security sucBlock:^{
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
    [MKCHInterface ch_configWIFISSID:self.ssid sucBlock:^{
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
    [MKCHInterface ch_configWIFIPassword:self.wifiPassword sucBlock:^{
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
    [MKCHInterface ch_configWIFIEAPType:self.eapType sucBlock:^{
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
    [MKCHInterface ch_configWIFIEAPUsername:self.eapUserName sucBlock:^{
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
    [MKCHInterface ch_configWIFIEAPPassword:self.eapPassword sucBlock:^{
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
    [MKCHInterface ch_configWIFIEAPDomainID:self.domainID sucBlock:^{
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
    [MKCHInterface ch_configWIFIVerifyServerStatus:self.verifyServer sucBlock:^{
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
    [MKCHInterface ch_configWIFICAFile:caData sucBlock:^{
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
    [MKCHInterface ch_configWIFIClientPrivateKey:clientKeyData sucBlock:^{
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
    [MKCHInterface ch_configWIFIClientCert:clientCertData sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
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
        if (self.verifyServer && !ValidStr(self.wifi_ca)) {
            return @"CA File cannot be empty.";
        }
    }
    if (self.eapType == 2) {
        //TLS
        if (self.domainID.length > 64) {
            return @"domain ID error";
        }
        if (!ValidStr(self.wifi_ca)) {
            return @"CA File cannot be empty.";
        }
//        if (!ValidStr(self.wifi_clientKey) || !ValidStr(self.wifi_clientCert)) {
//            return @"Client File cannot be empty.";
//        }
    }
    return @"";
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
    [MKCHInterface ch_configServerHost:self.host sucBlock:^{
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
    [MKCHInterface ch_configServerPort:[self.port integerValue] sucBlock:^{
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
    [MKCHInterface ch_configClientID:self.clientID sucBlock:^{
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
    [MKCHInterface ch_configServerUserName:self.userName sucBlock:^{
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
    [MKCHInterface ch_configServerPassword:self.password sucBlock:^{
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
    [MKCHInterface ch_configServerCleanSession:self.cleanSession sucBlock:^{
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
    [MKCHInterface ch_configServerKeepAlive:[self.keepAlive integerValue] sucBlock:^{
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
    [MKCHInterface ch_configServerQos:self.qos sucBlock:^{
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
    
    [MKCHInterface ch_configSubscibeTopic:self.subscribeTopic sucBlock:^{
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
    
    [MKCHInterface ch_configPublishTopic:self.publishTopic sucBlock:^{
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
    mk_ch_connectMode mode = mk_ch_connectMode_TCP;
    if (self.sslIsOn) {
        if (self.certificate == 0) {
            mode = mk_ch_connectMode_CASignedServerCertificate;
        }else if (self.certificate == 1) {
            mode = mk_ch_connectMode_CACertificate;
        }else if (self.certificate == 2) {
            mode = mk_ch_connectMode_SelfSignedCertificates;
        }
    }
    [MKCHInterface ch_configConnectMode:mode sucBlock:^{
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
    [MKCHInterface ch_configCAFile:caData sucBlock:^{
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
    [MKCHInterface ch_configClientPrivateKey:clientKeyData sucBlock:^{
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
    [MKCHInterface ch_configClientCert:clientCertData sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - Network Settings
- (NSString *)checkNetworkMsg {
    if (self.dhcp) {
        return @"";
    }
    if (![self.ip regularExpressions:isIPAddress]) {
        return @"IP Error";
    }
    if (![self.mask regularExpressions:isIPAddress]) {
        return @"Mask Error";
    }
    if (![self.gateway regularExpressions:isIPAddress]) {
        return @"Gateway Error";
    }
    if (![self.dns regularExpressions:isIPAddress]) {
        return @"DNS Error";
    }
    return @"";
}

- (BOOL)configDHCPStatus {
    __block BOOL success = NO;
    [MKCHInterface ch_configWIFIDHCPStatus:self.dhcp sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configIpAddress {
    __block BOOL success = NO;
    [MKCHInterface ch_configWIFIIpAddress:self.ip
                                     mask:self.mask
                                  gateway:self.gateway
                                      dns:self.dns
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
    [MKCHInterface ch_configNTPServerHost:self.ntpHost sucBlock:^{
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
    [MKCHInterface ch_configTimeZone:(self.timeZone - 24) sucBlock:^{
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
    if (![MKCHDeviceMQTTParamsModel shared].cloud) {
        return;
    }
    //从云端导入
    //WIFI
    self.security = [[MKCHDeviceMQTTParamsModel shared].params[@"security"] integerValue];
    self.ssid = [MKCHDeviceMQTTParamsModel shared].params[@"wifiSSID"];
    self.wifiPassword = [MKCHDeviceMQTTParamsModel shared].params[@"wifiPassword"];
    self.eapType = [[MKCHDeviceMQTTParamsModel shared].params[@"eap"] integerValue];
    self.eapUserName = [MKCHDeviceMQTTParamsModel shared].params[@"eapUsername"];
    self.eapPassword = [MKCHDeviceMQTTParamsModel shared].params[@"eapPassword"];
    self.domainID = [MKCHDeviceMQTTParamsModel shared].params[@"domainID"];
    self.verifyServer = [[MKCHDeviceMQTTParamsModel shared].params[@"verifyServer"] boolValue];
    //参考MKCHBleMqttConfigSelectModel里面写死的证书名字
    self.wifi_ca = @"wifi_ca.pem";
    self.wifi_clientCert = @"wifi_client.crt";
    self.wifi_clientKey = @"wifi_client.key";
    
    
    //MQTT
    self.host = [MKCHDeviceMQTTParamsModel shared].params[@"host"];
    self.port = [MKCHDeviceMQTTParamsModel shared].params[@"port"];
    self.subscribeTopic = [MKCHDeviceMQTTParamsModel shared].params[@"subscribeTopic"];
    self.publishTopic = [MKCHDeviceMQTTParamsModel shared].params[@"publishTopic"];
    self.cleanSession = [[MKCHDeviceMQTTParamsModel shared].params[@"cleanSession"] boolValue];
    
    self.qos = [[MKCHDeviceMQTTParamsModel shared].params[@"qos"] integerValue];
    self.keepAlive = [MKCHDeviceMQTTParamsModel shared].params[@"keepAlive"];
    self.userName = [MKCHDeviceMQTTParamsModel shared].params[@"userName"];
    self.password = [MKCHDeviceMQTTParamsModel shared].params[@"password"];
    self.sslIsOn = [[MKCHDeviceMQTTParamsModel shared].params[@"sslIsOn"] boolValue];
    self.certificate = [[MKCHDeviceMQTTParamsModel shared].params[@"certificate"] integerValue];
    self.caFileName = @"ca.pem";
    self.clientKeyName = @"private.pem.key";
    self.clientCertName = @"certificate.pem.crt";
    
    //Network Settings
    self.dhcp = [[MKCHDeviceMQTTParamsModel shared].params[@"dhcp"] boolValue];
    self.ip = [MKCHDeviceMQTTParamsModel shared].params[@"ip"];
    self.mask = [MKCHDeviceMQTTParamsModel shared].params[@"mask"];
    self.gateway = [MKCHDeviceMQTTParamsModel shared].params[@"gateway"];
    self.dns = [MKCHDeviceMQTTParamsModel shared].params[@"dns"];
    
    //NtpServer
    self.ntpHost = [MKCHDeviceMQTTParamsModel shared].params[@"ntpServer"];
    self.timeZone = [[MKCHDeviceMQTTParamsModel shared].params[@"timezone"] integerValue] + 24;
    
    [MKCHDeviceMQTTParamsModel shared].deviceModel.publishedTopic = [MKCHDeviceMQTTParamsModel shared].params[@"publishTopic"];
    [MKCHDeviceMQTTParamsModel shared].deviceModel.subscribedTopic = [MKCHDeviceMQTTParamsModel shared].params[@"subscribeTopic"];
    [MKCHDeviceMQTTParamsModel shared].deviceModel.clientID = self.clientID;
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
