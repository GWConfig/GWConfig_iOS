//
//  MKCFDeviceMQTTParamsModel.m
//  CommureGWThree_Example
//
//  Created by aa on 2023/1/29.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCFDeviceMQTTParamsModel.h"

#import "MKCFDeviceModel.h"

static MKCFDeviceMQTTParamsModel *paramsModel = nil;
static dispatch_once_t onceToken;

@implementation MKCFDeviceMQTTParamsModel

+ (MKCFDeviceMQTTParamsModel *)shared {
    dispatch_once(&onceToken, ^{
        if (!paramsModel) {
            paramsModel = [MKCFDeviceMQTTParamsModel new];
        }
    });
    return paramsModel;
}

+ (void)sharedDealloc {
    paramsModel = nil;
    onceToken = 0;
}

#pragma mark - getter
- (MKCFDeviceModel *)deviceModel {
    if (!_deviceModel) {
        _deviceModel = [[MKCFDeviceModel alloc] init];
    }
    return _deviceModel;
}

@end
