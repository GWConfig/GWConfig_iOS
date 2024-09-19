//
//  MKCHSosTriggerController.m
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/4/22.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCHSosTriggerController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "NSString+MKAdd.h"

#import "MKHudManager.h"

#import "MKCHMQTTDataManager.h"
#import "MKCHMQTTInterface.h"

#import "MKCHDeviceModeManager.h"
#import "MKCHDeviceModel.h"

#import "MKCHSosTriggerCell.h"

@interface MKCHSosTriggerController ()<UITableViewDelegate,
UITableViewDataSource,
MKCHSosTriggerCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@end

@implementation MKCHSosTriggerController

- (void)dealloc {
    NSLog(@"MKCHSosTriggerController销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self loadSectionDatas];
    [self readDataFromDevice];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKCHSosTriggerCell *cell = [MKCHSosTriggerCell initCellWithTableView:tableView];
    cell.dataModel = self.dataList[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - MKCHSosTriggerCellDelegate
- (void)ch_sosTriggerCellAction:(NSInteger)index {
    [self configSosTrigger:index];
}

#pragma mark - Interface
- (void)readDataFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    [MKCHMQTTInterface ch_readSosTriggerTypeWithBleMacAddress:self.bleMac macAddress:[MKCHDeviceModeManager shared].macAddress topic:[MKCHDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        if ([returnData[@"data"][@"result_code"] integerValue] != 0) {
            [self.view showCentralToast:@"Read Failed"];
            return;
        }
        [self updateCellModel:([returnData[@"data"][@"mode"] integerValue] - 1)];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)updateCellModel:(NSInteger)index {
    MKCHSosTriggerCellModel *cellModel1 = self.dataList[0];
    cellModel1.selected = (index == 0);
    
    MKCHSosTriggerCellModel *cellModel2 = self.dataList[1];
    cellModel2.selected = (index == 1);
    
    MKCHSosTriggerCellModel *cellModel3 = self.dataList[2];
    cellModel3.selected = (index == 2);
    
    [self.tableView reloadData];
}

- (void)configSosTrigger:(NSInteger)index {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    [MKCHMQTTInterface ch_configSosTriggerType:index bleMac:self.bleMac macAddress:[MKCHDeviceModeManager shared].macAddress topic:[MKCHDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        [self updateCellModel:index];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    MKCHSosTriggerCellModel *cellModel1 = [[MKCHSosTriggerCellModel alloc] init];
    cellModel1.index = 0;
    cellModel1.msg = @"Single click";
    [self.dataList addObject:cellModel1];
    
    MKCHSosTriggerCellModel *cellModel2 = [[MKCHSosTriggerCellModel alloc] init];
    cellModel2.index = 1;
    cellModel2.msg = @"Double click";
    [self.dataList addObject:cellModel2];
    
    MKCHSosTriggerCellModel *cellModel3 = [[MKCHSosTriggerCellModel alloc] init];
    cellModel3.index = 2;
    cellModel3.msg = @"Triple click";
    [self.dataList addObject:cellModel3];
    
    [self.tableView reloadData];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"SOS triggered by button";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
    }];
}

#pragma mark - getter
- (MKBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
    }
    return _tableView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

@end
