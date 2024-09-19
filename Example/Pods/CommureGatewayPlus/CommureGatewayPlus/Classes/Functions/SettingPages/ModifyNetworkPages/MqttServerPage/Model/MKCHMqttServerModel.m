//
//  MKCHMqttServerModel.m
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/2/7.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCHMqttServerModel.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKCHDeviceModeManager.h"

#import "MKCHMQTTInterface.h"

#import "MKCHModifyNetworkDataModel.h"

static NSString *const defaultSubTopic = @"{device_name}/{device_id}/app_to_device";
static NSString *const defaultPubTopic = @"{device_name}/{device_id}/device_to_app";

@interface MKCHMqttServerModel ()

@property (nonatomic, strong)dispatch_queue_t configQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKCHMqttServerModel

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

- (void)updateValue:(MKCHMqttServerModel *)model {
    if (!model || ![model isKindOfClass:MKCHMqttServerModel.class]) {
        return;
    }
    self.host = model.host;
    self.port = model.port;
    self.clientID = model.clientID;
    self.subscribeTopic = model.subscribeTopic;
    self.publishTopic = model.publishTopic;
    self.cleanSession = model.cleanSession;
    
    self.qos = model.qos;
    self.keepAlive = model.keepAlive;
    self.userName = model.userName;
    self.password = model.password;
    self.sslIsOn = model.sslIsOn;
    self.certificate = model.certificate;
    self.connectMode = model.connectMode;
    self.caFilePath = model.caFilePath;
    self.clientKeyPath = model.clientKeyPath;
    self.clientCertPath = model.clientCertPath;
}

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.configQueue, ^{
        if ([MKCHModifyNetworkDataModel shared].cloud) {
            //云端下载
            self.host = [MKCHModifyNetworkDataModel shared].params[@"host"];
            self.port = [MKCHModifyNetworkDataModel shared].params[@"port"];
            self.clientID = [MKCHModifyNetworkDataModel shared].params[@"clientID"];
            self.subscribeTopic = [MKCHModifyNetworkDataModel shared].params[@"subscribeTopic"];
            self.publishTopic = [MKCHModifyNetworkDataModel shared].params[@"publishTopic"];
            self.cleanSession = [[MKCHModifyNetworkDataModel shared].params[@"cleanSession"] boolValue];
            
            self.qos = [[MKCHModifyNetworkDataModel shared].params[@"qos"] integerValue];
            self.keepAlive = [MKCHModifyNetworkDataModel shared].params[@"keepAlive"];
            self.userName = [MKCHModifyNetworkDataModel shared].params[@"userName"];
            self.password = [MKCHModifyNetworkDataModel shared].params[@"password"];
            self.sslIsOn = [[MKCHModifyNetworkDataModel shared].params[@"sslIsOn"] boolValue];
            self.certificate = [[MKCHModifyNetworkDataModel shared].params[@"certificate"] integerValue];
            self.caFilePath = [MKCHModifyNetworkDataModel shared].params[@"caPath"];
            self.clientKeyPath = [MKCHModifyNetworkDataModel shared].params[@"clientKeyPath"];
            self.clientCertPath = [MKCHModifyNetworkDataModel shared].params[@"clientCertPath"];
            
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
        NSInteger status = [self readOTAState];
        if (status == -1) {
            [self operationFailedBlockWithMsg:@"Read OTA Status Error" block:failedBlock];
            return;
        }
        if (status == 1) {
            [self operationFailedBlockWithMsg:@"Device is busy now!" block:failedBlock];
            return;
        }
        
        if (![self configMqttInfos]) {
            [self operationFailedBlockWithMsg:@"Config Mqtt Infos Error" block:failedBlock];
            return;
        }
        if (self.connectMode > 1 && !(!ValidStr(self.caFilePath) && !ValidStr(self.clientKeyPath) && !ValidStr(self.clientCertPath))) {
            if (![self configMqttCerts]) {
                [self operationFailedBlockWithMsg:@"Config Mqtt Certs Error" block:failedBlock];
                return;
            }
        }
        
        [self updateCloudParams];
        
        moko_dispatch_main_safe(^{
            sucBlock();
        });
    });
}

#pragma mark - interface
- (NSInteger)readOTAState {
    __block NSInteger status = -1;
    [MKCHMQTTInterface ch_readOtaStatusWithMacAddress:[MKCHDeviceModeManager shared].macAddress topic:[MKCHDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        status = [returnData[@"data"][@"status"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return status;
}

- (BOOL)readMqttInfos {
    __block BOOL success = NO;
    [MKCHMQTTInterface ch_readMQTTParamsWithMacAddress:[MKCHDeviceModeManager shared].macAddress topic:[MKCHDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.host = returnData[@"data"][@"host"];
        self.port = [NSString stringWithFormat:@"%@",returnData[@"data"][@"port"]];
        self.clientID = returnData[@"data"][@"client_id"];
        self.subscribeTopic = returnData[@"data"][@"sub_topic"];
        self.publishTopic = returnData[@"data"][@"pub_topic"];
        self.cleanSession = ([returnData[@"data"][@"clean_session"] integerValue] == 1);
        self.qos = [returnData[@"data"][@"qos"] integerValue];
        self.keepAlive = [NSString stringWithFormat:@"%@",returnData[@"data"][@"keepalive"]];
        self.userName = returnData[@"data"][@"username"];
        self.password = returnData[@"data"][@"passwd"];
        self.connectMode = [returnData[@"data"][@"security_type"] integerValue];
        self.sslIsOn = YES;
        if (self.connectMode == 0) {
            //TCP
            self.sslIsOn = NO;
        }else if (self.connectMode == 1) {
            self.certificate = 0;
        }else if (self.connectMode == 2) {
            self.certificate = 1;
        }else if (self.connectMode == 3) {
            self.certificate = 2;
        }
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configMqttInfos {
    __block BOOL success = NO;
    if ([self.publishTopic isEqualToString:defaultPubTopic]) {
        //用户使用默认的topic
        self.publishTopic = [NSString stringWithFormat:@"%@/%@/%@",[MKCHDeviceModeManager shared].deviceName,self.clientID,@"device_to_app"];
    }
    if ([self.subscribeTopic isEqualToString:defaultSubTopic]) {
        //用户使用默认的topic
        self.subscribeTopic = [NSString stringWithFormat:@"%@/%@/%@",[MKCHDeviceModeManager shared].deviceName,self.clientID,@"app_to_device"];
    }
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
    
    [MKCHMQTTInterface ch_modifyMqttInfos:self macAddress:[MKCHDeviceModeManager shared].macAddress topic:[MKCHDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configMqttCerts {
    __block BOOL success = NO;
    [MKCHMQTTInterface ch_modifyMqttCerts:self macAddress:[MKCHDeviceModeManager shared].macAddress topic:[MKCHDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (void)updateCloudParams {
    if (![MKCHModifyNetworkDataModel shared].cloud) {
        return;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[MKCHModifyNetworkDataModel shared].params];
    [dic setObject:SafeStr(self.host) forKey:@"host"];
    [dic setObject:SafeStr(self.port) forKey:@"port"];
    [dic setObject:SafeStr(self.clientID) forKey:@"clientID"];
    [dic setObject:SafeStr(self.subscribeTopic) forKey:@"subscribeTopic"];
    [dic setObject:SafeStr(self.publishTopic) forKey:@"publishTopic"];
    [dic setObject:@(self.cleanSession) forKey:@"cleanSession"];
    [dic setObject:@(self.qos) forKey:@"qos"];
    [dic setObject:self.keepAlive forKey:@"keepAlive"];
    [dic setObject:SafeStr(self.userName) forKey:@"userName"];
    [dic setObject:SafeStr(self.password) forKey:@"password"];
    [dic setObject:@(self.sslIsOn) forKey:@"sslIsOn"];
    [dic setObject:@(self.certificate) forKey:@"certificate"];
    [dic setObject:SafeStr(self.caFilePath) forKey:@"caPath"];
    [dic setObject:SafeStr(self.clientKeyPath) forKey:@"clientKeyPath"];
    [dic setObject:SafeStr(self.clientCertPath) forKey:@"clientCertPath"];
    
    [MKCHModifyNetworkDataModel shared].params = dic;
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
