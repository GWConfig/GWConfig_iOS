//
//  MKCMMqttServerSSLView.m
//  MKCommureApp_Example
//
//  Created by aa on 2023/2/14.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCMMqttServerSSLView.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKCustomUIAdopter.h"
#import "MKPickerView.h"
#import "MKTextField.h"

#import "MKCMMqttServerSSLTextField.h"

static CGFloat const textFieldHeight = 30.f;

@implementation MKCMMqttServerSSLViewModel
@end

@interface MKCMMqttServerSSLView ()<MKCMMqttServerSSLTextFieldDelegate>

@property (nonatomic, strong)UILabel *sslLabel;

@property (nonatomic, strong)UIButton *sslButton;

@property (nonatomic, strong)UIView *bottomView;

@property (nonatomic, strong)UILabel *certificateLabel;

@property (nonatomic, strong)UIButton *certificateButton;

@property (nonatomic, strong)MKCMMqttServerSSLTextField *caFileView;

@property (nonatomic, strong)MKCMMqttServerSSLTextField *clientKeyView;

@property (nonatomic, strong)MKCMMqttServerSSLTextField *clientCertView;

@end

@implementation MKCMMqttServerSSLView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.sslLabel];
        [self addSubview:self.sslButton];
        [self addSubview:self.bottomView];
        [self.bottomView addSubview:self.certificateLabel];
        [self.bottomView addSubview:self.certificateButton];
        [self.bottomView addSubview:self.caFileView];
        [self.bottomView addSubview:self.clientKeyView];
        [self.bottomView addSubview:self.clientCertView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.sslButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(40.f);
        make.top.mas_equalTo(15.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.sslLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(120.f);
        make.centerY.mas_equalTo(self.sslButton.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.sslButton.mas_bottom).mas_offset(10.f);
        make.bottom.mas_equalTo(0);
    }];
    [self.certificateButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.left.mas_equalTo(self.certificateLabel.mas_right).mas_offset(10.f);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(30.f);
    }];
    [self.certificateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(120.f);
        make.centerY.mas_equalTo(self.certificateButton.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.caFileView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.certificateButton.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(textFieldHeight);
    }];
    [self.clientCertView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.caFileView.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(textFieldHeight);
    }];
    [self.clientKeyView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.clientCertView.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(textFieldHeight);
    }];
}

#pragma mark - MKCMMqttServerSSLTextFieldDelegate
/// textField内容发送改变时的回调事件
/// @param index 当前cell所在的index
/// @param value 当前textField的值
- (void)cm_modifyServerSSLTextFieldValueChanged:(NSInteger)index textValue:(NSString *)value {
    if ([self.delegate respondsToSelector:@selector(cm_mqtt_sslParams_modifyDevice_textFieldValueChanged:value:)]) {
        [self.delegate cm_mqtt_sslParams_modifyDevice_textFieldValueChanged:index value:value];
    }
}

#pragma mark - event method
- (void)sslButtonPressed {
    self.sslButton.selected = !self.sslButton.selected;
    [self updateSSLButtonIcon];
    self.bottomView.hidden = !self.sslButton.selected;
    if ([self.delegate respondsToSelector:@selector(cm_mqtt_sslParams_modifyDevice_sslStatusChanged:)]) {
        [self.delegate cm_mqtt_sslParams_modifyDevice_sslStatusChanged:self.sslButton.selected];
    }
}

- (void)certificateButtonPressed {
    NSArray *dataList = @[@"CA signed server certificate",@"CA certificate",@"Self signed certificates"];
    NSInteger index = 0;
    for (NSInteger i = 0; i < dataList.count; i ++) {
        if ([self.certificateButton.titleLabel.text isEqualToString:dataList[i]]) {
            index = i;
            break;
        }
    }
    MKPickerView *pickView = [[MKPickerView alloc] init];
    [pickView showPickViewWithDataList:dataList selectedRow:index block:^(NSInteger currentRow) {
        [self.certificateButton setTitle:dataList[currentRow] forState:UIControlStateNormal];
        [self updateCertificateView:currentRow];
        if ([self.delegate respondsToSelector:@selector(cm_mqtt_sslParams_modifyDevice_certificateChanged:)]) {
            [self.delegate cm_mqtt_sslParams_modifyDevice_certificateChanged:currentRow];
        }
    }];
}

#pragma mark - setter
- (void)setDataModel:(MKCMMqttServerSSLViewModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKCMMqttServerSSLViewModel.class]) {
        return;
    }
    self.sslButton.selected = _dataModel.sslIsOn;
    [self updateSSLButtonIcon];
    NSArray *dataList = @[@"CA signed server certificate",@"CA certificate",@"Self signed certificates"];
    [self.certificateButton setTitle:dataList[_dataModel.certificate] forState:UIControlStateNormal];
    [self updateCertificateView:_dataModel.certificate];
    
    MKCMMqttServerSSLTextFieldModel *caModel = [[MKCMMqttServerSSLTextFieldModel alloc] init];
    caModel.index = 0;
    caModel.msg = @"CA cert file URL";
    caModel.textPlaceholder = @"0-256 Characters";
    caModel.textFieldType = mk_normal;
    caModel.textFieldValue = SafeStr(_dataModel.caFilePath);
    caModel.maxLength = 256;
    self.caFileView.dataModel = caModel;
    
    MKCMMqttServerSSLTextFieldModel *clientKeyModel = [[MKCMMqttServerSSLTextFieldModel alloc] init];
    clientKeyModel.index = 1;
    clientKeyModel.msg = @"Client key file URL";
    clientKeyModel.textPlaceholder = @"0-256 Characters";
    clientKeyModel.textFieldType = mk_normal;
    clientKeyModel.textFieldValue = SafeStr(_dataModel.clientKeyPath);
    clientKeyModel.maxLength = 256;
    self.clientKeyView.dataModel = clientKeyModel;
    
    MKCMMqttServerSSLTextFieldModel *clientModel = [[MKCMMqttServerSSLTextFieldModel alloc] init];
    clientModel.index = 2;
    clientModel.msg = @"Client cert file URL";
    clientModel.textPlaceholder = @"0-256 Characters";
    clientModel.textFieldType = mk_normal;
    clientModel.textFieldValue = SafeStr(_dataModel.clientCertPath);
    clientModel.maxLength = 256;
    self.clientCertView.dataModel = clientModel;
    
    self.bottomView.hidden = !_dataModel.sslIsOn;
}

#pragma mark - private method
- (void)updateSSLButtonIcon {
    UIImage *image = (self.sslButton.selected ? LOADICON(@"MKCommureApp", @"MKCMMqttServerSSLView", @"cm_switchSelectedIcon.png") : LOADICON(@"MKCommureApp", @"MKCMMqttServerSSLView", @"cm_switchUnselectedIcon.png"));
    [self.sslButton setImage:image forState:UIControlStateNormal];
}

- (void)updateCertificateView:(NSInteger)certificate {
    if (certificate == 0) {
        //隐藏下面的证书相关
        self.caFileView.hidden = YES;
        self.clientCertView.hidden = YES;
        self.clientKeyView.hidden = YES;
        return;
    }
    if (certificate == 1) {
        //只保留CA证书
        self.caFileView.hidden = NO;
        self.clientCertView.hidden = YES;
        self.clientKeyView.hidden = YES;
        return;
    }
    //双向验证
    self.caFileView.hidden = NO;
    self.clientCertView.hidden = NO;
    self.clientKeyView.hidden = NO;
}

#pragma mark - getter
- (UILabel *)sslLabel {
    if (!_sslLabel) {
        _sslLabel = [[UILabel alloc] init];
        _sslLabel.textColor = DEFAULT_TEXT_COLOR;
        _sslLabel.font = MKFont(15.f);
        _sslLabel.textAlignment = NSTextAlignmentLeft;
        _sslLabel.text = @"SSL/TLS";
    }
    return _sslLabel;
}

- (UIButton *)sslButton {
    if (!_sslButton) {
        _sslButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sslButton setImage:LOADICON(@"MKCommureApp", @"MKCMMqttServerSSLView", @"cm_switchUnselectedIcon.png") forState:UIControlStateNormal];
        [_sslButton addTarget:self
                       action:@selector(sslButtonPressed)
             forControlEvents:UIControlEventTouchUpInside];
    }
    return _sslButton;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
    }
    return _bottomView;
}

- (UILabel *)certificateLabel {
    if (!_certificateLabel) {
        _certificateLabel = [[UILabel alloc] init];
        _certificateLabel.textColor = DEFAULT_TEXT_COLOR;
        _certificateLabel.textAlignment = NSTextAlignmentLeft;
        _certificateLabel.font = MKFont(13.f);
        _certificateLabel.text = @"Certificate";
    }
    return _certificateLabel;
}

- (UIButton *)certificateButton {
    if (!_certificateButton) {
        _certificateButton = [MKCustomUIAdopter customButtonWithTitle:@"CA signed server certificate"
                                                               target:self
                                                               action:@selector(certificateButtonPressed)];
        [_certificateButton.titleLabel setFont:MKFont(13.f)];
    }
    return _certificateButton;
}

- (MKCMMqttServerSSLTextField *)caFileView {
    if (!_caFileView) {
        _caFileView = [[MKCMMqttServerSSLTextField alloc] init];
        _caFileView.delegate = self;
    }
    return _caFileView;
}

- (MKCMMqttServerSSLTextField *)clientKeyView {
    if (!_clientKeyView) {
        _clientKeyView = [[MKCMMqttServerSSLTextField alloc] init];
        _clientKeyView.delegate = self;
    }
    return _clientKeyView;
}

- (MKCMMqttServerSSLTextField *)clientCertView {
    if (!_clientCertView) {
        _clientCertView = [[MKCMMqttServerSSLTextField alloc] init];
        _clientCertView.delegate = self;
    }
    return _clientCertView;
}

@end
