//
//  MKCGBatchModifyModel.m
//  CommureGateway_Example
//
//  Created by aa on 2023/12/14.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import "MKCGBatchModifyModel.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKCGMQTTInterface.h"
#import "MKCGMQTTConfigDefines.h"

#import "MKCGBatchModifyManager.h"

#import "MKCGBatchModifySubModel.h"


@interface MKCGBatchModifyModel ()

@property (nonatomic, strong)dispatch_queue_t configQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@property (nonatomic, strong)MKCGBatchModifySubModel *modifyModel;

@end

@implementation MKCGBatchModifyModel

- (instancetype)init {
    if (self = [super init]) {
        self.subTopic = @"/provision/gateway/cmds";
        self.pubTopic = @"/provision/gateway/data";
    }
    return self;
}

- (void)configDataWithMacList:(NSArray <NSString *>*)macList
                progressBlock:(void (^)(NSString *macAddress,cg_batchModifyStatus status))progressBlock
                completeBlock:(void (^)(void))completeBlock {
    dispatch_async(self.configQueue, ^{
        
        for (NSInteger i = 0; i < macList.count; i ++) {
            NSString *macAddress = macList[i];
            moko_dispatch_main_safe(^{
                progressBlock(macAddress,cg_batchModifyStatus_upgrading);
            });
            BOOL success = [self modifyWithMacAddress:macAddress];
            cg_batchModifyStatus resultStatus = (success ? cg_batchModifyStatus_success : cg_batchModifyStatus_failed);
            moko_dispatch_main_safe(^{
                progressBlock(macAddress,resultStatus);
            });
        }
        
        
        moko_dispatch_main_safe(^{
            completeBlock();
        });
    });
}

#pragma mark - interface
- (BOOL)modifyWithMacAddress:(NSString *)macAddress {
    __block BOOL success = NO;
    
    [self.modifyModel configDataWithMacAddress:macAddress 
                           pubTopic:self.subTopic
                           sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
        } 
                        failedBlock:^(NSError * _Nonnull error) {
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

- (MKCGBatchModifySubModel *)modifyModel {
    if (!_modifyModel) {
        _modifyModel = [[MKCGBatchModifySubModel alloc] init];
    }
    return _modifyModel;
}

@end
