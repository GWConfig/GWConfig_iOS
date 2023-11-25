//
//  MKCGBaseViewController.m
//  CommureGateway_Example
//
//  Created by aa on 2023/1/29.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCGBaseViewController.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"

#import "MKCGDeviceModeManager.h"
#import "MKCGDeviceModel.h"

#import "MKCGMQTTDataManager.h"

@interface MKCGBaseViewController ()

@end

@implementation MKCGBaseViewController

- (void)dealloc {
    NSLog(@"MKCGBaseViewController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNotifications];
}

#pragma mark - note
- (void)deviceOffline:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user) || !ValidStr(user[@"macAddress"])) {
        return;
    }
    [self processOfflineWithMacAddress:user[@"macAddress"]];
}

- (void)deviceResetByButton:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user) || !ValidStr(user[@"device_info"][@"mac"])) {
        return;
    }
    [self processOfflineWithMacAddress:user[@"device_info"][@"mac"]];
}

#pragma mark - Private method
- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOffline:)
                                                 name:MKCGDeviceModelOfflineNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceResetByButton:)
                                                 name:MKCGReceiveDeviceResetByButtonNotification
                                               object:nil];
}

- (void)processOfflineWithMacAddress:(NSString *)macAddress {
    if (![macAddress isEqualToString:[MKCGDeviceModeManager shared].macAddress] || ![MKBaseViewController isCurrentViewControllerVisible:self]) {
        return;
    }
    //让setting页面推出的alert消失
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_cg_needDismissAlert" object:nil];
    //让所有MKPickView消失
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_customUIModule_dismissPickView" object:nil];
    [self.view showCentralToast:@"device is off-line"];
    [self performSelector:@selector(gobackToListView) withObject:nil afterDelay:1.f];
}

- (void)gobackToListView {
    [self popToViewControllerWithClassName:@"MKCGDeviceListController"];
}

@end
