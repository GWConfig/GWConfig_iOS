//
//  MKCHMQTTDataManager.m
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/2/4.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCHMQTTDataManager.h"

#import "MKMacroDefines.h"

#import "MKCHMQTTServerManager.h"

#import "MKCHMQTTOperation.h"

NSString *const MKCHMQTTSessionManagerStateChangedNotification = @"MKCHMQTTSessionManagerStateChangedNotification";

NSString *const MKCHReceiveDeviceOnlineNotification = @"MKCHReceiveDeviceOnlineNotification";
NSString *const MKCHReceiveDeviceNetStateNotification = @"MKCHReceiveDeviceNetStateNotification";
NSString *const MKCHReceiveDeviceOTAResultNotification = @"MKCHReceiveDeviceOTAResultNotification";
NSString *const MKCHReceiveDeviceNpcOTAResultNotification = @"MKCHReceiveDeviceNpcOTAResultNotification";
NSString *const MKCHReceiveDeviceResetByButtonNotification = @"MKCHReceiveDeviceResetByButtonNotification";
NSString *const MKCHReceiveDeviceUpdateEapCertsResultNotification = @"MKCHReceiveDeviceUpdateEapCertsResultNotification";
NSString *const MKCHReceiveDeviceUpdateMqttCertsResultNotification = @"MKCHReceiveDeviceUpdateMqttCertsResultNotification";

NSString *const MKCHReceiveDeviceDatasNotification = @"MKCHReceiveDeviceDatasNotification";
NSString *const MKCHReceiveGatewayDisconnectBXPButtonNotification = @"MKCHReceiveGatewayDisconnectBXPButtonNotification";
NSString *const MKCHReceiveGatewayDisconnectDeviceNotification = @"MKCHReceiveGatewayDisconnectDeviceNotification";
NSString *const MKCHReceiveGatewayConnectedDeviceDatasNotification = @"MKCHReceiveGatewayConnectedDeviceDatasNotification";

NSString *const MKCHReceiveBxpButtonDfuProgressNotification = @"MKCHReceiveBxpButtonDfuProgressNotification";
NSString *const MKCHReceiveBxpButtonDfuResultNotification = @"MKCHReceiveBxpButtonDfuResultNotification";
NSString *const MKCHReceiveBxpButtonBatchDfuResultNotification = @"MKCHReceiveBxpButtonBatchDfuResultNotification";

NSString *const MKCHReceiveBxpButtonUpdateKeyResultNotification = @"MKCHReceiveBxpButtonUpdateKeyResultNotification";
NSString *const MKCHReceiveBxpButtonBatchUpdateKeyResultNotification = @"MKCHReceiveBxpButtonBatchUpdateKeyResultNotification";

NSString *const MKCHReceiveButtonLogNotification = @"MKCHReceiveButtonLogNotification";


static MKCHMQTTDataManager *manager = nil;
static dispatch_once_t onceToken;

@interface MKCHMQTTDataManager ()

@property (nonatomic, strong)NSOperationQueue *operationQueue;

@end

@implementation MKCHMQTTDataManager

- (instancetype)init {
    if (self = [super init]) {
        [[MKCHMQTTServerManager shared] loadDataManager:self];
    }
    return self;
}

+ (MKCHMQTTDataManager *)shared {
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [MKCHMQTTDataManager new];
        }
    });
    return manager;
}

+ (void)singleDealloc {
    [[MKCHMQTTServerManager shared] removeDataManager:manager];
    onceToken = 0;
    manager = nil;
}

#pragma mark - MKCHServerManagerProtocol
- (void)ch_didReceiveMessage:(NSDictionary *)data onTopic:(NSString *)topic {
    if (!ValidDict(data) || !ValidNum(data[@"msg_id"]) || !ValidStr(data[@"device_info"][@"mac"])) {
        return;
    }
    NSInteger msgID = [data[@"msg_id"] integerValue];
    NSString *macAddress = data[@"device_info"][@"mac"];
    //无论是什么消息，都抛出该通知，证明设备在线
    [[NSNotificationCenter defaultCenter] postNotificationName:MKCHReceiveDeviceOnlineNotification
                                                        object:nil
                                                      userInfo:@{@"macAddress":macAddress}];
    if (msgID == 3004) {
        //上报的网络状态
        NSDictionary *resultDic = @{
            @"macAddress":macAddress,
            @"data":data[@"data"]
        };
        [[NSNotificationCenter defaultCenter] postNotificationName:MKCHReceiveDeviceNetStateNotification
                                                            object:nil
                                                          userInfo:resultDic];
        return;
    }
    if (msgID == 3007) {
        //固件升级结果
        [[NSNotificationCenter defaultCenter] postNotificationName:MKCHReceiveDeviceOTAResultNotification
                                                            object:nil
                                                          userInfo:data];
        return;
    }
    if (msgID == 3014) {
        //设备通过按键恢复出厂设置
        [[NSNotificationCenter defaultCenter] postNotificationName:MKCHReceiveDeviceResetByButtonNotification
                                                            object:nil
                                                          userInfo:data];
        return;
    }
    if (msgID == 3019) {
        //NCP固件升级结果
        [[NSNotificationCenter defaultCenter] postNotificationName:MKCHReceiveDeviceNpcOTAResultNotification
                                                            object:nil
                                                          userInfo:data];
        return;
    }
    if (msgID == 3022) {
        //EAP证书更新结果
        [[NSNotificationCenter defaultCenter] postNotificationName:MKCHReceiveDeviceUpdateEapCertsResultNotification
                                                            object:nil
                                                          userInfo:data];
        return;
    }
    if (msgID == 3032) {
        //MQTT证书更新结果
        [[NSNotificationCenter defaultCenter] postNotificationName:MKCHReceiveDeviceUpdateMqttCertsResultNotification
                                                            object:nil
                                                          userInfo:data];
        return;
    }
    if (msgID == 3070) {
        //扫描到的数据
        if ([self.dataDelegate respondsToSelector:@selector(mk_ch_receiveDeviceDatas:)]) {
            [self.dataDelegate mk_ch_receiveDeviceDatas:data];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:MKCHReceiveDeviceDatasNotification
                                                            object:nil
                                                          userInfo:data];
        return;
    }
    if (msgID == 3104) {
        //网关与已连接的蓝牙设备断开了链接，非主动断开
        [[NSNotificationCenter defaultCenter] postNotificationName:MKCHReceiveGatewayDisconnectDeviceNotification
                                                            object:nil
                                                          userInfo:data];
        return;
    }
    if (msgID == 3108) {
        //网关与已连接的BXP-Button设备断开了链接，非主动断开
        [[NSNotificationCenter defaultCenter] postNotificationName:MKCHReceiveGatewayDisconnectBXPButtonNotification
                                                            object:nil
                                                          userInfo:data];
        return;
    }
    if (msgID == 3176) {
        //按键操作log
        [[NSNotificationCenter defaultCenter] postNotificationName:MKCHReceiveButtonLogNotification
                                                            object:nil
                                                          userInfo:data];
        return;
    }
    if (msgID == 3202) {
        //BXP-Button升级进度
        [[NSNotificationCenter defaultCenter] postNotificationName:MKCHReceiveBxpButtonDfuProgressNotification
                                                            object:nil
                                                          userInfo:data];
        return;
    }
    if (msgID == 3203) {
        //单个Beacon升级结果
        [[NSNotificationCenter defaultCenter] postNotificationName:MKCHReceiveBxpButtonDfuResultNotification
                                                            object:nil
                                                          userInfo:data];
        return;
    }
    if (msgID == 3204) {
        //批量BXP-Button升级结果
        [[NSNotificationCenter defaultCenter] postNotificationName:MKCHReceiveBxpButtonBatchDfuResultNotification
                                                            object:nil
                                                          userInfo:data];
        return;
    }
    if (msgID == 3206) {
        //单个Update Key升级结果
        [[NSNotificationCenter defaultCenter] postNotificationName:MKCHReceiveBxpButtonUpdateKeyResultNotification
                                                            object:nil
                                                          userInfo:data];
        return;
    }
    if (msgID == 3207) {
        //批量Update Key升级结果
        [[NSNotificationCenter defaultCenter] postNotificationName:MKCHReceiveBxpButtonBatchUpdateKeyResultNotification
                                                            object:nil
                                                          userInfo:data];
        return;
    }
    if (msgID == 3311) {
        //网关接收到已连接的蓝牙设备的数据
        [[NSNotificationCenter defaultCenter] postNotificationName:MKCHReceiveGatewayConnectedDeviceDatasNotification
                                                            object:nil
                                                          userInfo:data];
        return;
    }
    @synchronized(self.operationQueue) {
        NSArray *operations = [self.operationQueue.operations copy];
        for (NSOperation <MKCHMQTTOperationProtocol>*operation in operations) {
            if (operation.executing) {
                [operation didReceiveMessage:data onTopic:topic];
                break;
            }
        }
    }
}

- (void)ch_didChangeState:(MKCHMQTTSessionManagerState)newState {
    [[NSNotificationCenter defaultCenter] postNotificationName:MKCHMQTTSessionManagerStateChangedNotification object:nil];
}

#pragma mark - public method

- (id<MKCHServerParamsProtocol>)currentServerParams {
    return [MKCHMQTTServerManager shared].currentServerParams;
}

- (BOOL)saveServerParams:(id <MKCHServerParamsProtocol>)protocol {
    return [[MKCHMQTTServerManager shared] saveServerParams:protocol];
}

- (BOOL)clearLocalData {
    return [[MKCHMQTTServerManager shared] clearLocalData];
}

- (BOOL)connect {
    return [[MKCHMQTTServerManager shared] connect];
}

- (void)disconnect {
    if (self.operationQueue.operations.count > 0) {
        [self.operationQueue cancelAllOperations];
    }
    [[MKCHMQTTServerManager shared] disconnect];
}

- (void)subscriptions:(NSArray <NSString *>*)topicList {
    [[MKCHMQTTServerManager shared] subscriptions:topicList];
}

- (void)unsubscriptions:(NSArray <NSString *>*)topicList {
    [[MKCHMQTTServerManager shared] unsubscriptions:topicList];
}

- (void)clearAllSubscriptions {
    [[MKCHMQTTServerManager shared] clearAllSubscriptions];
}

- (MKCHMQTTSessionManagerState)state {
    return [MKCHMQTTServerManager shared].state;
}

- (void)sendData:(NSDictionary *)data
           topic:(NSString *)topic
      macAddress:(NSString *)macAddress
          taskID:(mk_ch_serverOperationID)taskID
        sucBlock:(void (^)(id returnData))sucBlock
     failedBlock:(void (^)(NSError *error))failedBlock {
    MKCHMQTTOperation *operation = [self generateOperationWithTaskID:taskID
                                                               topic:topic
                                                          macAddress:macAddress
                                                                data:data
                                                            sucBlock:sucBlock
                                                         failedBlock:failedBlock];
    if (!operation) {
        return;
    }
    [self.operationQueue addOperation:operation];
}

- (void)sendData:(NSDictionary *)data
           topic:(NSString *)topic
      macAddress:(NSString *)macAddress
          taskID:(mk_ch_serverOperationID)taskID
         timeout:(NSInteger)timeout
        sucBlock:(void (^)(id returnData))sucBlock
     failedBlock:(void (^)(NSError *error))failedBlock {
    MKCHMQTTOperation *operation = [self generateOperationWithTaskID:taskID
                                                               topic:topic
                                                          macAddress:macAddress
                                                                data:data
                                                            sucBlock:sucBlock
                                                         failedBlock:failedBlock];
    if (!operation) {
        return;
    }
    operation.operationTimeout = timeout;
    [self.operationQueue addOperation:operation];
}

#pragma mark - private method

- (MKCHMQTTOperation *)generateOperationWithTaskID:(mk_ch_serverOperationID)taskID
                                              topic:(NSString *)topic
                                        macAddress:(NSString *)macAddress
                                               data:(NSDictionary *)data
                                           sucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    if (!ValidDict(data)) {
        [self operationFailedBlockWithMsg:@"The data sent to the device cannot be empty" failedBlock:failedBlock];
        return nil;
    }
    if (!ValidStr(topic) || topic.length > 128) {
        [self operationFailedBlockWithMsg:@"Topic error" failedBlock:failedBlock];
        return nil;
    }
    if ([MKMQTTServerManager shared].managerState != MKMQTTSessionManagerStateConnected) {
        [self operationFailedBlockWithMsg:@"MTQQ Server disconnect" failedBlock:failedBlock];
        return nil;
    }
    __weak typeof(self) weakSelf = self;
    MKCHMQTTOperation *operation = [[MKCHMQTTOperation alloc] initOperationWithID:taskID macAddress:macAddress commandBlock:^{
        [[MKCHMQTTServerManager shared] sendData:data topic:topic sucBlock:nil failedBlock:nil];
    } completeBlock:^(NSError * _Nonnull error, id  _Nonnull returnData) {
        __strong typeof(self) sself = weakSelf;
        if (error) {
            moko_dispatch_main_safe(^{
                if (failedBlock) {
                    failedBlock(error);
                }
            });
            return ;
        }
        if (!returnData) {
            [sself operationFailedBlockWithMsg:@"Request data error" failedBlock:failedBlock];
            return ;
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock(returnData);
            }
        });
    }];
    return operation;
}

- (void)operationFailedBlockWithMsg:(NSString *)message failedBlock:(void (^)(NSError *error))failedBlock {
    NSError *error = [[NSError alloc] initWithDomain:@"com.moko.RGMQTTDataManager"
                                                code:-999
                                            userInfo:@{@"errorInfo":message}];
    moko_dispatch_main_safe(^{
        if (failedBlock) {
            failedBlock(error);
        }
    });
}

#pragma mark - getter
- (NSOperationQueue *)operationQueue{
    if (!_operationQueue) {
        _operationQueue = [[NSOperationQueue alloc] init];
        _operationQueue.maxConcurrentOperationCount = 10;
    }
    return _operationQueue;
}

@end
