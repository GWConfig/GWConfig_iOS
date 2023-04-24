//
//  MKCMTestController.m
//  MKCommureApp_Example
//
//  Created by aa on 2023/4/19.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCMTestController.h"

#import "Masonry.h"

#import "MKCustomUIAdopter.h"

#import "MKCMDeviceListController.h"

@interface MKCMTestController ()

@end

@implementation MKCMTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.defaultTitle = @"Commure";
    self.leftButton.hidden = YES;
    UIButton *button = [MKCustomUIAdopter customButtonWithTitle:@"Commure"
                                                         target:self
                                                         action:@selector(pushRemoteGatewayPage)];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(150.f);
        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.height.mas_equalTo(40.f);
    }];
}

- (void)pushRemoteGatewayPage {
    MKCMDeviceListController *vc = [[MKCMDeviceListController alloc] init];
    vc.connectServer = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
