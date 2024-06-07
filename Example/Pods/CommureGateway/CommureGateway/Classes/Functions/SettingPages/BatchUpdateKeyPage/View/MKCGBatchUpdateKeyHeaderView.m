//
//  MKCGBatchUpdateKeyHeaderView.m
//  CommureGateway_Example
//
//  Created by aa on 2023/4/21.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCGBatchUpdateKeyHeaderView.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"
#import "NSString+MKAdd.h"

#import "MKTextField.h"

@interface MKCGBatchUpdateKeyHeaderView ()

@property (nonatomic, strong)UILabel *keyLabel;

@property (nonatomic, strong)MKTextField *keyTextField;

@property (nonatomic, strong)UILabel *passwordFileLabel;

@property (nonatomic, strong)MKTextField *passwordTextField;

@property (nonatomic, strong)UILabel *listLabel;

@property (nonatomic, strong)UIButton *excelButton;

@property (nonatomic, strong)UIButton *scanButton;

@property (nonatomic, strong)UILabel *macLabel;

@property (nonatomic, strong)UILabel *statusLabel;

@end

@implementation MKCGBatchUpdateKeyHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.keyLabel];
        [self addSubview:self.keyTextField];
        [self addSubview:self.passwordFileLabel];
        [self addSubview:self.passwordTextField];
        [self addSubview:self.listLabel];
        [self addSubview:self.excelButton];
        [self addSubview:self.scanButton];
        [self addSubview:self.macLabel];
        [self addSubview:self.statusLabel];
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
    [self.passwordTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.keyLabel.mas_right).mas_offset(10.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.keyTextField.mas_bottom).mas_offset(15.f);
        make.height.mas_equalTo(25.f);
    }];
    [self.passwordFileLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(120.f);
        make.centerY.mas_equalTo(self.passwordTextField.mas_centerY);
        make.height.mas_equalTo(MKFont(14.f).lineHeight);
    }];
    [self.scanButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(30.f);
        make.top.mas_equalTo(self.passwordTextField.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.excelButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.scanButton.mas_left).mas_offset(-10.f);
        make.width.mas_equalTo(45.f);
        make.centerY.mas_equalTo(self.scanButton.mas_centerY);
        make.height.mas_equalTo(30.f);
    }];
    [self.listLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(110.f);
        make.centerY.mas_equalTo(self.scanButton.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-75.f);
        make.width.mas_equalTo(60.f);
        make.top.mas_equalTo(self.scanButton.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.macLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(110.f);
        make.centerY.mas_equalTo(self.statusLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
}

#pragma mark - event method
- (void)excelButtonPressed {
    if ([self.delegate respondsToSelector:@selector(cg_beaconListButtonPressed)]) {
        [self.delegate cg_beaconListButtonPressed];
    }
}

- (void)scanButtonPressed {
    if ([self.delegate respondsToSelector:@selector(cg_scanCodeButtonPressed)]) {
        [self.delegate cg_scanCodeButtonPressed];
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
        _keyTextField = [[MKTextField alloc] initWithTextFieldType:mk_hexCharOnly];
        @weakify(self);
        _keyTextField.textChangedBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(cg_encryptionKeyChanged:)]) {
                [self.delegate cg_encryptionKeyChanged:text];
            }
        };
        _keyTextField.placeholder = @"26 Bytes";
        _keyTextField.textColor = DEFAULT_TEXT_COLOR;
        _keyTextField.textAlignment = NSTextAlignmentLeft;
        _keyTextField.maxLength = 52;
        _keyTextField.font = MKFont(13.f);
        
        _keyTextField.layer.masksToBounds = YES;
        _keyTextField.layer.borderColor = CUTTING_LINE_COLOR.CGColor;
        _keyTextField.layer.borderWidth = CUTTING_LINE_HEIGHT;
        _keyTextField.layer.cornerRadius = 6;
    }
    return _keyTextField;
}

- (UILabel *)passwordFileLabel {
    if (!_passwordFileLabel) {
        _passwordFileLabel = [[UILabel alloc] init];
        _passwordFileLabel.textColor = DEFAULT_TEXT_COLOR;
        _passwordFileLabel.textAlignment = NSTextAlignmentLeft;
        _passwordFileLabel.font = MKFont(14.f);
        _passwordFileLabel.text = @"Beacon password";
    }
    return _passwordFileLabel;
}

- (MKTextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [[MKTextField alloc] initWithTextFieldType:mk_normal];
        _passwordTextField.text = @"Commure4321";
        @weakify(self);
        _passwordTextField.textChangedBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(cg_dataPasswordChanged:)]) {
                [self.delegate cg_dataPasswordChanged:text];
            }
        };
        _passwordTextField.textColor = DEFAULT_TEXT_COLOR;
        _passwordTextField.textAlignment = NSTextAlignmentLeft;
        _passwordTextField.maxLength = 16;
        _passwordTextField.font = MKFont(13.f);
        _passwordTextField.placeholder = @"0-16 Characters";
        
        _passwordTextField.layer.masksToBounds = YES;
        _passwordTextField.layer.borderColor = CUTTING_LINE_COLOR.CGColor;
        _passwordTextField.layer.borderWidth = CUTTING_LINE_HEIGHT;
        _passwordTextField.layer.cornerRadius = 6;
    }
    return _passwordTextField;
}

- (UILabel *)listLabel {
    if (!_listLabel) {
        _listLabel = [self loadLabelWithMsg:@"Beacon list"];
    }
    return _listLabel;
}

- (UIButton *)excelButton {
    if (!_excelButton) {
        _excelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_excelButton setImage:LOADICON(@"CommureGateway", @"MKCGBatchUpdateKeyHeaderView", @"cg_batchOtaListSelectIcon.png") forState:UIControlStateNormal];
        [_excelButton addTarget:self
                         action:@selector(excelButtonPressed)
               forControlEvents:UIControlEventTouchUpInside];
    }
    return _excelButton;
}

- (UIButton *)scanButton {
    if (!_scanButton) {
        _scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_scanButton setImage:LOADICON(@"CommureGateway", @"MKCGBatchUpdateKeyHeaderView", @"cg_batchOtaQRCodeIcon.png") forState:UIControlStateNormal];
        [_scanButton addTarget:self
                        action:@selector(scanButtonPressed)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _scanButton;
}

- (UILabel *)macLabel {
    if (!_macLabel) {
        _macLabel = [self loadLabelWithMsg:@"Beacon Mac"];
    }
    return _macLabel;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [self loadLabelWithMsg:@"Status"];
    }
    return _statusLabel;
}


- (UILabel *)loadLabelWithMsg:(NSString *)msg {
    UILabel *tempLabel = [[UILabel alloc] init];
    tempLabel.textColor = DEFAULT_TEXT_COLOR;
    tempLabel.font = MKFont(15.f);
    tempLabel.textAlignment = NSTextAlignmentLeft;
    tempLabel.text = msg;
    return tempLabel;
}

@end
