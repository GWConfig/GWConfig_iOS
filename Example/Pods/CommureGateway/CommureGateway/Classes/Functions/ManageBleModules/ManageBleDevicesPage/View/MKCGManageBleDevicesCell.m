//
//  MKCGManageBleDevicesCell.m
//  CommureGateway_Example
//
//  Created by aa on 2023/2/8.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCGManageBleDevicesCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

#import "MKCustomUIAdopter.h"

@implementation MKCGManageBleDevicesCellModel
@end

@interface MKCGManageBleDevicesCell ()

@property (nonatomic, strong)UILabel *nameLabel;

@property (nonatomic, strong)UILabel *macLabel;

@property (nonatomic, strong)UILabel *rssiLabel;

@property (nonatomic, strong)UIButton *connectButton;

@end

@implementation MKCGManageBleDevicesCell

+ (MKCGManageBleDevicesCell *)initCellWithTableView:(UITableView *)tableView {
    MKCGManageBleDevicesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKCGManageBleDevicesCellIdenty"];
    if (!cell) {
        cell = [[MKCGManageBleDevicesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKCGManageBleDevicesCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.macLabel];
        [self.contentView addSubview:self.rssiLabel];
        [self.contentView addSubview:self.connectButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.connectButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(80.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(30.f);
    }];
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.connectButton.mas_left).mas_offset(-5.f);
        make.top.mas_equalTo(10.f);
        make.height.mas_equalTo(MKFont(14.f).lineHeight);
    }];
    [self.macLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.rssiLabel.mas_left).mas_offset(-10.f);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.rssiLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.connectButton.mas_left).mas_offset(-10.f);
        make.width.mas_equalTo(70.f);
        make.centerY.mas_equalTo(self.macLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
}

#pragma mark - event method
- (void)connectButtonPressed {
    if ([self.delegate respondsToSelector:@selector(cg_manageBleDevicesCellConnectButtonPressed:typeCode:)]) {
        [self.delegate cg_manageBleDevicesCellConnectButtonPressed:SafeStr(self.dataModel.macAddress)
                                                          typeCode:self.dataModel.typeCode];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKCGManageBleDevicesCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKCGManageBleDevicesCellModel.class]) {
        return;
    }
    self.connectButton.hidden = !_dataModel.connectable;
    self.nameLabel.text = (ValidStr(_dataModel.deviceName) ? _dataModel.deviceName : @"N/A");
    self.macLabel.text = [SafeStr(_dataModel.macAddress) uppercaseString];
    self.rssiLabel.text = [NSString stringWithFormat:@"%ld dBm",(long)_dataModel.rssi];
}

#pragma mark - getter
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = DEFAULT_TEXT_COLOR;
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = MKFont(14.f);
    }
    return _nameLabel;
}

- (UILabel *)macLabel {
    if (!_macLabel) {
        _macLabel = [[UILabel alloc] init];
        _macLabel.textColor = DEFAULT_TEXT_COLOR;
        _macLabel.textAlignment = NSTextAlignmentLeft;
        _macLabel.font = MKFont(13.f);
    }
    return _macLabel;
}

- (UILabel *)rssiLabel {
    if (!_rssiLabel) {
        _rssiLabel = [[UILabel alloc] init];
        _rssiLabel.textColor = DEFAULT_TEXT_COLOR;
        _rssiLabel.textAlignment = NSTextAlignmentLeft;
        _rssiLabel.font = MKFont(13.f);
    }
    return _rssiLabel;
}

- (UIButton *)connectButton {
    if (!_connectButton) {
        _connectButton = [MKCustomUIAdopter customButtonWithTitle:@"Connect"
                                                           target:self
                                                           action:@selector(connectButtonPressed)];
    }
    return _connectButton;
}

@end
