//
//  MKCMNetworkStatusController.m
//  MKCommureApp_Example
//
//  Created by aa on 2023/2/11.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCMNetworkStatusController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"
#import "NSString+MKAdd.h"

#import "MKCustomUIAdopter.h"
#import "MKHudManager.h"
#import "MKTextField.h"

#import "MKCMNetworkStatusModel.h"

@interface MKCMNetworkStatusController ()

@property (nonatomic, strong)MKTextField *textField;

@property (nonatomic, strong)UILabel *noteLabel;

@property (nonatomic, strong)MKCMNetworkStatusModel *dataModel;

@end

@implementation MKCMNetworkStatusController

- (void)dealloc {
    NSLog(@"MKCMNetworkStatusController销毁");
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
        self.textField.text = self.dataModel.interval;
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
    self.dataModel.interval = SafeStr(self.textField.text);
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
    self.defaultTitle = @"Network Status report interval";
    [self.rightButton setImage:LOADICON(@"MKCommureApp", @"MKCMNetworkStatusController", @"cm_saveIcon.png") forState:UIControlStateNormal];
    [self.view addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30.f);
        make.right.mas_equalTo(-30.f);
        make.top.mas_equalTo(defaultTopInset + 30.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.view addSubview:self.noteLabel];
    CGSize size = [NSString sizeWithText:self.noteLabel.text
                                 andFont:self.noteLabel.font
                              andMaxSize:CGSizeMake(kViewWidth - 2 * 15.f, MAXFLOAT)];
    [self.noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.textField.mas_bottom).mas_offset(15.f);
        make.height.mas_equalTo(size.height);
    }];
}

#pragma mark - getter
- (MKTextField *)textField {
    if (!_textField) {
        _textField = [[MKTextField alloc] initWithTextFieldType:mk_realNumberOnly];
        _textField.maxLength = 5;
        _textField.placeholder = @"0 or 30-86400, unit: s";
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
        _noteLabel.text = @"This value defines the time interval at which the device reports its network status. A value of 0 means that the device will report the network status only once when it connects successfully.";
        _noteLabel.numberOfLines = 0;
    }
    return _noteLabel;
}

- (MKCMNetworkStatusModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKCMNetworkStatusModel alloc] init];
    }
    return _dataModel;
}

@end
