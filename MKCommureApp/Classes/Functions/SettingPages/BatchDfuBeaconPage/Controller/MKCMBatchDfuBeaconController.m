//
//  MKCMBatchDfuBeaconController.m
//  MKCommureApp_Example
//
//  Created by aa on 2023/4/21.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCMBatchDfuBeaconController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "NSString+MKAdd.h"

#import "MKHudManager.h"
#import "MKCustomUIAdopter.h"

#import "MKCMMQTTDataManager.h"
#import "MKCMMQTTInterface.h"

#import "MKCMDeviceModeManager.h"
#import "MKCMDeviceModel.h"

#import "MKCMExcelDataManager.h"

#import "MKCMImportServerController.h"

#import "MKCMBatchDfuBeaconModel.h"

#import "MKCMBatchDfuBeaconHeaderView.h"
#import "MKCMBatchDfuBeaconCell.h"

@interface MKCMBatchDfuBeaconController ()<UITableViewDelegate,
UITableViewDataSource,
MKCMImportServerControllerDelegate,
MKCMBatchDfuBeaconHeaderViewDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)MKCMBatchDfuBeaconModel *dataModel;

@property (nonatomic, strong)MKCMBatchDfuBeaconHeaderView *tableHeaderView;

@end

@implementation MKCMBatchDfuBeaconController

- (void)dealloc {
    NSLog(@"MKCMBatchDfuBeaconController销毁");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];

    //本页面禁止右划退出手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self loadSectionDatas];
}

#pragma mark - super method
- (void)rightButtonMethod {
    [self configDataToDevice];
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
    MKCMBatchDfuBeaconCell *cell = [MKCMBatchDfuBeaconCell initCellWithTableView:tableView];
    cell.dataModel = self.dataList[indexPath.row];
    return cell;
}

#pragma mark - MKCMImportServerControllerDelegate
- (void)cm_selectedServerParams:(NSString *)fileName {
    [[MKHudManager share] showHUDWithTitle:@"Loading..." inView:self.view isPenetration:NO];
    [MKCMExcelDataManager parseBeaconExcel:fileName sucBlock:^(NSArray<NSDictionary *> * _Nonnull beaconInfoList) {
        [[MKHudManager share] hide];
        [self.dataList removeAllObjects];
        for (NSInteger i = 0; i < beaconInfoList.count; i ++) {
            NSDictionary *beaconDic = beaconInfoList[i];
            MKCMBatchDfuBeaconCellModel *cellModel = [[MKCMBatchDfuBeaconCellModel alloc] init];
            cellModel.macAddress = beaconDic[@"macAddress"];
            cellModel.password = beaconDic[@"password"];
            [self.dataList addObject:cellModel];
        }
        [self.tableView reloadData];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - MKCMBatchDfuBeaconHeaderViewDelegate
- (void)cm_firmwareUrlChanged:(NSString *)url {
    self.dataModel.firmwareUrl = url;
}

- (void)cm_dataFileUrlChanged:(NSString *)url {
    self.dataModel.dataUrl = url;
}

- (void)cm_beaconListButtonPressed {
    MKCMImportServerController *vc = [[MKCMImportServerController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - event method
- (void)configDataToDevice {
    if (!self.dataList.count == 0 || self.dataList.count > 20) {
        [self.view showCentralToast:@"Beacon list MAC error"];
        return;
    }
    [[MKHudManager share] showHUDWithTitle:@"Waiting..." inView:self.view isPenetration:NO];
    NSMutableArray *list = [NSMutableArray array];
    for (NSInteger i = 0; i < self.dataList.count; i ++) {
        MKCMBatchDfuBeaconCellModel *cellModel = self.dataList[i];
        NSDictionary *dic = @{
            @"macAddress":cellModel.macAddress,
            @"password":SafeStr(cellModel.password)
        };
        [list addObject:dic];
    }
    
    @weakify(self);
    [self.dataModel configDataWithBeaconList:list sucBlock:^{
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"setup succeed!"];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    
    
    [self.tableView reloadData];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Batch DFU Beacon";
    [self.rightButton setImage:LOADICON(@"MKCommureApp", @"MKCMBatchDfuBeaconController", @"cm_saveIcon.png") forState:UIControlStateNormal];
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
        
        _tableView.tableHeaderView = self.tableHeaderView;
    }
    return _tableView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (MKCMBatchDfuBeaconModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKCMBatchDfuBeaconModel alloc] init];
    }
    return _dataModel;
}

- (MKCMBatchDfuBeaconHeaderView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[MKCMBatchDfuBeaconHeaderView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 160.f)];
        _tableHeaderView.delegate = self;
    }
    return _tableHeaderView;
}

@end
