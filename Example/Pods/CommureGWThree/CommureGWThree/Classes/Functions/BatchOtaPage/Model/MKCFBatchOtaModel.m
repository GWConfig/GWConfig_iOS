//
//  MKCFBatchOtaModel.m
//  CommureGWThree_Example
//
//  Created by aa on 2023/7/10.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCFBatchOtaModel.h"

#import "MKMacroDefines.h"

#import "MKCFMQTTDataManager.h"
#import "MKCFMQTTInterface.h"

@interface MKCFBatchOtaModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@property (nonatomic, copy)void (^otaBlock)(NSString *macAddress,cf_batchOtaStatus status);

@end

@implementation MKCFBatchOtaModel

- (void)dealloc {
    NSLog(@"MKCFBatchOtaModel销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - public method
- (void)otaWithResultBlock:(void (^)(NSString *macAddress, cf_batchOtaStatus status))block {
    [[MKCFMQTTDataManager shared] subscriptions:@[self.pubTopic]];
    dispatch_async(self.readQueue, ^{
        NSInteger status = [self readOTAState];
        if (status == -1) {
            moko_dispatch_main_safe(^{
                if (block) {
                    block(self.macAddress,cf_batchOtaStatus_timeout);
                }
            })
            return;
        }
        if (status == 1) {
            moko_dispatch_main_safe(^{
                if (block) {
                    block(self.macAddress,cf_batchOtaStatus_upgrading);
                }
            })
            return;
        }
        if (![self startOTA]) {
            moko_dispatch_main_safe(^{
                if (block) {
                    block(self.macAddress,cf_batchOtaStatus_timeout);
                }
            })
            return;
        }
        moko_dispatch_main_safe(^{
            if (block) {
                block(self.macAddress,cf_batchOtaStatus_upgrading);
            }
            self.otaBlock = nil;
            self.otaBlock = block;
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(receiveOTAResult:)
                                                         name:MKCFReceiveDeviceOTAResultNotification
                                                       object:nil];
        });
    });
}

#pragma mark - note
- (void)receiveOTAResult:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user) || !ValidStr(user[@"device_info"][@"mac"]) || ![self.macAddress isEqualToString:user[@"device_info"][@"mac"]]) {
        return;
    }
    [[MKCFMQTTDataManager shared] subscriptions:@[self.pubTopic]];
    NSDictionary *dataDic = user[@"data"];
    NSInteger result = [dataDic[@"result_code"] integerValue];
    
    if (result == 1) {
        //成功
        if (self.otaBlock) {
            self.otaBlock(self.macAddress,cf_batchOtaStatus_success);
        }
    }else {
        if (self.otaBlock) {
            self.otaBlock(self.macAddress,cf_batchOtaStatus_failed);
        }
    }
}

#pragma mark - interface
- (NSInteger)readOTAState {
    __block NSInteger status = -1;
    [MKCFMQTTInterface cf_readOtaStatusWithMacAddress:self.macAddress topic:self.subTopic sucBlock:^(id  _Nonnull returnData) {
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
    [MKCFMQTTInterface cf_configOTAWithFilePath:self.filePath macAddress:self.macAddress topic:self.subTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
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
