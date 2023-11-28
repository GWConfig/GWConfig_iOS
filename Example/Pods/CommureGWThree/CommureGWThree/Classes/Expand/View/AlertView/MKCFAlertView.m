//
//  MKCFAlertView.m
//  CommureGWThree
//
//  Created by aa on 2023/2/7.
//

#import "MKCFAlertView.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

static CGFloat const centerViewOffsetX = 50.f;
static CGFloat const msgLabelOffsetX = 10.f;
static CGFloat const titleLabelOffsetY = 25.f;
static CGFloat const buttonHeight = 50.f;

@implementation MKCFAlertViewModel
@end

@interface MKCFAlertView ()

@property (nonatomic, strong)UIView *centerView;

@property (nonatomic, strong)UILabel *titleLabel;

@property (nonatomic, strong)UILabel *messageLabel;

@property (nonatomic, strong)UIView *horizontalLine;

@property (nonatomic, strong)UIView *verticalLine;

@property (nonatomic, strong)UIButton *cancelButton;

@property (nonatomic, strong)UIButton *confirmButton;

@property (nonatomic, copy)void(^cancelBlock)(void);

@property (nonatomic, copy)void(^confirmBlock)(void);

@end

@implementation MKCFAlertView

- (void)dealloc {
    NSLog(@"MKCFAlertView销毁");
}

- (instancetype)init{
    if (self = [super init]) {
        self.frame = kAppWindow.bounds;
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0.3);
        [self addSubview:self.centerView];
        [self.centerView addSubview:self.titleLabel];
        [self.centerView addSubview:self.messageLabel];
        [self.centerView addSubview:self.horizontalLine];
        [self.centerView addSubview:self.verticalLine];
        [self.centerView addSubview:self.cancelButton];
        [self.centerView addSubview:self.confirmButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize msgSize = [NSString sizeWithText:self.messageLabel.text
                                    andFont:self.messageLabel.font
                                 andMaxSize:CGSizeMake(kViewWidth - 2 * (centerViewOffsetX + msgLabelOffsetX) , MAXFLOAT)];
    CGFloat centerViewHeight = (titleLabelOffsetY + MKFont(14.f).lineHeight + 10.f + msgSize.height + CUTTING_LINE_HEIGHT + buttonHeight + 20.f);
    [self.centerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(centerViewOffsetX);
        make.right.mas_equalTo(-centerViewOffsetX);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(centerViewHeight);
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5.f);
        make.right.mas_equalTo(-5.f);
        make.top.mas_equalTo(titleLabelOffsetY);
        make.height.mas_equalTo(MKFont(18.f).lineHeight);
    }];
    [self.messageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(msgLabelOffsetX);
        make.right.mas_equalTo(-msgLabelOffsetX);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(msgSize.height);
    }];
    [self.horizontalLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.messageLabel.mas_bottom).mas_offset(20.f);
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
        make.top.mas_equalTo(self.horizontalLine.mas_bottom);
        make.bottom.mas_equalTo(0);
    }];
    [self.confirmButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.verticalLine.mas_right);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.horizontalLine.mas_bottom);
        make.bottom.mas_equalTo(0);
    }];
}

#pragma mark - event method
- (void)cancelButtonPressed {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [self dismiss];
}

- (void)confirmButtonPressed {
    if (self.confirmBlock) {
        self.confirmBlock();
    }
    [self dismiss];
}

- (void)dismiss {
    if (self.superview) {
        [self removeFromSuperview];
    }
}

#pragma mark - public method
- (void)showWithModel:(MKCFAlertViewModel *)dataModel
         cancelAction:(void (^)(void))cancelBlock
        confirmAction:(void (^)(void))confirmBlock {
    if (!dataModel || ![dataModel isKindOfClass:MKCFAlertViewModel.class]) {
        return;
    }
    [kAppWindow addSubview:self];
    self.titleLabel.text = SafeStr(dataModel.title);
    self.messageLabel.text = SafeStr(dataModel.message);
    self.cancelBlock = nil;
    self.cancelBlock = cancelBlock;
    self.confirmBlock = nil;
    self.confirmBlock = confirmBlock;
    if (ValidStr(dataModel.cancelTitle)) {
        [self.cancelButton setTitle:dataModel.cancelTitle forState:UIControlStateNormal];
    }
    if (ValidStr(dataModel.confirmTitle)) {
        [self.confirmButton setTitle:dataModel.confirmTitle forState:UIControlStateNormal];
    }
    [self setNeedsLayout];
    if (ValidStr(dataModel.notificationName)) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(dismiss)
                                                     name:dataModel.notificationName
                                                   object:nil];
    }
}

#pragma mark - getter
- (UIView *)centerView {
    if (!_centerView) {
        _centerView = [[UIView alloc] init];
        _centerView.backgroundColor = COLOR_WHITE_MACROS;
        
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

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.textColor = DEFAULT_TEXT_COLOR;
        _messageLabel.font = MKFont(14.f);
        _messageLabel.numberOfLines = 0;
    }
    return _messageLabel;
}

- (UIView *)verticalLine {
    if (!_verticalLine) {
        _verticalLine = [[UIView alloc] init];
        _verticalLine.backgroundColor = CUTTING_LINE_COLOR;
    }
    return _verticalLine;
}

- (UIView *)horizontalLine {
    if (!_horizontalLine) {
        _horizontalLine = [[UIView alloc] init];
        _horizontalLine.backgroundColor = CUTTING_LINE_COLOR;
    }
    return _horizontalLine;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitleColor:COLOR_BLUE_MARCROS forState:UIControlStateNormal];
        [_cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [_cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18.f]];
        [_cancelButton addTarget:self
                          action:@selector(cancelButtonPressed)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitleColor:COLOR_BLUE_MARCROS forState:UIControlStateNormal];
        [_confirmButton setTitle:@"Confirm" forState:UIControlStateNormal];
        [_confirmButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18.f]];
        [_confirmButton addTarget:self
                           action:@selector(confirmButtonPressed)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

@end
