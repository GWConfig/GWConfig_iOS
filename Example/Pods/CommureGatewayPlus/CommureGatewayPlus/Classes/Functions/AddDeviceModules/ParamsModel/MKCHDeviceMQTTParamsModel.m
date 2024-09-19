//
//  MKCHDeviceMQTTParamsModel.m
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/1/29.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCHDeviceMQTTParamsModel.h"

#import "MKCHDeviceModel.h"

static MKCHDeviceMQTTParamsModel *paramsModel = nil;
static dispatch_once_t onceToken;

@implementation MKCHDeviceMQTTParamsModel

+ (MKCHDeviceMQTTParamsModel *)shared {
    dispatch_once(&onceToken, ^{
        if (!paramsModel) {
            paramsModel = [MKCHDeviceMQTTParamsModel new];
        }
    });
    return paramsModel;
}

+ (void)sharedDealloc {
    paramsModel = nil;
    onceToken = 0;
}

#pragma mark - getter
- (MKCHDeviceModel *)deviceModel {
    if (!_deviceModel) {
        _deviceModel = [[MKCHDeviceModel alloc] init];
    }
    return _deviceModel;
}

@end
