//
//  MKCMDeviceModel.h
//  MKCommureApp_Example
//
//  Created by aa on 2023/1/29.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKCMDeviceModeManager.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MKCMDeviceModelState) {
    MKCMDeviceModelStateOffline,
    MKCMDeviceModelStateOnline,
};

//当设备离线的时候发出通知
extern NSString *const MKCMDeviceModelOfflineNotification;

@protocol MKCMDeviceModelDelegate <NSObject>

/// 当前设备离线
/// @param macAddress 当前设备的macAddress
- (void)cm_deviceOfflineWithMacAddress:(NSString *)macAddress;

@end

@interface MKCMDeviceModel : NSObject<MKCMDeviceModeManagerDataProtocol>

/// 设备类型
@property (nonatomic, copy)NSString *deviceType;

/// MTQQ通信所需的ID，如果存在重复的，会出现交替上线的情况
@property (nonatomic, copy)NSString *clientID;

/**
 设备广播名字
 */
@property (nonatomic, copy)NSString *deviceName;

/**
 订阅主题
 */
@property (nonatomic, copy)NSString *subscribedTopic;

/**
 发布主题
 */
@property (nonatomic, copy)NSString *publishedTopic;

/**
 mac地址，注意此处用的是wifi的mac而非ble的
 */
@property (nonatomic, copy)NSString *macAddress;

/**
 设备的状态，离线、在线
 */
@property (nonatomic, assign)MKCMDeviceModelState onLineState;

#pragma mark - 业务流程相关

@property (nonatomic, weak)id <MKCMDeviceModelDelegate>delegate;

/**
 当前model的订阅主题，当用户设置了app的订阅主题时，返回设置的订阅主题，否则返回当前model的订阅主题
 
 @return subscribedTopic
 */
- (NSString *)currentSubscribedTopic;

/**
 当前model的发布主题，当用户设置了app的发布主题时，返回设置的发布主题，否则返回当前model的发布主题
 
 @return publishedTopic
 */
- (NSString *)currentPublishedTopic;

/**
 设备列表页面的状态监控
 */
- (void)startStateMonitoringTimer;

/**
 接收到开关状态的时候，需要清除离线状态计数
 */
- (void)resetTimerCounter;

/**
 取消定时器
 */
- (void)cancel;

@end

NS_ASSUME_NONNULL_END
