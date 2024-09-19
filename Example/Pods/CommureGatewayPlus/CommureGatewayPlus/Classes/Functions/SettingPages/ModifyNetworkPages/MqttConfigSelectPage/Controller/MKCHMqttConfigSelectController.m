//
//  MKCHMqttConfigSelectController.m
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/11/22.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import "MKCHMqttConfigSelectController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"

#import "MKTableSectionLineHeader.h"

#import "MKHudManager.h"
#import "MKCustomUIAdopter.h"

#import "MKCHMqttConfigSelectModel.h"

#import "MKCHMqttConfigSelectHeader.h"

#import "MKCHModifyNetworkDataModel.h"

#import "MKCHMqttParamsListController.h"

@interface MKCHMqttConfigSelectController ()<MKCHMqttConfigSelectHeaderDelegate>

@property (nonatomic, strong)MKCHMqttConfigSelectHeader *headerView;

@property (nonatomic, strong)MKCHMqttConfigSelectModel *dataModel;

@end

@implementation MKCHMqttConfigSelectController

- (void)dealloc {
    NSLog(@"MKCHMqttConfigSelectController销毁");
    [MKCHModifyNetworkDataModel sharedDealloc];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    NSString *url = [[NSUserDefaults standardUserDefaults] objectForKey:@"ch_mqtt_cloudUrl_key"];
    if (ValidStr(url)) {
        self.dataModel.url = url;
        [self.headerView updateUrl:url];
    }
}

#pragma mark - MKCHMqttConfigSelectHeaderDelegate
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
        [[NSUserDefaults standardUserDefaults] setObject:SafeStr(self.dataModel.url) forKey:@"ch_mqtt_cloudUrl_key"];
        
        [MKCHModifyNetworkDataModel shared].cloud = (self.dataModel.fileType == 0);
        [MKCHModifyNetworkDataModel shared].params = params;
        
        MKCHMqttParamsListController *vc = [[MKCHMqttParamsListController alloc] init];
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
- (MKCHMqttConfigSelectHeader *)headerView {
    if (!_headerView) {
        _headerView = [[MKCHMqttConfigSelectHeader alloc] init];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (MKCHMqttConfigSelectModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKCHMqttConfigSelectModel alloc] init];
    }
    return _dataModel;
}

@end
