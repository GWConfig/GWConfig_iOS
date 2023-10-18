//
//  MKCMFilterTestResultAlert.m
//  MKCommureApp_Example
//
//  Created by aa on 2023/6/27.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCMFilterTestResultAlert.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"
#import "UIView+MKAdd.h"

static CGFloat const centerViewOffsetX = 50.f;
static CGFloat const buttonHeight = 45.f;
static CGFloat const textFieldHeight = 30.f;

@interface MKCMFilterTestResultAlert ()

@property (nonatomic, strong)UIView *centerView;

@property (nonatomic, strong)UILabel *numberLabel;

@property (nonatomic, strong)UIView *horizontalLine;

@property (nonatomic, strong)UIView *verticalLine;

@property (nonatomic, strong)UIButton *cancelButton;

@property (nonatomic, strong)UIButton *confirmButton;

@end

@implementation MKCMFilterTestResultAlert

- (void)dealloc {
    NSLog(@"MKCMFilterTestResultAlert销毁");
}

- (instancetype)init{
    if (self = [super init]) {
        self.frame = kAppWindow.bounds;
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0.3);
        [self addSubview:self.centerView];
        
        [self.centerView addSubview:self.numberLabel];
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
        make.height.mas_equalTo(130.f);
    }];
    [self.numberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(30.f);
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
    [self dismiss];
}

#pragma mark - public method

- (void)show:(NSInteger)number {
    [kAppWindow addSubview:self];
    self.numberLabel.text = [NSString stringWithFormat:@"Count: %ld",(long)number];
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

- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.textColor = DEFAULT_TEXT_COLOR;
        _numberLabel.font = MKFont(13.f);
    }
    return _numberLabel;
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
