//
//  MKCMDeviceConnectedModel.m
//  MKCommureApp_Example
//
//  Created by aa on 2023/4/21.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCMDeviceConnectedModel.h"

#import "MKMacroDefines.h"

#import "MKCMDeviceModeManager.h"

#import "MKCMMQTTInterface.h"

#import "MKMacroDefines.h"

#import "MKCMDeviceModeManager.h"

@interface MKCMDeviceConnectedModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKCMDeviceConnectedModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readBattery]) {
            [self operationFailedBlockWithMsg:@"Read Battery Error" block:failedBlock];
            return;
        }
        if (![self readTagID]) {
            [self operationFailedBlockWithMsg:@"Read Tag ID Error" block:failedBlock];
            return;
        }
        if (![self readAlarmStatus]) {
            [self operationFailedBlockWithMsg:@"Read Alarm Status Error" block:failedBlock];
            return;
        }
        if (![self readPasswordVerfy]) {
            [self operationFailedBlockWithMsg:@"Read Password Verification Error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            sucBlock();
        });
    });
}

#pragma mark - interface

- (BOOL)readBattery {
    __block BOOL success = NO;
    [MKCMMQTTInterface cm_readDeviceBatteryVoltageWithBleMacAddress:self.deviceBleMacAddress macAddress:[MKCMDeviceModeManager shared].macAddress topic:[MKCMDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        if ([returnData[@"data"][@"result_code"] integerValue] == 0) {
            //失败
            success = YES;
            self.battery = [NSString stringWithFormat:@"%@",returnData[@"data"][@"battery_v"]];
        }
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readTagID {
    __block BOOL success = NO;
    [MKCMMQTTInterface cm_readTagIDWithBleMacAddress:self.deviceBleMacAddress macAddress:[MKCMDeviceModeManager shared].macAddress topic:[MKCMDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        if ([returnData[@"data"][@"result_code"] integerValue] == 0) {
            //失败
            success = YES;
            self.tagID = returnData[@"data"][@"tag_id"];
        }
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readAlarmStatus {
    __block BOOL success = NO;
    [MKCMMQTTInterface cm_readAlarmStatusWithBleMacAddress:self.deviceBleMacAddress macAddress:[MKCMDeviceModeManager shared].macAddress topic:[MKCMDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        if ([returnData[@"data"][@"result_code"] integerValue] == 0) {
            //失败
            success = YES;
            self.alarmStatus = [returnData[@"data"][@"alarm_status"] integerValue];
        }
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readPasswordVerfy {
    __block BOOL success = NO;
    [MKCMMQTTInterface cm_readPasswordVerificationStatusWithBleMacAddress:self.deviceBleMacAddress macAddress:[MKCMDeviceModeManager shared].macAddress topic:[MKCMDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        if ([returnData[@"data"][@"result_code"] integerValue] == 0) {
            //失败
            success = YES;
            self.passwordVerification = ([returnData[@"data"][@"switch_value"] integerValue] == 1);
        }
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
        NSError *error = [[NSError alloc] initWithDomain:@"ConnectedDevice"
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
        _readQueue = dispatch_queue_create("ConnectedDeviceQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
