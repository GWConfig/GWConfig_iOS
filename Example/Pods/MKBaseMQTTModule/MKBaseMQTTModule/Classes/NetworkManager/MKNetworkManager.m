//
//  MKNetworkManager.m
//  MokoLifeX_Example
//
//  Created by aa on 2021/8/19.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKNetworkManager.h"

#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>
#import <arpa/inet.h>

NSString *const MKNetworkStatusChangedNotification = @"MKNetworkStatusChangedNotification";

@interface NSObject (MKNetworkManager)

@end

@implementation NSObject (MKNetworkManager)

+ (void)load{
    [MKNetworkManager sharedInstance];
}

@end

@interface MKNetworkManager()

@property (nonatomic, assign) SCNetworkReachabilityRef reachabilityRef;

@end

@implementation MKNetworkManager

+ (MKNetworkManager *)sharedInstance{
    static MKNetworkManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [MKNetworkManager new];
        }
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // 初始化网络监控
        [self startMonitoring];
    }
    return self;
}

- (void)dealloc {
    // 停止监控并释放资源
    if (_reachabilityRef) {
        SCNetworkReachabilityUnscheduleFromRunLoop(_reachabilityRef, CFRunLoopGetMain(), kCFRunLoopCommonModes);
        CFRelease(_reachabilityRef);
    }
}

#pragma mark - Public method
- (BOOL)currentNetworkAvailable {
    if (self.currentNetStatus == AFNetworkReachabilityStatusUnknown || self.currentNetStatus == AFNetworkReachabilityStatusNotReachable) {
        return NO;
    }
    return YES;
}

#pragma mark - 开始监听网络连接
- (void)startMonitoring {
    // 创建 SCNetworkReachabilityRef
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;

    _reachabilityRef = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)&zeroAddress);
    if (!_reachabilityRef) {
        NSLog(@"Failed to create reachability reference");
        return;
    }

    // 设置回调
    SCNetworkReachabilityContext context = {0, (__bridge void *)self, NULL, NULL, NULL};
    if (!SCNetworkReachabilitySetCallback(_reachabilityRef, ReachabilityCallback, &context)) {
        NSLog(@"Failed to set reachability callback");
        CFRelease(_reachabilityRef);
        _reachabilityRef = NULL;
        return;
    }

    // 添加到 RunLoop
    if (!SCNetworkReachabilityScheduleWithRunLoop(_reachabilityRef, CFRunLoopGetMain(), kCFRunLoopCommonModes)) {
        NSLog(@"Failed to schedule reachability");
        CFRelease(_reachabilityRef);
        _reachabilityRef = NULL;
        return;
    }
    
    // 主动获取当前网络状态并触发回调
    SCNetworkReachabilityFlags flags;
    if (SCNetworkReachabilityGetFlags(_reachabilityRef, &flags)) {
        [self handleReachabilityChange:flags];
    }
}

#pragma mark - 网络状态回调
static void ReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void* info) {
    MKNetworkManager *networkStatus = (__bridge MKNetworkManager *)info;
    [networkStatus handleReachabilityChange:flags];
}

- (void)handleReachabilityChange:(SCNetworkReachabilityFlags)flags {
    AFNetworkReachabilityStatus status = [self networkStatusForFlags:flags];
    if (self.currentNetStatus != status) {
        self.currentNetStatus = status;
        [[NSNotificationCenter defaultCenter] postNotificationName:MKNetworkStatusChangedNotification object:nil];
    }
}

#pragma mark - 获取当前网络状态
- (AFNetworkReachabilityStatus)networkStatusForFlags:(SCNetworkReachabilityFlags)flags {
    if ((flags & kSCNetworkReachabilityFlagsReachable) == 0) {
        return AFNetworkReachabilityStatusNotReachable;
    }

    if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0) {
        return AFNetworkReachabilityStatusReachableViaWiFi;
    }
    if (((flags & kSCNetworkReachabilityFlagsConnectionOnDemand) != 0) ||
        ((flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0)) {
        if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0) {
            return AFNetworkReachabilityStatusReachableViaWiFi;
        }
    }
    if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN) {
        return AFNetworkReachabilityStatusReachableViaWWAN;
    }
    return AFNetworkReachabilityStatusUnknown;
}

@end
