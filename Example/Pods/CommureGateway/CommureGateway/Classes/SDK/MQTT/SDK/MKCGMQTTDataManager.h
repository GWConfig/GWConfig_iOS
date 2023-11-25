//
//  MKCGMQTTDataManager.h
//  CommureGateway_Example
//
//  Created by aa on 2023/2/4.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKCGServerConfigDefines.h"

#import "MKCGMQTTTaskID.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString *const MKCGMQTTSessionManagerStateChangedNotification;

extern NSString *const MKCGReceiveDeviceOnlineNotification;

extern NSString *const MKCGReceiveDeviceOTAResultNotification;

extern NSString *const MKCGReceiveDeviceResetByButtonNotification;

extern NSString *const MKCGReceiveDeviceUpdateEapCertsResultNotification;

extern NSString *const MKCGReceiveDeviceUpdateMqttCertsResultNotification;

extern NSString *const MKCGReceiveDeviceNetStateNotification;

extern NSString *const MKCGReceiveDeviceDatasNotification;

extern NSString *const MKCGReceiveGatewayDisconnectBXPButtonNotification;

extern NSString *const MKCGReceiveGatewayDisconnectDeviceNotification;

extern NSString *const MKCGReceiveGatewayConnectedDeviceDatasNotification;

extern NSString *const MKCGReceiveBxpButtonDfuProgressNotification;

extern NSString *const MKCGReceiveBxpButtonDfuResultNotification;

extern NSString *const MKCGReceiveBxpButtonBatchDfuResultNotification;

extern NSString *const MKCGReceiveBxpButtonUpdateKeyResultNotification;

extern NSString *const MKCGReceiveBxpButtonBatchUpdateKeyResultNotification;

extern NSString *const MKCGReceiveButtonLogNotification;


@protocol MKCGReceiveDeviceDatasDelegate <NSObject>

- (void)mk_cg_receiveDeviceDatas:(NSDictionary *)data;

@end

@interface MKCGMQTTDataManager : NSObject<MKCGServerManagerProtocol>

@property (nonatomic, weak)id <MKCGReceiveDeviceDatasDelegate>dataDelegate;

@property (nonatomic, assign, readonly)MKCGMQTTSessionManagerState state;

+ (MKCGMQTTDataManager *)shared;

+ (void)singleDealloc;

/// 当前app连接服务器参数
@property (nonatomic, strong, readonly, getter=currentServerParams)id <MKCGServerParamsProtocol>serverParams;

/// 将参数保存到本地，下次启动通过该参数连接服务器
/// @param protocol protocol
- (BOOL)saveServerParams:(id <MKCGServerParamsProtocol>)protocol;

/**
 清除本地记录的设置信息
 */
- (BOOL)clearLocalData;

#pragma mark - *****************************服务器交互部分******************************

/// 开始连接服务器，前提是必须服务器参数不能为空
- (BOOL)connect;

- (void)disconnect;

/**
 Subscribe the topic

 @param topicList topicList
 */
- (void)subscriptions:(NSArray <NSString *>*)topicList;

/**
 Unsubscribe the topic
 
 @param topicList topicList
 */
- (void)unsubscriptions:(NSArray <NSString *>*)topicList;

- (void)clearAllSubscriptions;

/// Send Data
/// @param data json
/// @param topic topic,1-128 Characters
/// @param macAddress macAddress,6字节16进制，不包含任何符号AABBCCDDEEFF
/// @param taskID taskID
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
- (void)sendData:(NSDictionary *)data
           topic:(NSString *)topic
      macAddress:(NSString *)macAddress
          taskID:(mk_cg_serverOperationID)taskID
        sucBlock:(void (^)(id returnData))sucBlock
     failedBlock:(void (^)(NSError *error))failedBlock;

/// Send Data
/// @param data json
/// @param topic topic,1-128 Characters
/// @param macAddress macAddress,6字节16进制，不包含任何符号AABBCCDDEEFF
/// @param taskID taskID
/// @param timeout 任务超时时间
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
- (void)sendData:(NSDictionary *)data
           topic:(NSString *)topic
      macAddress:(NSString *)macAddress
          taskID:(mk_cg_serverOperationID)taskID
         timeout:(NSInteger)timeout
        sucBlock:(void (^)(id returnData))sucBlock
     failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
