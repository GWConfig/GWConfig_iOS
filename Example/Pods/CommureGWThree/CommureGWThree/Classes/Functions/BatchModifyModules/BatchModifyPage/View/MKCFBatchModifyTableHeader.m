//
//  MKCFBatchModifyTableHeader.m
//  CommureGWThree_Example
//
//  Created by aa on 2023/12/14.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import "MKCFBatchModifyTableHeader.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"

#import "MKTextField.h"
#import "MKCustomUIAdopter.h"

@interface MKCFBatchModifyTableHeader ()

@property (nonatomic, strong)UILabel *subTopicLabel;

@property (nonatomic, strong)MKTextField *subTextField;

@property (nonatomic, strong)UILabel *pubTopicLabel;

@property (nonatomic, strong)MKTextField *pubTextField;

@property (nonatomic, strong)UILabel *listLabel;

@property (nonatomic, strong)UIButton *excelButton;

@property (nonatomic, strong)UIButton *scanButton;

@property (nonatomic, strong)UILabel *macLabel;

@property (nonatomic, strong)UILabel *statusLabel;

@end

@implementation MKCFBatchModifyTableHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.subTopicLabel];
        [self addSubview:self.subTextField];
        [self addSubview:self.pubTopicLabel];
        [self addSubview:self.pubTextField];
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
    
    [self.subTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.left.mas_equalTo(self.subTopicLabel.mas_right).mas_offset(5.f);
        make.top.mas_equalTo(15.f);
        make.height.mas_equalTo(25.f);
    }];
    [self.subTopicLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(175.f);
        make.centerY.mas_equalTo(self.subTextField.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.pubTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.left.mas_equalTo(self.pubTopicLabel.mas_right).mas_offset(5.f);
        make.top.mas_equalTo(self.subTextField.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(25.f);
    }];
    [self.pubTopicLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(175.f);
        make.centerY.mas_equalTo(self.pubTextField.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.scanButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(30.f);
        make.top.mas_equalTo(self.pubTextField.mas_bottom).mas_offset(10.f);
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
    if ([self.delegate respondsToSelector:@selector(cf_listButtonPressed)]) {
        [self.delegate cf_listButtonPressed];
    }
}

- (void)scanButtonPressed {
    if ([self.delegate respondsToSelector:@selector(cf_scanCodeButtonPressed)]) {
        [self.delegate cf_scanCodeButtonPressed];
    }
}

#pragma mark - getter

- (UILabel *)subTopicLabel {
    if (!_subTopicLabel) {
        _subTopicLabel = [self loadLabelWithMsg:@"Gateway subscribe topic"];
    }
    return _subTopicLabel;
}

- (MKTextField *)subTextField {
    if (!_subTextField) {
        _subTextField = [MKCustomUIAdopter customNormalTextFieldWithText:@"/provision/gateway/cmds"
                                                               placeHolder:@"1- 128 Characters"
                                                                  textType:mk_normal];
        _subTextField.maxLength = 128;
        @weakify(self);
        _subTextField.textChangedBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(cf_topicValueChanged:type:)]) {
                [self.delegate cf_topicValueChanged:text type:0];
            }
        };
    }
    return _subTextField;
}

- (UILabel *)pubTopicLabel {
    if (!_pubTopicLabel) {
        _pubTopicLabel = [self loadLabelWithMsg:@"Gateway publish topic"];
    }
    return _pubTopicLabel;
}

- (MKTextField *)pubTextField {
    if (!_pubTextField) {
        _pubTextField = [MKCustomUIAdopter customNormalTextFieldWithText:@"/provision/gateway/data"
                                                               placeHolder:@"1- 128 Characters"
                                                                  textType:mk_normal];
        _pubTextField.maxLength = 128;
        @weakify(self);
        _pubTextField.textChangedBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(cf_topicValueChanged:type:)]) {
                [self.delegate cf_topicValueChanged:text type:1];
            }
        };
    }
    return _pubTextField;
}

- (UILabel *)listLabel {
    if (!_listLabel) {
        _listLabel = [self loadLabelWithMsg:@"Gateway list"];
    }
    return _listLabel;
}

- (UIButton *)excelButton {
    if (!_excelButton) {
        _excelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_excelButton setImage:LOADICON(@"CommureGWThree", @"MKCFBatchModifyTableHeader", @"cf_batchOtaListSelectIcon.png") forState:UIControlStateNormal];
        [_excelButton addTarget:self
                         action:@selector(excelButtonPressed)
               forControlEvents:UIControlEventTouchUpInside];
    }
    return _excelButton;
}

- (UIButton *)scanButton {
    if (!_scanButton) {
        _scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_scanButton setImage:LOADICON(@"CommureGWThree", @"MKCFBatchModifyTableHeader", @"cf_batchOtaQRCodeIcon.png") forState:UIControlStateNormal];
        [_scanButton addTarget:self
                        action:@selector(scanButtonPressed)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _scanButton;
}

- (UILabel *)macLabel {
    if (!_macLabel) {
        _macLabel = [self loadLabelWithMsg:@"Gateway Mac"];
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
