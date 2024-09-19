//
//  MKCHBleWifiSettingsCertCell.m
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/1/30.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCHBleWifiSettingsCertCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

@implementation MKCHBleWifiSettingsCertCellModel
@end

@interface MKCHBleWifiSettingsCertCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UILabel *certificateLabel;

@property (nonatomic, strong)UIButton *certificateButton;

@end

@implementation MKCHBleWifiSettingsCertCell

+ (MKCHBleWifiSettingsCertCell *)initCellWithTableView:(UITableView *)tableView {
    MKCHBleWifiSettingsCertCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKCHBleWifiSettingsCertCellIdenty"];
    if (!cell) {
        cell = [[MKCHBleWifiSettingsCertCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKCHBleWifiSettingsCertCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.certificateLabel];
        [self.contentView addSubview:self.certificateButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = [NSString sizeWithText:self.certificateLabel.text
                                 andFont:self.certificateLabel.font
                              andMaxSize:CGSizeMake(self.frame.size.width - 2 * 15.f - 120.f -  2 * 10.f - 40.f, MAXFLOAT)];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(120.f);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(MKFont(14.f).lineHeight);
    }];
    [self.certificateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.msgLabel.mas_right).mas_offset(10.f);
        make.right.mas_equalTo(self.certificateButton.mas_left).mas_offset(-10.f);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(size.height);
    }];
    [self.certificateButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(40.f);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(30.f);
    }];
}

#pragma mark - event method
- (void)certificateButtonPressed {
    if ([self.delegate respondsToSelector:@selector(ch_bleWifiSettingsCertPressed:)]) {
        [self.delegate ch_bleWifiSettingsCertPressed:self.dataModel.index];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKCHBleWifiSettingsCertCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKCHBleWifiSettingsCertCellModel.class]) {
        return;
    }
    self.msgLabel.text = _dataModel.msg;
    self.certificateLabel.text = _dataModel.fileName;
    [self setNeedsLayout];
}

#pragma mark - getter

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.font = MKFont(14.f);
    }
    return _msgLabel;
}

- (UILabel *)certificateLabel {
    if (!_certificateLabel) {
        _certificateLabel = [[UILabel alloc] init];
        _certificateLabel.textColor = DEFAULT_TEXT_COLOR;
        _certificateLabel.textAlignment = NSTextAlignmentLeft;
        _certificateLabel.font = MKFont(13.f);
        _certificateLabel.numberOfLines = 0;
    }
    return _certificateLabel;
}

- (UIButton *)certificateButton {
    if (!_certificateButton) {
        _certificateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_certificateButton setImage:LOADICON(@"CommureGatewayPlus", @"MKCHBleWifiSettingsCertCell", @"ch_config_certAddIcon.png") forState:UIControlStateNormal];
        [_certificateButton addTarget:self
                               action:@selector(certificateButtonPressed)
                     forControlEvents:UIControlEventTouchUpInside];
    }
    return _certificateButton;
}

@end
