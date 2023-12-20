//
//  MKCFDecryptionKeyController.m
//  CommureGWThree_Example
//
//  Created by aa on 2023/4/21.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCFDecryptionKeyController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"
#import "NSString+MKAdd.h"

#import "MKCustomUIAdopter.h"
#import "MKHudManager.h"
#import "MKTextField.h"

#import "MKCFDecryptionKeyModel.h"

@interface MKCFDecryptionKeyController ()

@property (nonatomic, strong)MKTextField *textField;

@property (nonatomic, strong)UILabel *noteLabel;

@property (nonatomic, strong)MKCFDecryptionKeyModel *dataModel;

@end

@implementation MKCFDecryptionKeyController

- (void)dealloc {
    NSLog(@"MKCFDecryptionKeyController销毁");
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
        self.textField.text = self.dataModel.decryptionKey;
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
    self.dataModel.decryptionKey = SafeStr(self.textField.text);
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
    self.defaultTitle = @"Decryption key";
    [self.rightButton setImage:LOADICON(@"CommureGWThree", @"MKCFDecryptionKeyController", @"cf_saveIcon.png") forState:UIControlStateNormal];
    UIView *topView = [self topView];
    [self.view addSubview:topView];
    [topView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.height.mas_equalTo(40.f);
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
        _textField = [[MKTextField alloc] initWithTextFieldType:mk_hexCharOnly];
        _textField.maxLength = 64;
        _textField.placeholder = @"32 Bytes";
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

- (MKCFDecryptionKeyModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKCFDecryptionKeyModel alloc] init];
    }
    return _dataModel;
}

- (UIView *)topView {
    UIView *topView = [[UIView alloc] init];
    UILabel *timeOffsetLabel = [[UILabel alloc] init];
    timeOffsetLabel.textAlignment = NSTextAlignmentLeft;
    timeOffsetLabel.textColor = DEFAULT_TEXT_COLOR;
    timeOffsetLabel.font = MKFont(15.f);
    timeOffsetLabel.text = @"Decryption key";
    [topView addSubview:timeOffsetLabel];
    [timeOffsetLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(10.f);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    return  topView;
}

@end
