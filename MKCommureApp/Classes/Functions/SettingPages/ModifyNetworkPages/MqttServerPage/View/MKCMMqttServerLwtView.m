//
//  MKCMMqttServerLwtView.m
//  MKCommureApp_Example
//
//  Created by aa on 2023/2/7.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCMMqttServerLwtView.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"
#import "UISegmentedControl+MKAdd.h"

#import "MKCustomUIAdopter.h"
#import "MKTextField.h"

static NSString *const defaultSubTopic = @"{device_name}/{device_id}/app_to_device";

@implementation MKCMMqttServerLwtViewModel
@end

@interface MKCMMqttServerLwtView ()

@property (nonatomic, strong)UILabel *lwtLabel;

@property (nonatomic, strong)UIButton *lwtButton;

@property (nonatomic, strong)UILabel *retainLabel;

@property (nonatomic, strong)UIButton *retainButton;

@property (nonatomic, strong)UILabel *qosLabel;

@property (nonatomic, strong)UISegmentedControl *segment;

@property (nonatomic, strong)UILabel *topicLabel;

@property (nonatomic, strong)MKTextField *topicTextField;

@property (nonatomic, strong)UILabel *payloadLabel;

@property (nonatomic, strong)MKTextField *payloadTextField;

@end

@implementation MKCMMqttServerLwtView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.lwtLabel];
        [self addSubview:self.lwtButton];
        [self addSubview:self.retainLabel];
        [self addSubview:self.retainButton];
        [self addSubview:self.qosLabel];
        [self addSubview:self.segment];
        [self addSubview:self.topicLabel];
        [self addSubview:self.topicTextField];
        [self addSubview:self.payloadLabel];
        [self addSubview:self.payloadTextField];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.lwtButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(40.f);
        make.top.mas_equalTo(10.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.lwtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.lwtButton.mas_left).mas_offset(-15.f);
        make.centerY.mas_equalTo(self.lwtButton.mas_centerY);
        make.height.mas_equalTo(MKFont(14.f).lineHeight);
    }];
    [self.retainButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(40.f);
        make.top.mas_equalTo(self.lwtButton.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.retainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.retainButton.mas_left).mas_offset(-15.f);
        make.centerY.mas_equalTo(self.retainButton.mas_centerY);
        make.height.mas_equalTo(MKFont(14.f).lineHeight);
    }];
    [self.segment mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.qosLabel.mas_right).mas_offset(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.retainButton.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.qosLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(100.f);
        make.centerY.mas_equalTo(self.segment.mas_centerY);
        make.height.mas_equalTo(MKFont(14.f).lineHeight);
    }];
    [self.topicTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.segment.mas_width);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.segment.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.topicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(100.f);
        make.centerY.mas_equalTo(self.topicTextField.mas_centerY);
        make.height.mas_equalTo(MKFont(14.f).lineHeight);
    }];
    [self.payloadTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.segment.mas_width);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.topicTextField.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.payloadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(100.f);
        make.centerY.mas_equalTo(self.payloadTextField.mas_centerY);
        make.height.mas_equalTo(MKFont(14.f).lineHeight);
    }];
}

#pragma mark - event method
- (void)lwtButtonPressed {
    self.lwtButton.selected = !self.lwtButton.selected;
    UIImage *lwtIcon = (self.lwtButton.selected ? LOADICON(@"MKCommureApp", @"MKCMMqttServerLwtView", @"cm_switchSelectedIcon.png") : LOADICON(@"MKCommureApp", @"MKCMMqttServerLwtView", @"cm_switchUnselectedIcon.png"));
    [self.lwtButton setImage:lwtIcon forState:UIControlStateNormal];
    if ([self.delegate respondsToSelector:@selector(cm_lwt_statusChanged:)]) {
        [self.delegate cm_lwt_statusChanged:self.lwtButton.selected];
    }
}

- (void)retainButtonPressed {
    self.retainButton.selected = !self.retainButton.selected;
    UIImage *retainIcon = (self.retainButton.selected ? LOADICON(@"MKCommureApp", @"MKCMMqttServerLwtView", @"cm_switchSelectedIcon.png") : LOADICON(@"MKCommureApp", @"MKCMMqttServerLwtView", @"cm_switchUnselectedIcon.png"));
    [self.retainButton setImage:retainIcon forState:UIControlStateNormal];
    if ([self.delegate respondsToSelector:@selector(cm_lwt_retainChanged:)]) {
        [self.delegate cm_lwt_retainChanged:self.retainButton.selected];
    }
}

- (void)segmentValueChanged {
    if ([self.delegate respondsToSelector:@selector(cm_lwt_qosChanged:)]) {
        [self.delegate cm_lwt_qosChanged:self.segment.selectedSegmentIndex];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKCMMqttServerLwtViewModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKCMMqttServerLwtViewModel.class]) {
        return;
    }
    self.lwtButton.selected = _dataModel.lwtStatus;
    UIImage *lwtIcon = (self.lwtButton.selected ? LOADICON(@"MKCommureApp", @"MKCMMqttServerLwtView", @"cm_switchSelectedIcon.png") : LOADICON(@"MKCommureApp", @"MKCMMqttServerLwtView", @"cm_switchUnselectedIcon.png"));
    [self.lwtButton setImage:lwtIcon forState:UIControlStateNormal];
    
    self.retainButton.selected = _dataModel.lwtRetain;
    UIImage *retainIcon = (self.retainButton.selected ? LOADICON(@"MKCommureApp", @"MKCMMqttServerLwtView", @"cm_switchSelectedIcon.png") : LOADICON(@"MKCommureApp", @"MKCMMqttServerLwtView", @"cm_switchUnselectedIcon.png"));
    [self.retainButton setImage:retainIcon forState:UIControlStateNormal];
    
    self.segment.selectedSegmentIndex = _dataModel.lwtQos;
    self.topicTextField.text = SafeStr(_dataModel.lwtTopic);
    self.payloadTextField.text = SafeStr(_dataModel.lwtPayload);
}

#pragma mark - getter
- (UILabel *)lwtLabel {
    if (!_lwtLabel) {
        _lwtLabel = [self msgLabelWithMsg:@"LWT"];
    }
    return _lwtLabel;
}

- (UIButton *)lwtButton {
    if (!_lwtButton) {
        _lwtButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lwtButton setImage:LOADICON(@"MKCommureApp", @"MKCMMqttServerLwtView", @"cm_switchUnselectedIcon.png") forState:UIControlStateNormal];
        [_lwtButton addTarget:self
                       action:@selector(lwtButtonPressed)
             forControlEvents:UIControlEventTouchUpInside];
    }
    return _lwtButton;
}

- (UILabel *)retainLabel {
    if (!_retainLabel) {
        _retainLabel = [self msgLabelWithMsg:@"Retain"];
    }
    return _retainLabel;
}

- (UIButton *)retainButton {
    if (!_retainButton) {
        _retainButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_retainButton setImage:LOADICON(@"MKCommureApp", @"MKCMMqttServerLwtView", @"cm_switchUnselectedIcon.png") forState:UIControlStateNormal];
        [_retainButton addTarget:self
                          action:@selector(retainButtonPressed)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _retainButton;
}

- (UILabel *)qosLabel {
    if (!_qosLabel) {
        _qosLabel = [self msgLabelWithMsg:@"Qos"];
    }
    return _qosLabel;
}

- (UISegmentedControl *)segment {
    if (!_segment) {
        _segment = [[UISegmentedControl alloc] initWithItems:@[@"0",@"1",@"2"]];
        [_segment mk_setTintColor:NAVBAR_COLOR_MACROS];
        _segment.selectedSegmentIndex = 1;
        [_segment addTarget:self
                     action:@selector(segmentValueChanged)
           forControlEvents:UIControlEventValueChanged];
    }
    return _segment;
}

- (UILabel *)topicLabel {
    if (!_topicLabel) {
        _topicLabel = [self msgLabelWithMsg:@"Topic"];
    }
    return _topicLabel;
}

- (MKTextField *)topicTextField {
    if (!_topicTextField) {
        _topicTextField = [MKCustomUIAdopter customNormalTextFieldWithText:@""
                                                               placeHolder:@"1-128 Characters"
                                                                  textType:mk_normal];
        @weakify(self);
        _topicTextField.textChangedBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(cm_lwt_topicChanged:)]) {
                [self.delegate cm_lwt_topicChanged:text];
            }
        };
        _topicTextField.maxLength = 128;
    }
    return _topicTextField;
}

- (UILabel *)payloadLabel {
    if (!_payloadLabel) {
        _payloadLabel = [self msgLabelWithMsg:@"Payload"];
    }
    return _payloadLabel;
}

- (MKTextField *)payloadTextField {
    if (!_payloadTextField) {
        _payloadTextField = [MKCustomUIAdopter customNormalTextFieldWithText:@""
                                                                 placeHolder:@"1-128 Characters"
                                                                    textType:mk_normal];
        @weakify(self);
        _payloadTextField.textChangedBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(cm_lwt_payloadChanged:)]) {
                [self.delegate cm_lwt_payloadChanged:text];
            }
        };
        _payloadTextField.maxLength = 128;
    }
    return _payloadTextField;
}

- (UILabel *)msgLabelWithMsg:(NSString *)msg {
    UILabel * msgLabel = [[UILabel alloc] init];
    msgLabel.textColor = DEFAULT_TEXT_COLOR;
    msgLabel.textAlignment = NSTextAlignmentLeft;
    msgLabel.font = MKFont(14.f);
    msgLabel.text = SafeStr(msg);
    return msgLabel;
}

@end
