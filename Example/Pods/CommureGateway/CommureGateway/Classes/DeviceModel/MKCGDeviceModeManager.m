//
//  MKCGDeviceModeManager.m
//  CommureGateway_Example
//
//  Created by aa on 2023/2/4.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCGDeviceModeManager.h"

#import "MKMacroDefines.h"


static MKCGDeviceModeManager *manager = nil;
static dispatch_once_t onceToken;

@interface MKCGDeviceModeManager ()

@property (nonatomic, strong)id <MKCGDeviceModeManagerDataProtocol>protocol;

@end

@implementation MKCGDeviceModeManager

+ (MKCGDeviceModeManager *)shared {
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [MKCGDeviceModeManager new];
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

- (void)addDeviceModel:(id <MKCGDeviceModeManagerDataProtocol>)protocol {
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
