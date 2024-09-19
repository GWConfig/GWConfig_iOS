//
//  MKCHResetByButtonController.m
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/2/13.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCHResetByButtonController.h"

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

#import "MKCHResetByButtonCell.h"

@interface MKCHResetByButtonController ()<UITableViewDelegate,
UITableViewDataSource,
MKCHResetByButtonCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@end

@implementation MKCHResetByButtonController

- (void)dealloc {
    NSLog(@"MKCHResetByButtonController销毁");
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
    MKCHResetByButtonCell *cell = [MKCHResetByButtonCell initCellWithTableView:tableView];
    cell.dataModel = self.dataList[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - MKCHResetByButtonCellDelegate
- (void)ch_resetByButtonCellAction:(NSInteger)index {
    [self configResetByButton:index];
}

#pragma mark - Interface
- (void)readDataFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    [MKCHMQTTInterface ch_readKeyResetTypeWithMacAddress:[MKCHDeviceModeManager shared].macAddress topic:[MKCHDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        [self updateCellModel:[returnData[@"data"][@"key_reset_type"] integerValue]];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)updateCellModel:(NSInteger)index {
    MKCHResetByButtonCellModel *cellModel1 = self.dataList[0];
    cellModel1.selected = (index == 0);
    
    MKCHResetByButtonCellModel *cellModel2 = self.dataList[1];
    cellModel2.selected = (index == 1);
    
    [self.tableView reloadData];
}

- (void)configResetByButton:(NSInteger)index {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    [MKCHMQTTInterface ch_configKeyResetType:index macAddress:[MKCHDeviceModeManager shared].macAddress topic:[MKCHDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        [self updateCellModel:index];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    MKCHResetByButtonCellModel *cellModel1 = [[MKCHResetByButtonCellModel alloc] init];
    cellModel1.index = 0;
    cellModel1.msg = @"Press in 1 minute after powered";
    [self.dataList addObject:cellModel1];
    
    MKCHResetByButtonCellModel *cellModel2 = [[MKCHResetByButtonCellModel alloc] init];
    cellModel2.index = 1;
    cellModel2.msg = @"Press any time";
    [self.dataList addObject:cellModel2];
    
    [self.tableView reloadData];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Reset device by button";
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
