//
//  MKCFDownLoadModifyController.m
//  CommureGWThree_Example
//
//  Created by aa on 2023/12/14.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import "MKCFDownLoadModifyController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"

#import "MKCustomUIAdopter.h"
#import "MKHudManager.h"
#import "MKTextField.h"

#import "MKCFBatchModifyManager.h"

#import "MKCFDownLoadModifyModel.h"

#import "MKCFBatchModifyController.h"

@interface MKCFDownLoadModifyController ()

@property (nonatomic, strong)MKTextField *textField;

@property (nonatomic, strong)UIButton *downLoadButton;

@property (nonatomic, strong)MKCFDownLoadModifyModel *dataModel;

@end

@implementation MKCFDownLoadModifyController

- (void)dealloc {
    NSLog(@"MKCFDownLoadModifyController销毁");
    [MKCFBatchModifyManager sharedDealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    
    NSString *url = [[NSUserDefaults standardUserDefaults] objectForKey:@"cf_mqtt_modify_cloudUrl_key"];
    if (ValidStr(url)) {
        self.dataModel.url = url;
        self.textField.text = url;
    }
}

#pragma mark - event method
- (void)downLoadButtonPressed {
    [[MKHudManager share] showHUDWithTitle:@"Waiting..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel startDownFileWithSucBlock:^(NSDictionary * _Nonnull params) {
        @strongify(self);
        [[MKHudManager share] hide];
        [[NSUserDefaults standardUserDefaults] setObject:SafeStr(self.dataModel.url) forKey:@"cf_mqtt_modify_cloudUrl_key"];
        
        [MKCFBatchModifyManager shared].params = params;
        
        MKCFBatchModifyController *vc = [[MKCFBatchModifyController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Down Data";
    [self.view addSubview:self.textField];
    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30.f);
        make.right.mas_equalTo(-30.f);
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).mas_offset(50.f);
        make.height.mas_equalTo(40.f);
    }];
    [self.view addSubview:self.downLoadButton];
    [self.downLoadButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50.f);
        make.right.mas_equalTo(-50.f);
        make.top.mas_equalTo(self.textField.mas_bottom).mas_offset(50.f);
        make.height.mas_equalTo(40.f);
    }];
}

#pragma mark - getter
- (MKTextField *)textField {
    if (!_textField) {
        _textField = [MKCustomUIAdopter customNormalTextFieldWithText:@""
                                                          placeHolder:@"Please input URL link here"
                                                             textType:mk_normal];
        @weakify(self);
        _textField.textChangedBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            self.dataModel.url = text;
        };
    }
    return _textField;
}

- (UIButton *)downLoadButton {
    if (!_downLoadButton) {
        _downLoadButton = [MKCustomUIAdopter customButtonWithTitle:@"Import Config File - Cloud" 
                                                            target:self
                                                            action:@selector(downLoadButtonPressed)];
    }
    return _downLoadButton;
}

- (MKCFDownLoadModifyModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKCFDownLoadModifyModel alloc] init];
    }
    return _dataModel;
}

@end
