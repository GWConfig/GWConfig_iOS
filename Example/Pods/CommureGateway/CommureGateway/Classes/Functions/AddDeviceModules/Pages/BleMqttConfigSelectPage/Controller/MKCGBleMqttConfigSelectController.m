//
//  MKCGBleMqttConfigSelectController.m
//  CommureGateway_Example
//
//  Created by aa on 2023/11/22.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import "MKCGBleMqttConfigSelectController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"

#import "MKTableSectionLineHeader.h"

#import "MKHudManager.h"
#import "MKCustomUIAdopter.h"

#import "MKCGDeviceMQTTParamsModel.h"

#import "MKCGBleMqttConfigSelectModel.h"

#import "MKCGBleMqttConfigSelectHeader.h"

#import "MKCGDeviceParamsListController.h"

@interface MKCGBleMqttConfigSelectController ()<MKCGBleMqttConfigSelectHeaderDelegate>

@property (nonatomic, strong)MKCGBleMqttConfigSelectHeader *headerView;

@property (nonatomic, strong)MKCGBleMqttConfigSelectModel *dataModel;

@end

@implementation MKCGBleMqttConfigSelectController

- (void)dealloc {
    NSLog(@"MKCGBleMqttConfigSelectController销毁");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    NSString *url = [[NSUserDefaults standardUserDefaults] objectForKey:@"cg_ble_cloudUrl_key"];
    if (ValidStr(url)) {
        self.dataModel.url = url;
        [self.headerView updateUrl:url];
    }
}

#pragma mark - MKCGBleMqttConfigSelectHeaderDelegate
- (void)cg_mqttConfigSelectHeaderButtonPressed:(NSInteger)index {
    self.dataModel.fileType = index;
}

- (void)cg_mqttConfigSelectHeaderUrlChanged:(NSString *)url {
    self.dataModel.url = url;
}

#pragma mark - event method
- (void)nextButtonPressed {
    [[MKHudManager share] showHUDWithTitle:@"Waiting..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel startDownFileWithSucBlock:^(NSDictionary * _Nonnull params) {
        @strongify(self);
        [[MKHudManager share] hide];
        
        [[NSUserDefaults standardUserDefaults] setObject:SafeStr(self.dataModel.url) forKey:@"cg_ble_cloudUrl_key"];
        
        [MKCGDeviceMQTTParamsModel shared].cloud = (self.dataModel.fileType == 0);
        [MKCGDeviceMQTTParamsModel shared].params = params;
        
        MKCGDeviceParamsListController *vc = [[MKCGDeviceParamsListController alloc] init];
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
        make.top.mas_equalTo(defaultTopInset + 15.f);
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
- (MKCGBleMqttConfigSelectHeader *)headerView {
    if (!_headerView) {
        _headerView = [[MKCGBleMqttConfigSelectHeader alloc] init];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (MKCGBleMqttConfigSelectModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKCGBleMqttConfigSelectModel alloc] init];
    }
    return _dataModel;
}

@end
