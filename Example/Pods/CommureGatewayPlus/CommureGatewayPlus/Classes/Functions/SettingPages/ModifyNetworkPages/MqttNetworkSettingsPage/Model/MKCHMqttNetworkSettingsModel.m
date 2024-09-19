//
//  MKCHMqttNetworkSettingsModel.m
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/2/14.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCHMqttNetworkSettingsModel.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKCHDeviceModeManager.h"

#import "MKCHMQTTInterface.h"

#import "MKCHModifyNetworkDataModel.h"

@interface MKCHMqttNetworkSettingsModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKCHMqttNetworkSettingsModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if ([MKCHModifyNetworkDataModel shared].cloud) {
            //云端下载
            self.dhcp = [[MKCHModifyNetworkDataModel shared].params[@"dhcp"] boolValue];
            self.ip = [MKCHModifyNetworkDataModel shared].params[@"ip"];
            self.mask = [MKCHModifyNetworkDataModel shared].params[@"mask"];
            self.gateway = [MKCHModifyNetworkDataModel shared].params[@"gateway"];
            self.dns = [MKCHModifyNetworkDataModel shared].params[@"dns"];
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
    [MKCHMQTTInterface ch_readWifiNetworkInfosWithMacAddress:[MKCHDeviceModeManager shared].macAddress topic:[MKCHDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
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
    [MKCHMQTTInterface ch_modifyWifiNetworkInfos:self macAddress:[MKCHDeviceModeManager shared].macAddress topic:[MKCHDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
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
    if (![MKCHModifyNetworkDataModel shared].cloud) {
        return;
    }
    //从云端导入
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[MKCHModifyNetworkDataModel shared].params];
    
    [dic setObject:@(self.dhcp) forKey:@"dhcp"];
    [dic setObject:SafeStr(self.ip) forKey:@"ip"];
    [dic setObject:SafeStr(self.mask) forKey:@"mask"];
    [dic setObject:SafeStr(self.gateway) forKey:@"gateway"];
    [dic setObject:SafeStr(self.dns) forKey:@"dns"];
    
    [MKCHModifyNetworkDataModel shared].params = dic;
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
