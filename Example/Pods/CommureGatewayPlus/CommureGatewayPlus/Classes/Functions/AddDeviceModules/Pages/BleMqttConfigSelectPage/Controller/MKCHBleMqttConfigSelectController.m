//
//  MKCHBleMqttConfigSelectController.m
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/11/22.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import "MKCHBleMqttConfigSelectController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"

#import "MKTableSectionLineHeader.h"

#import "MKHudManager.h"
#import "MKCustomUIAdopter.h"

#import "MKCHDeviceMQTTParamsModel.h"

#import "MKCHBleMqttConfigSelectModel.h"

#import "MKCHBleMqttConfigSelectHeader.h"

#import "MKCHDeviceParamsListController.h"

@interface MKCHBleMqttConfigSelectController ()<MKCHBleMqttConfigSelectHeaderDelegate>

@property (nonatomic, strong)MKCHBleMqttConfigSelectHeader *headerView;

@property (nonatomic, strong)MKCHBleMqttConfigSelectModel *dataModel;

@end

@implementation MKCHBleMqttConfigSelectController

- (void)dealloc {
    NSLog(@"MKCHBleMqttConfigSelectController销毁");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    NSString *url = [[NSUserDefaults standardUserDefaults] objectForKey:@"ch_ble_cloudUrl_key"];
    if (ValidStr(url)) {
        self.dataModel.url = url;
        [self.headerView updateUrl:url];
    }
}

#pragma mark - MKCHBleMqttConfigSelectHeaderDelegate
- (void)ch_mqttConfigSelectHeaderButtonPressed:(NSInteger)index {
    self.dataModel.fileType = index;
}

- (void)ch_mqttConfigSelectHeaderUrlChanged:(NSString *)url {
    self.dataModel.url = url;
}

#pragma mark - event method
- (void)nextButtonPressed {
    [[MKHudManager share] showHUDWithTitle:@"Waiting..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel startDownFileWithSucBlock:^(NSDictionary * _Nonnull params) {
        @strongify(self);
        [[MKHudManager share] hide];
        
        [[NSUserDefaults standardUserDefaults] setObject:SafeStr(self.dataModel.url) forKey:@"ch_ble_cloudUrl_key"];
        
        [MKCHDeviceMQTTParamsModel shared].cloud = (self.dataModel.fileType == 0);
        [MKCHDeviceMQTTParamsModel shared].params = params;
        
        MKCHDeviceParamsListController *vc = [[MKCHDeviceParamsListController alloc] init];
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
- (MKCHBleMqttConfigSelectHeader *)headerView {
    if (!_headerView) {
        _headerView = [[MKCHBleMqttConfigSelectHeader alloc] init];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (MKCHBleMqttConfigSelectModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKCHBleMqttConfigSelectModel alloc] init];
    }
    return _dataModel;
}

@end
