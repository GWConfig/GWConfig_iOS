//
//  MKCGFilterTestAlert.m
//  CommureGateway_Example
//
//  Created by aa on 2023/6/26.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCGFilterTestAlert.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"
#import "UIView+MKAdd.h"

#import "MKCustomUIAdopter.h"
#import "MKTextField.h"

static CGFloat const centerViewOffsetX = 50.f;
static CGFloat const buttonHeight = 45.f;
static CGFloat const textFieldHeight = 30.f;

@interface MKCGFilterTestAlert ()

@property (nonatomic, strong)UIView *centerView;

@property (nonatomic, strong)UILabel *durationLabel;

@property (nonatomic, strong)MKTextField *durationField;

@property (nonatomic, strong)UILabel *statusLabel;

@property (nonatomic, strong)MKTextField *statusField;

@property (nonatomic, strong)UIView *horizontalLine;

@property (nonatomic, strong)UIView *verticalLine;

@property (nonatomic, strong)UIButton *cancelButton;

@property (nonatomic, strong)UIButton *confirmButton;

@property (nonatomic, copy)void (^confirmBlock)(NSString *duration,NSString *alarmStatus);

@end

@implementation MKCGFilterTestAlert

- (void)dealloc {
    NSLog(@"MKCGFilterTestAlert销毁");
}

- (instancetype)init{
    if (self = [super init]) {
        self.frame = kAppWindow.bounds;
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0.3);
        [self addSubview:self.centerView];
        
        [self.centerView addSubview:self.durationLabel];
        [self.centerView addSubview:self.durationField];
        [self.centerView addSubview:self.statusLabel];
        [self.centerView addSubview:self.statusField];
        [self.centerView addSubview:self.horizontalLine];
        [self.centerView addSubview:self.verticalLine];
        [self.centerView addSubview:self.cancelButton];
        [self.centerView addSubview:self.confirmButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.centerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(centerViewOffsetX);
        make.right.mas_equalTo(-centerViewOffsetX);
        make.centerY.mas_equalTo(self.mas_centerY).mas_offset(-90.f);
        make.height.mas_equalTo(150.f);
    }];
    [self.durationField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(130.f);
        make.top.mas_equalTo(15.f);
        make.height.mas_equalTo(textFieldHeight);
    }];
    [self.durationLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.durationField.mas_left).mas_offset(-5.f);
        make.centerY.mas_equalTo(self.durationField.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.statusField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(130.f);
        make.top.mas_equalTo(self.durationField.mas_bottom).mas_offset(15.f);
        make.height.mas_equalTo(textFieldHeight);
    }];
    [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.statusField.mas_left).mas_offset(-5.f);
        make.centerY.mas_equalTo(self.statusField.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.horizontalLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.cancelButton.mas_top);
        make.height.mas_equalTo(CUTTING_LINE_HEIGHT);
    }];
    [self.verticalLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.centerView.mas_centerX);
        make.width.mas_equalTo(CUTTING_LINE_HEIGHT);
        make.top.mas_equalTo(self.horizontalLine.mas_bottom);
        make.bottom.mas_equalTo(0);
    }];
    [self.cancelButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.verticalLine.mas_left);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(buttonHeight);
    }];
    [self.confirmButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(self.verticalLine.mas_right);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(buttonHeight);
    }];
}

#pragma mark - event method
- (void)cancelButtonPressed {
    [self dismiss];
}

- (void)confirmButtonPressed {
    if (self.confirmBlock) {
        self.confirmBlock(SafeStr(self.durationField.text), SafeStr(self.statusField.text));
    }
    [self dismiss];
}

#pragma mark - public method

- (void)showWithHandler:(void (^)(NSString *duration,NSString *alarmStatus))handler {
    [kAppWindow addSubview:self];
    self.confirmBlock = handler;
}
- (void)dismiss {
    if (self.superview) {
        [self removeFromSuperview];
    }
}

#pragma mark - getter
- (UIView *)centerView {
    if (!_centerView) {
        _centerView = [[UIView alloc] init];
        _centerView.backgroundColor = RGBCOLOR(234, 234, 234);
        
        _centerView.layer.masksToBounds = YES;
        _centerView.layer.cornerRadius = 8.f;
    }
    return _centerView;
}

- (UILabel *)durationLabel {
    if (!_durationLabel) {
        _durationLabel = [[UILabel alloc] init];
        _durationLabel.textAlignment = NSTextAlignmentLeft;
        _durationLabel.textColor = DEFAULT_TEXT_COLOR;
        _durationLabel.font = MKFont(13.f);
        _durationLabel.text = @"Duration";
    }
    return _durationLabel;
}

- (MKTextField *)durationField {
    if (!_durationField) {
        _durationField = [MKCustomUIAdopter customNormalTextFieldWithText:@""
                                                              placeHolder:@"10-600(s)"
                                                                 textType:mk_realNumberOnly];
        _durationField.maxLength = 3;
        @weakify(self);
        _durationField.textChangedBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
        };
    }
    return _durationField;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.textAlignment = NSTextAlignmentLeft;
        _statusLabel.textColor = DEFAULT_TEXT_COLOR;
        _statusLabel.font = MKFont(13.f);
        _statusLabel.text = @"Alarm status";
    }
    return _statusLabel;
}

- (MKTextField *)statusField {
    if (!_statusField) {
        _statusField = [MKCustomUIAdopter customNormalTextFieldWithText:@""
                                                            placeHolder:@"01,02,03"
                                                               textType:mk_realNumberOnly];
        _statusField.maxLength = 2;
        @weakify(self);
        _statusField.textChangedBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
        };
    }
    return _statusField;
}

- (UIView *)horizontalLine {
    if (!_horizontalLine) {
        _horizontalLine = [[UIView alloc] init];
        _horizontalLine.backgroundColor = RGBCOLOR(53, 53, 53);
    }
    return _horizontalLine;
}

- (UIView *)verticalLine {
    if (!_verticalLine) {
        _verticalLine = [[UIView alloc] init];
        _verticalLine.backgroundColor = RGBCOLOR(53, 53, 53);
    }
    return _verticalLine;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [self loadButtonWithTitle:@"Cancel" selector:@selector(cancelButtonPressed)];
    }
    return _cancelButton;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [self loadButtonWithTitle:@"Confirm" selector:@selector(confirmButtonPressed)];
    }
    return _confirmButton;
}

- (UIButton *)loadButtonWithTitle:(NSString *)title selector:(SEL)selector{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:COLOR_BLUE_MARCROS forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:18.f]];
    [button addTarget:self
               action:selector
     forControlEvents:UIControlEventTouchUpInside];
    return button;
}

@end
