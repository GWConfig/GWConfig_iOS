//
//  Target_Commure_CG_Module.m
//  CommureGateway_Example
//
//  Created by aa on 2023/2/16.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "Target_Commure_CG_Module.h"

#import "MKCGDeviceListController.h"

@implementation Target_Commure_CG_Module

- (UIViewController *)Action_Commure_CG_DeviceListPage:(NSDictionary *)params {
    MKCGDeviceListController *vc = [[MKCGDeviceListController alloc] init];
    vc.connectServer = YES;
    return vc;
}

@end
