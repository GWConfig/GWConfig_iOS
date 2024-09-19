//
//  MKCHBatchOtaManager.h
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/7/10.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKCHBatchOtaModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKCHBatchOtaManager : NSObject

@property (nonatomic, copy)NSString *filePath;

/// 升级订阅的topic，根据用户填写的Gateway subscribe  topic确定，如果用户使用默认的/gateway/provision/#，则/gateway/provision/macAddress，否则就是用户输入的topic
@property (nonatomic, copy)NSString *subTopic;

/// 升级发布的topic，根据用户填写的Gateway publish  topic确定，如果用户使用默认的/gateway/data/#，则/gateway/data/macAddress，否则就是用户输入的topic
@property (nonatomic, copy)NSString *pubTopic;

- (void)startBatchOta:(NSArray <NSString *>*)macList
   statusChangedBlock:(void (^)(NSString *macAddress,ch_batchOtaStatus status))statusBlock
        completeBlock:(void (^)(BOOL complete))completeBlock;

@end

NS_ASSUME_NONNULL_END
