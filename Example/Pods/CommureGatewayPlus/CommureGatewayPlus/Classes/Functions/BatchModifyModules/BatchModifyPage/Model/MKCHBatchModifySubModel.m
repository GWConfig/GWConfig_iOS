//
//  MKCHBatchModifySubModel.m
//  CommureGatewayPlus
//
//  Created by aa on 2023/12/14.
//

#import "MKCHBatchModifySubModel.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKCHBatchModifyManager.h"



@interface MKCHBatchModifyWifiModel : NSObject<mk_ch_mqttModifyWifiProtocol,mk_ch_mqttModifyWifiEapCertProtocol>

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

/*
 0：United Arab Emirates
 1：Argentina
 2：American Samoa
 3：Austria
 4：Australia
 5：Barbados
 6：Burkina Faso
 7：Bermuda
 8：Brazil
 9：Bahamas
 10：Canada
 11:Central African Republic
 12:Côte d'Ivoire
 13:China
 14:Colombia
 15:Costa Rica
 16:Cuba
 17:Christmas Island
 18:Dominica
 19:Dominican Republic
 20:Ecuador
 21:Europe
 22:Micronesia, Federated States of
 23:France
 24:Grenada
 25:Ghana
 26:Greece
 27:Guatemala
 28:Guam
 29:Guyana
 30:Honduras
 31:Haiti
 32:Jamaica
 33:Cayman Islands
 34:Kazakhstan
 35:Lebanon
 36:Sri Lanka
 37:Marshall Islands
 38:Mongolia
 39:Macao, SAR China
 40:Northern Mariana Islands
 41:Mauritius
 42:Mexico
 43:Malaysia
 44:Nicaragua
 45:Panama
 46:Peru
 47:Papua New Guinea
 48:Philippines
 49:Puerto Rico
 50:Palau
 51:Paraguay
 52:Rwanda
 53:Singapore
 54:Senegal
 55:El Salvador
 56:Syrian Arab Republic (Syria)
 57:Turks and Caicos Islands
 58:Thailand
 59:Trinidad and Tobago
 60:Taiwan, Republic of China
 61:Tanzania, United Republic of
 62:Uganda
 63:United States of America
 64:Uruguay
 65:Venezuela (Bolivarian
 Republic)
 66:Virgin Islands,US
 67:Viet Nam
 68:Vanuatu
 */
@property (nonatomic, assign)NSInteger country;

/// security为personal无此参数
@property (nonatomic, copy)NSString *caFilePath;

/// eapType为TLS有效
@property (nonatomic, copy)NSString *clientKeyPath;

/// eapType为TLS有效
@property (nonatomic, copy)NSString *clientCertPath;


- (NSString *)checkMsg;

@end

@implementation MKCHBatchModifyWifiModel

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
    self.security = [[MKCHBatchModifyManager shared].params[@"security"] integerValue];
    self.ssid = [MKCHBatchModifyManager shared].params[@"wifiSSID"];
    self.wifiPassword = [MKCHBatchModifyManager shared].params[@"wifiPassword"];
    self.eapType = [[MKCHBatchModifyManager shared].params[@"eap"] integerValue];
    self.eapUserName = [MKCHBatchModifyManager shared].params[@"eapUsername"];
    self.eapPassword = [MKCHBatchModifyManager shared].params[@"eapPassword"];
    self.domainID = [MKCHBatchModifyManager shared].params[@"domainID"];
    self.verifyServer = [[MKCHBatchModifyManager shared].params[@"verifyServer"] boolValue];
    self.country = [[MKCHBatchModifyManager shared].params[@"countryBand"] integerValue];
    self.caFilePath = [MKCHBatchModifyManager shared].params[@"wifiCaPath"];
    self.clientKeyPath = [MKCHBatchModifyManager shared].params[@"wifiClientKeyPath"];
    self.clientCertPath = [MKCHBatchModifyManager shared].params[@"wifiClientCertPath"];
}

@end


@interface MKCHBatchModifyServerModel : NSObject<mk_ch_modifyMqttServerProtocol,mk_ch_modifyMqttServerCertsProtocol>

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

@implementation MKCHBatchModifyServerModel

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
    self.host = [MKCHBatchModifyManager shared].params[@"host"];
    self.port = [MKCHBatchModifyManager shared].params[@"port"];
//    self.clientID = [MKCHBatchModifyManager shared].params[@"clientID"];
    self.subscribeTopic = [MKCHBatchModifyManager shared].params[@"subscribeTopic"];
    self.publishTopic = [MKCHBatchModifyManager shared].params[@"publishTopic"];
    self.cleanSession = [[MKCHBatchModifyManager shared].params[@"cleanSession"] boolValue];
    
    self.qos = [[MKCHBatchModifyManager shared].params[@"qos"] integerValue];
    self.keepAlive = [MKCHBatchModifyManager shared].params[@"keepAlive"];
    self.userName = [MKCHBatchModifyManager shared].params[@"userName"];
    self.password = [MKCHBatchModifyManager shared].params[@"password"];
    self.sslIsOn = [[MKCHBatchModifyManager shared].params[@"sslIsOn"] boolValue];
    self.certificate = [[MKCHBatchModifyManager shared].params[@"certificate"] integerValue];
    self.caFilePath = [MKCHBatchModifyManager shared].params[@"caPath"];
    self.clientKeyPath = [MKCHBatchModifyManager shared].params[@"clientKeyPath"];
    self.clientCertPath = [MKCHBatchModifyManager shared].params[@"clientCertPath"];
    
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


@interface MKCHBatchModifyNetworkModel : NSObject<mk_ch_mqttModifyNetworkProtocol>

@property (nonatomic, assign)BOOL dhcp;

@property (nonatomic, copy)NSString *ip;

@property (nonatomic, copy)NSString *mask;

@property (nonatomic, copy)NSString *gateway;

@property (nonatomic, copy)NSString *dns;

- (NSString *)checkMsg;

@end

@implementation MKCHBatchModifyNetworkModel
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
    self.dhcp = [[MKCHBatchModifyManager shared].params[@"dhcp"] boolValue];
    self.ip = [MKCHBatchModifyManager shared].params[@"ip"];
    self.mask = [MKCHBatchModifyManager shared].params[@"mask"];
    self.gateway = [MKCHBatchModifyManager shared].params[@"gateway"];
    self.dns = [MKCHBatchModifyManager shared].params[@"dns"];
}

@end



@interface MKCHBatchModifySubModel ()

@property (nonatomic, strong)dispatch_queue_t configQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@property (nonatomic, copy)NSString *macAddress;

@property (nonatomic, copy)NSString *pubTopic;

@end

@implementation MKCHBatchModifySubModel

- (void)configDataWithMacAddress:(NSString *)macAddress
                        pubTopic:(NSString *)pubTopic
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock {
    self.pubTopic = pubTopic;
    self.macAddress = macAddress;
    dispatch_async(self.configQueue, ^{
        MKCHBatchModifyWifiModel *wifiModel = [[MKCHBatchModifyWifiModel alloc] init];
        NSString *wifiMsg = [wifiModel checkMsg];
        if (ValidStr(wifiMsg)) {
            [self operationFailedBlockWithMsg:wifiMsg block:failedBlock];
            return;
        }
        
        MKCHBatchModifyServerModel *serverModel = [[MKCHBatchModifyServerModel alloc] init];
        serverModel.clientID = macAddress;
        NSString *serverMsg = [serverModel checkParams];
        if (ValidStr(serverMsg)) {
            [self operationFailedBlockWithMsg:serverMsg block:failedBlock];
            return;
        }
        
        MKCHBatchModifyNetworkModel *networkModel = [[MKCHBatchModifyNetworkModel alloc] init];
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
    [MKCHMQTTInterface ch_readOtaStatusWithMacAddress:self.macAddress topic:self.pubTopic sucBlock:^(id  _Nonnull returnData) {
        status = [returnData[@"data"][@"status"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return status;
}

- (BOOL)configWifiInfos:(id <mk_ch_mqttModifyWifiProtocol>)protocol {
    __block BOOL success = NO;
    [MKCHMQTTInterface ch_modifyWifiInfos:protocol macAddress:self.macAddress topic:self.pubTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configEAPCerts:(id <mk_ch_mqttModifyWifiEapCertProtocol>)protocol {
    __block BOOL success = NO;
    [MKCHMQTTInterface ch_modifyWifiCerts:protocol macAddress:self.macAddress topic:self.pubTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configMqttInfos:(id <mk_ch_modifyMqttServerProtocol>)protocol {
    __block BOOL success = NO;
    
    [MKCHMQTTInterface ch_modifyMqttInfos:protocol macAddress:self.macAddress topic:self.pubTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configMqttCerts:(id <mk_ch_modifyMqttServerCertsProtocol>)protocol {
    __block BOOL success = NO;
    [MKCHMQTTInterface ch_modifyMqttCerts:protocol macAddress:self.macAddress topic:self.pubTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configNetworkInfos:(id <mk_ch_mqttModifyNetworkProtocol>)protocol {
    __block BOOL success = NO;
    [MKCHMQTTInterface ch_modifyWifiNetworkInfos:protocol macAddress:self.macAddress topic:self.pubTopic sucBlock:^(id  _Nonnull returnData) {
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
    [MKCHMQTTInterface ch_rebootDeviceWithMacAddress:self.macAddress topic:self.pubTopic sucBlock:^(id  _Nonnull returnData) {
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
