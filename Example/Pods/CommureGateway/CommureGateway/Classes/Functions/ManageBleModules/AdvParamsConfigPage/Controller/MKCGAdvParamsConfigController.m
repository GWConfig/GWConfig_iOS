//
//  MKCGAdvParamsConfigController.m
//  CommureGateway_Example
//
//  Created by aa on 2023/4/24.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCGAdvParamsConfigController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKTextFieldCell.h"
#import "MKTextButtonCell.h"
#import "MKTableSectionLineHeader.h"

#import "MKCGAdvParamsConfigModel.h"

@interface MKCGAdvParamsConfigController ()<UITableViewDelegate,
UITableViewDataSource,
MKTextFieldCellDelegate,
MKTextButtonCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)NSMutableArray *section3List;

@property (nonatomic, strong)NSMutableArray *section4List;

@property (nonatomic, strong)NSMutableArray *section5List;

@property (nonatomic, strong)NSMutableArray *headerList;

@property (nonatomic, strong)MKCGAdvParamsConfigModel *dataModel;

@end

@implementation MKCGAdvParamsConfigController

- (void)dealloc {
    NSLog(@"MKCGAdvParamsConfigController销毁");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDataFromDevice];
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.f;
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
    if (section == 2) {
        return self.section2List.count;
    }
    if (section == 3) {
        return self.section3List.count;
    }
    if (section == 4) {
        return self.section4List.count;
    }
    if (section == 5) {
        return self.section5List.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 1) {
        MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:tableView];
        cell.dataModel = self.section1List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 2) {
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
        cell.dataModel = self.section2List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 3) {
        MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:tableView];
        cell.dataModel = self.section3List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 4) {
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
        cell.dataModel = self.section4List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:tableView];
    cell.dataModel = self.section5List[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - MKTextFieldCellDelegate
/// textField内容发送改变时的回调事件
/// @param index 当前cell所在的index
/// @param value 当前textField的值
- (void)mk_deviceTextCellValueChanged:(NSInteger)index textValue:(NSString *)value {
    if (index == 0) {
        //Config Adv interval
        self.dataModel.configInterval = value;
        MKTextFieldCellModel *cellModel = self.section0List[0];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 1) {
        //Config Adv duration
        self.dataModel.configDuration = value;
        MKTextFieldCellModel *cellModel = self.section0List[1];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 2) {
        //Normal Adv interval
        self.dataModel.normalInterval = value;
        MKTextFieldCellModel *cellModel = self.section2List[0];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 3) {
        //Normal Adv duration
//        self.dataModel.normalDuration = value;
//        MKTextFieldCellModel *cellModel = self.section2List[1];
//        cellModel.textFieldValue = value;
        return;
    }
    if (index == 4) {
        //Trigger Adv interval
        self.dataModel.triggerInterval = value;
        MKTextFieldCellModel *cellModel = self.section4List[0];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 5) {
        //Trigger Adv duration
        self.dataModel.triggerDuration = value;
        MKTextFieldCellModel *cellModel = self.section4List[1];
        cellModel.textFieldValue = value;
        return;
    }
}

#pragma mark - MKTextButtonCellDelegate
/// 右侧按钮点击触发的回调事件
/// @param index 当前cell所在的index
/// @param dataListIndex 点击按钮选中的dataList里面的index
/// @param value dataList[dataListIndex]
- (void)mk_loraTextButtonCellSelected:(NSInteger)index
                        dataListIndex:(NSInteger)dataListIndex
                                value:(NSString *)value {
    if (index == 0) {
        //Config TxPower
        self.dataModel.configTxPower = dataListIndex;
        MKTextButtonCellModel *cellModel = self.section1List[0];
        cellModel.dataListIndex = dataListIndex;
        return;
    }
    if (index == 1) {
        //Normal TxPower
        self.dataModel.normalTxPower = dataListIndex;
        MKTextButtonCellModel *cellModel = self.section3List[0];
        cellModel.dataListIndex = dataListIndex;
        return;
    }
    if (index == 2) {
        //Trigger TxPower
        self.dataModel.triggerTxPower = dataListIndex;
        MKTextButtonCellModel *cellModel = self.section5List[0];
        cellModel.dataListIndex = dataListIndex;
        return;
    }
}

#pragma mark - interface
- (void)readDataFromDevice {
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

- (void)configDataToDevice {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel configDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Setup succeed!"];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - loadSections
- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    [self loadSection2Datas];
    [self loadSection3Datas];
    [self loadSection4Datas];
    [self loadSection5Datas];
    
    for (NSInteger i = 0; i < 6; i ++) {
        MKTableSectionLineHeaderModel *headerModel = [[MKTableSectionLineHeaderModel alloc] init];
        if (i == 0) {
            headerModel.text = @"Config advertisement";
        }else if (i == 2) {
            headerModel.text = @"Normal advertisement";
        }else if (i == 4) {
            headerModel.text = @"Trigger advertisement";
        }
        [self.headerList addObject:headerModel];
    }
    
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKTextFieldCellModel *cellModel1 = [[MKTextFieldCellModel alloc] init];
    cellModel1.index = 0;
    cellModel1.msg = @"Adv interval";
    cellModel1.textPlaceholder = @"1-100";
    cellModel1.maxLength = 3;
    cellModel1.textFieldType = mk_realNumberOnly;
    cellModel1.textFieldValue = self.dataModel.configInterval;
    cellModel1.unit = @"x 100ms";
    [self.section0List addObject:cellModel1];
    
    MKTextFieldCellModel *cellModel2 = [[MKTextFieldCellModel alloc] init];
    cellModel2.index = 1;
    cellModel2.msg = @"Adv duration";
    cellModel2.textPlaceholder = @"1-65535";
    cellModel2.maxLength = 5;
    cellModel2.textFieldType = mk_realNumberOnly;
    cellModel2.textFieldValue = self.dataModel.configDuration;
    cellModel2.unit = @"s";
    [self.section0List addObject:cellModel2];
}

- (void)loadSection1Datas {
    MKTextButtonCellModel *cellModel = [[MKTextButtonCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = @"Tx power";
    cellModel.dataList = @[@"-40dBm",@"-20dBm",@"-16dBm",@"-12dBm",@"-8dBm",@"-4dBm",@"0dBm",@"3dBm",@"4dBm"];
    cellModel.dataListIndex = self.dataModel.configTxPower;
    [self.section1List addObject:cellModel];
}

- (void)loadSection2Datas {
    MKTextFieldCellModel *cellModel1 = [[MKTextFieldCellModel alloc] init];
    cellModel1.index = 2;
    cellModel1.msg = @"Adv interval";
    cellModel1.textPlaceholder = @"1-100";
    cellModel1.maxLength = 3;
    cellModel1.textFieldType = mk_realNumberOnly;
    cellModel1.textFieldValue = self.dataModel.normalInterval;
    cellModel1.unit = @"x 100ms";
    [self.section2List addObject:cellModel1];
    
//    MKTextFieldCellModel *cellModel2 = [[MKTextFieldCellModel alloc] init];
//    cellModel2.index = 3;
//    cellModel2.msg = @"Adv duration";
//    cellModel2.textPlaceholder = @"1-65535";
//    cellModel2.maxLength = 5;
//    cellModel2.textFieldType = mk_realNumberOnly;
//    cellModel2.textFieldValue = self.dataModel.normalDuration;
//    cellModel2.unit = @"s";
//    [self.section2List addObject:cellModel2];
}

- (void)loadSection3Datas {
    MKTextButtonCellModel *cellModel = [[MKTextButtonCellModel alloc] init];
    cellModel.index = 1;
    cellModel.msg = @"Tx power";
    cellModel.dataList = @[@"-40dBm",@"-20dBm",@"-16dBm",@"-12dBm",@"-8dBm",@"-4dBm",@"0dBm",@"3dBm",@"4dBm"];
    cellModel.dataListIndex = self.dataModel.normalTxPower;
    [self.section3List addObject:cellModel];
}

- (void)loadSection4Datas {
    MKTextFieldCellModel *cellModel1 = [[MKTextFieldCellModel alloc] init];
    cellModel1.index = 4;
    cellModel1.msg = @"Adv interval";
    cellModel1.textPlaceholder = @"1-100";
    cellModel1.maxLength = 3;
    cellModel1.textFieldType = mk_realNumberOnly;
    cellModel1.textFieldValue = self.dataModel.triggerInterval;
    cellModel1.unit = @"x 100ms";
    [self.section4List addObject:cellModel1];
    
    MKTextFieldCellModel *cellModel2 = [[MKTextFieldCellModel alloc] init];
    cellModel2.index = 5;
    cellModel2.msg = @"Adv duration";
    cellModel2.textPlaceholder = @"1-65535";
    cellModel2.maxLength = 5;
    cellModel2.textFieldType = mk_realNumberOnly;
    cellModel2.textFieldValue = self.dataModel.triggerDuration;
    cellModel2.unit = @"s";
    [self.section4List addObject:cellModel2];
}

- (void)loadSection5Datas {
    MKTextButtonCellModel *cellModel = [[MKTextButtonCellModel alloc] init];
    cellModel.index = 2;
    cellModel.msg = @"Tx power";
    cellModel.dataList = @[@"-40dBm",@"-20dBm",@"-16dBm",@"-12dBm",@"-8dBm",@"-4dBm",@"0dBm",@"3dBm",@"4dBm"];
    cellModel.dataListIndex = self.dataModel.triggerTxPower;
    [self.section5List addObject:cellModel];
}


#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"ADV parameters";
    [self.rightButton setImage:LOADICON(@"CommureGateway", @"MKCGAdvParamsConfigController", @"cg_saveIcon.png") forState:UIControlStateNormal];
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
        _tableView.backgroundColor = RGBCOLOR(242, 242, 242);
        _tableView.delegate = self;
        _tableView.dataSource = self;
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

- (NSMutableArray *)section2List {
    if (!_section2List) {
        _section2List = [NSMutableArray array];
    }
    return _section2List;
}

- (NSMutableArray *)section3List {
    if (!_section3List) {
        _section3List = [NSMutableArray array];
    }
    return _section3List;
}

- (NSMutableArray *)section4List {
    if (!_section4List) {
        _section4List = [NSMutableArray array];
    }
    return _section4List;
}

- (NSMutableArray *)section5List {
    if (!_section5List) {
        _section5List = [NSMutableArray array];
    }
    return _section5List;
}

- (NSMutableArray *)headerList {
    if (!_headerList) {
        _headerList = [NSMutableArray array];
    }
    return _headerList;
}

- (MKCGAdvParamsConfigModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKCGAdvParamsConfigModel alloc] init];
        _dataModel.bleMac = self.bleMac;
    }
    return _dataModel;
}

@end
