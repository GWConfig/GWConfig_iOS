//
//  MKCFMqttParamsModel.m
//  CommureGWThree_Example
//
//  Created by aa on 2023/2/15.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCFMqttParamsModel.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKCFDeviceModeManager.h"

#import "MKCFMQTTInterface.h"
#import "MKCFMQTTConfigDefines.h"

#import "MKCFModifyNetworkDataModel.h"


@interface MKCFMqttNetworkIPSettingModel : NSObject<mk_cf_mqttModifyNetworkProtocol>

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

@implementation MKCFMqttNetworkIPSettingModel
@end


@interface MKCFCloudImportServerModel : NSObject<mk_cf_modifyMqttServerProtocol,mk_cf_modifyMqttServerCertsProtocol>

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

/// 0:TCP    1:CA signed server certificate     2:CA certificate     3:Self signed certificates
@property (nonatomic, assign)NSInteger connectMode;


@property (nonatomic, copy)NSString *caFilePath;

@property (nonatomic, copy)NSString *clientKeyPath;

@property (nonatomic, copy)NSString *clientCertPath;

- (NSString *)checkParams;

@end

@implementation MKCFCloudImportServerModel

- (instancetype)init {
    if (self = [super init]) {
        [self loadValues];
    }
    return self;
}

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
        if (self.certificate == 1) {
            if (self.caFilePath.length > 256) {
                return @"CA File Path Error";
            }
        }
        if (self.certificate == 2) {
            if (self.caFilePath.length > 256 || self.clientKeyPath.length > 256 || self.clientCertPath.length > 256) {
                return @"File Path Error.";
            }
        }
    }
    return @"";
}

- (void)loadValues {
    if (![MKCFModifyNetworkDataModel shared].cloud) {
        return;
    }
    self.host = [MKCFModifyNetworkDataModel shared].params[@"host"];
    self.port = [MKCFModifyNetworkDataModel shared].params[@"port"];
    self.clientID = [MKCFModifyNetworkDataModel shared].params[@"clientID"];
    self.subscribeTopic = [MKCFModifyNetworkDataModel shared].params[@"subscribeTopic"];
    self.publishTopic = [MKCFModifyNetworkDataModel shared].params[@"publishTopic"];
    self.cleanSession = [[MKCFModifyNetworkDataModel shared].params[@"cleanSession"] boolValue];
    
    self.qos = [[MKCFModifyNetworkDataModel shared].params[@"qos"] integerValue];
    self.keepAlive = [MKCFModifyNetworkDataModel shared].params[@"keepAlive"];
    self.userName = [MKCFModifyNetworkDataModel shared].params[@"userName"];
    self.password = [MKCFModifyNetworkDataModel shared].params[@"password"];
    self.sslIsOn = [[MKCFModifyNetworkDataModel shared].params[@"sslIsOn"] boolValue];
    self.certificate = [[MKCFModifyNetworkDataModel shared].params[@"certificate"] integerValue];
    self.caFilePath = [MKCFModifyNetworkDataModel shared].params[@"caPath"];
    self.clientKeyPath = [MKCFModifyNetworkDataModel shared].params[@"clientKeyPath"];
    self.clientCertPath = [MKCFModifyNetworkDataModel shared].params[@"clientCertPath"];
    
    if (!self.sslIsOn) {
        self.connectMode = 0;
    }else {
        if (self.certificate == 0) {
            self.connectMode = 1;
        }else if (self.certificate == 1) {
            self.connectMode = 2;
        }else if (self.certificate == 2) {
            self.connectMode = 3;
        }
    }
}

@end


@interface MKCFCloudImportNetworkModel : NSObject<mk_cf_mqttModifyWifiProtocol,
mk_cf_mqttModifyWifiEapCertProtocol>

/// 0:Ethernet    1:WiFi
@property (nonatomic, assign)NSInteger networkType;

#pragma mark - Wifi Settings

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
@property (nonatomic, copy)NSString *caFilePath;

/// eapType为TLS有效
@property (nonatomic, copy)NSString *clientKeyPath;

/// eapType为TLS有效
@property (nonatomic, copy)NSString *clientCertPath;


#pragma mark - Wifi Network Settings

@property (nonatomic, assign)BOOL wifi_dhcp;

@property (nonatomic, copy)NSString *wifi_ip;

@property (nonatomic, copy)NSString *wifi_mask;

@property (nonatomic, copy)NSString *wifi_gateway;

@property (nonatomic, copy)NSString *wifi_dns;


#pragma mark - Ethernet Network Settings

@property (nonatomic, assign)BOOL ethernet_dhcp;

@property (nonatomic, copy)NSString *ethernet_ip;

@property (nonatomic, copy)NSString *ethernet_mask;

@property (nonatomic, copy)NSString *ethernet_gateway;

@property (nonatomic, copy)NSString *ethernet_dns;

@end

@implementation MKCFCloudImportNetworkModel
- (instancetype)init {
    if (self = [super init]) {
        [self loadValues];
    }
    return self;
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

- (void)loadValues {
    if (![MKCFModifyNetworkDataModel shared].cloud) {
        return;
    }
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
}

@end


@interface MKCFMqttParamsModel ()

@property (nonatomic, strong)dispatch_queue_t configQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;


#pragma mark - WIFI

@end

@implementation MKCFMqttParamsModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.configQueue, ^{
        if ([MKCFModifyNetworkDataModel shared].cloud) {
            //云端下载
            self.clientID = [MKCFModifyNetworkDataModel shared].params[@"clientID"];
            self.subscribeTopic = [MKCFModifyNetworkDataModel shared].params[@"subscribeTopic"];
            self.publishTopic = [MKCFModifyNetworkDataModel shared].params[@"publishTopic"];
            moko_dispatch_main_safe(^{
                sucBlock();
            });
            return;
        }
        if (![self readMqttInfos]) {
            [self operationFailedBlockWithMsg:@"Read Mqtt Infos Error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            sucBlock();
        });
    });
}

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.configQueue, ^{
        
        MKCFCloudImportServerModel *serverModel = [[MKCFCloudImportServerModel alloc] init];
        NSString *serverMsg = [serverModel checkParams];
        if (ValidStr(serverMsg)) {
            [self operationFailedBlockWithMsg:serverMsg block:failedBlock];
            return;
        }
        
        MKCFCloudImportNetworkModel *networkModel = [[MKCFCloudImportNetworkModel alloc] init];
        NSString *networkMsg = [networkModel checkMsg];
        if (ValidStr(networkMsg)) {
            [self operationFailedBlockWithMsg:networkMsg block:failedBlock];
            return;
        }
        
        NSInteger status = [self readOTAState];
        if (status == -1) {
            [self operationFailedBlockWithMsg:@"Read OTA Status Error" block:failedBlock];
            return;
        }
        if (status == 1) {
            [self operationFailedBlockWithMsg:@"Device is busy now!" block:failedBlock];
            return;
        }
        
#pragma mark - Server
        if (![self configMqttInfos:serverModel]) {
            [self operationFailedBlockWithMsg:@"Config Mqtt Infos Error" block:failedBlock];
            return;
        }
        if (serverModel.connectMode > 1 && !(!ValidStr(serverModel.caFilePath) && !ValidStr(serverModel.clientKeyPath) && !ValidStr(serverModel.clientCertPath))) {
            if (![self configMqttCerts:serverModel]) {
                [self operationFailedBlockWithMsg:@"Config Mqtt Certs Error" block:failedBlock];
                return;
            }
        }
        
#pragma mark - Network
        if (![self configNetworkType:networkModel.networkType]) {
            [self operationFailedBlockWithMsg:@"Config Network Type Error" block:failedBlock];
            return;
        }
        
        if (networkModel.networkType == 0) {
            //Network Type 为Ethernet
            MKCFMqttNetworkIPSettingModel *ethModel = [[MKCFMqttNetworkIPSettingModel alloc] init];
            ethModel.dhcp = networkModel.ethernet_dhcp;
            ethModel.ip = networkModel.ethernet_ip;
            ethModel.mask = networkModel.ethernet_mask;
            ethModel.gateway = networkModel.ethernet_gateway;
            ethModel.dns = networkModel.ethernet_dns;
            if (![self configEthernetNetworkInfos:ethModel]) {
                [self operationFailedBlockWithMsg:@"Config Ethernet Infos Error" block:failedBlock];
                return;
            }
        } else {
            //Network Type 为Wifi
            MKCFMqttNetworkIPSettingModel *wifiModel = [[MKCFMqttNetworkIPSettingModel alloc] init];
            wifiModel.dhcp = networkModel.wifi_dhcp;
            wifiModel.ip = networkModel.wifi_ip;
            wifiModel.mask = networkModel.wifi_mask;
            wifiModel.gateway = networkModel.wifi_gateway;
            wifiModel.dns = networkModel.wifi_dns;
            if (![self configWifiNetworkInfos:wifiModel]) {
                [self operationFailedBlockWithMsg:@"Config Wifi Infos Error" block:failedBlock];
                return;
            }
            
            if (![self configWifiInfos:networkModel]) {
                [self operationFailedBlockWithMsg:@"Config Wifi Infos Error" block:failedBlock];
                return;
            }
            if (networkModel.security == 1 && !(!ValidStr(networkModel.caFilePath) && !ValidStr(networkModel.clientKeyPath) && !ValidStr(networkModel.clientCertPath))) {
                //三个证书同时为空，则不需要发送
                if (((networkModel.eapType == 0 || networkModel.eapType == 1) && networkModel.verifyServer) || networkModel.eapType == 2) {
                    //TLS需要设置这个，0:PEAP-MSCHAPV2  1:TTLS-MSCHAPV2这两种必须验证服务器打开的情况下才设置
                    if (![self configEAPCerts:networkModel]) {
                        [self operationFailedBlockWithMsg:@"Config EAP Certs Error" block:failedBlock];
                        return;
                    }
                }
            }
        }
        
        if (![self reboot]) {
            [self operationFailedBlockWithMsg:@"Reboot Error" block:failedBlock];
            return;
        }
        
        moko_dispatch_main_safe(^{
            sucBlock();
        });
    });
}

#pragma mark - interface
- (BOOL)readMqttInfos {
    __block BOOL success = NO;
    [MKCFMQTTInterface cf_readMQTTParamsWithMacAddress:[MKCFDeviceModeManager shared].macAddress topic:[MKCFDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.clientID = returnData[@"data"][@"client_id"];
        self.subscribeTopic = returnData[@"data"][@"sub_topic"];
        self.publishTopic = returnData[@"data"][@"pub_topic"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

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

- (BOOL)configNetworkType:(NSInteger)networkType {
    __block BOOL success = NO;
    [MKCFMQTTInterface cf_modifyNetworkType:networkType macAddress:[MKCFDeviceModeManager shared].macAddress topic:[MKCFDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configWifiInfos:(id <mk_cf_mqttModifyWifiProtocol>)protocol {
    __block BOOL success = NO;
    [MKCFMQTTInterface cf_modifyWifiInfos:protocol macAddress:[MKCFDeviceModeManager shared].macAddress topic:[MKCFDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configEAPCerts:(id <mk_cf_mqttModifyWifiEapCertProtocol>)protocol {
    __block BOOL success = NO;
    [MKCFMQTTInterface cf_modifyWifiCerts:protocol macAddress:[MKCFDeviceModeManager shared].macAddress topic:[MKCFDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configMqttInfos:(id <mk_cf_modifyMqttServerProtocol>)protocol {
    __block BOOL success = NO;
    
    [MKCFMQTTInterface cf_modifyMqttInfos:protocol macAddress:[MKCFDeviceModeManager shared].macAddress topic:[MKCFDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configMqttCerts:(id <mk_cf_modifyMqttServerCertsProtocol>)protocol {
    __block BOOL success = NO;
    [MKCFMQTTInterface cf_modifyMqttCerts:protocol macAddress:[MKCFDeviceModeManager shared].macAddress topic:[MKCFDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configWifiNetworkInfos:(id <mk_cf_mqttModifyNetworkProtocol>)protocol {
    __block BOOL success = NO;
    [MKCFMQTTInterface cf_modifyWifiNetworkInfos:protocol macAddress:[MKCFDeviceModeManager shared].macAddress topic:[MKCFDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configEthernetNetworkInfos:(id <mk_cf_mqttModifyNetworkProtocol>)protocol {
    __block BOOL success = NO;
    [MKCFMQTTInterface cf_modifyEthernetNetworkInfos:protocol macAddress:[MKCFDeviceModeManager shared].macAddress topic:[MKCFDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)reboot {
    __block BOOL success = NO;
    [MKCFMQTTInterface cf_rebootDeviceWithMacAddress:[MKCFDeviceModeManager shared].macAddress topic:[MKCFDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - private method
- (void)operationFailedBlockWithMsg:(NSString *)msg block:(void (^)(NSError *error))block {
    moko_dispatch_main_safe(^{
        NSError *error = [[NSError alloc] initWithDomain:@"serverParams"
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

- (dispatch_queue_t)configQueue {
    if (!_configQueue) {
        _configQueue = dispatch_queue_create("serverSettingsQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _configQueue;
}

@end
