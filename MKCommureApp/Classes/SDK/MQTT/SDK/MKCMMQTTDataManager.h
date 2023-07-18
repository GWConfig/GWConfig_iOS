//
//  MKCMMQTTDataManager.h
//  MKCommureApp_Example
//
//  Created by aa on 2023/2/4.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKCMServerConfigDefines.h"

#import "MKCMMQTTTaskID.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString *const MKCMMQTTSessionManagerStateChangedNotification;

extern NSString *const MKCMReceiveDeviceOnlineNotification;

extern NSString *const MKCMReceiveDeviceOTAResultNotification;

extern NSString *const MKCMReceiveDeviceResetByButtonNotification;

extern NSString *const MKCMReceiveDeviceUpdateEapCertsResultNotification;

extern NSString *const MKCMReceiveDeviceUpdateMqttCertsResultNotification;

extern NSString *const MKCMReceiveDeviceNetStateNotification;

extern NSString *const MKCMReceiveDeviceDatasNotification;

extern NSString *const MKCMReceiveGatewayDisconnectBXPButtonNotification;

extern NSString *const MKCMReceiveGatewayDisconnectDeviceNotification;

extern NSString *const MKCMReceiveGatewayConnectedDeviceDatasNotification;

extern NSString *const MKCMReceiveBxpButtonDfuProgressNotification;

extern NSString *const MKCMReceiveBxpButtonDfuResultNotification;

extern NSString *const MKCMReceiveBxpButtonBatchDfuResultNotification;

extern NSString *const MKCMReceiveBxpButtonUpdateKeyResultNotification;

extern NSString *const MKCMReceiveBxpButtonBatchUpdateKeyResultNotification;


@protocol MKCMReceiveDeviceDatasDelegate <NSObject>

- (void)mk_cm_receiveDeviceDatas:(NSDictionary *)data;

@end

@interface MKCMMQTTDataManager : NSObject<MKCMServerManagerProtocol>

@property (nonatomic, weak)id <MKCMReceiveDeviceDatasDelegate>dataDelegate;

@property (nonatomic, assign, readonly)MKCMMQTTSessionManagerState state;

+ (MKCMMQTTDataManager *)shared;

+ (void)singleDealloc;

/// 当前app连接服务器参数
@property (nonatomic, strong, readonly, getter=currentServerParams)id <MKCMServerParamsProtocol>serverParams;

/// 将参数保存到本地，下次启动通过该参数连接服务器
/// @param protocol protocol
- (BOOL)saveServerParams:(id <MKCMServerParamsProtocol>)protocol;

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
          taskID:(mk_cm_serverOperationID)taskID
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
          taskID:(mk_cm_serverOperationID)taskID
         timeout:(NSInteger)timeout
        sucBlock:(void (^)(id returnData))sucBlock
     failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
