//
//  Target_Commure_ch_Module.m
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/2/16.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "Target_Commure_ch_Module.h"

#import "MKCHDeviceListController.h"

@implementation Target_Commure_ch_Module

- (UIViewController *)Action_Commure_ch_DeviceListPage:(NSDictionary *)params {
    MKCHDeviceListController *vc = [[MKCHDeviceListController alloc] init];
    vc.connectServer = YES;
    return vc;
}

@end
