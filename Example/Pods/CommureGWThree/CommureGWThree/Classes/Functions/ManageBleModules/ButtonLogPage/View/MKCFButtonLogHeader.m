//
//  MKCFButtonLogHeader.m
//  CommureGWThree_Example
//
//  Created by aa on 2023/10/20.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import "MKCFButtonLogHeader.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

#import "MKCustomUIAdopter.h"

static CGFloat const buttonWidth = 40.f;
static CGFloat const buttonHeight = 50.f;
static CGFloat const offset_X = 15.f;
static CGFloat const buttonSpace = 10.f;

@interface MKCFMsgIconButton : UIControl

@property (nonatomic, strong)UIImageView *topIcon;

@property (nonatomic, strong)UILabel *msgLabel;

@end

@implementation MKCFMsgIconButton

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

@interface MKCFButtonLogHeader ()

@property (nonatomic, strong)MKCFMsgIconButton *synButton;

@property (nonatomic, strong)MKCFMsgIconButton *emptyButton;

@property (nonatomic, strong)MKCFMsgIconButton *exportButton;

@end

@implementation MKCFButtonLogHeader

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
    if ([self.delegate respondsToSelector:@selector(cf_syncButtonPressed)]) {
        [self.delegate cf_syncButtonPressed];
    }
}

- (void)emptyButtonPressed {
    if ([self.delegate respondsToSelector:@selector(cf_deleteButtonPressed)]) {
        [self.delegate cf_deleteButtonPressed];
    }
}

- (void)exportButtonPressed {
    if ([self.delegate respondsToSelector:@selector(cf_exportButtonPressed)]) {
        [self.delegate cf_exportButtonPressed];
    }
}

#pragma mark - getter

- (MKCFMsgIconButton *)synButton {
    if (!_synButton) {
        _synButton = [[MKCFMsgIconButton alloc] init];
        _synButton.topIcon.image = LOADICON(@"CommureGWThree", @"MKCFButtonLogHeader", @"cf_sync_enableIcon.png");
        _synButton.msgLabel.text = @"Sync";
        [_synButton addTarget:self
                       action:@selector(synButtonPressed)
             forControlEvents:UIControlEventTouchUpInside];
    }
    return _synButton;
}

- (MKCFMsgIconButton *)emptyButton {
    if (!_emptyButton) {
        _emptyButton = [[MKCFMsgIconButton alloc] init];
        _emptyButton.topIcon.image = LOADICON(@"CommureGWThree", @"MKCFButtonLogHeader", @"cf_delete_enableIcon.png");
        _emptyButton.msgLabel.text = @"Empty";
        [_emptyButton addTarget:self
                         action:@selector(emptyButtonPressed)
               forControlEvents:UIControlEventTouchUpInside];
    }
    return _emptyButton;
}

- (MKCFMsgIconButton *)exportButton {
    if (!_exportButton) {
        _exportButton = [[MKCFMsgIconButton alloc] init];
        _exportButton.topIcon.image = LOADICON(@"CommureGWThree", @"MKCFButtonLogHeader", @"cf_export_enableIcon.png");
        _exportButton.msgLabel.text = @"Export";
        [_exportButton addTarget:self
                          action:@selector(exportButtonPressed)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _exportButton;
}

@end
