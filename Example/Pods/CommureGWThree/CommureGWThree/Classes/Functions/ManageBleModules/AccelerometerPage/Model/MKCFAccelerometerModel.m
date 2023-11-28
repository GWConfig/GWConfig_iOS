//
//  MKCFAccelerometerModel.m
//  CommureGWThree_Example
//
//  Created by aa on 2023/4/23.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCFAccelerometerModel.h"

#import "MKMacroDefines.h"

#import "MKCFDeviceModeManager.h"

#import "MKCFMQTTInterface.h"

#import "MKMacroDefines.h"

#import "MKCFDeviceModeManager.h"

@interface MKCFAccelerometerModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKCFAccelerometerModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readAccelerometerParams]) {
            [self operationFailedBlockWithMsg:@"Read Accelerometer Params Error" block:failedBlock];
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
        if (![self configAccelerometerParams]) {
            [self operationFailedBlockWithMsg:@"Config Battery Params Error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            sucBlock();
        });
    });
}

#pragma mark - interface

- (BOOL)readAccelerometerParams {
    __block BOOL success = NO;
    [MKCFMQTTInterface cf_readAccelerometerParamsWithBleMacAddress:self.bleMac macAddress:[MKCFDeviceModeManager shared].macAddress topic:[MKCFDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        if ([returnData[@"data"][@"result_code"] integerValue] == 0) {
            //成功
            success = YES;
            self.sampleRate = [returnData[@"data"][@"sampling_rate"] integerValue];
            self.fullScale = [returnData[@"data"][@"full_scale"] integerValue];
            self.sensitivity = [NSString stringWithFormat:@"%@",returnData[@"data"][@"sensitivity"]];
        }
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configAccelerometerParams {
    __block BOOL success = NO;
    [MKCFMQTTInterface cf_configAccelerometerParamsWithBleMacAddress:self.bleMac sampleRate:self.sampleRate fullScale:self.fullScale sensitivity:[self.sensitivity integerValue] macAddress:[MKCFDeviceModeManager shared].macAddress topic:[MKCFDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
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
        NSError *error = [[NSError alloc] initWithDomain:@"Accelerometer"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    });
}

- (BOOL)validParams {
    if (!ValidStr(self.sensitivity) || [self.sensitivity integerValue] < 0 || [self.sensitivity integerValue] > 255) {
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
        _readQueue = dispatch_queue_create("AccelerometerQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end

