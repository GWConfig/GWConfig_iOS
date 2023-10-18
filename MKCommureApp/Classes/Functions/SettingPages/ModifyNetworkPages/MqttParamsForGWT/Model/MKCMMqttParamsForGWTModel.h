//
//  MKCMMqttParamsForGWTModel.h
//  MKCommureApp_Example
//
//  Created by aa on 2023/7/27.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCMMqttParamsForGWTModel : NSObject

@property (nonatomic, copy)NSString *clientID;

@property (nonatomic, copy)NSString *subscribeTopic;

@property (nonatomic, copy)NSString *publishTopic;

@property (nonatomic, assign)BOOL lwtStatus;

/// 只有配置了MQTT，该参数才需要更新本地
@property (nonatomic, copy)NSString *lwtTopic;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
