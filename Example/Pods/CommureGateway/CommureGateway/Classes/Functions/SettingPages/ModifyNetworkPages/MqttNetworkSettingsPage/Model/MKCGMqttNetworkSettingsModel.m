//
//  MKCGMqttNetworkSettingsModel.m
//  CommureGateway_Example
//
//  Created by aa on 2023/2/14.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCGMqttNetworkSettingsModel.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKCGDeviceModeManager.h"

#import "MKCGMQTTInterface.h"

#import "MKCGModifyNetworkDataModel.h"

@interface MKCGMqttNetworkSettingsModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKCGMqttNetworkSettingsModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if ([MKCGModifyNetworkDataModel shared].cloud) {
            //云端下载
            self.dhcp = [[MKCGModifyNetworkDataModel shared].params[@"dhcp"] boolValue];
            self.ip = [MKCGModifyNetworkDataModel shared].params[@"ip"];
            self.mask = [MKCGModifyNetworkDataModel shared].params[@"mask"];
            self.gateway = [MKCGModifyNetworkDataModel shared].params[@"gateway"];
            self.dns = [MKCGModifyNetworkDataModel shared].params[@"dns"];
            moko_dispatch_main_safe(^{
                sucBlock();
            });
            return;
        }
        
        if (![self readNetworkInfos]) {
            [self operationFailedBlockWithMsg:@"Read Network Infos Error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            sucBlock();
        });
    });
}

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self configNetworkInfos]) {
            [self operationFailedBlockWithMsg:@"Config Network Infos Error" block:failedBlock];
            return;
        }
        [self updateValues];
        moko_dispatch_main_safe(^{
            sucBlock();
        });
    });
}

#pragma mark - interface
- (BOOL)readNetworkInfos {
    __block BOOL success = NO;
    [MKCGMQTTInterface cg_readWifiNetworkInfosWithMacAddress:[MKCGDeviceModeManager shared].macAddress topic:[MKCGDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.dhcp = ([returnData[@"data"][@"dhcp_en"] integerValue] == 1);
        self.ip = returnData[@"data"][@"ip"];
        self.mask = returnData[@"data"][@"netmask"];
        self.gateway = returnData[@"data"][@"gw"];
        self.dns = returnData[@"data"][@"dns"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configNetworkInfos {
    __block BOOL success = NO;
    [MKCGMQTTInterface cg_modifyWifiNetworkInfos:self macAddress:[MKCGDeviceModeManager shared].macAddress topic:[MKCGDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
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
    if (![MKCGModifyNetworkDataModel shared].cloud) {
        return;
    }
    //从云端导入
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[MKCGModifyNetworkDataModel shared].params];
    
    [dic setObject:@(self.dhcp) forKey:@"dhcp"];
    [dic setObject:SafeStr(self.ip) forKey:@"ip"];
    [dic setObject:SafeStr(self.mask) forKey:@"mask"];
    [dic setObject:SafeStr(self.gateway) forKey:@"gateway"];
    [dic setObject:SafeStr(self.dns) forKey:@"dns"];
    
    [MKCGModifyNetworkDataModel shared].params = dic;
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
        NSError *error = [[NSError alloc] initWithDomain:@"MqttNetwork"
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
        _readQueue = dispatch_queue_create("MqttNetworkQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
