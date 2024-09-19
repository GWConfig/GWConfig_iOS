//
//  MKCHBatchUpdateCell.m
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/10/19.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import "MKCHBatchUpdateCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"

@implementation MKCHBatchUpdateCellModel
@end

@interface MKCHBatchUpdateCell ()

@property (nonatomic, strong)UILabel *macLabel;

@property (nonatomic, strong)UILabel *statusLabel;

@property (nonatomic, strong)UIButton *retryButton;

@property (nonatomic, strong)UIButton *deleteButton;

@end

@implementation MKCHBatchUpdateCell

+ (MKCHBatchUpdateCell *)initCellWithTableView:(UITableView *)tableView {
    MKCHBatchUpdateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKCHBatchUpdateCellIdenty"];
    if (!cell) {
        cell = [[MKCHBatchUpdateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKCHBatchUpdateCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.macLabel];
        [self.contentView addSubview:self.statusLabel];
        [self.contentView addSubview:self.retryButton];
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
    [self.retryButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.macLabel.mas_right).mas_offset(10.f);
        make.width.mas_equalTo(45.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(25.f);
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
    if ([self.delegate respondsToSelector:@selector(ch_batchUpdateCell_delete:)]) {
        [self.delegate ch_batchUpdateCell_delete:self.dataModel.index];
    }
}

- (void)retryButtonPressed {
    if ([self.delegate respondsToSelector:@selector(ch_batchUpdateCell_retry:)]) {
        [self.delegate ch_batchUpdateCell_retry:self.dataModel.index];
    }
}

#pragma mark - private method
- (NSString *)cellStatusMsg {
    if (self.dataModel.status == mk_ch_batchUpdateStatus_normal) {
        return @"Wait";
    }
    if (self.dataModel.status == mk_ch_batchUpdateStatus_upgrading) {
        return @"Upgrading";
    }
    if (self.dataModel.status == mk_ch_batchUpdateStatus_timeout) {
        return @"Timeout";
    }
    if (self.dataModel.status == mk_ch_batchUpdateStatus_success) {
        return @"Success";
    }
    if (self.dataModel.status == mk_ch_batchUpdateStatus_failed) {
        return @"Failed";
    }
    return @"";
}

#pragma mark - setter
- (void)setDataModel:(MKCHBatchUpdateCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKCHBatchUpdateCellModel.class]) {
        return;
    }
    self.macLabel.text = SafeStr(_dataModel.macAddress);
    self.statusLabel.text = [self cellStatusMsg];
    if (_dataModel.status == mk_ch_batchUpdateStatus_timeout || _dataModel.status == mk_ch_batchUpdateStatus_failed) {
        self.retryButton.hidden = NO;
    }else {
        self.retryButton.hidden = YES;
    }
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

- (UIButton *)retryButton {
    if (!_retryButton) {
        _retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_retryButton setTitle:@"Retry" forState:UIControlStateNormal];
        [_retryButton.titleLabel setFont:MKFont(13.f)];
        [_retryButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_retryButton addTarget:self
                         action:@selector(retryButtonPressed)
               forControlEvents:UIControlEventTouchUpInside];
    }
    return _retryButton;
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:LOADICON(@"CommureGatewayPlus", @"MKCHBatchUpdateCell", @"ch_subIcon.png") forState:UIControlStateNormal];
        [_deleteButton addTarget:self
                          action:@selector(deleteButtonPressed)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

@end
