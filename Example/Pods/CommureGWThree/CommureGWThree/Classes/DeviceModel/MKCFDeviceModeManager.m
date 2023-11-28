//
//  MKCFDeviceModeManager.m
//  CommureGWThree_Example
//
//  Created by aa on 2023/2/4.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCFDeviceModeManager.h"

#import "MKMacroDefines.h"


static MKCFDeviceModeManager *manager = nil;
static dispatch_once_t onceToken;

@interface MKCFDeviceModeManager ()

@property (nonatomic, strong)id <MKCFDeviceModeManagerDataProtocol>protocol;

@end

@implementation MKCFDeviceModeManager

+ (MKCFDeviceModeManager *)shared {
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [MKCFDeviceModeManager new];
        }
    });
    return manager;
}

+ (void)sharedDealloc {
    manager = nil;
    onceToken = 0;
}

#pragma mark - public method

- (NSString *)deviceType {
    if (!self.protocol) {
        return @"";
    }
    return SafeStr(self.protocol.deviceType);
}

/// 当前设备的mac地址
- (NSString *)macAddress {
    if (!self.protocol) {
        return @"";
    }
    return SafeStr(self.protocol.macAddress);
}

/// 当前设备的订阅主题
- (NSString *)subscribedTopic {
    if (!self.protocol) {
        return @"";
    }
    return [self.protocol currentSubscribedTopic];
}

- (NSString *)deviceName {
    if (!self.protocol) {
        return @"";
    }
    return self.protocol.deviceName;
}

- (void)addDeviceModel:(id <MKCFDeviceModeManagerDataProtocol>)protocol {
    self.protocol = nil;
    self.protocol = protocol;
}

- (void)clearDeviceModel {
    if (self.protocol) {
        self.protocol = nil;
    }
}

- (void)updateDeviceName:(NSString *)deviceName {
    if (!ValidStr(deviceName)) {
        return;
    }
    self.protocol.deviceName = SafeStr(deviceName);
}

@end
