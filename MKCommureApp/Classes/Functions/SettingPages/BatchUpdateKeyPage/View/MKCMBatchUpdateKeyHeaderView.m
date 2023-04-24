//
//  MKCMBatchUpdateKeyHeaderView.m
//  MKCommureApp_Example
//
//  Created by aa on 2023/4/21.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCMBatchUpdateKeyHeaderView.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"
#import "NSString+MKAdd.h"

#import "MKTextField.h"

@interface MKCMBatchUpdateKeyHeaderView ()

@property (nonatomic, strong)UILabel *keyLabel;

@property (nonatomic, strong)MKTextField *keyTextField;

@property (nonatomic, strong)UILabel *beaconLabel;

@property (nonatomic, strong)UIButton *selectedButton;

@property (nonatomic, strong)UILabel *macLabel;

@property (nonatomic, strong)UILabel *passwordLabel;

@end

@implementation MKCMBatchUpdateKeyHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.keyLabel];
        [self addSubview:self.keyTextField];
        [self addSubview:self.beaconLabel];
        [self addSubview:self.selectedButton];
        [self addSubview:self.macLabel];
        [self addSubview:self.passwordLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.keyTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.keyLabel.mas_right).mas_offset(10.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(15.f);
        make.height.mas_equalTo(25.f);
    }];
    [self.keyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(120.f);
        make.centerY.mas_equalTo(self.keyTextField.mas_centerY);
        make.height.mas_equalTo(MKFont(14.f).lineHeight);
    }];
    [self.selectedButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(40.f);
        make.top.mas_equalTo(self.keyTextField.mas_bottom).mas_offset(15.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.beaconLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.selectedButton.mas_left).mas_offset(-15.f);
        make.centerY.mas_equalTo(self.selectedButton.mas_centerY);
        make.height.mas_equalTo(MKFont(14.f).lineHeight);
    }];
    [self.macLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.mas_centerX).mas_offset(-5.f);
        make.top.mas_equalTo(self.selectedButton.mas_bottom).mas_offset(15.f);
        make.height.mas_equalTo(MKFont(14.f).lineHeight);
    }];
    [self.passwordLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.left.mas_equalTo(self.mas_centerX).mas_offset(5.f);
        make.top.mas_equalTo(self.selectedButton.mas_bottom).mas_offset(15.f);
        make.height.mas_equalTo(MKFont(14.f).lineHeight);
    }];
}

#pragma mark - event method
- (void)selectedButtonPressed {
    if ([self.delegate respondsToSelector:@selector(cm_beaconListButtonPressed)]) {
        [self.delegate cm_beaconListButtonPressed];
    }
}

#pragma mark - getter
- (UILabel *)keyLabel {
    if (!_keyLabel) {
        _keyLabel = [[UILabel alloc] init];
        _keyLabel.textColor = DEFAULT_TEXT_COLOR;
        _keyLabel.textAlignment = NSTextAlignmentLeft;
        _keyLabel.font = MKFont(14.f);
        _keyLabel.text = @"Encryption key";
    }
    return _keyLabel;
}

- (MKTextField *)keyTextField {
    if (!_keyTextField) {
        _keyTextField = [[MKTextField alloc] initWithTextFieldType:mk_normal];
        @weakify(self);
        _keyTextField.textChangedBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(cm_keyUrlChanged:)]) {
                [self.delegate cm_encryptionKeyChanged:text];
            }
        };
        _keyTextField.textColor = DEFAULT_TEXT_COLOR;
        _keyTextField.textAlignment = NSTextAlignmentLeft;
        _keyTextField.maxLength = 256;
        _keyTextField.font = MKFont(13.f);
        
        _keyTextField.layer.masksToBounds = YES;
        _keyTextField.layer.borderColor = CUTTING_LINE_COLOR.CGColor;
        _keyTextField.layer.borderWidth = CUTTING_LINE_HEIGHT;
        _keyTextField.layer.cornerRadius = 6;
    }
    return _keyTextField;
}

- (UILabel *)beaconLabel {
    if (!_beaconLabel) {
        _beaconLabel = [[UILabel alloc] init];
        _beaconLabel.textColor = DEFAULT_TEXT_COLOR;
        _beaconLabel.textAlignment = NSTextAlignmentLeft;
        _beaconLabel.font = MKFont(14.f);
        _beaconLabel.text = @"Beacon list";
    }
    return _beaconLabel;
}

- (UIButton *)selectedButton {
    if (!_selectedButton) {
        _selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectedButton setImage:LOADICON(@"MKCommureApp", @"MKCMBatchUpdateKeyHeaderView", @"cm_config_certAddIcon.png") forState:UIControlStateNormal];
        [_selectedButton addTarget:self
                            action:@selector(selectedButtonPressed)
                  forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectedButton;
}

- (UILabel *)macLabel {
    if (!_macLabel) {
        _macLabel = [[UILabel alloc] init];
        _macLabel.textColor = DEFAULT_TEXT_COLOR;
        _macLabel.textAlignment = NSTextAlignmentLeft;
        _macLabel.font = MKFont(14.f);
        _macLabel.text = @"MAC";
    }
    return _macLabel;
}

- (UILabel *)passwordLabel {
    if (!_passwordLabel) {
        _passwordLabel = [[UILabel alloc] init];
        _passwordLabel.textColor = DEFAULT_TEXT_COLOR;
        _passwordLabel.textAlignment = NSTextAlignmentRight;
        _passwordLabel.font = MKFont(14.f);
        _passwordLabel.text = @"Password";
    }
    return _passwordLabel;
}

@end
