//
//  MKCFBleBaseController.m
//  CommureGWThree_Example
//
//  Created by aa on 2023/3/3.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCFBleBaseController.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"

#import "MKCFCentralManager.h"

@interface MKCFBleBaseController ()

@end

@implementation MKCFBleBaseController

- (void)dealloc {
    NSLog(@"MKCFBleBaseController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceConnectStateChanged)
                                                 name:mk_cf_peripheralConnectStateChangedNotification
                                               object:nil];
}

#pragma mark - note
- (void)deviceConnectStateChanged {
    if ([MKCFCentralManager shared].connectStatus == mk_cf_centralConnectStatusConnected) {
        return;
    }
    if (![MKBaseViewController isCurrentViewControllerVisible:self]) {
        return;
    }
    [self.view showCentralToast:@"Device disconnect!"];
    [self performSelector:@selector(gotoScanPage) withObject:nil afterDelay:0.5f];
}

#pragma mark - private method
- (void)gotoScanPage {
    [self popToViewControllerWithClassName:@"MKCFScanPageController"];
}

@end
