//
//  MKCFSosTriggerCell.m
//  CommureGWThree_Example
//
//  Created by aa on 2023/4/22.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCFSosTriggerCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"
#import "UIView+MKAdd.h"

@implementation MKCFSosTriggerCellModel
@end

@interface MKCFSosTriggerCell ()

@property (nonatomic, strong)UIControl *backButton;

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UIImageView *rightIcon;

@end

@implementation MKCFSosTriggerCell

+ (MKCFSosTriggerCell *)initCellWithTableView:(UITableView *)tableView {
    MKCFSosTriggerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKCFSosTriggerCellIdenty"];
    if (!cell) {
        cell = [[MKCFSosTriggerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKCFSosTriggerCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.backButton];
        [self.backButton addSubview:self.msgLabel];
        [self.backButton addSubview:self.rightIcon];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.backButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    [self.rightIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(13.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(13.f);
    }];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.rightIcon.mas_left).mas_offset(-10.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(MKFont(14.f).lineHeight);
    }];
}

#pragma mark - event method
- (void)backButtonPressed {
    if ([self.delegate respondsToSelector:@selector(cf_sosTriggerCellAction:)]) {
        [self.delegate cf_sosTriggerCellAction:self.dataModel.index];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKCFSosTriggerCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKCFSosTriggerCellModel.class]) {
        return;
    }
    self.msgLabel.text = SafeStr(_dataModel.msg);
    self.rightIcon.image = (_dataModel.selected ? LOADICON(@"CommureGWThree", @"MKCFSosTriggerCell", @"cf_resetByButtonSelectedIcon.png") : LOADICON(@"CommureGWThree", @"MKCFSosTriggerCell", @"cf_resetByButtonUnselectedIcon.png"));
    self.backButton.selected = _dataModel.selected;
}

#pragma mark - getter
- (UIControl *)backButton {
    if (!_backButton) {
        _backButton = [[UIControl alloc] init];
        [_backButton addTarget:self
                        action:@selector(backButtonPressed)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.font = MKFont(14.f);
    }
    return _msgLabel;
}

- (UIImageView *)rightIcon {
    if (!_rightIcon) {
        _rightIcon = [[UIImageView alloc] init];
        _rightIcon.image = LOADICON(@"CommureGWThree", @"MKCFSosTriggerCell", @"cf_resetByButtonUnselectedIcon.png");
    }
    return _rightIcon;
}

@end
