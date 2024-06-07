//
//  MKCGBatchDfuBeaconHeaderView.m
//  CommureGateway_Example
//
//  Created by aa on 2023/4/21.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCGBatchDfuBeaconHeaderView.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"
#import "NSString+MKAdd.h"

#import "MKTextField.h"

static NSString *defaultFirmwareUrl = @"http://47.104.172.169:8080/updata_fold/CommureTag_V1.0.4.bin";
static NSString *defaultInitDataUrl = @"http://47.104.172.169:8080/updata_fold/CommureTag_V1.0.4.dat";

@interface MKCGBatchDfuBeaconHeaderView ()

@property (nonatomic, strong)UILabel *firmwareLabel;

@property (nonatomic, strong)MKTextField *firmwareTextField;

@property (nonatomic, strong)UILabel *dataFileLabel;

@property (nonatomic, strong)MKTextField *dataTextField;

@property (nonatomic, strong)UILabel *passwordFileLabel;

@property (nonatomic, strong)MKTextField *passwordTextField;

@property (nonatomic, strong)UILabel *listLabel;

@property (nonatomic, strong)UIButton *excelButton;

@property (nonatomic, strong)UIButton *scanButton;

@property (nonatomic, strong)UILabel *macLabel;

@property (nonatomic, strong)UILabel *statusLabel;

@end

@implementation MKCGBatchDfuBeaconHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.firmwareLabel];
        [self addSubview:self.firmwareTextField];
        [self addSubview:self.dataFileLabel];
        [self addSubview:self.dataTextField];
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
    [self.firmwareTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.firmwareLabel.mas_right).mas_offset(10.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(15.f);
        make.height.mas_equalTo(25.f);
    }];
    [self.firmwareLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(120.f);
        make.centerY.mas_equalTo(self.firmwareTextField.mas_centerY);
        make.height.mas_equalTo(MKFont(14.f).lineHeight);
    }];
    [self.dataTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.dataFileLabel.mas_right).mas_offset(10.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.firmwareTextField.mas_bottom).mas_offset(15.f);
        make.height.mas_equalTo(25.f);
    }];
    [self.dataFileLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(120.f);
        make.centerY.mas_equalTo(self.dataTextField.mas_centerY);
        make.height.mas_equalTo(MKFont(14.f).lineHeight);
    }];
    [self.passwordTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.dataFileLabel.mas_right).mas_offset(10.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.dataTextField.mas_bottom).mas_offset(15.f);
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
- (UILabel *)firmwareLabel {
    if (!_firmwareLabel) {
        _firmwareLabel = [[UILabel alloc] init];
        _firmwareLabel.textColor = DEFAULT_TEXT_COLOR;
        _firmwareLabel.textAlignment = NSTextAlignmentLeft;
        _firmwareLabel.font = MKFont(14.f);
        _firmwareLabel.text = @"Firmware file URL";
    }
    return _firmwareLabel;
}

- (MKTextField *)firmwareTextField {
    if (!_firmwareTextField) {
        _firmwareTextField = [[MKTextField alloc] initWithTextFieldType:mk_normal];
//        _firmwareTextField.text = defaultFirmwareUrl;
        _firmwareTextField.placeholder = @"1-256 Characters";
        @weakify(self);
        _firmwareTextField.textChangedBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(cg_firmwareUrlChanged:)]) {
                [self.delegate cg_firmwareUrlChanged:text];
            }
        };
        _firmwareTextField.textColor = DEFAULT_TEXT_COLOR;
        _firmwareTextField.textAlignment = NSTextAlignmentLeft;
        _firmwareTextField.maxLength = 256;
        _firmwareTextField.font = MKFont(13.f);
        
        _firmwareTextField.layer.masksToBounds = YES;
        _firmwareTextField.layer.borderColor = CUTTING_LINE_COLOR.CGColor;
        _firmwareTextField.layer.borderWidth = CUTTING_LINE_HEIGHT;
        _firmwareTextField.layer.cornerRadius = 6;
    }
    return _firmwareTextField;
}

- (UILabel *)dataFileLabel {
    if (!_dataFileLabel) {
        _dataFileLabel = [[UILabel alloc] init];
        _dataFileLabel.textColor = DEFAULT_TEXT_COLOR;
        _dataFileLabel.textAlignment = NSTextAlignmentLeft;
        _dataFileLabel.font = MKFont(14.f);
        _dataFileLabel.text = @"Init data file URL";
    }
    return _dataFileLabel;
}

- (MKTextField *)dataTextField {
    if (!_dataTextField) {
        _dataTextField = [[MKTextField alloc] initWithTextFieldType:mk_normal];
//        _dataTextField.text = defaultInitDataUrl;
        _dataTextField.placeholder = @"1-256 Characters";
        @weakify(self);
        _dataTextField.textChangedBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(cg_dataFileUrlChanged:)]) {
                [self.delegate cg_dataFileUrlChanged:text];
            }
        };
        _dataTextField.textColor = DEFAULT_TEXT_COLOR;
        _dataTextField.textAlignment = NSTextAlignmentLeft;
        _dataTextField.maxLength = 256;
        _dataTextField.font = MKFont(13.f);
        
        _dataTextField.layer.masksToBounds = YES;
        _dataTextField.layer.borderColor = CUTTING_LINE_COLOR.CGColor;
        _dataTextField.layer.borderWidth = CUTTING_LINE_HEIGHT;
        _dataTextField.layer.cornerRadius = 6;
    }
    return _dataTextField;
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
        [_excelButton setImage:LOADICON(@"CommureGateway", @"MKCGBatchDfuBeaconHeaderView", @"cg_batchOtaListSelectIcon.png") forState:UIControlStateNormal];
        [_excelButton addTarget:self
                         action:@selector(excelButtonPressed)
               forControlEvents:UIControlEventTouchUpInside];
    }
    return _excelButton;
}

- (UIButton *)scanButton {
    if (!_scanButton) {
        _scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_scanButton setImage:LOADICON(@"CommureGateway", @"MKCGBatchDfuBeaconHeaderView", @"cg_batchOtaQRCodeIcon.png") forState:UIControlStateNormal];
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
