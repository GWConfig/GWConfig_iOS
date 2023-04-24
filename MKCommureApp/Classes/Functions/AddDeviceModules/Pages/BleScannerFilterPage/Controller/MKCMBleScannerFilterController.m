//
//  MKCMBleScannerFilterController.m
//  MKCommureApp_Example
//
//  Created by aa on 2023/1/31.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCMBleScannerFilterController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"

#import "MKHudManager.h"
#import "MKCustomUIAdopter.h"
#import "MKNormalSliderCell.h"
#import "MKTableSectionLineHeader.h"

#import "MKCMFilterNormalTextFieldCell.h"

#import "MKCMBleScannerFilterModel.h"

@interface MKCMBleScannerFilterController ()<UITableViewDelegate,
UITableViewDataSource,
MKNormalSliderCellDelegate,
MKCMFilterNormalTextFieldCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *headerList;

@property (nonatomic, strong)MKCMBleScannerFilterModel *dataModel;

@end

@implementation MKCMBleScannerFilterController

- (void)dealloc {
    NSLog(@"MKCMBleScannerFilterController销毁");
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
    [self readDatasFromDevice];
}

#pragma mark - super method
- (void)rightButtonMethod {
    [self saveDataToDevice];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 60.f;
    }
    return 66.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MKTableSectionLineHeader *headerView = [MKTableSectionLineHeader initHeaderViewWithTableView:tableView];
    headerView.headerModel = self.headerList[section];
    return headerView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.headerList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.section0List.count;
    }
    if (section == 1) {
        return self.section1List.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKNormalSliderCell *cell = [MKNormalSliderCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKCMFilterNormalTextFieldCell *cell = [MKCMFilterNormalTextFieldCell initCellWithTableView:tableView];
    cell.dataModel = self.section1List[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - MKNormalSliderCellDelegate
/// slider值发生改变的回调事件
/// @param value 当前slider的值
/// @param index 当前cell所在的index
- (void)mk_normalSliderValueChanged:(NSInteger)value index:(NSInteger)index {
    if (index == 0) {
        //RSSI Filter
        self.dataModel.rssi = value;
        MKNormalSliderCellModel *cellModel = self.section0List[0];
        cellModel.sliderValue = value;
        return;
    }
}

#pragma mark - MKCMFilterNormalTextFieldCellDelegate

- (void)mk_cm_filterNormalTextFieldValueChanged:(NSString *)text index:(NSInteger)index {
    if (index == 0) {
        //macAddress
        self.dataModel.macAddress = text;
        MKCMFilterNormalTextFieldCellModel *cellModel = self.section1List[0];
        cellModel.textFieldValue = text;
        return;
    }
    if (index == 1) {
        //ADV Name
        self.dataModel.advName = text;
        MKCMFilterNormalTextFieldCellModel *cellModel = self.section1List[1];
        cellModel.textFieldValue = text;
        return;
    }
}

#pragma mark - interface
- (void)readDatasFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel readDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self loadSectionDatas];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)saveDataToDevice {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel configDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success"];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    
    for (NSInteger i = 0; i < 2; i ++) {
        MKTableSectionLineHeaderModel *headerModel = [[MKTableSectionLineHeaderModel alloc] init];
        [self.headerList addObject:headerModel];
    }
    
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKNormalSliderCellModel *cellModel = [[MKNormalSliderCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = [MKCustomUIAdopter attributedString:@[@"RSSI Filter",@"   (-127dBm ~ 0dBm)"] fonts:@[MKFont(15.f),MKFont(13.f)] colors:@[DEFAULT_TEXT_COLOR,RGBCOLOR(223, 223, 223)]];
    cellModel.sliderValue = self.dataModel.rssi;
    [self.section0List addObject:cellModel];
}

- (void)loadSection1Datas {
    MKCMFilterNormalTextFieldCellModel *cellModel1 = [[MKCMFilterNormalTextFieldCellModel alloc] init];
    cellModel1.index = 0;
    cellModel1.msg = @"Filter by MAC Address";
    cellModel1.maxLength = 12;
    cellModel1.textPlaceholder = @"0~6 Bytes";
    cellModel1.textFieldType = mk_hexCharOnly;
    cellModel1.textFieldValue = self.dataModel.macAddress;
    [self.section1List addObject:cellModel1];
    
    MKCMFilterNormalTextFieldCellModel *cellModel2 = [[MKCMFilterNormalTextFieldCellModel alloc] init];
    cellModel2.index = 1;
    cellModel2.msg = @"Filter by ADV Name";
    cellModel2.maxLength = 20;
    cellModel2.textPlaceholder = @"0~20 Characters";
    cellModel2.textFieldType = mk_normal;
    cellModel2.textFieldValue = self.dataModel.advName;
    [self.section1List addObject:cellModel2];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Scanner Filter";
    [self.rightButton setImage:LOADICON(@"MKCommureApp", @"MKCMBleScannerFilterController", @"cm_saveIcon.png") forState:UIControlStateNormal];
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
        
        _tableView.backgroundColor = RGBCOLOR(242, 242, 242);
    }
    return _tableView;
}

- (NSMutableArray *)section0List {
    if (!_section0List) {
        _section0List = [NSMutableArray array];
    }
    return _section0List;
}

- (NSMutableArray *)section1List {
    if (!_section1List) {
        _section1List = [NSMutableArray array];
    }
    return _section1List;
}

- (NSMutableArray *)headerList {
    if (!_headerList) {
        _headerList = [NSMutableArray array];
    }
    return _headerList;
}

- (MKCMBleScannerFilterModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKCMBleScannerFilterModel alloc] init];
    }
    return _dataModel;
}

@end
