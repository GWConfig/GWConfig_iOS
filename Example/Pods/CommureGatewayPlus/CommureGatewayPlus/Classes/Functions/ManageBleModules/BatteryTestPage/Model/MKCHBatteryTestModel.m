//
//  MKCHBatteryTestModel.m
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/4/23.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCHBatteryTestModel.h"

#import "MKMacroDefines.h"

#import "MKCHDeviceModeManager.h"

#import "MKCHMQTTInterface.h"

#import "MKMacroDefines.h"

#import "MKCHDeviceModeManager.h"

@interface MKCHBatteryTestModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKCHBatteryTestModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readHardwareParams]) {
            [self operationFailedBlockWithMsg:@"Read Hardware Params Error" block:failedBlock];
            return;
        }
        if (![self readBatteryParams]) {
            [self operationFailedBlockWithMsg:@"Read Battery Params Error" block:failedBlock];
            return;
        }
        if (![self readBatteryTestLedParams0]) {
            [self operationFailedBlockWithMsg:@"Read Battery LED0 Error" block:failedBlock];
            return;
        }
        if (![self readBatteryTestLedParams1]) {
            [self operationFailedBlockWithMsg:@"Read Battery LED1 Error" block:failedBlock];
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
        if (![self configHardwareParams]) {
            [self operationFailedBlockWithMsg:@"Config Hardware Params Error" block:failedBlock];
            return;
        }
        if (![self configBatteryParams]) {
            [self operationFailedBlockWithMsg:@"Config Battery Params Error" block:failedBlock];
            return;
        }
        if (!self.batteryLedSwitch) {
            moko_dispatch_main_safe(^{
                sucBlock();
            });
            return;
        }
        if (![self configBatteryTestLedParams0]) {
            [self operationFailedBlockWithMsg:@"Config Battery LED0 Error" block:failedBlock];
            return;
        }
        if (![self configBatteryTestLedParams1]) {
            [self operationFailedBlockWithMsg:@"Config Battery LED1 Error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            sucBlock();
        });
    });
}

#pragma mark - interface
- (BOOL)readHardwareParams {
    __block BOOL success = NO;
    [MKCHMQTTInterface ch_readHardwareSelfTestWithBleMacAddress:self.bleMac macAddress:[MKCHDeviceModeManager shared].macAddress topic:[MKCHDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        if ([returnData[@"data"][@"result_code"] integerValue] == 0) {
            //成功
            success = YES;
            self.ledDuration = [NSString stringWithFormat:@"%@",returnData[@"data"][@"led_flash_time"]];
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

- (BOOL)configHardwareParams {
    __block BOOL success = NO;
    [MKCHMQTTInterface ch_configHardwareSelfTestLedBlinkingDuration:[self.ledDuration integerValue] buzzerBeepingInterval:[self.beepingInterval integerValue] buzzerBeepingDuration:[self.beepingDuration integerValue] bleMacAddress:self.bleMac macAddress:[MKCHDeviceModeManager shared].macAddress topic:[MKCHDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = [returnData[@"data"][@"result_code"] integerValue] == 0;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readBatteryParams {
    __block BOOL success = NO;
    [MKCHMQTTInterface ch_readBatterySelfTestWithBleMacAddress:self.bleMac macAddress:[MKCHDeviceModeManager shared].macAddress topic:[MKCHDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        if ([returnData[@"data"][@"result_code"] integerValue] == 0) {
            //成功
            success = YES;
            self.batteryLedSwitch = ([returnData[@"data"][@"led_warn_switch"] integerValue] == 1);
            self.voltageThreshold = [NSString stringWithFormat:@"%@",returnData[@"data"][@"batt_warn_threshold"]];
        }
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configBatteryParams {
    __block BOOL success = NO;
    [MKCHMQTTInterface ch_configBatterySelfTestWithLedState:self.batteryLedSwitch voltageThreshold:[self.voltageThreshold integerValue] bleMacAddress:self.bleMac macAddress:[MKCHDeviceModeManager shared].macAddress topic:[MKCHDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = [returnData[@"data"][@"result_code"] integerValue] == 0;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readBatteryTestLedParams0 {
    __block BOOL success = NO;
    [MKCHMQTTInterface ch_readBatterySelfTestLedParamsWithMode:0 bleMacAddress:self.bleMac macAddress:[MKCHDeviceModeManager shared].macAddress topic:[MKCHDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        if ([returnData[@"data"][@"result_code"] integerValue] == 0) {
            //成功
            success = YES;
            self.underInterval = [NSString stringWithFormat:@"%ld",[returnData[@"data"][@"led_off_time"] integerValue] / 100];
            self.underDuration = [NSString stringWithFormat:@"%@",returnData[@"data"][@"led_flash_time"]];
            NSString *ledColor = SafeStr(returnData[@"data"][@"led_color"]);
            if ([ledColor isEqualToString:@"blue"]) {
                self.underColor = 1;
            }else if ([ledColor isEqualToString:@"green"]) {
                self.underColor = 2;
            }
        }
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configBatteryTestLedParams0 {
    __block BOOL success = NO;
    [MKCHMQTTInterface ch_configBatterySelfTestLedParams:0 ledColor:self.underColor interval:[self.underInterval integerValue] duration:[self.underDuration integerValue] bleMacAddress:self.bleMac macAddress:[MKCHDeviceModeManager shared].macAddress topic:[MKCHDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = [returnData[@"data"][@"result_code"] integerValue] == 0;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readBatteryTestLedParams1 {
    __block BOOL success = NO;
    [MKCHMQTTInterface ch_readBatterySelfTestLedParamsWithMode:1 bleMacAddress:self.bleMac macAddress:[MKCHDeviceModeManager shared].macAddress topic:[MKCHDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        if ([returnData[@"data"][@"result_code"] integerValue] == 0) {
            //成功
            success = YES;
            self.overInterval = [NSString stringWithFormat:@"%ld",[returnData[@"data"][@"led_off_time"] integerValue] / 100];
            self.overDuration = [NSString stringWithFormat:@"%@",returnData[@"data"][@"led_flash_time"]];
            NSString *ledColor = SafeStr(returnData[@"data"][@"led_color"]);
            if ([ledColor isEqualToString:@"blue"]) {
                self.overColor = 1;
            }else if ([ledColor isEqualToString:@"green"]) {
                self.overColor = 2;
            }
        }
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configBatteryTestLedParams1 {
    __block BOOL success = NO;
    [MKCHMQTTInterface ch_configBatterySelfTestLedParams:1 ledColor:self.overColor interval:[self.overInterval integerValue] duration:[self.overDuration integerValue] bleMacAddress:self.bleMac macAddress:[MKCHDeviceModeManager shared].macAddress topic:[MKCHDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
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
        NSError *error = [[NSError alloc] initWithDomain:@"BatteryTest"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    });
}

- (BOOL)validParams {
    if (!ValidStr(self.ledDuration) || [self.ledDuration integerValue] < 1 || [self.ledDuration integerValue] > 255) {
        return NO;
    }
    if (!ValidStr(self.beepingInterval) || [self.beepingInterval integerValue] < 0 || [self.beepingInterval integerValue] > 100) {
        return NO;
    }
    if (!ValidStr(self.beepingDuration) || [self.beepingDuration integerValue] < 0|| [self.beepingDuration integerValue] > 655) {
        return NO;
    }
    if (!self.batteryLedSwitch) {
        return YES;
    }
    if (!ValidStr(self.overInterval) || [self.overInterval integerValue] < 0 || [self.overInterval integerValue] > 100) {
        return NO;
    }
    if (!ValidStr(self.overDuration) || [self.overDuration integerValue] < 1 || [self.overDuration integerValue] > 255) {
        return NO;
    }
    if (!ValidStr(self.underInterval) || [self.underInterval integerValue] < 0 || [self.underInterval integerValue] > 100) {
        return NO;
    }
    if (!ValidStr(self.underDuration) || [self.underDuration integerValue] < 1 || [self.underDuration integerValue] > 255) {
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
        _readQueue = dispatch_queue_create("BatteryTestQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end

