//
//  MKCFDeviceListCell.m
//  CommureGWThree_Example
//
//  Created by aa on 2023/2/7.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCFDeviceListCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"

#import "MKCFDeviceListModel.h"

@interface MKCFDeviceListCell ()

@property (nonatomic, strong)UIImageView *wifiIcon;

@property (nonatomic, strong)UILabel *deviceNameLabel;

@property (nonatomic, strong)UILabel *stateLabel;

@property (nonatomic, strong)UILabel *macLabel;

@property (nonatomic, strong)UIImageView *rightIcon;

@end

@implementation MKCFDeviceListCell

+ (MKCFDeviceListCell *)initCellWithTableView:(UITableView *)tableView {
    MKCFDeviceListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKCFDeviceListCellIdenty"];
    if (!cell) {
        cell = [[MKCFDeviceListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKCFDeviceListCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = RGBCOLOR(242, 242, 242);
        [self.contentView addSubview:self.wifiIcon];
        [self.contentView addSubview:self.deviceNameLabel];
        [self.contentView addSubview:self.stateLabel];
        [self.contentView addSubview:self.macLabel];
        [self.contentView addSubview:self.rightIcon];
        [self addLongPressEventAction];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.wifiIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(32.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(32.f);
    }];
    [self.rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(8.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(14.f);
    }];
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.rightIcon.mas_left).mas_offset(-5.f);
        make.width.mas_equalTo(40.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.deviceNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.wifiIcon.mas_right).mas_offset(10.f);
        make.right.mas_equalTo(self.stateLabel.mas_left).mas_offset(-5.f);
        make.top.mas_equalTo(8.f);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.macLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.wifiIcon.mas_right).mas_offset(10.f);
        make.right.mas_equalTo(self.stateLabel.mas_left).mas_offset(-5.f);
        make.bottom.mas_equalTo(-8.f);
        make.height.mas_equalTo(MKFont(14.f).lineHeight);
    }];
}

#pragma mark - event method
- (void)longPressEventAction:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan && [self.delegate respondsToSelector:@selector(cf_cellDeleteButtonPressed:)]) {
        [self.delegate cf_cellDeleteButtonPressed:self.indexPath.row];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKCFDeviceListModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKCFDeviceModel.class]) {
        return;
    }
    self.deviceNameLabel.text = SafeStr(_dataModel.deviceName);
    self.stateLabel.text = (_dataModel.onLineState == MKCFDeviceModelStateOnline ? @"Online" : @"Offline");
    self.stateLabel.textColor = (_dataModel.onLineState == MKCFDeviceModelStateOnline ? NAVBAR_COLOR_MACROS : UIColorFromRGB(0xcccccc));
    self.macLabel.text = SafeStr(_dataModel.macAddress);
    if (dataModel.onLineState == MKCFDeviceModelStateOffline) {
        //设备离线
        self.wifiIcon.image = LOADICON(@"CommureGWThree", @"MKCFDeviceListCell", @"cf_offline_wifi.png");
        return;
    }
    //设备在线
    if (_dataModel.wifiLevel >= -50 && _dataModel.wifiLevel <= 0) {
        //Good
        self.wifiIcon.image = LOADICON(@"CommureGWThree", @"MKCFDeviceListCell", @"cf_good_wifi.png");
        return;
    }
    if (_dataModel.wifiLevel >= -65 && _dataModel.wifiLevel < 50) {
        //Medium
        self.wifiIcon.image = LOADICON(@"CommureGWThree", @"MKCFDeviceListCell", @"cf_medium_wifi.png");
        return;
    }
    if (_dataModel.wifiLevel < -65) {
        //Poor
        self.wifiIcon.image = LOADICON(@"CommureGWThree", @"MKCFDeviceListCell", @"cf_poor_wifi.png");
        return;
    }
}

#pragma mark - private method
- (void)addLongPressEventAction {
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] init];
    [longPress addTarget:self action:@selector(longPressEventAction:)];
    [self.contentView addGestureRecognizer:longPress];
}

#pragma mark - getter
- (UIImageView *)wifiIcon {
    if (!_wifiIcon) {
        _wifiIcon = [[UIImageView alloc] init];
        _wifiIcon.image = LOADICON(@"CommureGWThree", @"MKCFDeviceListCell", @"cf_offline_wifi.png");
    }
    return _wifiIcon;
}

- (UILabel *)deviceNameLabel {
    if (!_deviceNameLabel) {
        _deviceNameLabel = [[UILabel alloc] init];
        _deviceNameLabel.textColor = DEFAULT_TEXT_COLOR;
        _deviceNameLabel.textAlignment = NSTextAlignmentLeft;
        _deviceNameLabel.font = MKFont(15.f);
    }
    return _deviceNameLabel;
}

- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.textColor = UIColorFromRGB(0xcccccc);
        _stateLabel.textAlignment = NSTextAlignmentLeft;
        _stateLabel.font = MKFont(12.f);
        _stateLabel.text = @"Offline";
    }
    return _stateLabel;
}

- (UILabel *)macLabel {
    if (!_macLabel) {
        _macLabel = [[UILabel alloc] init];
        _macLabel.textAlignment = NSTextAlignmentLeft;
        _macLabel.textColor = UIColorFromRGB(0xcccccc);
        _macLabel.font = MKFont(14.f);
    }
    return _macLabel;
}

- (UIImageView *)rightIcon {
    if (!_rightIcon) {
        _rightIcon = [[UIImageView alloc] init];
        _rightIcon.image = LOADICON(@"CommureGWThree", @"MKCFDeviceListCell", @"cf_goNextButton.png");
    }
    return _rightIcon;
}

@end
