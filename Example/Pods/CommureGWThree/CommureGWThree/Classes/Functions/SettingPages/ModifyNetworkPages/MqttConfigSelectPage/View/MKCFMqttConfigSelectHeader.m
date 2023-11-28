//
//  MKCFMqttConfigSelectHeader.m
//  CommureGWThree_Example
//
//  Created by aa on 2023/11/22.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import "MKCFMqttConfigSelectHeader.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"

#import "MKTextField.h"
#import "MKCustomUIAdopter.h"

@interface MKCFMqttConfigSelectHeaderButton : UIControl

@property (nonatomic, strong)UIImageView *icon;

@property (nonatomic, strong)UILabel *msgLabel;

@end

@implementation MKCFMqttConfigSelectHeaderButton

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
        make.left.mas_equalTo(self.icon.mas_right).mas_offset(3.f);
        make.right.mas_equalTo(-2.f);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
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
        _msgLabel.font = MKFont(13.f);
    }
    return _msgLabel;
}

@end

@interface MKCFMqttConfigSelectHeader ()

@property (nonatomic, strong)MKCFMqttConfigSelectHeaderButton *cloudButton;

@property (nonatomic, strong)MKCFMqttConfigSelectHeaderButton *manualButton;

@property (nonatomic, strong)MKTextField *textField;

@property (nonatomic, assign)NSInteger selectedIndex;

@end

@implementation MKCFMqttConfigSelectHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.cloudButton];
        [self addSubview:self.manualButton];
        [self addSubview:self.textField];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.cloudButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(15.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.manualButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.cloudButton.mas_bottom).mas_offset(15.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.manualButton.mas_bottom).mas_offset(30.f);
        make.height.mas_equalTo(30.f);
    }];
}

#pragma mark - event method
- (void)cloudButtonPressed {
    if (self.selectedIndex == 0) {
        return;
    }
    self.selectedIndex = 0;
    [self updateUI];
}

- (void)manualButtonPressed {
    if (self.selectedIndex == 1) {
        return;
    }
    self.selectedIndex = 1;
    [self updateUI];
}

#pragma mark - public method
- (void)updateUrl:(NSString *)url {
    self.textField.text = SafeStr(url);
}

#pragma mark - private method
- (void)updateUI {
    self.textField.hidden = (self.selectedIndex == 1);
    if ([self.delegate respondsToSelector:@selector(cf_mqttConfigSelectHeaderButtonPressed:)]) {
        [self.delegate cf_mqttConfigSelectHeaderButtonPressed:self.selectedIndex];
    }
    if (self.selectedIndex == 0) {
        self.cloudButton.icon.image = LOADICON(@"CommureGWThree", @"MKCFMqttConfigSelectHeader", @"cf_resetByButtonSelectedIcon.png");
        self.manualButton.icon.image = LOADICON(@"CommureGWThree", @"MKCFMqttConfigSelectHeader", @"cf_resetByButtonUnselectedIcon.png");
        return;
    }
    self.cloudButton.icon.image = LOADICON(@"CommureGWThree", @"MKCFMqttConfigSelectHeader", @"cf_resetByButtonUnselectedIcon.png");
    self.manualButton.icon.image = LOADICON(@"CommureGWThree", @"MKCFMqttConfigSelectHeader", @"cf_resetByButtonSelectedIcon.png");
}

#pragma mark - getter
- (MKCFMqttConfigSelectHeaderButton *)cloudButton {
    if (!_cloudButton) {
        _cloudButton = [[MKCFMqttConfigSelectHeaderButton alloc] init];
        _cloudButton.icon.image = LOADICON(@"CommureGWThree", @"MKCFMqttConfigSelectHeader", @"cf_resetByButtonSelectedIcon.png");
        _cloudButton.msgLabel.text = @"Import Config File - Cloud";
        [_cloudButton addTarget:self
                         action:@selector(cloudButtonPressed)
               forControlEvents:UIControlEventTouchUpInside];
    }
    return _cloudButton;
}

- (MKCFMqttConfigSelectHeaderButton *)manualButton {
    if (!_manualButton) {
        _manualButton = [[MKCFMqttConfigSelectHeaderButton alloc] init];
        _manualButton.icon.image = LOADICON(@"CommureGWThree", @"MKCFMqttConfigSelectHeader", @"cf_resetByButtonUnselectedIcon.png");
        _manualButton.msgLabel.text = @"Manual setting";
        [_manualButton addTarget:self
                          action:@selector(manualButtonPressed)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _manualButton;
}

- (MKTextField *)textField {
    if (!_textField) {
        _textField = [MKCustomUIAdopter customNormalTextFieldWithText:@"" 
                                                          placeHolder:@"Please input URL link here"
                                                             textType:mk_normal];
        @weakify(self);
        _textField.textChangedBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(cf_mqttConfigSelectHeaderUrlChanged:)]) {
                [self.delegate cf_mqttConfigSelectHeaderUrlChanged:text];
            }
        };
    }
    return _textField;
}

@end
