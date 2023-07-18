//
//  MKCMBatchDfuBeaconCell.m
//  MKCommureApp_Example
//
//  Created by aa on 2023/4/21.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCMBatchDfuBeaconCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

@implementation MKCMBatchDfuBeaconCellModel
@end

@interface MKCMBatchDfuBeaconCell ()

@property (nonatomic, strong)UILabel *macLabel;

@property (nonatomic, strong)UILabel *passwordLabel;

@property (nonatomic, strong)UILabel *statusLabel;

@end

@implementation MKCMBatchDfuBeaconCell

+ (MKCMBatchDfuBeaconCell *)initCellWithTableView:(UITableView *)tableView {
    MKCMBatchDfuBeaconCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKCMBatchDfuBeaconCellIdenty"];
    if (!cell) {
        cell = [[MKCMBatchDfuBeaconCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKCMBatchDfuBeaconCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.macLabel];
        [self.contentView addSubview:self.passwordLabel];
        [self.contentView addSubview:self.statusLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-75.f);
        make.width.mas_equalTo(60.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.macLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(110.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.passwordLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.statusLabel.mas_left).mas_offset(-5.f);
        make.left.mas_equalTo(self.macLabel.mas_right).mas_offset(5.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(MKFont(14.f).lineHeight);
    }];
}

#pragma mark - setter
- (void)setDataModel:(MKCMBatchDfuBeaconCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKCMBatchDfuBeaconCellModel.class]) {
        return;
    }
    self.macLabel.text = SafeStr(_dataModel.macAddress);
    self.passwordLabel.text = SafeStr(_dataModel.password);
    self.statusLabel.text = [self statusMsg];
}

#pragma mark - private method
- (NSString *)statusMsg {
    switch (self.dataModel.status) {
        case mk_cm_batchDfuBeaconStatus_normal:
            return @"Wait";
        case mk_cm_batchDfuBeaconStatus_upgrading:
            return @"Upgrading";
        case mk_cm_batchDfuBeaconStatus_success:
            return @"Success";
        case mk_cm_batchDfuBeaconStatus_failed:
            return @"Failed";
    }
}

#pragma mark - getter
- (UILabel *)macLabel {
    if (!_macLabel) {
        _macLabel = [[UILabel alloc] init];
        _macLabel.textColor = DEFAULT_TEXT_COLOR;
        _macLabel.textAlignment = NSTextAlignmentLeft;
        _macLabel.font = MKFont(14.f);
    }
    return _macLabel;
}

- (UILabel *)passwordLabel {
    if (!_passwordLabel) {
        _passwordLabel = [[UILabel alloc] init];
        _passwordLabel.textColor = DEFAULT_TEXT_COLOR;
        _passwordLabel.textAlignment = NSTextAlignmentCenter;
        _passwordLabel.font = MKFont(14.f);
    }
    return _passwordLabel;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.textColor = DEFAULT_TEXT_COLOR;
        _statusLabel.textAlignment = NSTextAlignmentRight;
        _statusLabel.font = MKFont(14.f);
        _statusLabel.text = @"Wait";
    }
    return _statusLabel;
}

@end
