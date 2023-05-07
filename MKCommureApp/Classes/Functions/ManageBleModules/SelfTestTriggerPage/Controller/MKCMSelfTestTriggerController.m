//
//  MKCMSelfTestTriggerController.m
//  MKCommureApp_Example
//
//  Created by aa on 2023/4/22.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCMSelfTestTriggerController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"
#import "NSString+MKAdd.h"

#import "MKHudManager.h"
#import "MKTextField.h"

#import "MKCMMQTTDataManager.h"
#import "MKCMMQTTInterface.h"

#import "MKCMDeviceModeManager.h"
#import "MKCMDeviceModel.h"

@interface MKCMSelfTestTriggerController ()

@property (nonatomic, strong)MKTextField *textField;

@end

@implementation MKCMSelfTestTriggerController

- (void)dealloc {
    NSLog(@"MKCMSelfTestTriggerController销毁");
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
    [MKCMMQTTInterface cm_readSelfTestTriggeredByButtonWithBleMacAddress:self.bleMac macAddress:[MKCMDeviceModeManager shared].macAddress topic:[MKCMDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        if ([returnData[@"data"][@"result_code"] integerValue] != 0) {
            [self.view showCentralToast:@"Read Failed"];
            return;
        }
        self.textField.text = [NSString stringWithFormat:@"%@",returnData[@"data"][@"time"]];
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
    if (value < 1 || value > 255) {
        [self.view showCentralToast:@"Params error"];
        return;
    }
    [[MKHudManager share] showHUDWithTitle:@"Config" inView:self.view isPenetration:NO];
    [MKCMMQTTInterface cm_configSelfTestTriggeredByButton:value bleMac:self.bleMac macAddress:[MKCMDeviceModeManager shared].macAddress topic:[MKCMDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
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
    self.defaultTitle = @"Self test triggered by button";
    [self.rightButton setImage:LOADICON(@"MKCommureApp", @"MKCMSelfTestTriggerController", @"cm_saveIcon.png") forState:UIControlStateNormal];
    [self.view addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30.f);
        make.right.mas_equalTo(-30.f);
        make.top.mas_equalTo(defaultTopInset + 30.f);
        make.height.mas_equalTo(30.f);
    }];
}

#pragma mark - getter
- (MKTextField *)textField {
    if (!_textField) {
        _textField = [[MKTextField alloc] initWithTextFieldType:mk_realNumberOnly];
        _textField.maxLength = 3;
        _textField.placeholder = @"0-255，unit:second";
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

@end
