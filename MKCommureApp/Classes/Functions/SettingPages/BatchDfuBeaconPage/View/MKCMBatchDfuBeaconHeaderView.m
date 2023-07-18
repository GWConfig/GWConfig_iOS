//
//  MKCMBatchDfuBeaconHeaderView.m
//  MKCommureApp_Example
//
//  Created by aa on 2023/4/21.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCMBatchDfuBeaconHeaderView.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"
#import "NSString+MKAdd.h"

#import "MKTextField.h"

static NSString *defaultFirmwareUrl = @"http://47.104.172.169:8080/updata_fold/CommureTag_V1.0.4.bin";
static NSString *defaultInitDataUrl = @"http://47.104.172.169:8080/updata_fold/CommureTag_V1.0.4.dat";

@interface MKCMBatchDfuBeaconHeaderView ()

@property (nonatomic, strong)UILabel *firmwareLabel;

@property (nonatomic, strong)MKTextField *firmwareTextField;

@property (nonatomic, strong)UILabel *dataFileLabel;

@property (nonatomic, strong)MKTextField *dataTextField;

@property (nonatomic, strong)UILabel *beaconLabel;

@property (nonatomic, strong)UIButton *selectedButton;

@property (nonatomic, strong)UILabel *macLabel;

@property (nonatomic, strong)UILabel *passwordLabel;

@property (nonatomic, strong)UILabel *statusLabel;

@end

@implementation MKCMBatchDfuBeaconHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.firmwareLabel];
        [self addSubview:self.firmwareTextField];
        [self addSubview:self.dataFileLabel];
        [self addSubview:self.dataTextField];
        [self addSubview:self.beaconLabel];
        [self addSubview:self.selectedButton];
        [self addSubview:self.macLabel];
        [self addSubview:self.passwordLabel];
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
    [self.selectedButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(40.f);
        make.top.mas_equalTo(self.dataTextField.mas_bottom).mas_offset(15.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.beaconLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.selectedButton.mas_left).mas_offset(-15.f);
        make.centerY.mas_equalTo(self.selectedButton.mas_centerY);
        make.height.mas_equalTo(MKFont(14.f).lineHeight);
    }];
    [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-75.f);
        make.width.mas_equalTo(60.f);
        make.top.mas_equalTo(self.selectedButton.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.macLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(110.f);
        make.centerY.mas_equalTo(self.statusLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.passwordLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.statusLabel.mas_left).mas_offset(-5.f);
        make.left.mas_equalTo(self.macLabel.mas_right).mas_offset(5.f);
        make.centerY.mas_equalTo(self.statusLabel.mas_centerY);
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
        _firmwareTextField.text = defaultFirmwareUrl;
        @weakify(self);
        _firmwareTextField.textChangedBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(cm_firmwareUrlChanged:)]) {
                [self.delegate cm_firmwareUrlChanged:text];
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
        _dataTextField.text = defaultInitDataUrl;
        @weakify(self);
        _dataTextField.textChangedBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(cm_dataFileUrlChanged:)]) {
                [self.delegate cm_dataFileUrlChanged:text];
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
        [_selectedButton setImage:LOADICON(@"MKCommureApp", @"MKCMBatchDfuBeaconHeaderView", @"cm_config_certAddIcon.png") forState:UIControlStateNormal];
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
        _macLabel.text = @"Beacon Mac";
    }
    return _macLabel;
}

- (UILabel *)passwordLabel {
    if (!_passwordLabel) {
        _passwordLabel = [[UILabel alloc] init];
        _passwordLabel.textColor = DEFAULT_TEXT_COLOR;
        _passwordLabel.textAlignment = NSTextAlignmentCenter;
        _passwordLabel.font = MKFont(14.f);
        _passwordLabel.text = @"Password";
    }
    return _passwordLabel;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.textColor = DEFAULT_TEXT_COLOR;
        _statusLabel.textAlignment = NSTextAlignmentRight;
        _statusLabel.font = MKFont(14.f);
        _statusLabel.text = @"Status";
    }
    return _statusLabel;
}

@end
