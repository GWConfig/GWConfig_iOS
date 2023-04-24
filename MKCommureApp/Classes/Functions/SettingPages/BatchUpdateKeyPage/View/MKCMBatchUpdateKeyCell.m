//
//  MKCMBatchUpdateKeyCell.m
//  MKCommureApp_Example
//
//  Created by aa on 2023/4/21.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCMBatchUpdateKeyCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

@implementation MKCMBatchUpdateKeyCellModel
@end

@interface MKCMBatchUpdateKeyCell ()

@property (nonatomic, strong)UILabel *macLabel;

@property (nonatomic, strong)UILabel *passwordLabel;

@end

@implementation MKCMBatchUpdateKeyCell

+ (MKCMBatchUpdateKeyCell *)initCellWithTableView:(UITableView *)tableView {
    MKCMBatchUpdateKeyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKCMBatchUpdateKeyCellIdenty"];
    if (!cell) {
        cell = [[MKCMBatchUpdateKeyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKCMBatchUpdateKeyCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.macLabel];
        [self.contentView addSubview:self.passwordLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.macLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.mas_centerX).mas_offset(-5.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(MKFont(14.f).lineHeight);
    }];
    [self.passwordLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.left.mas_equalTo(self.mas_centerX).mas_offset(5.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(MKFont(14.f).lineHeight);
    }];
}

#pragma mark - setter
- (void)setDataModel:(MKCMBatchUpdateKeyCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKCMBatchUpdateKeyCellModel.class]) {
        return;
    }
    self.macLabel.text = SafeStr(_dataModel.macAddress);
    self.passwordLabel.text = SafeStr(_dataModel.password);
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
        _passwordLabel.textAlignment = NSTextAlignmentRight;
        _passwordLabel.font = MKFont(14.f);
    }
    return _passwordLabel;
}

@end
