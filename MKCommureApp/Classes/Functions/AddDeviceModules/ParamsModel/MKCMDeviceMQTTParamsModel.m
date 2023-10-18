//
//  MKCMDeviceMQTTParamsModel.m
//  MKCommureApp_Example
//
//  Created by aa on 2023/1/29.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCMDeviceMQTTParamsModel.h"

#import "MKCMDeviceModel.h"

static MKCMDeviceMQTTParamsModel *paramsModel = nil;
static dispatch_once_t onceToken;

@implementation MKCMDeviceMQTTParamsModel

+ (MKCMDeviceMQTTParamsModel *)shared {
    dispatch_once(&onceToken, ^{
        if (!paramsModel) {
            paramsModel = [MKCMDeviceMQTTParamsModel new];
        }
    });
    return paramsModel;
}

+ (void)sharedDealloc {
    paramsModel = nil;
    onceToken = 0;
}

#pragma mark - getter
- (MKCMDeviceModel *)deviceModel {
    if (!_deviceModel) {
        _deviceModel = [[MKCMDeviceModel alloc] init];
    }
    return _deviceModel;
}

@end
