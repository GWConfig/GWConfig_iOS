//
//  MKCHSosAlarmNotiController.m
//  CommureGatewayPlus_Example
//
//  Created by aa on 2024/5/9.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import "MKCHSosAlarmNotiController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"

#import "MKHudManager.h"
#import "MKTextFieldCell.h"
#import "MKTextButtonCell.h"
#import "MKCustomUIAdopter.h"
#import "MKTableSectionLineHeader.h"

#import "MKCHSosAlarmNotiModel.h"

@interface MKCHSosAlarmNotiController ()<UITableViewDelegate,
UITableViewDataSource,
MKTextFieldCellDelegate,
MKTextButtonCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)NSMutableArray *headerList;

@property (nonatomic, strong)MKCHSosAlarmNotiModel *dataModel;

@end

@implementation MKCHSosAlarmNotiController

- (void)dealloc {
    NSLog(@"MKCHSosAlarmNotiController销毁");
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 2) {
        return 20.f;
    }
    
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
    if (section == 2) {
        return self.section2List.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 1) {
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
        cell.dataModel = self.section1List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
    cell.dataModel = self.section2List[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - MKTextFieldCellDelegate
/// textField内容发送改变时的回调事件
/// @param index 当前cell所在的index
/// @param value 当前textField的值
- (void)mk_deviceTextCellValueChanged:(NSInteger)index textValue:(NSString *)value {
    if (index == 0) {
        //LED notification
        //Blinking interval
        self.dataModel.ledInterval = value;
        MKTextFieldCellModel *cellModel = self.section1List[0];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 1) {
        //LED notification
        //Blinking duration
        self.dataModel.ledDuration = value;
        MKTextFieldCellModel *cellModel = self.section1List[1];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 2) {
        //Beeping interval
        self.dataModel.beepingInterval = value;
        MKTextFieldCellModel *cellModel = self.section2List[0];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 3) {
        //Beeping duration
        self.dataModel.beepingDuration = value;
        MKTextFieldCellModel *cellModel = self.section2List[1];
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
        //LED color
        self.dataModel.color = dataListIndex;
        MKTextButtonCellModel *cellModel = self.section0List[0];
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
    
    for (NSInteger i = 0; i < 3; i ++) {
        MKTableSectionLineHeaderModel *headerModel = [[MKTableSectionLineHeaderModel alloc] init];
        if (i == 0) {
            headerModel.text = @"LED notification";
            headerModel.msgTextColor = NAVBAR_COLOR_MACROS;
        }else if (i == 2) {
            headerModel.text = @"Buzzer notification";
            headerModel.msgTextColor = NAVBAR_COLOR_MACROS;
        }
        [self.headerList addObject:headerModel];
    }
        
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKTextButtonCellModel *cellModel = [[MKTextButtonCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = @"LED color";
    cellModel.dataList = @[@"Red",@"Blue",@"Green"];
    cellModel.dataListIndex = self.dataModel.color;
    [self.section0List addObject:cellModel];
}

- (void)loadSection1Datas {
    MKTextFieldCellModel *cellModel1 = [[MKTextFieldCellModel alloc] init];
    cellModel1.index = 0;
    cellModel1.msg = @"Blinking interval";
    cellModel1.textPlaceholder = @"0-100";
    cellModel1.maxLength = 3;
    cellModel1.textFieldType = mk_realNumberOnly;
    cellModel1.textFieldValue = self.dataModel.ledInterval;
    cellModel1.unit = @"x 100ms";
    [self.section1List addObject:cellModel1];
    
    MKTextFieldCellModel *cellModel2 = [[MKTextFieldCellModel alloc] init];
    cellModel2.index = 1;
    cellModel2.msg = @"Blinking duration";
    cellModel2.textPlaceholder = (self.pageType == mk_ch_sosAlarmNotiPageType_normal ? @"1-255" : @"0-655");
    cellModel2.maxLength = 3;
    cellModel2.textFieldType = mk_realNumberOnly;
    cellModel2.textFieldValue = self.dataModel.ledDuration;
    cellModel2.unit = (self.pageType == mk_ch_sosAlarmNotiPageType_normal ? @"s" : @"x 100ms");
    [self.section1List addObject:cellModel2];
}

- (void)loadSection2Datas {
    MKTextFieldCellModel *cellModel1 = [[MKTextFieldCellModel alloc] init];
    cellModel1.index = 2;
    cellModel1.msg = @"Beeping interval";
    cellModel1.textPlaceholder = @"0-100";
    cellModel1.maxLength = 3;
    cellModel1.textFieldType = mk_realNumberOnly;
    cellModel1.textFieldValue = self.dataModel.beepingInterval;
    cellModel1.unit = @"x 100ms";
    [self.section2List addObject:cellModel1];
    
    MKTextFieldCellModel *cellModel2 = [[MKTextFieldCellModel alloc] init];
    cellModel2.index = 3;
    cellModel2.msg = @"Beeping duration";
    cellModel2.textPlaceholder = @"0-655";
    cellModel2.maxLength = 3;
    cellModel2.textFieldType = mk_realNumberOnly;
    cellModel2.textFieldValue = self.dataModel.beepingDuration;
    cellModel2.unit = @"x 100ms";
    [self.section2List addObject:cellModel2];
}

#pragma mark - UI
- (void)loadSubViews {
    self.titleLabel.font = MKFont(15.f);
    self.defaultTitle = (self.pageType == mk_ch_sosAlarmNotiPageType_normal ? @"SOS alarm notifications" : @"Dismiss-SOS alarm notifications");
    [self.rightButton setImage:LOADICON(@"CommureGatewayPlus", @"MKCHSosAlarmNotiController", @"ch_saveIcon.png") forState:UIControlStateNormal];
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

- (NSMutableArray *)headerList {
    if (!_headerList) {
        _headerList = [NSMutableArray array];
    }
    return _headerList;
}

- (MKCHSosAlarmNotiModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKCHSosAlarmNotiModel alloc] init];
        _dataModel.bleMac = self.bleMac;
        _dataModel.dismiss = (self.pageType == mk_ch_sosAlarmNotiPageType_dismiss);
    }
    return _dataModel;
}

@end
