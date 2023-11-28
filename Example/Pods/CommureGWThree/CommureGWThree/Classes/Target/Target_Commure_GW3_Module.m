//
//  Target_Commure_GW3_Module.m
//  CommureGWThree_Example
//
//  Created by aa on 2023/2/16.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "Target_Commure_GW3_Module.h"

#import "MKCFDeviceListController.h"

@implementation Target_Commure_GW3_Module

- (UIViewController *)Action_Commure_GW3_DeviceListPage:(NSDictionary *)params {
    MKCFDeviceListController *vc = [[MKCFDeviceListController alloc] init];
    vc.connectServer = YES;
    return vc;
}

@end
