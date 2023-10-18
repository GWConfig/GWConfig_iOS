//
//  MKCMDeviceDatabaseManager.h
//  MKCommureApp_Example
//
//  Created by aa on 2023/1/29.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MKCMDeviceModel;
@interface MKCMDeviceDatabaseManager : NSObject

/// 创建数据库
+ (BOOL)initDataBase;

/// 设备入库，key为mac地址，如果本地已经存在则覆盖，不存在则插入
/// @param deviceList 设备列表
/// @param sucBlock 成功回调
/// @param failedBlock 失败回调
+ (void)insertDeviceList:(NSArray <MKCMDeviceModel *>*)deviceList
                sucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock;

+ (void)deleteDeviceWithMacAddress:(NSString *)macAddress
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;

+ (void)readLocalDeviceWithSucBlock:(void (^)(NSArray <MKCMDeviceModel *> *deviceList))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

/// 更新本地存储的名字
/// @param localName 名字
/// @param macAddress 本地存储的key
/// @param sucBlock 成功回调
/// @param failedBlock 失败回调
+ (void)updateLocalName:(NSString *)localName
             macAddress:(NSString *)macAddress
               sucBlock:(void (^)(void))sucBlock
            failedBlock:(void (^)(NSError *error))failedBlock;

/// 根据mac地址更新本地数据库
/// @param clientID clientID
/// @param subscribedTopic 订阅主题
/// @param publishedTopic 发布主题
/// @param lwtStatus用户是否打开了遗嘱功能
/// @param lwtTopic 遗言topic(用户打开了遗嘱功能的时候不能为空)
/// @param macAddress 本地存储的key
/// @param sucBlock 成功回调
/// @param failedBlock 失败回调
+ (void)updateClientID:(NSString *)clientID
       subscribedTopic:(NSString *)subscribedTopic
        publishedTopic:(NSString *)publishedTopic
             lwtStatus:(BOOL)lwtStatus
              lwtTopic:(NSString *)lwtTopic
            macAddress:(NSString *)macAddress
              sucBlock:(void (^)(void))sucBlock
           failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
