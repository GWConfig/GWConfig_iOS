//
//  MKCFDeviceDataPageHeaderView.m
//  CommureGWThree_Example
//
//  Created by aa on 2023/2/4.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCFDeviceDataPageHeaderView.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

#import "MKCustomUIAdopter.h"

@implementation MKCFDeviceDataPageHeaderViewModel
@end

@interface MKCFDeviceDataPageManageBleButton : UIControl

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UIImageView *rightIcon;

@end

@implementation MKCFDeviceDataPageManageBleButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.msgLabel];
        [self addSubview:self.rightIcon];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.rightIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(8.f);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(14.f);
    }];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.rightIcon.mas_left).mas_offset(-10.f);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(MKFont(14.f).lineHeight);
    }];
}

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.font = MKFont(14.f);
        _msgLabel.text = @"Manage BLE devices";
    }
    return _msgLabel;
}

- (UIImageView *)rightIcon {
    if (!_rightIcon) {
        _rightIcon = [[UIImageView alloc] init];
        _rightIcon.image = LOADICON(@"CommureGWThree", @"MKCFDeviceDataPageManageBleButton", @"cf_goNextButton.png");
    }
    return _rightIcon;
}

@end

@interface MKCFDeviceDataPageHeaderView ()

@property (nonatomic, strong)UIButton *uploadButton;

@property (nonatomic, strong)UILabel *scannerLabel;

@property (nonatomic, strong)UIButton *scannerButton;

@property (nonatomic, strong)UILabel *totalLabel;

@property (nonatomic, strong)UIButton *filterTestButton;

@property (nonatomic, strong)MKCFDeviceDataPageManageBleButton *manageBleButton;

@end

@implementation MKCFDeviceDataPageHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGBCOLOR(242, 242, 242);
        [self addSubview:self.uploadButton];
        [self addSubview:self.scannerLabel];
        [self addSubview:self.scannerButton];
        [self addSubview:self.manageBleButton];
        [self addSubview:self.totalLabel];
        [self addSubview:self.filterTestButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.uploadButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30.f);
        make.right.mas_equalTo(-30.f);
        make.top.mas_equalTo(10.f);
        make.height.mas_equalTo(40.f);
    }];
    [self.scannerButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(40.f);
        make.top.mas_equalTo(self.uploadButton.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.scannerLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30.f);
        make.width.mas_equalTo(100.f);
        make.centerY.mas_equalTo(self.scannerButton.mas_centerY);
        make.height.mas_equalTo(MKFont(14.f).lineHeight);
    }];
    [self.manageBleButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.scannerButton.mas_bottom).mas_offset(15.f);
        make.height.mas_equalTo(35.f);
    }];
    [self.totalLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30.f);
        make.right.mas_equalTo(self.filterTestButton.mas_left).mas_offset(-15.f);
        make.centerY.mas_equalTo(self.filterTestButton.mas_centerY);
        make.height.mas_equalTo(MKFont(14.f).lineHeight);
    }];
    [self.filterTestButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-30.f);
        make.width.mas_equalTo(80.f);
        make.top.mas_equalTo(self.manageBleButton.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(30.f);
    }];
}

#pragma mark - event method
- (void)uploadButtonPressed {
    if ([self.delegate respondsToSelector:@selector(cf_updateLoadButtonAction)]) {
        [self.delegate cf_updateLoadButtonAction];
    }
}

- (void)scannerButtonPressed {
    if ([self.delegate respondsToSelector:@selector(cf_scannerStatusChanged:)]) {
        [self.delegate cf_scannerStatusChanged:!self.scannerButton.selected];
    }
}

- (void)manageBleButtonPressed {
    if ([self.delegate respondsToSelector:@selector(cf_manageBleDeviceAction)]) {
        [self.delegate cf_manageBleDeviceAction];
    }
}

- (void)filterTestButtonPressed {
    if ([self.delegate respondsToSelector:@selector(cf_filterTestButtonAction)]) {
        [self.delegate cf_filterTestButtonAction];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKCFDeviceDataPageHeaderViewModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKCFDeviceDataPageHeaderViewModel.class]) {
        return;
    }
    self.scannerButton.selected = _dataModel.isOn;
    UIImage *image = (self.scannerButton.selected ? LOADICON(@"CommureGWThree", @"MKCFDeviceDataPageHeaderView", @"cf_switchSelectedIcon.png") : LOADICON(@"CommureGWThree", @"MKCFDeviceDataPageHeaderView", @"cf_switchUnselectedIcon.png"));
    [self.scannerButton setImage:image forState:UIControlStateNormal];
    self.manageBleButton.hidden = !_dataModel.isOn;
    self.totalLabel.hidden = !_dataModel.isOn;
}

#pragma mark - public method
- (void)updateTotalNumbers:(NSInteger)numbers {
    self.totalLabel.text = [NSString stringWithFormat:@"Total %@ pieces of data",@(numbers)];
}

#pragma mark - getter
- (UIButton *)uploadButton {
    if (!_uploadButton) {
        _uploadButton = [MKCustomUIAdopter customButtonWithTitle:@"Scanner and decryption option"
                                                          target:self
                                                          action:@selector(uploadButtonPressed)];
    }
    return _uploadButton;
}

- (UILabel *)scannerLabel {
    if (!_scannerLabel) {
        _scannerLabel = [[UILabel alloc] init];
        _scannerLabel.textColor = DEFAULT_TEXT_COLOR;
        _scannerLabel.textAlignment = NSTextAlignmentLeft;
        _scannerLabel.font = MKFont(14.f);
        _scannerLabel.text = @"Scanner";
    }
    return _scannerLabel;
}

- (UIButton *)scannerButton {
    if (!_scannerButton) {
        _scannerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_scannerButton addTarget:self
                           action:@selector(scannerButtonPressed)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    return _scannerButton;
}

- (MKCFDeviceDataPageManageBleButton *)manageBleButton {
    if (!_manageBleButton) {
        _manageBleButton = [[MKCFDeviceDataPageManageBleButton alloc] init];
        [_manageBleButton addTarget:self
                             action:@selector(manageBleButtonPressed)
                   forControlEvents:UIControlEventTouchUpInside];
    }
    return _manageBleButton;
}

- (UILabel *)totalLabel {
    if (!_totalLabel) {
        _totalLabel = [[UILabel alloc] init];
        _totalLabel.textColor = DEFAULT_TEXT_COLOR;
        _totalLabel.textAlignment = NSTextAlignmentLeft;
        _totalLabel.font = MKFont(14.f);
        _totalLabel.text = @"Total 0 pieces of data";
    }
    return _totalLabel;
}

- (UIButton *)filterTestButton {
    if (!_filterTestButton) {
        _filterTestButton = [MKCustomUIAdopter customButtonWithTitle:@"Filter Test"
                                                              target:self
                                                              action:@selector(filterTestButtonPressed)];
    }
    return _filterTestButton;
}

@end
