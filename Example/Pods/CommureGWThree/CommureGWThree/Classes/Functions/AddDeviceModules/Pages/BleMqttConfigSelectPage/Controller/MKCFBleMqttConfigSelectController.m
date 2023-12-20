//
//  MKCFBleMqttConfigSelectController.m
//  CommureGWThree_Example
//
//  Created by aa on 2023/11/22.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import "MKCFBleMqttConfigSelectController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"

#import "MKTableSectionLineHeader.h"

#import "MKHudManager.h"
#import "MKCustomUIAdopter.h"

#import "MKCFDeviceMQTTParamsModel.h"

#import "MKCFBleMqttConfigSelectModel.h"

#import "MKCFBleMqttConfigSelectHeader.h"

#import "MKCFDeviceParamsListController.h"

@interface MKCFBleMqttConfigSelectController ()<MKCFBleMqttConfigSelectHeaderDelegate>

@property (nonatomic, strong)MKCFBleMqttConfigSelectHeader *headerView;

@property (nonatomic, strong)MKCFBleMqttConfigSelectModel *dataModel;

@end

@implementation MKCFBleMqttConfigSelectController

- (void)dealloc {
    NSLog(@"MKCFBleMqttConfigSelectController销毁");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    NSString *url = [[NSUserDefaults standardUserDefaults] objectForKey:@"cf_ble_cloudUrl_key"];
    if (ValidStr(url)) {
        self.dataModel.url = url;
        [self.headerView updateUrl:url];
    }
}

#pragma mark - MKCFBleMqttConfigSelectHeaderDelegate
- (void)cf_mqttConfigSelectHeaderButtonPressed:(NSInteger)index {
    self.dataModel.fileType = index;
}

- (void)cf_mqttConfigSelectHeaderUrlChanged:(NSString *)url {
    self.dataModel.url = url;
}

#pragma mark - event method
- (void)nextButtonPressed {
    [[MKHudManager share] showHUDWithTitle:@"Waiting..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel startDownFileWithSucBlock:^(NSDictionary * _Nonnull params) {
        @strongify(self);
        [[MKHudManager share] hide];
        
        [[NSUserDefaults standardUserDefaults] setObject:SafeStr(self.dataModel.url) forKey:@"cf_ble_cloudUrl_key"];
        
        [MKCFDeviceMQTTParamsModel shared].cloud = (self.dataModel.fileType == 0);
        [MKCFDeviceMQTTParamsModel shared].params = params;
        
        MKCFDeviceParamsListController *vc = [[MKCFDeviceParamsListController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Import Config File";
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).mas_offset(15.f);
        make.height.mas_equalTo(180.f);
    }];
    
    UIButton *nextButton = [MKCustomUIAdopter customButtonWithTitle:@"NEXT"
                                                             target:self
                                                             action:@selector(nextButtonPressed)];
    [self.view addSubview:nextButton];
    [nextButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30.f);
        make.right.mas_equalTo(-30.f);
        make.top.mas_equalTo(self.headerView.mas_bottom).mas_offset(30.f);
        make.height.mas_equalTo(40.f);
    }];
}

#pragma mark - getter
- (MKCFBleMqttConfigSelectHeader *)headerView {
    if (!_headerView) {
        _headerView = [[MKCFBleMqttConfigSelectHeader alloc] init];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (MKCFBleMqttConfigSelectModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKCFBleMqttConfigSelectModel alloc] init];
    }
    return _dataModel;
}

@end
