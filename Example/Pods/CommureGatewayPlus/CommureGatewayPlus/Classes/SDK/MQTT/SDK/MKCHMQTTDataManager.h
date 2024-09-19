//
//  MKCHMQTTDataManager.h
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/2/4.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKCHServerConfigDefines.h"

#import "MKCHMQTTTaskID.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString *const MKCHMQTTSessionManagerStateChangedNotification;

extern NSString *const MKCHReceiveDeviceOnlineNotification;

extern NSString *const MKCHReceiveDeviceOTAResultNotification;

extern NSString *const MKCHReceiveDeviceNpcOTAResultNotification;

extern NSString *const MKCHReceiveDeviceResetByButtonNotification;

extern NSString *const MKCHReceiveDeviceUpdateEapCertsResultNotification;

extern NSString *const MKCHReceiveDeviceUpdateMqttCertsResultNotification;

extern NSString *const MKCHReceiveDeviceNetStateNotification;

extern NSString *const MKCHReceiveDeviceDatasNotification;

extern NSString *const MKCHReceiveGatewayDisconnectBXPButtonNotification;

extern NSString *const MKCHReceiveGatewayDisconnectDeviceNotification;

extern NSString *const MKCHReceiveGatewayConnectedDeviceDatasNotification;

extern NSString *const MKCHReceiveBxpButtonDfuProgressNotification;

extern NSString *const MKCHReceiveBxpButtonDfuResultNotification;

extern NSString *const MKCHReceiveBxpButtonBatchDfuResultNotification;

extern NSString *const MKCHReceiveBxpButtonUpdateKeyResultNotification;

extern NSString *const MKCHReceiveBxpButtonBatchUpdateKeyResultNotification;

extern NSString *const MKCHReceiveButtonLogNotification;


@protocol MKCHReceiveDeviceDatasDelegate <NSObject>

- (void)mk_ch_receiveDeviceDatas:(NSDictionary *)data;

@end

@interface MKCHMQTTDataManager : NSObject<MKCHServerManagerProtocol>

@property (nonatomic, weak)id <MKCHReceiveDeviceDatasDelegate>dataDelegate;

@property (nonatomic, assign, readonly)MKCHMQTTSessionManagerState state;

+ (MKCHMQTTDataManager *)shared;

+ (void)singleDealloc;

/// 当前app连接服务器参数
@property (nonatomic, strong, readonly, getter=currentServerParams)id <MKCHServerParamsProtocol>serverParams;

/// 将参数保存到本地，下次启动通过该参数连接服务器
/// @param protocol protocol
- (BOOL)saveServerParams:(id <MKCHServerParamsProtocol>)protocol;

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
          taskID:(mk_ch_serverOperationID)taskID
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
          taskID:(mk_ch_serverOperationID)taskID
         timeout:(NSInteger)timeout
        sucBlock:(void (^)(id returnData))sucBlock
     failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
