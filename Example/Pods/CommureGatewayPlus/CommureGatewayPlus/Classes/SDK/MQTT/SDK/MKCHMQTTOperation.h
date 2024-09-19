//
//  MKCHMQTTOperation.h
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/2/4.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKCHMQTTTaskID.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MKCHMQTTOperationProtocol <NSObject>

- (void)didReceiveMessage:(NSDictionary *)data onTopic:(NSString *)topic;

@end

@interface MKCHMQTTOperation : NSOperation<MKCHMQTTOperationProtocol>

/// 任务超时时间，默认为20s
@property (nonatomic, assign)NSTimeInterval operationTimeout;

/**
 初始化通信线程
 
 @param operationID 当前线程的任务ID
 @param macAddress 当前任务的macAddress
 @param commandBlock 发送命令回调
 @param completeBlock 数据通信完成回调
 @return operation
 */
- (instancetype)initOperationWithID:(mk_ch_serverOperationID)operationID
                         macAddress:(NSString *)macAddress
                       commandBlock:(void (^)(void))commandBlock
                      completeBlock:(void (^)(NSError *error, id returnData))completeBlock;

@end

NS_ASSUME_NONNULL_END
