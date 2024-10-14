//
//  MKCHBatchOtaManager.m
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/7/10.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCHBatchOtaManager.h"


#import "MKMacroDefines.h"

#import "MKCHMQTTDataManager.h"
#import "MKCHMQTTInterface.h"

const NSString *defaultOtaUrl = @"http://47.104.172.169:8080/updata_fold/commureMK110_V1.0.4.bin";
const NSString *defaultOtaSubTopic = @"/provision/gateway/cmds";
const NSString *defaultOtaPubTopic = @"/provision/gateway/data";

@interface MKCHBatchOtaManager ()

@property (nonatomic, copy)void (^otaBlock)(NSString *macAddress,ch_batchOtaStatus status);

@property (nonatomic, copy)void (^completeBlock)(BOOL complete);

@property (nonatomic, strong)NSMutableArray *otaList;

@property (nonatomic, strong)dispatch_source_t updateTimer;

@property (nonatomic, assign)NSInteger updateCount;

@end

@implementation MKCHBatchOtaManager

- (void)dealloc {
    NSLog(@"MKCHBatchOtaManager销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.updateTimer) {
        dispatch_cancel(self.updateTimer);
    }
}

- (instancetype)init {
    if (self = [super init]) {
//        self.filePath = defaultOtaUrl;
        self.subTopic = defaultOtaSubTopic;
        self.pubTopic = defaultOtaPubTopic;
    }
    return self;
}

- (void)startBatchOta:(NSArray <NSString *>*)macList
   statusChangedBlock:(void (^)(NSString *macAddress,ch_batchOtaStatus status))statusBlock
        completeBlock:(void (^)(BOOL complete))completeBlock  {
    self.otaBlock = statusBlock;
    self.completeBlock = completeBlock;
    [self.otaList removeAllObjects];
    for (NSInteger i = 0; i < macList.count; i ++) {
        NSString *macAddress = macList[i];
        MKCHBatchOtaModel *otaModel = [[MKCHBatchOtaModel alloc] init];
        otaModel.firwareType = self.firwareType;
        otaModel.macAddress = macAddress;
        otaModel.subTopic = self.subTopic;
        otaModel.pubTopic = self.pubTopic;
        otaModel.filePath = self.filePath;
        [self.otaList addObject:otaModel];
    }
    [self operateUpdateTimer];
    [self processOtaModel];
}

#pragma mark - private method
- (void)operateUpdateTimer {
    if (self.updateTimer) {
        dispatch_cancel(self.updateTimer);
    }
    self.updateCount = 0;
    self.updateTimer = nil;
    self.updateTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(self.updateTimer, dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), DISPATCH_TIME_FOREVER, 0);
    @weakify(self);
    dispatch_source_set_event_handler(self.updateTimer, ^{
        @strongify(self);
        if (self.updateCount == 300) {
            dispatch_cancel(self.updateTimer);
            self.updateCount = 0;
            [self.otaList removeAllObjects];
            moko_dispatch_main_safe((^{
                if (self.completeBlock) {
                    self.completeBlock(NO);
                }
                self.otaBlock = nil;
                self.completeBlock = nil;
            }));
            return;
        }
        self.updateCount ++;
    });
    dispatch_resume(self.updateTimer);
}

- (NSString *)subTopicWithMac:(NSString *)macAddress {
    if ([self.subTopic isEqualToString:defaultOtaSubTopic]) {
        return [NSString stringWithFormat:@"/gateway/provision/%@",macAddress];
    }
    return self.subTopic;
}

- (NSString *)pubTopicWithMac:(NSString *)macAddress {
    if ([self.pubTopic isEqualToString:defaultOtaPubTopic]) {
        return [NSString stringWithFormat:@"/gateway/data/%@",macAddress];
    }
    return self.pubTopic;
}

- (void)processOtaModel {
    if (self.otaList.count == 0) {
        if (self.updateTimer) {
            dispatch_cancel(self.updateTimer);
        }
        if (self.completeBlock) {
            self.completeBlock(YES);
        }
        self.otaBlock = nil;
        self.completeBlock = nil;
        self.updateCount = 0;
        return;
    }
    MKCHBatchOtaModel *otaModel = [self.otaList firstObject];
    @weakify(self);
    [otaModel otaWithResultBlock:^(NSString * _Nonnull macAddress, ch_batchOtaStatus status) {
        @strongify(self);
        self.updateCount = 0;
        if (self.otaBlock) {
            self.otaBlock(macAddress, status);
        }
        if (status != ch_batchOtaStatus_upgrading) {
            //升级结果
            [self.otaList removeObject:otaModel];
            [self processOtaModel];
        }
    }];
}

#pragma mark - getter
- (NSMutableArray *)otaList {
    if (!_otaList) {
        _otaList = [NSMutableArray array];
    }
    return _otaList;
}

@end
