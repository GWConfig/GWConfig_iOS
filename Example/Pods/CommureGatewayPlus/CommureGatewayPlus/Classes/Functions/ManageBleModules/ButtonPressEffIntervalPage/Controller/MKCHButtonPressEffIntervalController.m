//
//  MKCHButtonPressEffIntervalController.m
//  CommureGatewayPlus_Example
//
//  Created by aa on 2024/5/9.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import "MKCHButtonPressEffIntervalController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"
#import "NSString+MKAdd.h"

#import "MKHudManager.h"
#import "MKTextField.h"

#import "MKCHMQTTDataManager.h"
#import "MKCHMQTTInterface.h"

#import "MKCHDeviceModeManager.h"
#import "MKCHDeviceModel.h"

@interface MKCHButtonPressEffIntervalController ()

@property (nonatomic, strong)MKTextField *textField;

@end

@implementation MKCHButtonPressEffIntervalController

- (void)dealloc {
    NSLog(@"MKCHButtonPressEffIntervalController销毁");
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

#pragma mark - super mthod
- (void)rightButtonMethod {
    [self configDatas];
}

#pragma mark - Interface
- (void)readDataFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    [MKCHMQTTInterface ch_readButtonPressEffectiveIntervalWithBleMacAddress:self.bleMac macAddress:[MKCHDeviceModeManager shared].macAddress topic:[MKCHDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        if ([returnData[@"data"][@"result_code"] integerValue] != 0) {
            [self.view showCentralToast:@"Read Failed"];
            return;
        }
        self.textField.text = [NSString stringWithFormat:@"%@",returnData[@"data"][@"key_valid_interval"]];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)configDatas {
    if (!ValidStr(self.textField.text)) {
        [self.view showCentralToast:@"Cannot be empty!"];
        return;
    }
    NSInteger value = [self.textField.text integerValue];
    if (value < 5 || value > 20) {
        [self.view showCentralToast:@"Params error"];
        return;
    }
    [[MKHudManager share] showHUDWithTitle:@"Config" inView:self.view isPenetration:NO];
    [MKCHMQTTInterface ch_configButtonPressEffectiveIntervalWithBleMacAddress:self.bleMac interval:value macAddress:[MKCHDeviceModeManager shared].macAddress topic:[MKCHDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        if ([returnData[@"data"][@"result_code"] integerValue] != 0) {
            [self.view showCentralToast:@"Read Failed"];
            return;
        }
        [self.view showCentralToast:@"Success!"];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - UI
- (void)loadSubViews {
    self.titleLabel.font = MKFont(15.f);
    self.defaultTitle = @"Button press effective interval";
    [self.rightButton setImage:LOADICON(@"CommureGatewayPlus", @"MKCHButtonPressEffIntervalController", @"ch_saveIcon.png") forState:UIControlStateNormal];
    [self.view addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30.f);
        make.right.mas_equalTo(-30.f);
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).mas_offset(30.f);
        make.height.mas_equalTo(30.f);
    }];
    UILabel *noteLabel = [self noteLabel];
    [self.view addSubview:noteLabel];
    [noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.textField.mas_bottom).mas_offset(30.f);
        make.height.mas_equalTo(100.f);
    }];
}

#pragma mark - getter
- (MKTextField *)textField {
    if (!_textField) {
        _textField = [[MKTextField alloc] initWithTextFieldType:mk_realNumberOnly];
        _textField.maxLength = 2;
        _textField.placeholder = @"5-20, unit: 100ms";
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
    UILabel *noteLabel = [[UILabel alloc] init];
    noteLabel.textColor = DEFAULT_TEXT_COLOR;
    noteLabel.font = MKFont(12.f);
    noteLabel.textAlignment = NSTextAlignmentLeft;
    noteLabel.numberOfLines = 0;
    noteLabel.text = @"Button press effective interval: The threshold value to distiguish the single press, double press and triple press. For example: If you have set with 2000ms, when you press button once and in the next 2000ms if you press button again, and no more actions in the next 2000ms, then it will be recognized as double press action.";
    return noteLabel;
}

@end
