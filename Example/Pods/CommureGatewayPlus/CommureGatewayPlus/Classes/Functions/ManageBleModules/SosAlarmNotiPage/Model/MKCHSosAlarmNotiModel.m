//
//  MKCHSosAlarmNotiModel.m
//  CommureGatewayPlus_Example
//
//  Created by aa on 2024/5/9.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import "MKCHSosAlarmNotiModel.h"

#import "MKMacroDefines.h"

#import "MKCHDeviceModeManager.h"

#import "MKCHMQTTInterface.h"

#import "MKMacroDefines.h"

#import "MKCHDeviceModeManager.h"

@interface MKCHSosAlarmNotiModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKCHSosAlarmNotiModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (self.dismiss) {
            if (![self readDismissSosParams]) {
                [self operationFailedBlockWithMsg:@"Read Params Error" block:failedBlock];
                return;
            }
        }else {
            if (![self readSosParams]) {
                [self operationFailedBlockWithMsg:@"Read Params Error" block:failedBlock];
                return;
            }
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
        if (self.dismiss) {
            if (![self configDismissSosParams]) {
                [self operationFailedBlockWithMsg:@"Config Params Error" block:failedBlock];
                return;
            }
        }else {
            if (![self configSosParams]) {
                [self operationFailedBlockWithMsg:@"Config Params Error" block:failedBlock];
                return;
            }
        }
        
        moko_dispatch_main_safe(^{
            sucBlock();
        });
    });
}

#pragma mark - interface
- (BOOL)readSosParams {
    __block BOOL success = NO;
    [MKCHMQTTInterface ch_readSosAlarmNotiWithBleMacAddress:self.bleMac macAddress:[MKCHDeviceModeManager shared].macAddress topic:[MKCHDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        if ([returnData[@"data"][@"result_code"] integerValue] == 0) {
            //成功
            success = YES;
            NSString *ledColor = SafeStr(returnData[@"data"][@"led_color"]);
            if ([ledColor isEqualToString:@"blue"]) {
                self.color = 1;
            }else if ([ledColor isEqualToString:@"green"]) {
                self.color = 2;
            }
            self.ledInterval = [NSString stringWithFormat:@"%ld",[returnData[@"data"][@"led_off_time"] integerValue] / 100];
            self.ledDuration = [NSString stringWithFormat:@"%@",returnData[@"data"][@"led_work_time"]];
            self.beepingInterval = [NSString stringWithFormat:@"%ld",[returnData[@"data"][@"buzzer_off_time"] integerValue] / 100];
            self.beepingDuration = [NSString stringWithFormat:@"%ld",[returnData[@"data"][@"buzzer_work_time"] integerValue] / 100];
        }
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configSosParams {
    __block BOOL success = NO;
    [MKCHMQTTInterface ch_configSosAlarmNotiWithColor:self.color ledBlinkingInterval:[self.ledInterval integerValue] ledBlinkingDuration:[self.ledDuration integerValue] buzzerBeepingInterval:[self.beepingInterval integerValue] buzzerBeepingDuration:[self.beepingDuration integerValue] bleMacAddress:self.bleMac macAddress:[MKCHDeviceModeManager shared].macAddress topic:[MKCHDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = [returnData[@"data"][@"result_code"] integerValue] == 0;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readDismissSosParams {
    __block BOOL success = NO;
    [MKCHMQTTInterface ch_readDismissSosAlarmNotiWithBleMacAddress:self.bleMac macAddress:[MKCHDeviceModeManager shared].macAddress topic:[MKCHDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        if ([returnData[@"data"][@"result_code"] integerValue] == 0) {
            //成功
            success = YES;
            NSString *ledColor = SafeStr(returnData[@"data"][@"led_color"]);
            if ([ledColor isEqualToString:@"blue"]) {
                self.color = 1;
            }else if ([ledColor isEqualToString:@"green"]) {
                self.color = 2;
            }
            self.ledInterval = [NSString stringWithFormat:@"%ld",[returnData[@"data"][@"led_off_time"] integerValue] / 100];
            self.ledDuration = [NSString stringWithFormat:@"%ld",[returnData[@"data"][@"led_work_time"] integerValue] / 100];
            self.beepingInterval = [NSString stringWithFormat:@"%ld",[returnData[@"data"][@"buzzer_off_time"] integerValue] / 100];
            self.beepingDuration = [NSString stringWithFormat:@"%ld",[returnData[@"data"][@"buzzer_work_time"] integerValue] / 100];
        }
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configDismissSosParams {
    __block BOOL success = NO;
    [MKCHMQTTInterface ch_configDismissSosAlarmNotiWithColor:self.color ledBlinkingInterval:[self.ledInterval integerValue] ledBlinkingDuration:[self.ledDuration integerValue] buzzerBeepingInterval:[self.beepingInterval integerValue] buzzerBeepingDuration:[self.beepingDuration integerValue] bleMacAddress:self.bleMac macAddress:[MKCHDeviceModeManager shared].macAddress topic:[MKCHDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
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
        NSError *error = [[NSError alloc] initWithDomain:@"SosAlarmNoti"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    });
}

- (BOOL)validParams {
    if (!ValidStr(self.ledInterval) || [self.ledInterval integerValue] < 0 || [self.ledInterval integerValue] > 100) {
        return NO;
    }
    if (self.dismiss) {
        if (!ValidStr(self.ledDuration) || [self.ledDuration integerValue] < 0 || [self.ledDuration integerValue] > 655) {
            return NO;
        }
    }else {
        if (!ValidStr(self.ledDuration) || [self.ledDuration integerValue] < 1 || [self.ledDuration integerValue] > 255) {
            return NO;
        }
    }
    
    if (!ValidStr(self.beepingInterval) || [self.beepingInterval integerValue] < 0 || [self.beepingInterval integerValue] > 100) {
        return NO;
    }
    if (!ValidStr(self.beepingDuration) || [self.beepingDuration integerValue] < 0|| [self.beepingDuration integerValue] > 655) {
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
        _readQueue = dispatch_queue_create("SosAlarmNotiQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
