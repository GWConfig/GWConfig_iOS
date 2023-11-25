//
//  MKCGAboutController.m
//  CommureGateway_Example
//
//  Created by aa on 2023/4/25.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCGAboutController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"

#import "MKCustomUIAdopter.h"

#import "MKCGAppLogController.h"

@interface MKCGAboutController ()

@property (nonatomic, strong)UIImageView *aboutIcon;

@property (nonatomic, strong)UILabel *versionLabel;

@property (nonatomic, strong)UIButton *feedButton;

@end

@implementation MKCGAboutController

- (void)dealloc {
    NSLog(@"MKCGAboutController销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
}

#pragma mark - event method
- (void)feedButtonPressed {
    MKCGAppLogController *vc = [[MKCGAppLogController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - private method
- (void)loadSubViews {
    self.defaultTitle = @"About APP";
    [self.view addSubview:self.aboutIcon];
    [self.view addSubview:self.versionLabel];
    [self.view addSubview:self.feedButton];
    
    [self.aboutIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(110.f);
        make.top.mas_equalTo(defaultTopInset + 40.f);
        make.height.mas_equalTo(110.f);
    }];
    [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.aboutIcon.mas_bottom).mas_offset(17.f);
        make.height.mas_equalTo(MKFont(16.f).lineHeight);
    }];
    [self.feedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.top.mas_equalTo(self.versionLabel.mas_bottom).mas_offset(50.f);
        make.height.mas_equalTo(35.f);
    }];
}

#pragma mark - getter
- (UIImageView *)aboutIcon {
    if (!_aboutIcon) {
        _aboutIcon = [[UIImageView alloc] init];
        _aboutIcon.image = LOADICON(@"CommureGateway", @"MKCGAboutController", @"cg_deviceList_centerIcon.png");
    }
    return _aboutIcon;
}

- (UILabel *)versionLabel {
    if (!_versionLabel) {
        _versionLabel = [[UILabel alloc] init];
        _versionLabel.textColor = RGBCOLOR(189, 189, 189);
        _versionLabel.textAlignment = NSTextAlignmentCenter;
        _versionLabel.font = MKFont(16.f);
        _versionLabel.text = @"Version: V1.0.0";
    }
    return _versionLabel;
}

- (UIButton *)feedButton {
    if (!_feedButton) {
        _feedButton = [MKCustomUIAdopter customButtonWithTitle:@"Feedback log"
                                                        target:self
                                                        action:@selector(feedButtonPressed)];
    }
    return _feedButton;
}

@end
