//
//  MKCGBatchModifySubModel.m
//  CommureGateway
//
//  Created by aa on 2023/12/14.
//

#import "MKCGBatchModifySubModel.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKCGBatchModifyManager.h"



@interface MKCGBatchModifyWifiModel : NSObject<mk_cg_mqttModifyWifiProtocol,mk_cg_mqttModifyWifiEapCertProtocol>

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

@implementation MKCGBatchModifyWifiModel

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
    self.security = [[MKCGBatchModifyManager shared].params[@"security"] integerValue];
    self.ssid = [MKCGBatchModifyManager shared].params[@"wifiSSID"];
    self.wifiPassword = [MKCGBatchModifyManager shared].params[@"wifiPassword"];
    self.eapType = [[MKCGBatchModifyManager shared].params[@"eap"] integerValue];
    self.eapUserName = [MKCGBatchModifyManager shared].params[@"eapUsername"];
    self.eapPassword = [MKCGBatchModifyManager shared].params[@"eapPassword"];
    self.domainID = [MKCGBatchModifyManager shared].params[@"domainID"];
    self.verifyServer = [[MKCGBatchModifyManager shared].params[@"verifyServer"] boolValue];
    self.caFilePath = [MKCGBatchModifyManager shared].params[@"wifiCaPath"];
    self.clientKeyPath = [MKCGBatchModifyManager shared].params[@"wifiClientKeyPath"];
    self.clientCertPath = [MKCGBatchModifyManager shared].params[@"wifiClientCertPath"];
}

@end


@interface MKCGBatchModifyServerModel : NSObject<mk_cg_modifyMqttServerProtocol,mk_cg_modifyMqttServerCertsProtocol>

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

@implementation MKCGBatchModifyServerModel

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
    self.host = [MKCGBatchModifyManager shared].params[@"host"];
    self.port = [MKCGBatchModifyManager shared].params[@"port"];
    self.clientID = [MKCGBatchModifyManager shared].params[@"clientID"];
    self.subscribeTopic = [MKCGBatchModifyManager shared].params[@"subscribeTopic"];
    self.publishTopic = [MKCGBatchModifyManager shared].params[@"publishTopic"];
    self.cleanSession = [[MKCGBatchModifyManager shared].params[@"cleanSession"] boolValue];
    
    self.qos = [[MKCGBatchModifyManager shared].params[@"qos"] integerValue];
    self.keepAlive = [MKCGBatchModifyManager shared].params[@"keepAlive"];
    self.userName = [MKCGBatchModifyManager shared].params[@"userName"];
    self.password = [MKCGBatchModifyManager shared].params[@"password"];
    self.sslIsOn = [[MKCGBatchModifyManager shared].params[@"sslIsOn"] boolValue];
    self.certificate = [[MKCGBatchModifyManager shared].params[@"certificate"] integerValue];
    self.caFilePath = [MKCGBatchModifyManager shared].params[@"caPath"];
    self.clientKeyPath = [MKCGBatchModifyManager shared].params[@"clientKeyPath"];
    self.clientCertPath = [MKCGBatchModifyManager shared].params[@"clientCertPath"];
    
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


@interface MKCGBatchModifyNetworkModel : NSObject<mk_cg_mqttModifyNetworkProtocol>

@property (nonatomic, assign)BOOL dhcp;

@property (nonatomic, copy)NSString *ip;

@property (nonatomic, copy)NSString *mask;

@property (nonatomic, copy)NSString *gateway;

@property (nonatomic, copy)NSString *dns;

- (NSString *)checkMsg;

@end

@implementation MKCGBatchModifyNetworkModel
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
    self.dhcp = [[MKCGBatchModifyManager shared].params[@"dhcp"] boolValue];
    self.ip = [MKCGBatchModifyManager shared].params[@"ip"];
    self.mask = [MKCGBatchModifyManager shared].params[@"mask"];
    self.gateway = [MKCGBatchModifyManager shared].params[@"gateway"];
    self.dns = [MKCGBatchModifyManager shared].params[@"dns"];
}

@end



@interface MKCGBatchModifySubModel ()

@property (nonatomic, strong)dispatch_queue_t configQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@property (nonatomic, copy)NSString *macAddress;

@property (nonatomic, copy)NSString *pubTopic;

@end

@implementation MKCGBatchModifySubModel

- (void)configDataWithMacAddress:(NSString *)macAddress
                        pubTopic:(NSString *)pubTopic
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock {
    self.pubTopic = pubTopic;
    self.macAddress = macAddress;
    dispatch_async(self.configQueue, ^{
        MKCGBatchModifyWifiModel *wifiModel = [[MKCGBatchModifyWifiModel alloc] init];
        NSString *wifiMsg = [wifiModel checkMsg];
        if (ValidStr(wifiMsg)) {
            [self operationFailedBlockWithMsg:wifiMsg block:failedBlock];
            return;
        }
        
        MKCGBatchModifyServerModel *serverModel = [[MKCGBatchModifyServerModel alloc] init];
        NSString *serverMsg = [serverModel checkParams];
        if (ValidStr(serverMsg)) {
            [self operationFailedBlockWithMsg:serverMsg block:failedBlock];
            return;
        }
        
        MKCGBatchModifyNetworkModel *networkModel = [[MKCGBatchModifyNetworkModel alloc] init];
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
- (NSInteger)readOTAState {
    __block NSInteger status = -1;
    [MKCGMQTTInterface cg_readOtaStatusWithMacAddress:self.macAddress topic:self.pubTopic sucBlock:^(id  _Nonnull returnData) {
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
    [MKCGMQTTInterface cg_modifyWifiInfos:protocol macAddress:self.macAddress topic:self.pubTopic sucBlock:^(id  _Nonnull returnData) {
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
    [MKCGMQTTInterface cg_modifyWifiCerts:protocol macAddress:self.macAddress topic:self.pubTopic sucBlock:^(id  _Nonnull returnData) {
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
    
    [MKCGMQTTInterface cg_modifyMqttInfos:protocol macAddress:self.macAddress topic:self.pubTopic sucBlock:^(id  _Nonnull returnData) {
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
    [MKCGMQTTInterface cg_modifyMqttCerts:protocol macAddress:self.macAddress topic:self.pubTopic sucBlock:^(id  _Nonnull returnData) {
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
    [MKCGMQTTInterface cg_modifyWifiNetworkInfos:protocol macAddress:self.macAddress topic:self.pubTopic sucBlock:^(id  _Nonnull returnData) {
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
    [MKCGMQTTInterface cg_rebootDeviceWithMacAddress:self.macAddress topic:self.pubTopic sucBlock:^(id  _Nonnull returnData) {
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
