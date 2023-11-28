//
//  MKCFBleNTPTimezoneModel.m
//  CommureGWThree_Example
//
//  Created by aa on 2023/1/31.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCFBleNTPTimezoneModel.h"

#import "MKMacroDefines.h"

#import "MKCFInterface.h"
#import "MKCFInterface+MKCFConfig.h"

#import "MKCFDeviceMQTTParamsModel.h"

@interface MKCFBleNTPTimezoneModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKCFBleNTPTimezoneModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if ([MKCFDeviceMQTTParamsModel shared].cloud) {
            //从云端导入，不需要再读取了
            self.ntpHost = [MKCFDeviceMQTTParamsModel shared].params[@"ntpServer"];
            self.timeZone = [[MKCFDeviceMQTTParamsModel shared].params[@"timezone"] integerValue] + 24;
            
            moko_dispatch_main_safe(^{
                if (sucBlock) {
                    sucBlock();
                }
            });
            return;
        }
        
        if (![self readNTPHost]) {
            [self operationFailedBlockWithMsg:@"Read NTP Host Error" block:failedBlock];
            return;
        }
        if (![self readTimezone]) {
            [self operationFailedBlockWithMsg:@"Read Timezone Error" block:failedBlock];
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
        if (![self configNTPHost]) {
            [self operationFailedBlockWithMsg:@"Config NTP Host Error" block:failedBlock];
            return;
        }
        if (![self configTimezone]) {
            [self operationFailedBlockWithMsg:@"Config Timezone Error" block:failedBlock];
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
- (BOOL)readNTPHost {
    __block BOOL success = NO;
    [MKCFInterface cf_readNTPServerHostWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.ntpHost = returnData[@"result"][@"host"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configNTPHost {
    __block BOOL success = NO;
    [MKCFInterface cf_configNTPServerHost:self.ntpHost sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readTimezone {
    __block BOOL success = NO;
    [MKCFInterface cf_readTimeZoneWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.timeZone = [returnData[@"result"][@"timeZone"] integerValue] + 24;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configTimezone {
    __block BOOL success = NO;
    [MKCFInterface cf_configTimeZone:(self.timeZone - 24) sucBlock:^{
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
    if (![MKCFDeviceMQTTParamsModel shared].cloud) {
        return;
    }
    //从云端导入
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[MKCFDeviceMQTTParamsModel shared].params];
    
    [dic setObject:SafeStr(self.ntpHost) forKey:@"ntpServer"];
    [dic setObject:@((self.timeZone - 24)) forKey:@"verifyServer"];
    
    [MKCFDeviceMQTTParamsModel shared].params = dic;
}

- (NSString *)checkMsg {
    if (self.ntpHost.length > 64) {
        return @"NTP Host Error";
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
