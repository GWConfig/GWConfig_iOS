//
//  MKCMFilterBeaconCell.m
//  MKCommureApp_Example
//
//  Created by aa on 2023/2/7..
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCMFilterBeaconCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

#import "MKTextField.h"
#import "MKCustomUIAdopter.h"

@implementation MKCMFilterBeaconCellModel
@end

@interface MKCMFilterBeaconCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UILabel *minLabel;

@property (nonatomic, strong)MKTextField *minTextField;

@property (nonatomic, strong)UILabel *centerLabel;

@property (nonatomic, strong)UILabel *maxLabel;

@property (nonatomic, strong)MKTextField *maxTextField;

@end

@implementation MKCMFilterBeaconCell

+ (MKCMFilterBeaconCell *)initCellWithTableView:(UITableView *)tableView {
    MKCMFilterBeaconCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKCMFilterBeaconCellIdenty"];
    if (!cell) {
        cell = [[MKCMFilterBeaconCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKCMFilterBeaconCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.minLabel];
        [self.contentView addSubview:self.minTextField];
        [self.contentView addSubview:self.centerLabel];
        [self.contentView addSubview:self.maxLabel];
        [self.contentView addSubview:self.maxTextField];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(5.f);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.minLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(50.f);
        make.centerY.mas_equalTo(self.minTextField.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.minTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.minLabel.mas_right).mas_offset(5.f);
        make.width.mas_equalTo(80.f);
        make.top.mas_equalTo(self.msgLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.minTextField.mas_right).mas_offset(10.f);
        make.width.mas_equalTo(30.f);
        make.centerY.mas_equalTo(self.minTextField.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.maxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.centerLabel.mas_right).mas_offset(10.f);
        make.width.mas_equalTo(50.f);
        make.centerY.mas_equalTo(self.minTextField.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.maxTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.maxLabel.mas_right).mas_offset(5.f);
        make.width.mas_equalTo(80.f);
        make.centerY.mas_equalTo(self.minTextField.mas_centerY);
        make.height.mas_equalTo(30.f);
    }];
}

#pragma mark - setter
- (void)setDataModel:(MKCMFilterBeaconCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKCMFilterBeaconCellModel.class]) {
        return;
    }
    self.msgLabel.text = SafeStr(_dataModel.msg);
    self.minTextField.text = SafeStr(_dataModel.minValue);
    self.maxTextField.text = SafeStr(_dataModel.maxValue);
}

#pragma mark - getter
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [self loadLabelWithMsg:@""];
    }
    return _msgLabel;
}

- (UILabel *)minLabel {
    if (!_minLabel) {
        _minLabel = [self loadLabelWithMsg:@"Min"];
    }
    return _minLabel;
}

- (MKTextField *)minTextField {
    if (!_minTextField) {
        _minTextField = [MKCustomUIAdopter customNormalTextFieldWithText:@""
                                                             placeHolder:@"0~65535"
                                                                textType:mk_realNumberOnly];
        _minTextField.maxLength = 5;
        @weakify(self);
        _minTextField.textChangedBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(mk_cm_beaconMinValueChanged:index:)]) {
                [self.delegate mk_cm_beaconMinValueChanged:text index:self.dataModel.index];
            }
        };
    }
    return _minTextField;
}

- (UILabel *)centerLabel {
    if (!_centerLabel) {
        _centerLabel = [self loadLabelWithMsg:@"~"];
    }
    return _centerLabel;
}

- (UILabel *)maxLabel {
    if (!_maxLabel) {
        _maxLabel = [self loadLabelWithMsg:@"Max"];
    }
    return _maxLabel;
}

- (MKTextField *)maxTextField {
    if (!_maxTextField) {
        _maxTextField = [MKCustomUIAdopter customNormalTextFieldWithText:@""
                                                             placeHolder:@"0~65535"
                                                                textType:mk_realNumberOnly];
        _maxTextField.maxLength = 5;
        @weakify(self);
        _maxTextField.textChangedBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(mk_cm_beaconMaxValueChanged:index:)]) {
                [self.delegate mk_cm_beaconMaxValueChanged:text index:self.dataModel.index];
            }
        };
    }
    return _maxTextField;
}

- (UILabel *)loadLabelWithMsg:(NSString *)msg {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = DEFAULT_TEXT_COLOR;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = MKFont(15.f);
    label.text = msg;
    return label;
}

@end
