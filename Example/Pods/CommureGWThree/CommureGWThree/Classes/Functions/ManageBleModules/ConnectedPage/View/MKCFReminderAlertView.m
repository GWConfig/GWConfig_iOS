//
//  MKCFReminderAlertView.m
//  CommureGWThree_Example
//
//  Created by aa on 2023/4/22.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCFReminderAlertView.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"
#import "UIView+MKAdd.h"
#import "MKTextField.h"

static CGFloat const centerViewOffsetX = 30.f;
static CGFloat const titleLabelOffsetY = 25.f;
static CGFloat const buttonHeight = 45.f;
static CGFloat const textFieldHeight = 30.f;

@implementation MKCFReminderAlertViewModel
@end

@interface MKCFReminderColorButton : UIControl

@property (nonatomic, strong)UIImageView *icon;

@property (nonatomic, strong)UILabel *colorLabel;

@end

@implementation MKCFReminderColorButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.icon];
        [self addSubview:self.colorLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.icon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(1.f);
        make.width.mas_equalTo(13.f);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(13.f);
    }];
    [self.colorLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.icon.mas_right).mas_offset(2.f);
        make.right.mas_equalTo(-1.f);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.image = LOADICON(@"CommureGWThree", @"MKCFReminderColorButton", @"cf_resetByButtonUnselectedIcon.png");
    }
    return _icon;
}

- (UILabel *)colorLabel {
    if (!_colorLabel) {
        _colorLabel = [[UILabel alloc] init];
        _colorLabel.textColor = DEFAULT_TEXT_COLOR;
        _colorLabel.textAlignment = NSTextAlignmentLeft;
        _colorLabel.font = MKFont(12.f);
    }
    return _colorLabel;
    return _colorLabel;
}

@end

@interface MKCFReminderAlertView ()

@property (nonatomic, strong)UIView *centerView;

@property (nonatomic, strong)UILabel *titleLabel;

@property (nonatomic, strong)UILabel *intervalLabel;

@property (nonatomic, strong)MKTextField *intervalTextField;

@property (nonatomic, strong)UILabel *intervalUnitLabel;

@property (nonatomic, strong)UILabel *durationLabel;

@property (nonatomic, strong)MKTextField *durationTextField;

@property (nonatomic, strong)UILabel *durationUnitLabel;

@property (nonatomic, strong)UIView *horizontalLine;

@property (nonatomic, strong)UIView *verticallyLine;

@property (nonatomic, strong)UIButton *confirmButton;

@property (nonatomic, strong)UIButton *cancelButton;

@property (nonatomic, copy)void (^handler)(NSString *interval, NSString *duration, NSInteger color);

@property (nonatomic, assign)NSInteger currentColor;

@property (nonatomic, strong)UIView *colorView;

@property (nonatomic, strong)MKCFReminderColorButton *redColor;

@property (nonatomic, strong)MKCFReminderColorButton *blueColor;

@property (nonatomic, strong)MKCFReminderColorButton *greenColor;

@end

@implementation MKCFReminderAlertView

- (instancetype)init{
    if (self = [super init]) {
        self.frame = kAppWindow.bounds;
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0.3);
        [self addSubview:self.centerView];
        [self.centerView addSubview:self.titleLabel];
        [self.centerView addSubview:self.colorView];
        [self.colorView addSubview:self.redColor];
        [self.colorView addSubview:self.blueColor];
        [self.colorView addSubview:self.greenColor];
        [self.centerView addSubview:self.intervalLabel];
        [self.centerView addSubview:self.intervalTextField];
        [self.centerView addSubview:self.intervalUnitLabel];
        [self.centerView addSubview:self.durationLabel];
        [self.centerView addSubview:self.durationTextField];
        [self.centerView addSubview:self.durationUnitLabel];
        [self.centerView addSubview:self.horizontalLine];
        [self.centerView addSubview:self.verticallyLine];
        [self.centerView addSubview:self.confirmButton];
        [self.centerView addSubview:self.cancelButton];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(dismiss)
                                                     name:@"mk_cf_needDismissAlert"
                                                   object:nil];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.centerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(centerViewOffsetX);
        make.right.mas_equalTo(-centerViewOffsetX);
        make.centerY.mas_equalTo(self.mas_centerY).mas_offset(-90.f);
        make.height.mas_equalTo(240.f);
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5.f);
        make.right.mas_equalTo(-5.f);
        make.top.mas_equalTo(titleLabelOffsetY);
        make.height.mas_equalTo(MKFont(18.f).lineHeight);
    }];
    [self.colorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(15.f);
        make.height.mas_equalTo(20.f);
    }];
    CGFloat width = (self.frame.size.width - 4 * 15.f) / 3;
    [self.redColor mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(width);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [self.blueColor mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(width);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [self.greenColor mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(width);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [self.intervalLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5.f);
        make.width.mas_equalTo(110.f);
        make.centerY.mas_equalTo(self.intervalTextField.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.intervalTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.intervalLabel.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(self.intervalUnitLabel.mas_left).mas_offset(-5.f);
        make.top.mas_equalTo(self.colorView.mas_bottom).mas_offset(15.f);
        make.height.mas_equalTo(textFieldHeight);
    }];
    [self.intervalUnitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5.f);
        make.width.mas_equalTo(65.f);
        make.centerY.mas_equalTo(self.intervalTextField.mas_centerY);
        make.height.mas_equalTo(MKFont(11.f).lineHeight);
    }];
    [self.durationLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5.f);
        make.width.mas_equalTo(110.f);
        make.centerY.mas_equalTo(self.durationTextField.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.durationTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.durationLabel.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(self.durationUnitLabel.mas_left).mas_offset(-5.f);
        make.top.mas_equalTo(self.intervalTextField.mas_bottom).mas_offset(15.f);
        make.height.mas_equalTo(textFieldHeight);
    }];
    [self.durationUnitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5.f);
        make.width.mas_equalTo(65.f);
        make.centerY.mas_equalTo(self.durationTextField.mas_centerY);
        make.height.mas_equalTo(MKFont(11.f).lineHeight);
    }];
    [self.horizontalLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.durationTextField.mas_bottom).mas_offset(15.f);
        make.height.mas_equalTo(CUTTING_LINE_HEIGHT);
    }];
    [self.verticallyLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.centerView.mas_centerX);
        make.width.mas_equalTo(CUTTING_LINE_HEIGHT);
        make.top.mas_equalTo(self.horizontalLine.mas_bottom);
        make.bottom.mas_equalTo(0);
    }];
    [self.cancelButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.verticallyLine.mas_left);
        make.top.mas_equalTo(self.horizontalLine.mas_bottom);
        make.bottom.mas_equalTo(0);
    }];
    [self.confirmButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(self.verticallyLine.mas_right);
        make.top.mas_equalTo(self.horizontalLine.mas_bottom);
        make.bottom.mas_equalTo(0);
    }];
}

#pragma mark - event method
- (void)confirmButtonPressed {
    if (self.handler) {
        self.handler(self.intervalTextField.text, self.durationTextField.text,self.currentColor);
    }
    [self dismiss];
}

- (void)cancelButtonPressed {
    [self dismiss];
}

- (void)redColorButtonPressed {
    if (self.currentColor == 0) {
        return;
    }
    self.currentColor = 0;
    [self setupColorIcons];
}

- (void)blueColorButtonPressed {
    if (self.currentColor == 1) {
        return;
    }
    self.currentColor = 1;
    [self setupColorIcons];
}

- (void)greenColorButtonPressed {
    if (self.currentColor == 2) {
        return;
    }
    self.currentColor = 2;
    [self setupColorIcons];
}

#pragma mark - public method
- (void)showAlertWithModel:(MKCFReminderAlertViewModel *)dataModel
             confirmAction:(void (^)(NSString *interval, NSString *duration, NSInteger color))confirmAction {
    self.titleLabel.text = SafeStr(dataModel.title);
    self.intervalLabel.text = SafeStr(dataModel.intervalMsg);
    self.durationLabel.text = SafeStr(dataModel.durationMsg);
    self.handler = confirmAction;
    self.colorView.hidden = !dataModel.needColor;
    [self setupColorIcons];
    
    [kAppWindow addSubview:self];
}

#pragma mark - Private method
- (void)dismiss {
    if (self.superview) {
        [self removeFromSuperview];
    }
}

- (void)setupColorIcons {
    self.redColor.icon.image = (self.currentColor == 0 ? LOADICON(@"CommureGWThree", @"MKCFReminderColorButton", @"cf_resetByButtonSelectedIcon.png") : LOADICON(@"CommureGWThree", @"MKCFReminderColorButton", @"cf_resetByButtonUnselectedIcon.png"));
    self.blueColor.icon.image = (self.currentColor == 1 ? LOADICON(@"CommureGWThree", @"MKCFReminderColorButton", @"cf_resetByButtonSelectedIcon.png") : LOADICON(@"CommureGWThree", @"MKCFReminderColorButton", @"cf_resetByButtonUnselectedIcon.png"));
    self.greenColor.icon.image = (self.currentColor == 2 ? LOADICON(@"CommureGWThree", @"MKCFReminderColorButton", @"cf_resetByButtonSelectedIcon.png") : LOADICON(@"CommureGWThree", @"MKCFReminderColorButton", @"cf_resetByButtonUnselectedIcon.png"));
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

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = DEFAULT_TEXT_COLOR;
        _titleLabel.font = [UIFont boldSystemFontOfSize:18.f];
    }
    return _titleLabel;
}

- (UIView *)colorView {
    if (!_colorView) {
        _colorView = [[UIView alloc] init];
        _colorView.backgroundColor = RGBCOLOR(234, 234, 234);
    }
    return _colorView;
}

- (MKCFReminderColorButton *)redColor {
    if (!_redColor) {
        _redColor = [[MKCFReminderColorButton alloc] init];
        [_redColor addTarget:self
                      action:@selector(redColorButtonPressed)
            forControlEvents:UIControlEventTouchUpInside];
        _redColor.colorLabel.text = @"Red";
    }
    return _redColor;
}

- (MKCFReminderColorButton *)blueColor {
    if (!_blueColor) {
        _blueColor = [[MKCFReminderColorButton alloc] init];
        _blueColor.colorLabel.text = @"Blue";
        [_blueColor addTarget:self
                       action:@selector(blueColorButtonPressed)
             forControlEvents:UIControlEventTouchUpInside];
    }
    return _blueColor;
}

- (MKCFReminderColorButton *)greenColor {
    if (!_greenColor) {
        _greenColor = [[MKCFReminderColorButton alloc] init];
        _greenColor.colorLabel.text = @"Green";
        [_greenColor addTarget:self
                        action:@selector(greenColorButtonPressed)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _greenColor;
}

- (UILabel *)intervalLabel {
    if (!_intervalLabel) {
        _intervalLabel = [[UILabel alloc] init];
        _intervalLabel.textColor = DEFAULT_TEXT_COLOR;
        _intervalLabel.textAlignment = NSTextAlignmentLeft;
        _intervalLabel.font = MKFont(13.f);
    }
    return _intervalLabel;
}

- (MKTextField *)intervalTextField {
    if (!_intervalTextField) {
        _intervalTextField = [[MKTextField alloc] initWithTextFieldType:mk_realNumberOnly];
        _intervalTextField.backgroundColor = COLOR_WHITE_MACROS;
        _intervalTextField.font = MKFont(13.f);
        _intervalTextField.textColor = DEFAULT_TEXT_COLOR;
        _intervalTextField.maxLength = 3;
        _intervalTextField.placeholder = @"0-100";
        
        _intervalTextField.layer.masksToBounds = YES;
        _intervalTextField.layer.borderColor = CUTTING_LINE_COLOR.CGColor;
        _intervalTextField.layer.borderWidth = CUTTING_LINE_HEIGHT;
        _intervalTextField.layer.cornerRadius = 6;
    }
    return _intervalTextField;
}

- (UILabel *)intervalUnitLabel {
    if (!_intervalUnitLabel) {
        _intervalUnitLabel = [[UILabel alloc] init];
        _intervalUnitLabel.textAlignment = NSTextAlignmentLeft;
        _intervalUnitLabel.font = MKFont(11.f);
        _intervalUnitLabel.textColor = DEFAULT_TEXT_COLOR;
        _intervalUnitLabel.text = @"x100ms";
    }
    return _intervalUnitLabel;
}

- (UILabel *)durationLabel {
    if (!_durationLabel) {
        _durationLabel = [[UILabel alloc] init];
        _durationLabel.textColor = DEFAULT_TEXT_COLOR;
        _durationLabel.textAlignment = NSTextAlignmentLeft;
        _durationLabel.font = MKFont(13.f);
    }
    return _durationLabel;
}

- (MKTextField *)durationTextField {
    if (!_durationTextField) {
        _durationTextField = [[MKTextField alloc] initWithTextFieldType:mk_realNumberOnly];
        _durationTextField.backgroundColor = COLOR_WHITE_MACROS;
        _durationTextField.font = MKFont(13.f);
        _durationTextField.textColor = DEFAULT_TEXT_COLOR;
        _durationTextField.maxLength = 3;
        _durationTextField.placeholder = @"1-255";
        
        _durationTextField.layer.masksToBounds = YES;
        _durationTextField.layer.borderColor = CUTTING_LINE_COLOR.CGColor;
        _durationTextField.layer.borderWidth = CUTTING_LINE_HEIGHT;
        _durationTextField.layer.cornerRadius = 6;
    }
    return _durationTextField;
}

- (UILabel *)durationUnitLabel {
    if (!_durationUnitLabel) {
        _durationUnitLabel = [[UILabel alloc] init];
        _durationUnitLabel.textAlignment = NSTextAlignmentLeft;
        _durationUnitLabel.font = MKFont(11.f);
        _durationUnitLabel.textColor = DEFAULT_TEXT_COLOR;
        _durationUnitLabel.text = @"second";
    }
    return _durationUnitLabel;
}

- (UIView *)horizontalLine {
    if (!_horizontalLine) {
        _horizontalLine = [[UIView alloc] init];
        _horizontalLine.backgroundColor = RGBCOLOR(53, 53, 53);
    }
    return _horizontalLine;
}

- (UIView *)verticallyLine {
    if (!_verticallyLine) {
        _verticallyLine = [[UIView alloc] init];
        _verticallyLine.backgroundColor = RGBCOLOR(53, 53, 53);
    }
    return _verticallyLine;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [self loadButtonWithTitle:@"Confirm"
                                          selector:@selector(confirmButtonPressed)];
    }
    return _confirmButton;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [self loadButtonWithTitle:@"Cancel"
                                         selector:@selector(cancelButtonPressed)];
    }
    return _cancelButton;
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
