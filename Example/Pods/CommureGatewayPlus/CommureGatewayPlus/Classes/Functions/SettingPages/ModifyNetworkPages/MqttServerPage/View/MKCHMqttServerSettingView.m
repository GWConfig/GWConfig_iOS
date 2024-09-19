//
//  MKCHMqttServerSettingView.m
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/2/7.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCHMqttServerSettingView.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKCustomUIAdopter.h"

@interface MKCHMqttServerSettingView ()

@property (nonatomic, strong)UIButton *clearButton;

@property (nonatomic, strong)UIButton *exportButton;

@property (nonatomic, strong)UIButton *importButton;

@end

@implementation MKCHMqttServerSettingView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.clearButton];
        [self addSubview:self.exportButton];
        [self addSubview:self.importButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.clearButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30.f);
        make.right.mas_equalTo(-30.f);
        make.top.mas_equalTo(10.f);
        make.height.mas_equalTo(40.f);
    }];
    [self.exportButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30.f);
        make.width.mas_equalTo(130.f);
        make.top.mas_equalTo(self.clearButton.mas_bottom).mas_offset(40.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.importButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-30.f);
        make.width.mas_equalTo(130.f);
        make.centerY.mas_equalTo(self.exportButton.mas_centerY);
        make.height.mas_equalTo(30.f);
    }];
}

#pragma mark - event method
- (void)clearButtonPressed {
    if ([self.delegate respondsToSelector:@selector(ch_mqtt_deviecSetting_fileButtonPressed:)]) {
        [self.delegate ch_mqtt_deviecSetting_fileButtonPressed:2];
    }
}

- (void)exportButtonPressed {
    if ([self.delegate respondsToSelector:@selector(ch_mqtt_deviecSetting_fileButtonPressed:)]) {
        [self.delegate ch_mqtt_deviecSetting_fileButtonPressed:0];
    }
}

- (void)importButtonPressed {
    if ([self.delegate respondsToSelector:@selector(ch_mqtt_deviecSetting_fileButtonPressed:)]) {
        [self.delegate ch_mqtt_deviecSetting_fileButtonPressed:1];
    }
}

#pragma mark - getter
- (UIButton *)clearButton {
    if (!_clearButton) {
        _clearButton = [MKCustomUIAdopter customButtonWithTitle:@"Clear All Configurations"
                                                         target:self
                                                         action:@selector(clearButtonPressed)];
        _clearButton.titleLabel.font = MKFont(13.f);
    }
    return _clearButton;
}

- (UIButton *)exportButton {
    if (!_exportButton) {
        _exportButton = [MKCustomUIAdopter customButtonWithTitle:@"Export Demo File"
                                                          target:self
                                                          action:@selector(exportButtonPressed)];
        _exportButton.titleLabel.font = MKFont(13.f);
    }
    return _exportButton;
}

- (UIButton *)importButton {
    if (!_importButton) {
        _importButton = [MKCustomUIAdopter customButtonWithTitle:@"Import Config File"
                                                          target:self
                                                          action:@selector(importButtonPressed)];
        _importButton.titleLabel.font = MKFont(13.f);
    }
    return _importButton;
}

@end
