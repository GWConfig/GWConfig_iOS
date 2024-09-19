//
//  MKCHMqttWifiSettingsModel.m
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/2/14.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCHMqttWifiSettingsModel.h"

#import "MKMacroDefines.h"

#import "MKCHDeviceModeManager.h"

#import "MKCHMQTTInterface.h"

#import "MKCHModifyNetworkDataModel.h"

@interface MKCHMqttWifiSettingsModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKCHMqttWifiSettingsModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if ([MKCHModifyNetworkDataModel shared].cloud) {
            //云端读取
            self.security = [[MKCHModifyNetworkDataModel shared].params[@"security"] integerValue];
            self.ssid = [MKCHModifyNetworkDataModel shared].params[@"wifiSSID"];
            self.wifiPassword = [MKCHModifyNetworkDataModel shared].params[@"wifiPassword"];
            self.eapType = [[MKCHModifyNetworkDataModel shared].params[@"eap"] integerValue];
            self.eapUserName = [MKCHModifyNetworkDataModel shared].params[@"eapUsername"];
            self.eapPassword = [MKCHModifyNetworkDataModel shared].params[@"eapPassword"];
            self.domainID = [MKCHModifyNetworkDataModel shared].params[@"domainID"];
            self.verifyServer = [[MKCHModifyNetworkDataModel shared].params[@"verifyServer"] boolValue];
            self.caFilePath = [MKCHModifyNetworkDataModel shared].params[@"wifiCaPath"];
            self.clientKeyPath = [MKCHModifyNetworkDataModel shared].params[@"wifiClientKeyPath"];
            self.clientCertPath = [MKCHModifyNetworkDataModel shared].params[@"wifiClientCertPath"];
            self.country = [[MKCHModifyNetworkDataModel shared].params[@"countryBand"] integerValue];
            moko_dispatch_main_safe(^{
                sucBlock();
            });
            return;
        }
        
        if (![self readWifiInfos]) {
            [self operationFailedBlockWithMsg:@"Read Wifi Infos Error" block:failedBlock];
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

- (BOOL)readWifiInfos {
    __block BOOL success = NO;
    [MKCHMQTTInterface ch_readWifiInfosWithMacAddress:[MKCHDeviceModeManager shared].macAddress topic:[MKCHDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.security = [returnData[@"data"][@"security_type"] integerValue];
        self.ssid = returnData[@"data"][@"ssid"];
        self.wifiPassword = returnData[@"data"][@"passwd"];
        self.eapType = [returnData[@"data"][@"eap_type"] integerValue];
        self.domainID = returnData[@"data"][@"eap_id"];
        self.eapUserName = returnData[@"data"][@"eap_username"];
        self.eapPassword = returnData[@"data"][@"eap_passwd"];
        self.verifyServer = ([returnData[@"data"][@"eap_verify_server"] integerValue] == 1);
        self.country = [returnData[@"data"][@"country"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configWifiInfos {
    __block BOOL success = NO;
    [MKCHMQTTInterface ch_modifyWifiInfos:self macAddress:[MKCHDeviceModeManager shared].macAddress topic:[MKCHDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
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
    [MKCHMQTTInterface ch_modifyWifiCerts:self macAddress:[MKCHDeviceModeManager shared].macAddress topic:[MKCHDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
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
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)self.country] forKey:@"countryBand"];
    
    [MKCHModifyNetworkDataModel shared].params = dic;
}

#pragma mark - private method
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
