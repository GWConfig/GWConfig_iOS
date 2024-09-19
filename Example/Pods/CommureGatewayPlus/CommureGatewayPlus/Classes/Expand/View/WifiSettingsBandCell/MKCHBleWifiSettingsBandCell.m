//
//  MKCHBleWifiSettingsBandCell.m
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/6/15.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCHBleWifiSettingsBandCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKPickerView.h"

static CGFloat const offset_X = 15.f;
static CGFloat const selectButtonWidth = 130.f;
static CGFloat const selectButtonHeight = 30.f;

@implementation MKCHBleWifiSettingsBandCellModel
@end

@interface MKCHBleWifiSettingsBandCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UIButton *selectedButton;

@property (nonatomic, strong)UILabel *noteLabel;

@property (nonatomic, strong)NSMutableArray *dataList;

@end

@implementation MKCHBleWifiSettingsBandCell

+ (MKCHBleWifiSettingsBandCell *)initCellWithTableView:(UITableView *)tableView {
    MKCHBleWifiSettingsBandCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKCHBleWifiSettingsBandCellIdenty"];
    if (!cell) {
        cell = [[MKCHBleWifiSettingsBandCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKCHBleWifiSettingsBandCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.selectedButton];
        [self.contentView addSubview:self.noteLabel];
    }
    return self;
}

#pragma mark - super method
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.width.mas_equalTo(110.f);
        make.top.mas_equalTo(offset_X);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    
    [self.selectedButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-offset_X);
        make.left.mas_equalTo(self.msgLabel.mas_right).mas_offset(10.f);
        make.centerY.mas_equalTo(self.msgLabel.mas_centerY);
        make.height.mas_equalTo(selectButtonHeight);
    }];
    CGSize noteSize = [self noteSize];
    [self.noteLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.right.mas_equalTo(-offset_X);
        make.bottom.mas_equalTo(-offset_X);
        make.height.mas_equalTo(noteSize.height);
    }];
}

#pragma mark - event method
- (void)selectedButtonPressed {
    //隐藏其他cell里面的输入框键盘
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MKTextFieldNeedHiddenKeyboard" object:nil];
    if (!ValidArray(self.dataList)) {
        return;
    }
    NSInteger row = 0;
    for (NSInteger i = 0; i < self.dataList.count; i ++) {
        if ([self.selectedButton.titleLabel.text isEqualToString:self.dataList[i]]) {
            row = i;
            break;
        }
    }
    MKPickerView *pickView = [[MKPickerView alloc] init];
    [pickView showPickViewWithDataList:self.dataList selectedRow:row block:^(NSInteger currentRow) {
        [self.selectedButton setTitle:self.dataList[currentRow] forState:UIControlStateNormal];
        if ([self.delegate respondsToSelector:@selector(ch_bleWifiSettingsBandCell_countryChanged:)]) {
            [self.delegate ch_bleWifiSettingsBandCell_countryChanged:currentRow];
        }
    }];
}

#pragma mark - setter
- (void)setDataModel:(MKCHBleWifiSettingsBandCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKCHBleWifiSettingsBandCellModel.class] || _dataModel.country >= self.dataList.count) {
        return;
    }
    [self.selectedButton setTitle:self.dataList[_dataModel.country] forState:UIControlStateNormal];
    [self setNeedsLayout];
}

#pragma mark - Private method
- (CGSize)noteSize {
    if (!ValidStr(self.noteLabel.text)) {
        return CGSizeMake(0, 0);
    }
    CGFloat width = self.contentView.frame.size.width - 2 * offset_X;
    CGSize noteSize = [NSString sizeWithText:self.noteLabel.text
                                     andFont:self.noteLabel.font
                                  andMaxSize:CGSizeMake(width, MAXFLOAT)];
    return CGSizeMake(width, noteSize.height);
}

#pragma mark - getter
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.font = MKFont(14.f);
        _msgLabel.text = @"Country&Band";
    }
    return _msgLabel;
}

- (UILabel *)noteLabel {
    if (!_noteLabel) {
        _noteLabel = [[UILabel alloc] init];
        _noteLabel.textColor = DEFAULT_TEXT_COLOR;
        _noteLabel.font = MKFont(12.f);
        _noteLabel.textAlignment = NSTextAlignmentLeft;
        _noteLabel.numberOfLines = 0;
        _noteLabel.text = @"Please note the country&Band is a configuration for 5GHZ WiFi,if using 2.4GHz WiFi, there is no need to choose the band.";
    }
    return _noteLabel;
}

- (UIButton *)selectedButton {
    if (!_selectedButton) {
        _selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectedButton setTitleColor:COLOR_WHITE_MACROS forState:UIControlStateNormal];
        [_selectedButton setBackgroundColor:NAVBAR_COLOR_MACROS];
        [_selectedButton.titleLabel setFont:MKFont(12.f)];
        [_selectedButton.layer setMasksToBounds:YES];
        [_selectedButton.layer setCornerRadius:6.f];
        [_selectedButton addTarget:self
                            action:@selector(selectedButtonPressed)
                  forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectedButton;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray arrayWithArray:[self valueList]];
    }
    return _dataList;
}

- (NSArray *)valueList {
    return @[@"United Arab Emirates",@"Argentina",@"American Samoa",@"Austria",@"Australia",@"Barbados",
             @"Burkina Faso",@"Bermuda",@"Brazil",@"Bahamas",@"Canada",@"Central African Republic",@"Côte d'Ivoire",@"China",
             @"Colombia",@"Costa Rica",@"Cuba",@"Christmas Island",@"Dominica",@"Dominican Republic",@"Ecuador",@"Europe",
             @"Micronesia, Federated States of",@"France",@"Grenada",@"Ghana",@"Greece",@"Guatemala",@"Guam",@"Guyana",@"Honduras",
             @"Haiti",@"Jamaica",@"Cayman Islands",@"Kazakhstan",@"Lebanon",@"Sri Lanka",@"Marshall Islands",@"Mongolia"
             ,@"Macao, SAR China",@"Northern Mariana Islands",@"Mauritius",@"Mexico",@"Malaysia",@"Nicaragua",@"Panama",@"Peru",
             @"Papua New Guinea",@"Philippines",@"Puerto Rico",@"Palau",@"Paraguay",@"Rwanda",@"Singapore",@"Senegal",@"El Salvador",@"Syrian Arab Republic (Syria)",@"Turks and Caicos Islands",@"Thailand",
             @"Trinidad and Tobago",@"Taiwan, Republic of China",@"Tanzania, United Republic of",@"Uganda",@"United States of America",@"Uruguay",@"Venezuela (Bolivarian Republic)",@"Virgin Islands,US",@"Viet Nam",@"Vanuatu"];
}

@end
