//
//  MKCMBatchOtaManager.m
//  MKCommureApp_Example
//
//  Created by aa on 2023/7/10.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCMBatchOtaManager.h"


#import "MKMacroDefines.h"

#import "MKCMMQTTDataManager.h"
#import "MKCMMQTTInterface.h"

const NSString *defaultOtaUrl = @"http://47.104.172.169:8080/updata_fold/commureMK110_V1.0.4.bin";
const NSString *defaultOtaSubTopic = @"/gateway/provision/#";
const NSString *defaultOtaPubTopic = @"/gateway/data/#";

@interface MKCMBatchOtaManager ()

@property (nonatomic, copy)void (^otaBlock)(NSString *macAddress,cm_batchOtaStatus status);

@property (nonatomic, copy)void (^completeBlock)(void);

@property (nonatomic, strong)NSMutableArray *otaList;

@end

@implementation MKCMBatchOtaManager

- (void)dealloc {
    NSLog(@"MKCMBatchOtaManager销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    if (self = [super init]) {
        self.filePath = defaultOtaUrl;
        self.subTopic = defaultOtaSubTopic;
        self.pubTopic = defaultOtaPubTopic;
    }
    return self;
}

- (void)startBatchOta:(NSArray <NSString *>*)macList
   statusChangedBlock:(void (^)(NSString *macAddress,cm_batchOtaStatus status))statusBlock
        completeBlock:(void (^)(void))completeBlock  {
    self.otaBlock = statusBlock;
    self.completeBlock = completeBlock;
    [self.otaList removeAllObjects];
    for (NSInteger i = 0; i < macList.count; i ++) {
        NSString *macAddress = macList[i];
        MKCMBatchOtaModel *otaModel = [[MKCMBatchOtaModel alloc] init];
        otaModel.macAddress = macAddress;
        otaModel.subTopic = [self subTopicWithMac:macAddress];
        otaModel.pubTopic = [self pubTopicWithMac:macAddress];
        otaModel.filePath = self.filePath;
        [self.otaList addObject:otaModel];
    }
    [self processOtaModel];
}

#pragma mark - private method
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
        if (self.completeBlock) {
            self.completeBlock();
        }
        self.otaBlock = nil;
        self.completeBlock = nil;
        return;
    }
    MKCMBatchOtaModel *otaModel = [self.otaList firstObject];
    @weakify(self);
    [otaModel otaWithResultBlock:^(NSString * _Nonnull macAddress, cm_batchOtaStatus status) {
        @strongify(self);
        if (self.otaBlock) {
            self.otaBlock(macAddress, status);
        }
        if (status != cm_batchOtaStatus_upgrading) {
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
