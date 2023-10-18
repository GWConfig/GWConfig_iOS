//
//  MKAdvParamsConfigModel.m
//  MKCommureApp_Example
//
//  Created by aa on 2023/4/24.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKAdvParamsConfigModel.h"

#import "MKMacroDefines.h"

#import "MKCMDeviceModeManager.h"

#import "MKCMMQTTInterface.h"

#import "MKMacroDefines.h"

#import "MKCMDeviceModeManager.h"

@interface MKAdvParamsConfigModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKAdvParamsConfigModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readConfigParams]) {
            [self operationFailedBlockWithMsg:@"Read Config Params Error" block:failedBlock];
            return;
        }
        if (![self readNormalParams]) {
            [self operationFailedBlockWithMsg:@"Read Normal Params Error" block:failedBlock];
            return;
        }
        if (![self readTriggerParams]) {
            [self operationFailedBlockWithMsg:@"Read Trigger Params Error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            sucBlock();
        });
    });
}

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self validParams]) {
            [self operationFailedBlockWithMsg:@"Params Error" block:failedBlock];
            return;
        }
        if (![self configConfigParams]) {
            [self operationFailedBlockWithMsg:@"Config Config Params Error" block:failedBlock];
            return;
        }
        if (![self configNormalParams]) {
            [self operationFailedBlockWithMsg:@"Config Normal Params Error" block:failedBlock];
            return;
        }
        if (![self configTriggerParams]) {
            [self operationFailedBlockWithMsg:@"Config Trigger Params Error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            sucBlock();
        });
    });
}

#pragma mark - interface

- (BOOL)readConfigParams {
    __block BOOL success = NO;
    [MKCMMQTTInterface cm_readAdvParamsWithType:0 bleMacAddress:self.bleMac macAddress:[MKCMDeviceModeManager shared].macAddress topic:[MKCMDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        if ([returnData[@"data"][@"result_code"] integerValue] == 0) {
            //成功
            success = YES;
            NSInteger value = [returnData[@"data"][@"adv_interval"] integerValue] / 100;
            self.configInterval = [NSString stringWithFormat:@"%ld",(long)value];
            self.configDuration = [NSString stringWithFormat:@"%@",returnData[@"data"][@"adv_time"]];
            self.configTxPower = [self getTxPowerValue:[returnData[@"data"][@"tx_power"] integerValue]];
        }
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configConfigParams {
    __block BOOL success = NO;
    [MKCMMQTTInterface cm_configAdvParamsWithType:0 bleMacAddress:self.bleMac interval:([self.configInterval integerValue] * 100) duration:[self.configDuration integerValue] txPower:self.configTxPower macAddress:[MKCMDeviceModeManager shared].macAddress topic:[MKCMDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = [returnData[@"data"][@"result_code"] integerValue] == 0;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readNormalParams {
    __block BOOL success = NO;
    [MKCMMQTTInterface cm_readAdvParamsWithType:1 bleMacAddress:self.bleMac macAddress:[MKCMDeviceModeManager shared].macAddress topic:[MKCMDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        if ([returnData[@"data"][@"result_code"] integerValue] == 0) {
            //成功
            success = YES;
            NSInteger value = [returnData[@"data"][@"adv_interval"] integerValue] / 100;
            self.normalInterval = [NSString stringWithFormat:@"%ld",(long)value];
            self.normalDuration = [NSString stringWithFormat:@"%@",returnData[@"data"][@"adv_time"]];
            self.normalTxPower = [self getTxPowerValue:[returnData[@"data"][@"tx_power"] integerValue]];
        }
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configNormalParams {
    __block BOOL success = NO;
    [MKCMMQTTInterface cm_configAdvParamsWithType:1 bleMacAddress:self.bleMac interval:([self.normalInterval integerValue] * 100) duration:[self.normalDuration integerValue] txPower:self.normalTxPower macAddress:[MKCMDeviceModeManager shared].macAddress topic:[MKCMDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = [returnData[@"data"][@"result_code"] integerValue] == 0;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readTriggerParams {
    __block BOOL success = NO;
    [MKCMMQTTInterface cm_readAdvParamsWithType:2 bleMacAddress:self.bleMac macAddress:[MKCMDeviceModeManager shared].macAddress topic:[MKCMDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        if ([returnData[@"data"][@"result_code"] integerValue] == 0) {
            //成功
            success = YES;
            NSInteger value = [returnData[@"data"][@"adv_interval"] integerValue] / 100;
            self.triggerInterval = [NSString stringWithFormat:@"%ld",(long)value];
            self.triggerDuration = [NSString stringWithFormat:@"%@",returnData[@"data"][@"adv_time"]];
            self.triggerTxPower = [self getTxPowerValue:[returnData[@"data"][@"tx_power"] integerValue]];
        }
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configTriggerParams {
    __block BOOL success = NO;
    [MKCMMQTTInterface cm_configAdvParamsWithType:2 bleMacAddress:self.bleMac interval:([self.triggerInterval integerValue] * 100) duration:[self.triggerDuration integerValue] txPower:self.triggerTxPower macAddress:[MKCMDeviceModeManager shared].macAddress topic:[MKCMDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = [returnData[@"data"][@"result_code"] integerValue] == 0;
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
        NSError *error = [[NSError alloc] initWithDomain:@"AdvParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    });
}

- (NSInteger)getTxPowerValue:(NSInteger)txPower {
    if (txPower == -40) {
        return 0;
    }
    if (txPower == -20) {
        return 1;
    }
    if (txPower == -16) {
        return 2;
    }
    if (txPower == -12) {
        return 3;
    }
    if (txPower == -8) {
        return 4;
    }
    if (txPower == -4) {
        return 5;
    }
    if (txPower == 0) {
        return 6;
    }
    if (txPower == 3) {
        return 7;
    }
    if (txPower == 4) {
        return 8;
    }
    return 0;
}

- (BOOL)validParams {
    if (!ValidStr(self.configInterval) || [self.configInterval integerValue] < 1 || [self.configInterval integerValue] > 100) {
        return NO;
    }
    if (!ValidStr(self.configDuration) || [self.configDuration integerValue] < 1 || [self.configDuration integerValue] > 65535) {
        return NO;
    }
    if (!ValidStr(self.normalInterval) || [self.normalInterval integerValue] < 1 || [self.normalInterval integerValue] > 100) {
        return NO;
    }
    if (!ValidStr(self.normalDuration) || [self.normalDuration integerValue] < 1 || [self.normalDuration integerValue] > 65535) {
        return NO;
    }
    if (!ValidStr(self.triggerInterval) || [self.triggerInterval integerValue] < 1 || [self.triggerInterval integerValue] > 100) {
        return NO;
    }
    if (!ValidStr(self.triggerDuration) || [self.triggerDuration integerValue] < 1 || [self.triggerDuration integerValue] > 65535) {
        return NO;
    }
    return YES;
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
        _readQueue = dispatch_queue_create("AdvParamsQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
