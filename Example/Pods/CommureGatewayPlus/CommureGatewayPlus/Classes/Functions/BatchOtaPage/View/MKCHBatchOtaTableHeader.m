//
//  MKCHBatchOtaTableHeader.m
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/7/7.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCHBatchOtaTableHeader.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"

#import "MKTextField.h"
#import "MKCustomUIAdopter.h"
#import "MKPickerView.h"

const NSString *defaultUrl = @"http://47.104.172.169:8080/updata_fold/commureMK110_V1.0.4.bin";
const NSString *defaultSubTopic = @"/provision/gateway/cmds";
const NSString *defaultPubTopic = @"/provision/gateway/data";

@interface MKCHBatchOtaTableHeader ()

@property (nonatomic, strong)UILabel *typeLabel;

@property (nonatomic, strong)UIButton *typeButton;

@property (nonatomic, strong)UILabel *urlLabel;

@property (nonatomic, strong)MKTextField *urlTextField;

@property (nonatomic, strong)UILabel *subTopicLabel;

@property (nonatomic, strong)MKTextField *subTextField;

@property (nonatomic, strong)UILabel *pubTopicLabel;

@property (nonatomic, strong)MKTextField *pubTextField;

@property (nonatomic, strong)UILabel *listLabel;

@property (nonatomic, strong)UIButton *excelButton;

@property (nonatomic, strong)UIButton *scanButton;

@property (nonatomic, strong)UILabel *macLabel;

@property (nonatomic, strong)UILabel *statusLabel;

@property (nonatomic, strong)NSArray *typeList;

@end

@implementation MKCHBatchOtaTableHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.typeLabel];
        [self addSubview:self.typeButton];
        [self addSubview:self.urlLabel];
        [self addSubview:self.urlTextField];
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
    [self.typeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(180.f);
        make.centerY.mas_equalTo(self.typeButton.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.typeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.left.mas_equalTo(self.typeLabel.mas_right).mas_offset(5.f);
        make.top.mas_equalTo(15.f);
        make.height.mas_equalTo(30.f);
    }];
    
    [self.urlTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.left.mas_equalTo(self.urlLabel.mas_right).mas_offset(5.f);
        make.top.mas_equalTo(self.typeButton.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(25.f);
    }];
    [self.urlLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(180.f);
        make.centerY.mas_equalTo(self.urlTextField.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.subTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.left.mas_equalTo(self.subTopicLabel.mas_right).mas_offset(5.f);
        make.top.mas_equalTo(self.urlTextField.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(25.f);
    }];
    [self.subTopicLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(180.f);
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
        make.width.mas_equalTo(180.f);
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
-(void)typeButtonPressed {
    //隐藏其他cell里面的输入框键盘
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MKTextFieldNeedHiddenKeyboard" object:nil];
    NSInteger row = 0;
    for (NSInteger i = 0; i < self.typeList.count; i ++) {
        if ([self.typeButton.titleLabel.text isEqualToString:self.typeList[i]]) {
            row = i;
            break;
        }
    }
    MKPickerView *pickView = [[MKPickerView alloc] init];
    [pickView showPickViewWithDataList:self.typeList selectedRow:row block:^(NSInteger currentRow) {
        [self.typeButton setTitle:self.typeList[currentRow] forState:UIControlStateNormal];
        if ([self.delegate respondsToSelector:@selector(ch_firwareTypeChanged:)]) {
            [self.delegate ch_firwareTypeChanged:currentRow];
        }
    }];
}

- (void)excelButtonPressed {
    if ([self.delegate respondsToSelector:@selector(ch_listButtonPressed)]) {
        [self.delegate ch_listButtonPressed];
    }
}

- (void)scanButtonPressed {
    if ([self.delegate respondsToSelector:@selector(ch_scanCodeButtonPressed)]) {
        [self.delegate ch_scanCodeButtonPressed];
    }
}

#pragma mark - getter
- (UILabel *)typeLabel {
    if (!_typeLabel) {
        _typeLabel = [self loadLabelWithMsg:@"Firmware type"];
    }
    return _typeLabel;
}

- (UIButton *)typeButton {
    if (!_typeButton) {
        _typeButton = [MKCustomUIAdopter customButtonWithTitle:@"WIFI firmware" 
                                                        target:self
                                                        action:@selector(typeButtonPressed)];
    }
    return _typeButton;
}

- (UILabel *)urlLabel {
    if (!_urlLabel) {
        _urlLabel = [self loadLabelWithMsg:@"Firmware file URL"];
    }
    return _urlLabel;
}

- (MKTextField *)urlTextField {
    if (!_urlTextField) {
        _urlTextField = [MKCustomUIAdopter customNormalTextFieldWithText:@"" placeHolder:@"1- 256 Characters" textType:mk_normal];
        _urlTextField.maxLength = 256;
        @weakify(self);
        _urlTextField.textChangedBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(ch_urlValueChanged:)]) {
                [self.delegate ch_urlValueChanged:text];
            }
        };
    }
    return _urlTextField;
}

- (UILabel *)subTopicLabel {
    if (!_subTopicLabel) {
        _subTopicLabel = [self loadLabelWithMsg:@"Gateway subscribe topic"];
    }
    return _subTopicLabel;
}

- (MKTextField *)subTextField {
    if (!_subTextField) {
        _subTextField = [MKCustomUIAdopter customNormalTextFieldWithText:defaultSubTopic
                                                               placeHolder:@"1- 128 Characters"
                                                                  textType:mk_normal];
        _subTextField.maxLength = 128;
        @weakify(self);
        _subTextField.textChangedBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(ch_topicValueChanged:type:)]) {
                [self.delegate ch_topicValueChanged:text type:0];
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
        _pubTextField = [MKCustomUIAdopter customNormalTextFieldWithText:defaultPubTopic
                                                               placeHolder:@"1- 128 Characters"
                                                                  textType:mk_normal];
        _pubTextField.maxLength = 128;
        @weakify(self);
        _pubTextField.textChangedBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(ch_topicValueChanged:type:)]) {
                [self.delegate ch_topicValueChanged:text type:1];
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
        [_excelButton setImage:LOADICON(@"CommureGatewayPlus", @"MKCHBatchOtaTableHeader", @"ch_batchOtaListSelectIcon.png") forState:UIControlStateNormal];
        [_excelButton addTarget:self
                         action:@selector(excelButtonPressed)
               forControlEvents:UIControlEventTouchUpInside];
    }
    return _excelButton;
}

- (UIButton *)scanButton {
    if (!_scanButton) {
        _scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_scanButton setImage:LOADICON(@"CommureGatewayPlus", @"MKCHBatchOtaTableHeader", @"ch_batchOtaQRCodeIcon.png") forState:UIControlStateNormal];
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

- (NSArray *)typeList {
    if (!_typeList) {
        _typeList = @[@"WIFI firmware",@"Bluetooth firmware"];
    }
    return _typeList;
}

- (UILabel *)loadLabelWithMsg:(NSString *)msg {
    UILabel *tempLabel = [[UILabel alloc] init];
    tempLabel.textColor = DEFAULT_TEXT_COLOR;
    tempLabel.font = MKFont(13.f);
    tempLabel.textAlignment = NSTextAlignmentLeft;
    tempLabel.text = msg;
    return tempLabel;
}

@end
