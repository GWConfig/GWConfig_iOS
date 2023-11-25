//
//  MKCGMqttParamsModel.m
//  CommureGateway_Example
//
//  Created by aa on 2023/2/15.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCGMqttParamsModel.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKCGDeviceModeManager.h"

#import "MKCGMQTTInterface.h"
#import "MKCGMQTTConfigDefines.h"

#import "MKCGModifyNetworkDataModel.h"


@interface MKCGCloudImportMqttWifiModel : NSObject<mk_cg_mqttModifyWifiProtocol,mk_cg_mqttModifyWifiEapCertProtocol>

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


- (NSString *)checkMsg;

@end

@implementation MKCGCloudImportMqttWifiModel

- (instancetype)init {
    if (self = [super init]) {
        [self loadValues];
    }
    return self;
}

- (NSString *)checkMsg {
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
    if (![MKCGModifyNetworkDataModel shared].cloud) {
        return;
    }
    self.security = [[MKCGModifyNetworkDataModel shared].params[@"security"] integerValue];
    self.ssid = [MKCGModifyNetworkDataModel shared].params[@"wifiSSID"];
    self.wifiPassword = [MKCGModifyNetworkDataModel shared].params[@"wifiPassword"];
    self.eapType = [[MKCGModifyNetworkDataModel shared].params[@"eap"] integerValue];
    self.eapUserName = [MKCGModifyNetworkDataModel shared].params[@"eapUsername"];
    self.eapPassword = [MKCGModifyNetworkDataModel shared].params[@"eapPassword"];
    self.domainID = [MKCGModifyNetworkDataModel shared].params[@"domainID"];
    self.verifyServer = [[MKCGModifyNetworkDataModel shared].params[@"verifyServer"] boolValue];
    self.caFilePath = [MKCGModifyNetworkDataModel shared].params[@"wifiCaPath"];
    self.clientKeyPath = [MKCGModifyNetworkDataModel shared].params[@"wifiClientKeyPath"];
    self.clientCertPath = [MKCGModifyNetworkDataModel shared].params[@"wifiClientCertPath"];
}

@end


@interface MKCGCloudImportServerModel : NSObject<mk_cg_modifyMqttServerProtocol,mk_cg_modifyMqttServerCertsProtocol>

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

@implementation MKCGCloudImportServerModel

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
    if (![MKCGModifyNetworkDataModel shared].cloud) {
        return;
    }
    self.host = [MKCGModifyNetworkDataModel shared].params[@"host"];
    self.port = [MKCGModifyNetworkDataModel shared].params[@"port"];
    self.clientID = [MKCGModifyNetworkDataModel shared].params[@"clientID"];
    self.subscribeTopic = [MKCGModifyNetworkDataModel shared].params[@"subscribeTopic"];
    self.publishTopic = [MKCGModifyNetworkDataModel shared].params[@"publishTopic"];
    self.cleanSession = [[MKCGModifyNetworkDataModel shared].params[@"cleanSession"] boolValue];
    
    self.qos = [[MKCGModifyNetworkDataModel shared].params[@"qos"] integerValue];
    self.keepAlive = [MKCGModifyNetworkDataModel shared].params[@"keepAlive"];
    self.userName = [MKCGModifyNetworkDataModel shared].params[@"userName"];
    self.password = [MKCGModifyNetworkDataModel shared].params[@"password"];
    self.sslIsOn = [[MKCGModifyNetworkDataModel shared].params[@"sslIsOn"] boolValue];
    self.certificate = [[MKCGModifyNetworkDataModel shared].params[@"certificate"] integerValue];
    self.caFilePath = [MKCGModifyNetworkDataModel shared].params[@"caPath"];
    self.clientKeyPath = [MKCGModifyNetworkDataModel shared].params[@"clientKeyPath"];
    self.clientCertPath = [MKCGModifyNetworkDataModel shared].params[@"clientCertPath"];
    
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


@interface MKCGCloudImportNetworkModel : NSObject<mk_cg_mqttModifyNetworkProtocol>

@property (nonatomic, assign)BOOL dhcp;

@property (nonatomic, copy)NSString *ip;

@property (nonatomic, copy)NSString *mask;

@property (nonatomic, copy)NSString *gateway;

@property (nonatomic, copy)NSString *dns;

- (NSString *)checkMsg;

@end

@implementation MKCGCloudImportNetworkModel
- (instancetype)init {
    if (self = [super init]) {
        [self loadValues];
    }
    return self;
}

- (NSString *)checkMsg {
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

- (void)loadValues {
    if (![MKCGModifyNetworkDataModel shared].cloud) {
        return;
    }
    self.dhcp = [[MKCGModifyNetworkDataModel shared].params[@"dhcp"] boolValue];
    self.ip = [MKCGModifyNetworkDataModel shared].params[@"ip"];
    self.mask = [MKCGModifyNetworkDataModel shared].params[@"mask"];
    self.gateway = [MKCGModifyNetworkDataModel shared].params[@"gateway"];
    self.dns = [MKCGModifyNetworkDataModel shared].params[@"dns"];
}

@end


@interface MKCGMqttParamsModel ()

@property (nonatomic, strong)dispatch_queue_t configQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;


#pragma mark - WIFI

@end

@implementation MKCGMqttParamsModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.configQueue, ^{
        if ([MKCGModifyNetworkDataModel shared].cloud) {
            //云端下载
            self.clientID = [MKCGModifyNetworkDataModel shared].params[@"clientID"];
            self.subscribeTopic = [MKCGModifyNetworkDataModel shared].params[@"subscribeTopic"];
            self.publishTopic = [MKCGModifyNetworkDataModel shared].params[@"publishTopic"];
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
        
        MKCGCloudImportMqttWifiModel *wifiModel = [[MKCGCloudImportMqttWifiModel alloc] init];
        NSString *wifiMsg = [wifiModel checkMsg];
        if (ValidStr(wifiMsg)) {
            [self operationFailedBlockWithMsg:wifiMsg block:failedBlock];
            return;
        }
        
        MKCGCloudImportServerModel *serverModel = [[MKCGCloudImportServerModel alloc] init];
        NSString *serverMsg = [serverModel checkParams];
        if (ValidStr(serverMsg)) {
            [self operationFailedBlockWithMsg:serverMsg block:failedBlock];
            return;
        }
        
        MKCGCloudImportNetworkModel *networkModel = [[MKCGCloudImportNetworkModel alloc] init];
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
        
#pragma mark - WIFI
        if (![self configWifiInfos:wifiModel]) {
            [self operationFailedBlockWithMsg:@"Config Wifi Infos Error" block:failedBlock];
            return;
        }
        if (wifiModel.security == 1 && !(!ValidStr(wifiModel.caFilePath) && !ValidStr(wifiModel.clientKeyPath) && !ValidStr(wifiModel.clientCertPath))) {
            //三个证书同时为空，则不需要发送
            if (((wifiModel.eapType == 0 || wifiModel.eapType == 1) && wifiModel.verifyServer) || wifiModel.eapType == 2) {
                //TLS需要设置这个，0:PEAP-MSCHAPV2  1:TTLS-MSCHAPV2这两种必须验证服务器打开的情况下才设置
                if (![self configEAPCerts:wifiModel]) {
                    [self operationFailedBlockWithMsg:@"Config EAP Certs Error" block:failedBlock];
                    return;
                }
            }
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
        if (![self configNetworkInfos:networkModel]) {
            [self operationFailedBlockWithMsg:@"Config Network Infos Error" block:failedBlock];
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
    [MKCGMQTTInterface cg_readMQTTParamsWithMacAddress:[MKCGDeviceModeManager shared].macAddress topic:[MKCGDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
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
    [MKCGMQTTInterface cg_readOtaStatusWithMacAddress:[MKCGDeviceModeManager shared].macAddress topic:[MKCGDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        status = [returnData[@"data"][@"status"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return status;
}

- (BOOL)configWifiInfos:(id <mk_cg_mqttModifyWifiProtocol>)protocol {
    __block BOOL success = NO;
    [MKCGMQTTInterface cg_modifyWifiInfos:protocol macAddress:[MKCGDeviceModeManager shared].macAddress topic:[MKCGDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configEAPCerts:(id <mk_cg_mqttModifyWifiEapCertProtocol>)protocol {
    __block BOOL success = NO;
    [MKCGMQTTInterface cg_modifyWifiCerts:protocol macAddress:[MKCGDeviceModeManager shared].macAddress topic:[MKCGDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configMqttInfos:(id <mk_cg_modifyMqttServerProtocol>)protocol {
    __block BOOL success = NO;
    
    [MKCGMQTTInterface cg_modifyMqttInfos:protocol macAddress:[MKCGDeviceModeManager shared].macAddress topic:[MKCGDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configMqttCerts:(id <mk_cg_modifyMqttServerCertsProtocol>)protocol {
    __block BOOL success = NO;
    [MKCGMQTTInterface cg_modifyMqttCerts:protocol macAddress:[MKCGDeviceModeManager shared].macAddress topic:[MKCGDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configNetworkInfos:(id <mk_cg_mqttModifyNetworkProtocol>)protocol {
    __block BOOL success = NO;
    [MKCGMQTTInterface cg_modifyWifiNetworkInfos:protocol macAddress:[MKCGDeviceModeManager shared].macAddress topic:[MKCGDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
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
