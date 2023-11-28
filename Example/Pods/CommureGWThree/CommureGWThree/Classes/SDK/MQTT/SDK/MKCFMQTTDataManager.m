//
//  MKCFMQTTDataManager.m
//  CommureGWThree_Example
//
//  Created by aa on 2023/2/4.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCFMQTTDataManager.h"

#import "MKMacroDefines.h"

#import "MKCFMQTTServerManager.h"

#import "MKCFMQTTOperation.h"

NSString *const MKCFMQTTSessionManagerStateChangedNotification = @"MKCFMQTTSessionManagerStateChangedNotification";

NSString *const MKCFReceiveDeviceOnlineNotification = @"MKCFReceiveDeviceOnlineNotification";
NSString *const MKCFReceiveDeviceNetStateNotification = @"MKCFReceiveDeviceNetStateNotification";
NSString *const MKCFReceiveDeviceOTAResultNotification = @"MKCFReceiveDeviceOTAResultNotification";
NSString *const MKCFReceiveDeviceResetByButtonNotification = @"MKCFReceiveDeviceResetByButtonNotification";
NSString *const MKCFReceiveDeviceUpdateEapCertsResultNotification = @"MKCFReceiveDeviceUpdateEapCertsResultNotification";
NSString *const MKCFReceiveDeviceUpdateMqttCertsResultNotification = @"MKCFReceiveDeviceUpdateMqttCertsResultNotification";

NSString *const MKCFReceiveDeviceDatasNotification = @"MKCFReceiveDeviceDatasNotification";
NSString *const MKCFReceiveGatewayDisconnectBXPButtonNotification = @"MKCFReceiveGatewayDisconnectBXPButtonNotification";
NSString *const MKCFReceiveGatewayDisconnectDeviceNotification = @"MKCFReceiveGatewayDisconnectDeviceNotification";
NSString *const MKCFReceiveGatewayConnectedDeviceDatasNotification = @"MKCFReceiveGatewayConnectedDeviceDatasNotification";

NSString *const MKCFReceiveBxpButtonDfuProgressNotification = @"MKCFReceiveBxpButtonDfuProgressNotification";
NSString *const MKCFReceiveBxpButtonDfuResultNotification = @"MKCFReceiveBxpButtonDfuResultNotification";
NSString *const MKCFReceiveBxpButtonBatchDfuResultNotification = @"MKCFReceiveBxpButtonBatchDfuResultNotification";

NSString *const MKCFReceiveBxpButtonUpdateKeyResultNotification = @"MKCFReceiveBxpButtonUpdateKeyResultNotification";
NSString *const MKCFReceiveBxpButtonBatchUpdateKeyResultNotification = @"MKCFReceiveBxpButtonBatchUpdateKeyResultNotification";

NSString *const MKCFReceiveButtonLogNotification = @"MKCFReceiveButtonLogNotification";


static MKCFMQTTDataManager *manager = nil;
static dispatch_once_t onceToken;

@interface MKCFMQTTDataManager ()

@property (nonatomic, strong)NSOperationQueue *operationQueue;

@end

@implementation MKCFMQTTDataManager

- (instancetype)init {
    if (self = [super init]) {
        [[MKCFMQTTServerManager shared] loadDataManager:self];
    }
    return self;
}

+ (MKCFMQTTDataManager *)shared {
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [MKCFMQTTDataManager new];
        }
    });
    return manager;
}

+ (void)singleDealloc {
    [[MKCFMQTTServerManager shared] removeDataManager:manager];
    onceToken = 0;
    manager = nil;
}

#pragma mark - MKCFServerManagerProtocol
- (void)cf_didReceiveMessage:(NSDictionary *)data onTopic:(NSString *)topic {
    if (!ValidDict(data) || !ValidNum(data[@"msg_id"]) || !ValidStr(data[@"device_info"][@"mac"])) {
        return;
    }
    NSInteger msgID = [data[@"msg_id"] integerValue];
    NSString *macAddress = data[@"device_info"][@"mac"];
    //无论是什么消息，都抛出该通知，证明设备在线
    [[NSNotificationCenter defaultCenter] postNotificationName:MKCFReceiveDeviceOnlineNotification
                                                        object:nil
                                                      userInfo:@{@"macAddress":macAddress}];
    if (msgID == 3004) {
        //上报的网络状态
        NSDictionary *resultDic = @{
            @"macAddress":macAddress,
            @"data":data[@"data"]
        };
        [[NSNotificationCenter defaultCenter] postNotificationName:MKCFReceiveDeviceNetStateNotification
                                                            object:nil
                                                          userInfo:resultDic];
        return;
    }
    if (msgID == 3007) {
        //固件升级结果
        [[NSNotificationCenter defaultCenter] postNotificationName:MKCFReceiveDeviceOTAResultNotification
                                                            object:nil
                                                          userInfo:data];
        return;
    }
    if (msgID == 3014) {
        //设备通过按键恢复出厂设置
        [[NSNotificationCenter defaultCenter] postNotificationName:MKCFReceiveDeviceResetByButtonNotification
                                                            object:nil
                                                          userInfo:data];
        return;
    }
    if (msgID == 3022) {
        //EAP证书更新结果
        [[NSNotificationCenter defaultCenter] postNotificationName:MKCFReceiveDeviceUpdateEapCertsResultNotification
                                                            object:nil
                                                          userInfo:data];
        return;
    }
    if (msgID == 3032) {
        //MQTT证书更新结果
        [[NSNotificationCenter defaultCenter] postNotificationName:MKCFReceiveDeviceUpdateMqttCertsResultNotification
                                                            object:nil
                                                          userInfo:data];
        return;
    }
    if (msgID == 3070) {
        //扫描到的数据
        if ([self.dataDelegate respondsToSelector:@selector(mk_cf_receiveDeviceDatas:)]) {
            [self.dataDelegate mk_cf_receiveDeviceDatas:data];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:MKCFReceiveDeviceDatasNotification
                                                            object:nil
                                                          userInfo:data];
        return;
    }
    if (msgID == 3104) {
        //网关与已连接的蓝牙设备断开了链接，非主动断开
        [[NSNotificationCenter defaultCenter] postNotificationName:MKCFReceiveGatewayDisconnectDeviceNotification
                                                            object:nil
                                                          userInfo:data];
        return;
    }
    if (msgID == 3108) {
        //网关与已连接的BXP-Button设备断开了链接，非主动断开
        [[NSNotificationCenter defaultCenter] postNotificationName:MKCFReceiveGatewayDisconnectBXPButtonNotification
                                                            object:nil
                                                          userInfo:data];
        return;
    }
    if (msgID == 3176) {
        //按键操作log
        [[NSNotificationCenter defaultCenter] postNotificationName:MKCFReceiveButtonLogNotification
                                                            object:nil
                                                          userInfo:data];
        return;
    }
    if (msgID == 3202) {
        //BXP-Button升级进度
        [[NSNotificationCenter defaultCenter] postNotificationName:MKCFReceiveBxpButtonDfuProgressNotification
                                                            object:nil
                                                          userInfo:data];
        return;
    }
    if (msgID == 3203) {
        //单个Beacon升级结果
        [[NSNotificationCenter defaultCenter] postNotificationName:MKCFReceiveBxpButtonDfuResultNotification
                                                            object:nil
                                                          userInfo:data];
        return;
    }
    if (msgID == 3204) {
        //批量BXP-Button升级结果
        [[NSNotificationCenter defaultCenter] postNotificationName:MKCFReceiveBxpButtonBatchDfuResultNotification
                                                            object:nil
                                                          userInfo:data];
        return;
    }
    if (msgID == 3206) {
        //单个Update Key升级结果
        [[NSNotificationCenter defaultCenter] postNotificationName:MKCFReceiveBxpButtonUpdateKeyResultNotification
                                                            object:nil
                                                          userInfo:data];
        return;
    }
    if (msgID == 3207) {
        //批量Update Key升级结果
        [[NSNotificationCenter defaultCenter] postNotificationName:MKCFReceiveBxpButtonBatchUpdateKeyResultNotification
                                                            object:nil
                                                          userInfo:data];
        return;
    }
    if (msgID == 3311) {
        //网关接收到已连接的蓝牙设备的数据
        [[NSNotificationCenter defaultCenter] postNotificationName:MKCFReceiveGatewayConnectedDeviceDatasNotification
                                                            object:nil
                                                          userInfo:data];
        return;
    }
    @synchronized(self.operationQueue) {
        NSArray *operations = [self.operationQueue.operations copy];
        for (NSOperation <MKCFMQTTOperationProtocol>*operation in operations) {
            if (operation.executing) {
                [operation didReceiveMessage:data onTopic:topic];
                break;
            }
        }
    }
}

- (void)cf_didChangeState:(MKCFMQTTSessionManagerState)newState {
    [[NSNotificationCenter defaultCenter] postNotificationName:MKCFMQTTSessionManagerStateChangedNotification object:nil];
}

#pragma mark - public method

- (id<MKCFServerParamsProtocol>)currentServerParams {
    return [MKCFMQTTServerManager shared].currentServerParams;
}

- (BOOL)saveServerParams:(id <MKCFServerParamsProtocol>)protocol {
    return [[MKCFMQTTServerManager shared] saveServerParams:protocol];
}

- (BOOL)clearLocalData {
    return [[MKCFMQTTServerManager shared] clearLocalData];
}

- (BOOL)connect {
    return [[MKCFMQTTServerManager shared] connect];
}

- (void)disconnect {
    if (self.operationQueue.operations.count > 0) {
        [self.operationQueue cancelAllOperations];
    }
    [[MKCFMQTTServerManager shared] disconnect];
}

- (void)subscriptions:(NSArray <NSString *>*)topicList {
    [[MKCFMQTTServerManager shared] subscriptions:topicList];
}

- (void)unsubscriptions:(NSArray <NSString *>*)topicList {
    [[MKCFMQTTServerManager shared] unsubscriptions:topicList];
}

- (void)clearAllSubscriptions {
    [[MKCFMQTTServerManager shared] clearAllSubscriptions];
}

- (MKCFMQTTSessionManagerState)state {
    return [MKCFMQTTServerManager shared].state;
}

- (void)sendData:(NSDictionary *)data
           topic:(NSString *)topic
      macAddress:(NSString *)macAddress
          taskID:(mk_cf_serverOperationID)taskID
        sucBlock:(void (^)(id returnData))sucBlock
     failedBlock:(void (^)(NSError *error))failedBlock {
    MKCFMQTTOperation *operation = [self generateOperationWithTaskID:taskID
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
          taskID:(mk_cf_serverOperationID)taskID
         timeout:(NSInteger)timeout
        sucBlock:(void (^)(id returnData))sucBlock
     failedBlock:(void (^)(NSError *error))failedBlock {
    MKCFMQTTOperation *operation = [self generateOperationWithTaskID:taskID
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

- (MKCFMQTTOperation *)generateOperationWithTaskID:(mk_cf_serverOperationID)taskID
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
    MKCFMQTTOperation *operation = [[MKCFMQTTOperation alloc] initOperationWithID:taskID macAddress:macAddress commandBlock:^{
        [[MKCFMQTTServerManager shared] sendData:data topic:topic sucBlock:nil failedBlock:nil];
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
