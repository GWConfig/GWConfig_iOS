//
//  MKCMTimeOffsetController.m
//  MKCommureApp_Example
//
//  Created by aa on 2023/4/20.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCMTimeOffsetController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"
#import "NSString+MKAdd.h"

#import "MKCustomUIAdopter.h"
#import "MKHudManager.h"
#import "MKTextField.h"

#import "MKCMTimeOffsetModel.h"

@interface MKCMTimeOffsetController ()

@property (nonatomic, strong)MKTextField *textField;

@property (nonatomic, strong)UILabel *noteLabel;

@property (nonatomic, strong)MKCMTimeOffsetModel *dataModel;

@end

@implementation MKCMTimeOffsetController

- (void)dealloc {
    NSLog(@"MKCMTimeOffsetController销毁");
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDataFromDevice];
}

#pragma mark - super method
- (void)rightButtonMethod {
    [self configDataToDevice];
}

#pragma mark - interface
- (void)readDataFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel readDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        self.textField.text = self.dataModel.time;
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)configDataToDevice {
    if (!ValidStr(self.textField.text)) {
        [self.view showCentralToast:@"Cannot be empty!"];
        return;
    }
    self.dataModel.time = SafeStr(self.textField.text);
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel configDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Setup succeed!"];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Time offset";
    [self.rightButton setImage:LOADICON(@"MKCommureApp", @"MKCMTimeOffsetController", @"cm_saveIcon.png") forState:UIControlStateNormal];
    UIView *topView = [self topView];
    [self.view addSubview:topView];
    [topView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(defaultTopInset);
        make.height.mas_equalTo(60.f);
    }];
    [self.view addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30.f);
        make.right.mas_equalTo(-30.f);
        make.top.mas_equalTo(topView.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(30.f);
    }];
}

#pragma mark - getter
- (MKTextField *)textField {
    if (!_textField) {
        _textField = [[MKTextField alloc] initWithTextFieldType:mk_realNumberOnly];
        _textField.maxLength = 3;
        _textField.placeholder = @"0-600, minutes";
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.font = MKFont(13.f);
        
        _textField.backgroundColor = COLOR_WHITE_MACROS;
        _textField.layer.masksToBounds = YES;
        _textField.layer.borderWidth = CUTTING_LINE_HEIGHT;
        _textField.layer.borderColor = CUTTING_LINE_COLOR.CGColor;
        _textField.layer.cornerRadius = 6.f;
    }
    return _textField;
}

- (UILabel *)noteLabel {
    if (!_noteLabel) {
        _noteLabel = [[UILabel alloc] init];
        _noteLabel.textAlignment = NSTextAlignmentLeft;
        _noteLabel.font = MKFont(13.f);
        _noteLabel.textColor = UIColorFromRGB(0xcccccc);
        _noteLabel.text = @"(The allowed time offset between gateway and badge).";
        _noteLabel.numberOfLines = 0;
    }
    return _noteLabel;
}

- (MKCMTimeOffsetModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKCMTimeOffsetModel alloc] init];
    }
    return _dataModel;
}

- (UIView *)topView {
    UIView *topView = [[UIView alloc] init];
    UILabel *timeOffsetLabel = [[UILabel alloc] init];
    timeOffsetLabel.textAlignment = NSTextAlignmentLeft;
    timeOffsetLabel.textColor = DEFAULT_TEXT_COLOR;
    timeOffsetLabel.font = MKFont(15.f);
    timeOffsetLabel.text = @"Time offset";
    [topView addSubview:timeOffsetLabel];
    [timeOffsetLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(10.f);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    UILabel *noteLabel = [[UILabel alloc] init];
    noteLabel.textAlignment = NSTextAlignmentLeft;
    noteLabel.textColor = UIColorFromRGB(0xcccccc);
    noteLabel.font = MKFont(13.f);
    noteLabel.text = @"(The allowed time offset between gateway and badge)";
    [topView addSubview:noteLabel];
    [noteLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(timeOffsetLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    return  topView;
}

@end
