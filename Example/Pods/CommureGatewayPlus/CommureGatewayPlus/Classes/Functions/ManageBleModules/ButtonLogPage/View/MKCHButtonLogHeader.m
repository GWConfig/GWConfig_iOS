//
//  MKCHButtonLogHeader.m
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/10/20.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import "MKCHButtonLogHeader.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

#import "MKCustomUIAdopter.h"

static CGFloat const buttonWidth = 40.f;
static CGFloat const buttonHeight = 50.f;
static CGFloat const offset_X = 15.f;
static CGFloat const buttonSpace = 10.f;

@interface MKCHMsgIconButton : UIControl

@property (nonatomic, strong)UIImageView *topIcon;

@property (nonatomic, strong)UILabel *msgLabel;

@end

@implementation MKCHMsgIconButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.topIcon];
        [self addSubview:self.msgLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat iconWidth = 5.f;
    CGFloat iconHeight = 5.f;
    if (self.topIcon.image) {
        iconWidth = self.topIcon.image.size.width;
        iconHeight = self.topIcon.image.size.height;
    }
    [self.topIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(iconWidth);
        make.top.mas_equalTo(1.f);
        make.height.mas_equalTo(iconHeight);
    }];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(1.f);
        make.right.mas_equalTo(-1.f);
        make.top.mas_equalTo(self.topIcon.mas_bottom).mas_offset(2.f);
        make.bottom.mas_equalTo(-1.f);
    }];
}

- (UIImageView *)topIcon {
    if (!_topIcon) {
        _topIcon = [[UIImageView alloc] init];
    }
    return _topIcon;
}

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.textAlignment = NSTextAlignmentCenter;
        _msgLabel.font = MKFont(12.f);
    }
    return _msgLabel;
}

@end

@interface MKCHButtonLogHeader ()

@property (nonatomic, strong)MKCHMsgIconButton *synButton;

@property (nonatomic, strong)MKCHMsgIconButton *emptyButton;

@property (nonatomic, strong)MKCHMsgIconButton *exportButton;

@end

@implementation MKCHButtonLogHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.synButton];
        [self addSubview:self.emptyButton];
        [self addSubview:self.exportButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.exportButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-offset_X);
        make.width.mas_equalTo(buttonWidth);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(buttonHeight);
    }];
    [self.emptyButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(buttonWidth);
        make.centerY.mas_equalTo(self.exportButton.mas_centerY);
        make.height.mas_equalTo(buttonHeight);
    }];
    [self.synButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.width.mas_equalTo(buttonWidth);
        make.centerY.mas_equalTo(self.emptyButton.mas_centerY);
        make.height.mas_equalTo(buttonHeight);
    }];
}

#pragma mark - event method
- (void)synButtonPressed {
    if ([self.delegate respondsToSelector:@selector(ch_syncButtonPressed)]) {
        [self.delegate ch_syncButtonPressed];
    }
}

- (void)emptyButtonPressed {
    if ([self.delegate respondsToSelector:@selector(ch_deleteButtonPressed)]) {
        [self.delegate ch_deleteButtonPressed];
    }
}

- (void)exportButtonPressed {
    if ([self.delegate respondsToSelector:@selector(ch_exportButtonPressed)]) {
        [self.delegate ch_exportButtonPressed];
    }
}

#pragma mark - getter

- (MKCHMsgIconButton *)synButton {
    if (!_synButton) {
        _synButton = [[MKCHMsgIconButton alloc] init];
        _synButton.topIcon.image = LOADICON(@"CommureGatewayPlus", @"MKCHButtonLogHeader", @"ch_sync_enableIcon.png");
        _synButton.msgLabel.text = @"Sync";
        [_synButton addTarget:self
                       action:@selector(synButtonPressed)
             forControlEvents:UIControlEventTouchUpInside];
    }
    return _synButton;
}

- (MKCHMsgIconButton *)emptyButton {
    if (!_emptyButton) {
        _emptyButton = [[MKCHMsgIconButton alloc] init];
        _emptyButton.topIcon.image = LOADICON(@"CommureGatewayPlus", @"MKCHButtonLogHeader", @"ch_delete_enableIcon.png");
        _emptyButton.msgLabel.text = @"Empty";
        [_emptyButton addTarget:self
                         action:@selector(emptyButtonPressed)
               forControlEvents:UIControlEventTouchUpInside];
    }
    return _emptyButton;
}

- (MKCHMsgIconButton *)exportButton {
    if (!_exportButton) {
        _exportButton = [[MKCHMsgIconButton alloc] init];
        _exportButton.topIcon.image = LOADICON(@"CommureGatewayPlus", @"MKCHButtonLogHeader", @"ch_export_enableIcon.png");
        _exportButton.msgLabel.text = @"Export";
        [_exportButton addTarget:self
                          action:@selector(exportButtonPressed)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _exportButton;
}

@end
