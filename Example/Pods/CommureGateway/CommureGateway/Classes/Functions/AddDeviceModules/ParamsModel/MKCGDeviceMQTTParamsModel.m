//
//  MKCGDeviceMQTTParamsModel.m
//  CommureGateway_Example
//
//  Created by aa on 2023/1/29.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCGDeviceMQTTParamsModel.h"

#import "MKCGDeviceModel.h"

static MKCGDeviceMQTTParamsModel *paramsModel = nil;
static dispatch_once_t onceToken;

@implementation MKCGDeviceMQTTParamsModel

+ (MKCGDeviceMQTTParamsModel *)shared {
    dispatch_once(&onceToken, ^{
        if (!paramsModel) {
            paramsModel = [MKCGDeviceMQTTParamsModel new];
        }
    });
    return paramsModel;
}

+ (void)sharedDealloc {
    paramsModel = nil;
    onceToken = 0;
}

#pragma mark - getter
- (MKCGDeviceModel *)deviceModel {
    if (!_deviceModel) {
        _deviceModel = [[MKCGDeviceModel alloc] init];
    }
    return _deviceModel;
}

@end
