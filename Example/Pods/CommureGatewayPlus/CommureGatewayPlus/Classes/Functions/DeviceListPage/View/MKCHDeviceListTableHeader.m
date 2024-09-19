//
//  MKCHDeviceListTableHeader.m
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/12/14.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import "MKCHDeviceListTableHeader.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

@interface MKCHDeviceListTableHeaderButton : UIControl

@property (nonatomic, strong)UIImageView *icon;

@property (nonatomic, strong)UILabel *msgLabel;

@end

@implementation MKCHDeviceListTableHeaderButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.icon];
        [self addSubview:self.msgLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.icon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(2.f);
        make.width.mas_equalTo(13.f);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(13.f);
    }];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.icon.mas_right).mas_offset(2.f);
        make.right.mas_equalTo(-2.f);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
}

#pragma mark - getter
- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
    }
    return _icon;
}

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.font = MKFont(15.f);
    }
    return _msgLabel;
}

@end



@interface MKCHDeviceListTableHeader ()

@property (nonatomic, strong)MKCHDeviceListTableHeaderButton *allButton;

@property (nonatomic, strong)MKCHDeviceListTableHeaderButton *onlineButton;

@property (nonatomic, assign)NSInteger selectedIndex;

@property (nonatomic, strong)UIView *lineView;

@end

@implementation MKCHDeviceListTableHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.allButton];
        [self addSubview:self.onlineButton];
        [self addSubview:self.lineView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.allButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30.f);
        make.width.mas_equalTo(80.f);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(30.f);
    }];
    [self.onlineButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.allButton.mas_right).mas_offset(40.f);
        make.width.mas_equalTo(80.f);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(30.f);
    }];
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(CUTTING_LINE_HEIGHT);
    }];
}

#pragma mark - event method
- (void)allButtonPressed {
    if (self.selectedIndex == 0) {
        return;
    }
    self.selectedIndex = 0;
    self.allButton.icon.image = LOADICON(@"CommureGatewayPlus", @"MKCHDeviceListTableHeader", @"ch_resetByButtonSelectedIcon.png");
    self.onlineButton.icon.image = LOADICON(@"CommureGatewayPlus", @"MKCHDeviceListTableHeader", @"ch_resetByButtonUnselectedIcon.png");
    if ([self.delegate respondsToSelector:@selector(ch_deviceListFilter:)]) {
        [self.delegate ch_deviceListFilter:0];
    }
}

- (void)onlineButtonPressed {
    if (self.selectedIndex == 1) {
        return;
    }
    self.selectedIndex = 1;
    self.allButton.icon.image = LOADICON(@"CommureGatewayPlus", @"MKCHDeviceListTableHeader", @"ch_resetByButtonUnselectedIcon.png");
    self.onlineButton.icon.image = LOADICON(@"CommureGatewayPlus", @"MKCHDeviceListTableHeader", @"ch_resetByButtonSelectedIcon.png");
    if ([self.delegate respondsToSelector:@selector(ch_deviceListFilter:)]) {
        [self.delegate ch_deviceListFilter:1];
    }
}

#pragma mark - getter
- (MKCHDeviceListTableHeaderButton *)allButton {
    if (!_allButton) {
        _allButton = [[MKCHDeviceListTableHeaderButton alloc] init];
        _allButton.icon.image = LOADICON(@"CommureGatewayPlus", @"MKCHDeviceListTableHeader", @"ch_resetByButtonSelectedIcon.png");
        _allButton.msgLabel.text = @"All";
        [_allButton addTarget:self
                       action:@selector(allButtonPressed)
             forControlEvents:UIControlEventTouchUpInside];
    }
    return _allButton;
}

- (MKCHDeviceListTableHeaderButton *)onlineButton {
    if (!_onlineButton) {
        _onlineButton = [[MKCHDeviceListTableHeaderButton alloc] init];
        _onlineButton.icon.image = LOADICON(@"CommureGatewayPlus", @"MKCHDeviceListTableHeader", @"ch_resetByButtonUnselectedIcon.png");
        _onlineButton.msgLabel.text = @"Online";
        [_onlineButton addTarget:self
                          action:@selector(onlineButtonPressed)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _onlineButton;
}

@end
