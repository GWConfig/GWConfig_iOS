//
//  MKCMMqttParamsForGWTModel.m
//  MKCommureApp_Example
//
//  Created by aa on 2023/7/27.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import "MKCMMqttParamsForGWTModel.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKCMDeviceModeManager.h"

#import "MKCMMQTTInterface.h"

@interface MKCMMqttParamsForGWTModel ()

@property (nonatomic, strong)dispatch_queue_t configQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKCMMqttParamsForGWTModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.configQueue, ^{
        if (![self readMqttInfos]) {
            [self operationFailedBlockWithMsg:@"Read Mqtt Infos Error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            sucBlock();
        });
    });
}

#pragma mark - interface
- (BOOL)readMqttInfos {
    __block BOOL success = NO;
    [MKCMMQTTInterface cm_readMQTTParamsWithMacAddress:[MKCMDeviceModeManager shared].macAddress topic:[MKCMDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.clientID = returnData[@"data"][@"client_id"];
        self.subscribeTopic = returnData[@"data"][@"sub_topic"];
        self.publishTopic = returnData[@"data"][@"pub_topic"];
        self.lwtStatus = ([returnData[@"data"][@"lwt_en"] integerValue] == 1);
        self.lwtTopic = returnData[@"data"][@"lwt_topic"];
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
        NSError *error = [[NSError alloc] initWithDomain:@"serverParams"
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

- (dispatch_queue_t)configQueue {
    if (!_configQueue) {
        _configQueue = dispatch_queue_create("serverSettingsQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _configQueue;
}

@end
