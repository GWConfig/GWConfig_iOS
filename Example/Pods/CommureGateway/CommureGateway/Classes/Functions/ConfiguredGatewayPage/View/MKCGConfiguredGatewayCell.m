//
//  MKCGConfiguredGatewayCell.m
//  CommureGateway_Example
//
//  Created by aa on 2023/10/18.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import "MKCGConfiguredGatewayCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"

@implementation MKCGConfiguredGatewayCellModel
@end

@interface MKCGConfiguredGatewayCell ()

@property (nonatomic, strong)UILabel *macLabel;

@property (nonatomic, strong)UILabel *statusLabel;

@end

@implementation MKCGConfiguredGatewayCell

+ (MKCGConfiguredGatewayCell *)initCellWithTableView:(UITableView *)tableView {
    MKCGConfiguredGatewayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKCGConfiguredGatewayCellIdenty"];
    if (!cell) {
        cell = [[MKCGConfiguredGatewayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKCGConfiguredGatewayCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = RGBCOLOR(242, 242, 242);
        [self.contentView addSubview:self.macLabel];
        [self.contentView addSubview:self.statusLabel];
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
    
    [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-60);
        make.width.mas_equalTo(70.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
}

#pragma mark - setter
- (void)setDataModel:(MKCGConfiguredGatewayCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKCGConfiguredGatewayCellModel.class]) {
        return;
    }
    self.macLabel.text = SafeStr(_dataModel.macAddress);
    self.statusLabel.textColor = (_dataModel.added ? [UIColor greenColor] : DEFAULT_TEXT_COLOR);
    self.statusLabel.text = (_dataModel.added ? @"Added" : @"Wait");
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


@end

