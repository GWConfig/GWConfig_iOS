//
//  MKNetworkManager.h
//  MokoLifeX_Example
//
//  Created by aa on 2021/8/19.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, AFNetworkReachabilityStatus) {
    AFNetworkReachabilityStatusUnknown          = -1,
    AFNetworkReachabilityStatusNotReachable     = 0,
    AFNetworkReachabilityStatusReachableViaWWAN = 1,
    AFNetworkReachabilityStatusReachableViaWiFi = 2,
};

//当前网络状态发生改变通知
extern NSString *const MKNetworkStatusChangedNotification;

@interface MKNetworkManager : NSObject

@property(nonatomic, assign)AFNetworkReachabilityStatus currentNetStatus;//当前网络状态

+ (MKNetworkManager *)sharedInstance;

/**
 当前网络是否可用
 
 @return YES:可用，NO:不可用
 */
- (BOOL)currentNetworkAvailable;

@end

NS_ASSUME_NONNULL_END
