//
//  MKCMDeviceModeManager.h
//  MKCommureApp_Example
//
//  Created by aa on 2023/2/4.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKCMDeviceModeManagerDataProtocol <NSObject>

/// MTQQ通信所需的ID，如果存在重复的，会出现交替上线的情况
@property (nonatomic, copy)NSString *clientID;

/**
 mac地址,对应设备读取信息参数的device_id
 */
@property (nonatomic, copy)NSString *macAddress;

/**
 设备广播名字
 */
@property (nonatomic, copy)NSString *deviceName;

/// 本地名字
@property (nonatomic, copy)NSString *localName;

@property (nonatomic, copy)NSString *deviceType;

- (NSString *)currentSubscribedTopic;

- (NSString *)currentPublishedTopic;

@end

@interface MKCMDeviceModeManager : NSObject

+ (MKCMDeviceModeManager *)shared;

+ (void)sharedDealloc;

/// 当前设备的类型    00:Commure  10:GW3
- (NSString *)deviceType;

/// 当前设备的deviceID
- (NSString *)deviceID;

/// 当前设备的mac地址
- (NSString *)macAddress;

/// 当前设备的订阅主题
- (NSString *)subscribedTopic;

/// 本地存储的名字
- (NSString *)deviceName;

/// 当前需要托管的deviceModel
/// @param protocol protocol
- (void)addDeviceModel:(id <MKCMDeviceModeManagerDataProtocol>)protocol;

/// 清空当前托管的数据
- (void)clearDeviceModel;

- (void)updateDeviceName:(NSString *)deviceName;

@end

NS_ASSUME_NONNULL_END
