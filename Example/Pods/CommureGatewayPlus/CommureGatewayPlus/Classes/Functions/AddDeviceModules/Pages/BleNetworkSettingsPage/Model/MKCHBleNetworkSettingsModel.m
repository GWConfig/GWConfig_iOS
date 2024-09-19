//
//  MKCHBleNetworkSettingsModel.m
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/1/30.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCHBleNetworkSettingsModel.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKCHInterface.h"
#import "MKCHInterface+MKCHConfig.h"

#import "MKCHDeviceMQTTParamsModel.h"

@interface MKCHBleNetworkSettingsModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKCHBleNetworkSettingsModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if ([MKCHDeviceMQTTParamsModel shared].cloud) {
            //从云端导入，不需要再读取了
            self.dhcp = [[MKCHDeviceMQTTParamsModel shared].params[@"dhcp"] boolValue];
            self.ip = [MKCHDeviceMQTTParamsModel shared].params[@"ip"];
            self.mask = [MKCHDeviceMQTTParamsModel shared].params[@"mask"];
            self.gateway = [MKCHDeviceMQTTParamsModel shared].params[@"gateway"];
            self.dns = [MKCHDeviceMQTTParamsModel shared].params[@"dns"];
            
            moko_dispatch_main_safe(^{
                if (sucBlock) {
                    sucBlock();
                }
            });
            return;
        }
        
        if (![self readDHCPStatus]) {
            [self operationFailedBlockWithMsg:@"Read DHCP Error" block:failedBlock];
            return;
        }
        if (![self readIpAddress]) {
            [self operationFailedBlockWithMsg:@"Read Ip Error" block:failedBlock];
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
        
        [self updateValues];
        
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

#pragma mark - interface
- (BOOL)readDHCPStatus {
    __block BOOL success = NO;
    [MKCHInterface ch_readWIFIDHCPStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.dhcp = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
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

- (BOOL)readIpAddress {
    __block BOOL success = NO;
    [MKCHInterface ch_readWIFINetworkIpInfosWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.ip = returnData[@"result"][@"ip"];
        self.mask = returnData[@"result"][@"mask"];
        self.gateway = returnData[@"result"][@"gateway"];
        self.dns = returnData[@"result"][@"dns"];
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

#pragma mark - private method
- (void)updateValues {
    if (![MKCHDeviceMQTTParamsModel shared].cloud) {
        return;
    }
    //从云端导入
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[MKCHDeviceMQTTParamsModel shared].params];
    
    [dic setObject:@(self.dhcp) forKey:@"dhcp"];
    [dic setObject:SafeStr(self.ip) forKey:@"ip"];
    [dic setObject:SafeStr(self.mask) forKey:@"mask"];
    [dic setObject:SafeStr(self.gateway) forKey:@"gateway"];
    [dic setObject:SafeStr(self.dns) forKey:@"dns"];
    
    [MKCHDeviceMQTTParamsModel shared].params = dic;
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

- (void)operationFailedBlockWithMsg:(NSString *)msg block:(void (^)(NSError *error))block {
    moko_dispatch_main_safe(^{
        NSError *error = [[NSError alloc] initWithDomain:@"NTPSettings"
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
        _readQueue = dispatch_queue_create("NTPSettingsQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
