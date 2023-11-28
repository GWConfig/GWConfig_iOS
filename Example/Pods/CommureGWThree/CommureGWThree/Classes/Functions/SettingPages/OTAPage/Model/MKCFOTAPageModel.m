//
//  MKCFOTAPageModel.m
//  CommureGWThree_Example
//
//  Created by aa on 2023/2/13.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCFOTAPageModel.h"

#import "MKMacroDefines.h"

#import "MKCFDeviceModeManager.h"

#import "MKCFMQTTInterface.h"

@interface MKCFOTAPageModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKCFOTAPageModel

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self validParams]) {
            [self operationFailedBlockWithMsg:@"Params error" block:failedBlock];
            return;
        }
        NSInteger status = [self readOTAState];
        if (status == -1) {
            [self operationFailedBlockWithMsg:@"Read OTA Status Error" block:failedBlock];
            return;
        }
        if (status == 1) {
            [self operationFailedBlockWithMsg:@"Device is busy now!" block:failedBlock];
            return;
        }
        if (![self startOTA]) {
            [self operationFailedBlockWithMsg:@"OTA Error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            sucBlock();
        });
    });
}

#pragma mark - interface
- (NSInteger)readOTAState {
    __block NSInteger status = -1;
    [MKCFMQTTInterface cf_readOtaStatusWithMacAddress:[MKCFDeviceModeManager shared].macAddress topic:[MKCFDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        status = [returnData[@"data"][@"status"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return status;
}

- (BOOL)startOTA {
    __block BOOL success = NO;
    [MKCFMQTTInterface cf_configOTAWithFilePath:self.filePath macAddress:[MKCFDeviceModeManager shared].macAddress topic:[MKCFDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - private method
- (BOOL)validParams {
    if (!ValidStr(self.filePath) || self.filePath.length > 256) {
        return NO;
    }
    return YES;
}

- (void)operationFailedBlockWithMsg:(NSString *)msg block:(void (^)(NSError *error))block {
    moko_dispatch_main_safe(^{
        NSError *error = [[NSError alloc] initWithDomain:@"OTA"
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
        _readQueue = dispatch_queue_create("OTAParamsQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
