//
//  MKCMConfiguredGatewayCell.m
//  MKCommureApp_Example
//
//  Created by aa on 2023/7/7.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCMConfiguredGatewayCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"

@implementation MKCMConfiguredGatewayCellModel
@end

@interface MKCMConfiguredGatewayCell ()

@property (nonatomic, strong)UILabel *macLabel;

@property (nonatomic, strong)UILabel *statusLabel;

@property (nonatomic, strong)UIButton *deleteButton;

@end

@implementation MKCMConfiguredGatewayCell

+ (MKCMConfiguredGatewayCell *)initCellWithTableView:(UITableView *)tableView {
    MKCMConfiguredGatewayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKCMConfiguredGatewayCellIdenty"];
    if (!cell) {
        cell = [[MKCMConfiguredGatewayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKCMConfiguredGatewayCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.macLabel];
        [self.contentView addSubview:self.statusLabel];
        [self.contentView addSubview:self.deleteButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.macLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(120.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.deleteButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(30.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(25.f);
    }];
    [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.deleteButton.mas_left).mas_offset(-15.f);
        make.width.mas_equalTo(70.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
}

#pragma mark - event method
- (void)deleteButtonPressed {
    if ([self.delegate respondsToSelector:@selector(cm_ConfiguredGatewayCell_delete:)]) {
        [self.delegate cm_ConfiguredGatewayCell_delete:self.dataModel.index];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKCMConfiguredGatewayCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKCMConfiguredGatewayCellModel.class]) {
        return;
    }
    self.macLabel.text = SafeStr(_dataModel.macAddress);
    self.statusLabel.text = SafeStr(_dataModel.status);
}

#pragma mark - getter
- (UILabel *)macLabel {
    if (!_macLabel) {
        _macLabel = [[UILabel alloc] init];
        _macLabel.textColor = DEFAULT_TEXT_COLOR;
        _macLabel.font = MKFont(15.f);
        _macLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _macLabel;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.textColor = DEFAULT_TEXT_COLOR;
        _statusLabel.font = MKFont(13.f);
        _statusLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _statusLabel;
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:LOADICON(@"MKCommureApp", @"MKCMConfiguredGatewayCell", @"cm_subIcon.png") forState:UIControlStateNormal];
        [_deleteButton addTarget:self
                          action:@selector(deleteButtonPressed)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

@end
