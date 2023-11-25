//
//  MKCGMqttConfigSelectController.m
//  CommureGateway_Example
//
//  Created by aa on 2023/11/22.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import "MKCGMqttConfigSelectController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"

#import "MKTableSectionLineHeader.h"

#import "MKHudManager.h"
#import "MKCustomUIAdopter.h"

#import "MKCGMqttConfigSelectModel.h"

#import "MKCGMqttConfigSelectHeader.h"

#import "MKCGModifyNetworkDataModel.h"

#import "MKCGMqttParamsListController.h"

@interface MKCGMqttConfigSelectController ()<MKCGMqttConfigSelectHeaderDelegate>

@property (nonatomic, strong)MKCGMqttConfigSelectHeader *headerView;

@property (nonatomic, strong)MKCGMqttConfigSelectModel *dataModel;

@end

@implementation MKCGMqttConfigSelectController

- (void)dealloc {
    NSLog(@"MKCGMqttConfigSelectController销毁");
    [MKCGModifyNetworkDataModel sharedDealloc];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    NSString *url = [[NSUserDefaults standardUserDefaults] objectForKey:@"cg_mqtt_cloudUrl_key"];
    if (ValidStr(url)) {
        self.dataModel.url = url;
        [self.headerView updateUrl:url];
    }
}

#pragma mark - MKCGMqttConfigSelectHeaderDelegate
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
        [[NSUserDefaults standardUserDefaults] setObject:SafeStr(self.dataModel.url) forKey:@"cg_mqtt_cloudUrl_key"];
        
        [MKCGModifyNetworkDataModel shared].cloud = (self.dataModel.fileType == 0);
        [MKCGModifyNetworkDataModel shared].params = params;
        
        MKCGMqttParamsListController *vc = [[MKCGMqttParamsListController alloc] init];
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
- (MKCGMqttConfigSelectHeader *)headerView {
    if (!_headerView) {
        _headerView = [[MKCGMqttConfigSelectHeader alloc] init];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (MKCGMqttConfigSelectModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKCGMqttConfigSelectModel alloc] init];
    }
    return _dataModel;
}

@end
