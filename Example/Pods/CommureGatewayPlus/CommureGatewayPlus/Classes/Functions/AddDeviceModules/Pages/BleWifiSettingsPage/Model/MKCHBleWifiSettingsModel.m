//
//  MKCHBleWifiSettingsModel.m
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/1/30.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCHBleWifiSettingsModel.h"

#import "MKMacroDefines.h"

#import "MKCHInterface.h"
#import "MKCHInterface+MKCHConfig.h"

#import "MKCHDeviceMQTTParamsModel.h"

@interface MKCHBleWifiSettingsModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKCHBleWifiSettingsModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        
        if ([MKCHDeviceMQTTParamsModel shared].cloud) {
            //从云端导入，不需要再读取了
            self.security = [[MKCHDeviceMQTTParamsModel shared].params[@"security"] integerValue];
            self.ssid = [MKCHDeviceMQTTParamsModel shared].params[@"wifiSSID"];
            self.wifiPassword = [MKCHDeviceMQTTParamsModel shared].params[@"wifiPassword"];
            self.eapType = [[MKCHDeviceMQTTParamsModel shared].params[@"eap"] integerValue];
            self.eapUserName = [MKCHDeviceMQTTParamsModel shared].params[@"eapUsername"];
            self.eapPassword = [MKCHDeviceMQTTParamsModel shared].params[@"eapPassword"];
            self.domainID = [MKCHDeviceMQTTParamsModel shared].params[@"domainID"];
            self.verifyServer = [[MKCHDeviceMQTTParamsModel shared].params[@"verifyServer"] boolValue];
            //参考MKCHBleMqttConfigSelectModel里面写死的证书名字
            self.caFileName = @"wifi_ca.pem";
            self.clientCertName = @"wifi_client.crt";
            self.clientKeyName = @"wifi_client.key";
            self.country = [[MKCHDeviceMQTTParamsModel shared].params[@"countryBand"] integerValue];
            
            moko_dispatch_main_safe(^{
                if (sucBlock) {
                    sucBlock();
                }
            });
            return;
        }
        
        if (![self readSecurityType]) {
            [self operationFailedBlockWithMsg:@"Read Security Type Error" block:failedBlock];
            return;
        }
        if (![self readWifiSSID]) {
            [self operationFailedBlockWithMsg:@"Read WIFI SSID Error" block:failedBlock];
            return;
        }
        if (![self readWifiPassword]) {
            [self operationFailedBlockWithMsg:@"Read WIFI Password Error" block:failedBlock];
            return;
        }
        if (![self readEAPType]) {
            [self operationFailedBlockWithMsg:@"Read EAP Type Error" block:failedBlock];
            return;
        }
        if (![self readEAPUsername]) {
            [self operationFailedBlockWithMsg:@"Read EAP Username Error" block:failedBlock];
            return;
        }
        if (![self readEAPPassword]) {
            [self operationFailedBlockWithMsg:@"Read EAP Password Error" block:failedBlock];
            return;
        }
        if (![self readEAPDomainID]) {
            [self operationFailedBlockWithMsg:@"Read EAP Domain ID Error" block:failedBlock];
            return;
        }
        if (![self readVerifyServer]) {
            [self operationFailedBlockWithMsg:@"Read EAP Verify Server Error" block:failedBlock];
            return;
        }
        if (![self readCountryBand]) {
            [self operationFailedBlockWithMsg:@"Read Country Band Error" block:failedBlock];
            return;
        }
        
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        NSString *msg = [self checkMsg];
        if (ValidStr(msg)) {
            [self operationFailedBlockWithMsg:msg block:failedBlock];
            return;
        }
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
                    if (![self configCAFile]) {
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
                if (![self configCAFile]) {
                    [self operationFailedBlockWithMsg:@"Config CA File Error" block:failedBlock];
                    return;
                }
                if (ValidStr(self.clientKeyName)) {
                    if (![self configClientKey]) {
                        [self operationFailedBlockWithMsg:@"Config Client Key Error" block:failedBlock];
                        return;
                    }
                }
                if (ValidStr(self.clientCertName)) {
                    if (![self configClientCert]) {
                        [self operationFailedBlockWithMsg:@"Config Client Cert Error" block:failedBlock];
                        return;
                    }
                }
            }
        }
        
        if (![self configCountryBand]) {
            [self operationFailedBlockWithMsg:@"Config Country Band Error" block:failedBlock];
            return;
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
- (BOOL)readSecurityType {
    __block BOOL success = NO;
    [MKCHInterface ch_readWIFISecurityWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.security = [returnData[@"result"][@"security"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

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

- (BOOL)readWifiSSID {
    __block BOOL success = NO;
    [MKCHInterface ch_readWIFISSIDWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.ssid = returnData[@"result"][@"ssid"];
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

- (BOOL)readWifiPassword {
    __block BOOL success = NO;
    [MKCHInterface ch_readWIFIPasswordWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.wifiPassword = returnData[@"result"][@"password"];
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

- (BOOL)readEAPType {
    __block BOOL success = NO;
    [MKCHInterface ch_readWIFIEAPTypeWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.eapType = [returnData[@"result"][@"eapType"] integerValue];
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

- (BOOL)readEAPUsername {
    __block BOOL success = NO;
    [MKCHInterface ch_readWIFIEAPUsernameWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.eapUserName = returnData[@"result"][@"username"];
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

- (BOOL)readEAPPassword {
    __block BOOL success = NO;
    [MKCHInterface ch_readWIFIEAPPasswordWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.eapPassword = returnData[@"result"][@"password"];
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

- (BOOL)readEAPDomainID {
    __block BOOL success = NO;
    [MKCHInterface ch_readWIFIEAPDomainIDWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.domainID = returnData[@"result"][@"domainID"];
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

- (BOOL)readVerifyServer {
    __block BOOL success = NO;
    [MKCHInterface ch_readWIFIVerifyServerStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.verifyServer = [returnData[@"result"][@"verify"] boolValue];
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

- (BOOL)configCAFile {
    __block BOOL success = NO;
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [document stringByAppendingPathComponent:self.caFileName];
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

- (BOOL)configClientKey {
    __block BOOL success = NO;
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [document stringByAppendingPathComponent:self.clientKeyName];
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

- (BOOL)configClientCert {
    __block BOOL success = NO;
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [document stringByAppendingPathComponent:self.clientCertName];
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

- (BOOL)readCountryBand {
    __block BOOL success = NO;
    [MKCHInterface ch_readCountryBandWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.country = [returnData[@"result"][@"parameter"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configCountryBand {
    __block BOOL success = NO;
    [MKCHInterface ch_configCountryBand:self.country sucBlock:^{
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
    if (![MKCHDeviceMQTTParamsModel shared].cloud) {
        return;
    }
    //从云端导入
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[MKCHDeviceMQTTParamsModel shared].params];
    
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)self.security] forKey:@"security"];
    [dic setObject:SafeStr(self.ssid) forKey:@"wifiSSID"];
    [dic setObject:SafeStr(self.wifiPassword) forKey:@"wifiPassword"];
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)self.eapType] forKey:@"eap"];
    [dic setObject:SafeStr(self.eapUserName) forKey:@"eapUsername"];
    [dic setObject:SafeStr(self.eapPassword) forKey:@"eapPassword"];
    [dic setObject:SafeStr(self.domainID) forKey:@"domainID"];
    [dic setObject:@(self.verifyServer) forKey:@"verifyServer"];
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)self.country] forKey:@"countryBand"];
    
    [MKCHDeviceMQTTParamsModel shared].params = dic;
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
        if (!ValidStr(self.clientKeyName) || !ValidStr(self.clientCertName)) {
            return @"Client File cannot be empty.";
        }
    }
    return @"";
}

- (void)operationFailedBlockWithMsg:(NSString *)msg block:(void (^)(NSError *error))block {
    moko_dispatch_main_safe(^{
        NSError *error = [[NSError alloc] initWithDomain:@"WIfiSettings"
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
        _readQueue = dispatch_queue_create("WifiSettingsQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
