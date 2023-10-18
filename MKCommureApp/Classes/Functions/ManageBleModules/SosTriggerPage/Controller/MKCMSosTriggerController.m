//
//  MKCMSosTriggerController.m
//  MKCommureApp_Example
//
//  Created by aa on 2023/4/22.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCMSosTriggerController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "NSString+MKAdd.h"

#import "MKHudManager.h"

#import "MKCMMQTTDataManager.h"
#import "MKCMMQTTInterface.h"

#import "MKCMDeviceModeManager.h"
#import "MKCMDeviceModel.h"

#import "MKCMSosTriggerCell.h"

@interface MKCMSosTriggerController ()<UITableViewDelegate,
UITableViewDataSource,
MKCMSosTriggerCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@end

@implementation MKCMSosTriggerController

- (void)dealloc {
    NSLog(@"MKCMSosTriggerController销毁");
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
    MKCMSosTriggerCell *cell = [MKCMSosTriggerCell initCellWithTableView:tableView];
    cell.dataModel = self.dataList[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - MKCMSosTriggerCellDelegate
- (void)cm_sosTriggerCellAction:(NSInteger)index {
    [self configSosTrigger:index];
}

#pragma mark - Interface
- (void)readDataFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    [MKCMMQTTInterface cm_readSosTriggerTypeWithBleMacAddress:self.bleMac macAddress:[MKCMDeviceModeManager shared].macAddress topic:[MKCMDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
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
    MKCMSosTriggerCellModel *cellModel1 = self.dataList[0];
    cellModel1.selected = (index == 0);
    
    MKCMSosTriggerCellModel *cellModel2 = self.dataList[1];
    cellModel2.selected = (index == 1);
    
    MKCMSosTriggerCellModel *cellModel3 = self.dataList[2];
    cellModel3.selected = (index == 2);
    
    [self.tableView reloadData];
}

- (void)configSosTrigger:(NSInteger)index {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    [MKCMMQTTInterface cm_configSosTriggerType:index bleMac:self.bleMac macAddress:[MKCMDeviceModeManager shared].macAddress topic:[MKCMDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        [self updateCellModel:index];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    MKCMSosTriggerCellModel *cellModel1 = [[MKCMSosTriggerCellModel alloc] init];
    cellModel1.index = 0;
    cellModel1.msg = @"Single click";
    [self.dataList addObject:cellModel1];
    
    MKCMSosTriggerCellModel *cellModel2 = [[MKCMSosTriggerCellModel alloc] init];
    cellModel2.index = 1;
    cellModel2.msg = @"Double click";
    [self.dataList addObject:cellModel2];
    
    MKCMSosTriggerCellModel *cellModel3 = [[MKCMSosTriggerCellModel alloc] init];
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
        make.top.mas_equalTo(defaultTopInset);
        make.bottom.mas_equalTo(-VirtualHomeHeight);
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
