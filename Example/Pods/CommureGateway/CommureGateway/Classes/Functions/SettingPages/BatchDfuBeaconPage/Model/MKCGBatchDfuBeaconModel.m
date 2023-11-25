//
//  MKCGBatchDfuBeaconModel.m
//  CommureGateway_Example
//
//  Created by aa on 2023/4/21.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCGBatchDfuBeaconModel.h"

#import "MKMacroDefines.h"

#import "MKCGDeviceModeManager.h"

#import "MKCGMQTTInterface.h"

#import "MKMacroDefines.h"

#import "MKCGDeviceModeManager.h"

@interface MKCGBatchDfuBeaconModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKCGBatchDfuBeaconModel

- (instancetype)init {
    if (self = [super init]) {
        self.firmwareUrl = @"http://47.104.172.169:8080/updata_fold/CommureTag_V1.0.4.bin";
        self.dataUrl = @"http://47.104.172.169:8080/updata_fold/CommureTag_V1.0.4.dat";
    }
    return self;
}

- (void)configDataWithBeaconList:(NSArray <NSString *>*)list
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self configDatas:list]) {
            [self operationFailedBlockWithMsg:@"setup failed!" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            sucBlock();
        });
    });
}

#pragma mark - interface

- (BOOL)configDatas:(NSArray <NSString *>*)list {
    NSMutableArray *dfuList = [NSMutableArray array];
    for (NSInteger i = 0; i < list.count; i ++) {
        NSDictionary *dic = @{
            @"macAddress":list[i],
            @"password":SafeStr(self.password),
        };
        [dfuList addObject:dic];
    }
    __block BOOL success = NO;
    [MKCGMQTTInterface cg_batchDfuBeacon:self.firmwareUrl dataFileUrl:self.dataUrl beaconList:dfuList macAddress:[MKCGDeviceModeManager shared].macAddress topic:[MKCGDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        if ([returnData[@"data"][@"result_code"] integerValue] == 0) {
            success = YES;
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
        NSError *error = [[NSError alloc] initWithDomain:@"BatchDFUBeacon"
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
        _readQueue = dispatch_queue_create("BatchDFUBeaconQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
