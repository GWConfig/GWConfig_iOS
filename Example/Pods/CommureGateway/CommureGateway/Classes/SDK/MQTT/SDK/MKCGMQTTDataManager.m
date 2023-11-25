//
//  MKCGMQTTDataManager.m
//  CommureGateway_Example
//
//  Created by aa on 2023/2/4.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCGMQTTDataManager.h"

#import "MKMacroDefines.h"

#import "MKCGMQTTServerManager.h"

#import "MKCGMQTTOperation.h"

NSString *const MKCGMQTTSessionManagerStateChangedNotification = @"MKCGMQTTSessionManagerStateChangedNotification";

NSString *const MKCGReceiveDeviceOnlineNotification = @"MKCGReceiveDeviceOnlineNotification";
NSString *const MKCGReceiveDeviceNetStateNotification = @"MKCGReceiveDeviceNetStateNotification";
NSString *const MKCGReceiveDeviceOTAResultNotification = @"MKCGReceiveDeviceOTAResultNotification";
NSString *const MKCGReceiveDeviceResetByButtonNotification = @"MKCGReceiveDeviceResetByButtonNotification";
NSString *const MKCGReceiveDeviceUpdateEapCertsResultNotification = @"MKCGReceiveDeviceUpdateEapCertsResultNotification";
NSString *const MKCGReceiveDeviceUpdateMqttCertsResultNotification = @"MKCGReceiveDeviceUpdateMqttCertsResultNotification";

NSString *const MKCGReceiveDeviceDatasNotification = @"MKCGReceiveDeviceDatasNotification";
NSString *const MKCGReceiveGatewayDisconnectBXPButtonNotification = @"MKCGReceiveGatewayDisconnectBXPButtonNotification";
NSString *const MKCGReceiveGatewayDisconnectDeviceNotification = @"MKCGReceiveGatewayDisconnectDeviceNotification";
NSString *const MKCGReceiveGatewayConnectedDeviceDatasNotification = @"MKCGReceiveGatewayConnectedDeviceDatasNotification";

NSString *const MKCGReceiveBxpButtonDfuProgressNotification = @"MKCGReceiveBxpButtonDfuProgressNotification";
NSString *const MKCGReceiveBxpButtonDfuResultNotification = @"MKCGReceiveBxpButtonDfuResultNotification";
NSString *const MKCGReceiveBxpButtonBatchDfuResultNotification = @"MKCGReceiveBxpButtonBatchDfuResultNotification";

NSString *const MKCGReceiveBxpButtonUpdateKeyResultNotification = @"MKCGReceiveBxpButtonUpdateKeyResultNotification";
NSString *const MKCGReceiveBxpButtonBatchUpdateKeyResultNotification = @"MKCGReceiveBxpButtonBatchUpdateKeyResultNotification";

NSString *const MKCGReceiveButtonLogNotification = @"MKCGReceiveButtonLogNotification";


static MKCGMQTTDataManager *manager = nil;
static dispatch_once_t onceToken;

@interface MKCGMQTTDataManager ()

@property (nonatomic, strong)NSOperationQueue *operationQueue;

@end

@implementation MKCGMQTTDataManager

- (instancetype)init {
    if (self = [super init]) {
        [[MKCGMQTTServerManager shared] loadDataManager:self];
    }
    return self;
}

+ (MKCGMQTTDataManager *)shared {
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [MKCGMQTTDataManager new];
        }
    });
    return manager;
}

+ (void)singleDealloc {
    [[MKCGMQTTServerManager shared] removeDataManager:manager];
    onceToken = 0;
    manager = nil;
}

#pragma mark - MKCGServerManagerProtocol
- (void)cg_didReceiveMessage:(NSDictionary *)data onTopic:(NSString *)topic {
    if (!ValidDict(data) || !ValidNum(data[@"msg_id"]) || !ValidStr(data[@"device_info"][@"mac"])) {
        return;
    }
    NSInteger msgID = [data[@"msg_id"] integerValue];
    NSString *macAddress = data[@"device_info"][@"mac"];
    //无论是什么消息，都抛出该通知，证明设备在线
    [[NSNotificationCenter defaultCenter] postNotificationName:MKCGReceiveDeviceOnlineNotification
                                                        object:nil
                                                      userInfo:@{@"macAddress":macAddress}];
    if (msgID == 3004) {
        //上报的网络状态
        NSDictionary *resultDic = @{
            @"macAddress":macAddress,
            @"data":data[@"data"]
        };
        [[NSNotificationCenter defaultCenter] postNotificationName:MKCGReceiveDeviceNetStateNotification
                                                            object:nil
                                                          userInfo:resultDic];
        return;
    }
    if (msgID == 3007) {
        //固件升级结果
        [[NSNotificationCenter defaultCenter] postNotificationName:MKCGReceiveDeviceOTAResultNotification
                                                            object:nil
                                                          userInfo:data];
        return;
    }
    if (msgID == 3014) {
        //设备通过按键恢复出厂设置
        [[NSNotificationCenter defaultCenter] postNotificationName:MKCGReceiveDeviceResetByButtonNotification
                                                            object:nil
                                                          userInfo:data];
        return;
    }
    if (msgID == 3022) {
        //EAP证书更新结果
        [[NSNotificationCenter defaultCenter] postNotificationName:MKCGReceiveDeviceUpdateEapCertsResultNotification
                                                            object:nil
                                                          userInfo:data];
        return;
    }
    if (msgID == 3032) {
        //MQTT证书更新结果
        [[NSNotificationCenter defaultCenter] postNotificationName:MKCGReceiveDeviceUpdateMqttCertsResultNotification
                                                            object:nil
                                                          userInfo:data];
        return;
    }
    if (msgID == 3070) {
        //扫描到的数据
        if ([self.dataDelegate respondsToSelector:@selector(mk_cg_receiveDeviceDatas:)]) {
            [self.dataDelegate mk_cg_receiveDeviceDatas:data];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:MKCGReceiveDeviceDatasNotification
                                                            object:nil
                                                          userInfo:data];
        return;
    }
    if (msgID == 3104) {
        //网关与已连接的蓝牙设备断开了链接，非主动断开
        [[NSNotificationCenter defaultCenter] postNotificationName:MKCGReceiveGatewayDisconnectDeviceNotification
                                                            object:nil
                                                          userInfo:data];
        return;
    }
    if (msgID == 3108) {
        //网关与已连接的BXP-Button设备断开了链接，非主动断开
        [[NSNotificationCenter defaultCenter] postNotificationName:MKCGReceiveGatewayDisconnectBXPButtonNotification
                                                            object:nil
                                                          userInfo:data];
        return;
    }
    if (msgID == 3176) {
        //按键操作log
        [[NSNotificationCenter defaultCenter] postNotificationName:MKCGReceiveButtonLogNotification
                                                            object:nil
                                                          userInfo:data];
        return;
    }
    if (msgID == 3202) {
        //BXP-Button升级进度
        [[NSNotificationCenter defaultCenter] postNotificationName:MKCGReceiveBxpButtonDfuProgressNotification
                                                            object:nil
                                                          userInfo:data];
        return;
    }
    if (msgID == 3203) {
        //单个Beacon升级结果
        [[NSNotificationCenter defaultCenter] postNotificationName:MKCGReceiveBxpButtonDfuResultNotification
                                                            object:nil
                                                          userInfo:data];
        return;
    }
    if (msgID == 3204) {
        //批量BXP-Button升级结果
        [[NSNotificationCenter defaultCenter] postNotificationName:MKCGReceiveBxpButtonBatchDfuResultNotification
                                                            object:nil
                                                          userInfo:data];
        return;
    }
    if (msgID == 3206) {
        //单个Update Key升级结果
        [[NSNotificationCenter defaultCenter] postNotificationName:MKCGReceiveBxpButtonUpdateKeyResultNotification
                                                            object:nil
                                                          userInfo:data];
        return;
    }
    if (msgID == 3207) {
        //批量Update Key升级结果
        [[NSNotificationCenter defaultCenter] postNotificationName:MKCGReceiveBxpButtonBatchUpdateKeyResultNotification
                                                            object:nil
                                                          userInfo:data];
        return;
    }
    if (msgID == 3311) {
        //网关接收到已连接的蓝牙设备的数据
        [[NSNotificationCenter defaultCenter] postNotificationName:MKCGReceiveGatewayConnectedDeviceDatasNotification
                                                            object:nil
                                                          userInfo:data];
        return;
    }
    @synchronized(self.operationQueue) {
        NSArray *operations = [self.operationQueue.operations copy];
        for (NSOperation <MKCGMQTTOperationProtocol>*operation in operations) {
            if (operation.executing) {
                [operation didReceiveMessage:data onTopic:topic];
                break;
            }
        }
    }
}

- (void)cg_didChangeState:(MKCGMQTTSessionManagerState)newState {
    [[NSNotificationCenter defaultCenter] postNotificationName:MKCGMQTTSessionManagerStateChangedNotification object:nil];
}

#pragma mark - public method

- (id<MKCGServerParamsProtocol>)currentServerParams {
    return [MKCGMQTTServerManager shared].currentServerParams;
}

- (BOOL)saveServerParams:(id <MKCGServerParamsProtocol>)protocol {
    return [[MKCGMQTTServerManager shared] saveServerParams:protocol];
}

- (BOOL)clearLocalData {
    return [[MKCGMQTTServerManager shared] clearLocalData];
}

- (BOOL)connect {
    return [[MKCGMQTTServerManager shared] connect];
}

- (void)disconnect {
    if (self.operationQueue.operations.count > 0) {
        [self.operationQueue cancelAllOperations];
    }
    [[MKCGMQTTServerManager shared] disconnect];
}

- (void)subscriptions:(NSArray <NSString *>*)topicList {
    [[MKCGMQTTServerManager shared] subscriptions:topicList];
}

- (void)unsubscriptions:(NSArray <NSString *>*)topicList {
    [[MKCGMQTTServerManager shared] unsubscriptions:topicList];
}

- (void)clearAllSubscriptions {
    [[MKCGMQTTServerManager shared] clearAllSubscriptions];
}

- (MKCGMQTTSessionManagerState)state {
    return [MKCGMQTTServerManager shared].state;
}

- (void)sendData:(NSDictionary *)data
           topic:(NSString *)topic
      macAddress:(NSString *)macAddress
          taskID:(mk_cg_serverOperationID)taskID
        sucBlock:(void (^)(id returnData))sucBlock
     failedBlock:(void (^)(NSError *error))failedBlock {
    MKCGMQTTOperation *operation = [self generateOperationWithTaskID:taskID
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
          taskID:(mk_cg_serverOperationID)taskID
         timeout:(NSInteger)timeout
        sucBlock:(void (^)(id returnData))sucBlock
     failedBlock:(void (^)(NSError *error))failedBlock {
    MKCGMQTTOperation *operation = [self generateOperationWithTaskID:taskID
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

- (MKCGMQTTOperation *)generateOperationWithTaskID:(mk_cg_serverOperationID)taskID
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
    MKCGMQTTOperation *operation = [[MKCGMQTTOperation alloc] initOperationWithID:taskID macAddress:macAddress commandBlock:^{
        [[MKCGMQTTServerManager shared] sendData:data topic:topic sucBlock:nil failedBlock:nil];
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
