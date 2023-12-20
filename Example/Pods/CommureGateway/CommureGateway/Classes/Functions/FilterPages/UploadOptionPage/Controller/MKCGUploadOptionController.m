//
//  MKCGUploadOptionController.m
//  CommureGateway_Example
//
//  Created by aa on 2023/2/6.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCGUploadOptionController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"

#import "MKHudManager.h"
#import "MKNormalTextCell.h"
#import "MKNormalSliderCell.h"
#import "MKTableSectionLineHeader.h"
#import "MKCustomUIAdopter.h"

#import "MKCGDeviceModel.h"
#import "MKCGDeviceModeManager.h"

#import "MKCGUploadOptionModel.h"

#import "MKCGFilterCell.h"

#import "MKCGFilterByMacController.h"
#import "MKCGFilterByTagController.h"
#import "MKCGTimeOffsetController.h"
#import "MKCGDecryptionKeyController.h"

@interface MKCGUploadOptionController ()<UITableViewDelegate,
UITableViewDataSource,
MKNormalSliderCellDelegate,
MKCGFilterCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)NSMutableArray *section3List;

@property (nonatomic, strong)NSMutableArray *section4List;

@property (nonatomic, strong)NSMutableArray *headerList;

@property (nonatomic, strong)MKCGUploadOptionModel *dataModel;

@end

@implementation MKCGUploadOptionController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //本页面禁止右划退出手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 3 || section == 4) {
        return 10;
    }
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 90.f;
    }
    return 44.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MKTableSectionLineHeader *headerView = [MKTableSectionLineHeader initHeaderViewWithTableView:tableView];
    headerView.headerModel = self.headerList[section];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        MKNormalTextCellModel *cellModel = self.section1List[indexPath.row];
        if (ValidStr(cellModel.methodName) && [self respondsToSelector:NSSelectorFromString(cellModel.methodName)]) {
            [self performSelector:NSSelectorFromString(cellModel.methodName) withObject:nil];
        }
        return;
    }
    if (indexPath.section == 3) {
        MKNormalTextCellModel *cellModel = self.section3List[indexPath.row];
        if (ValidStr(cellModel.methodName) && [self respondsToSelector:NSSelectorFromString(cellModel.methodName)]) {
            [self performSelector:NSSelectorFromString(cellModel.methodName) withObject:nil];
        }
        return;
    }
    if (indexPath.section == 4) {
        MKNormalTextCellModel *cellModel = self.section4List[indexPath.row];
        if (ValidStr(cellModel.methodName) && [self respondsToSelector:NSSelectorFromString(cellModel.methodName)]) {
            [self performSelector:NSSelectorFromString(cellModel.methodName) withObject:nil];
        }
        return;
    }
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
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKNormalSliderCell *cell = [MKNormalSliderCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 1) {
        MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
        cell.dataModel = self.section1List[indexPath.row];
        return cell;
    }
    if (indexPath.section == 2) {
        MKCGFilterCell *cell = [MKCGFilterCell initCellWithTableView:tableView];
        cell.dataModel = self.section2List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 3) {
        MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
        cell.dataModel = self.section3List[indexPath.row];
        return cell;
    }
    MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
    cell.dataModel = self.section4List[indexPath.row];
    return cell;
}

#pragma mark - MKNormalSliderCellDelegate
/// slider值发生改变的回调事件
/// @param value 当前slider的值
/// @param index 当前cell所在的index
- (void)mk_normalSliderValueChanged:(NSInteger)value index:(NSInteger)index {
    if (index == 0) {
        //Filter by RSSI
        self.dataModel.rssi = value;
        return;
    }
}

#pragma mark - MKCGFilterCellDelegate
- (void)cg_filterValueChanged:(NSInteger)dataListIndex index:(NSInteger)index {
    if (index == 0) {
        //Filter Relationship
        self.dataModel.relationship = dataListIndex;
        MKCGFilterCellModel *cellModel = self.section2List[0];
        cellModel.dataListIndex = dataListIndex;
        return;
    }
}

#pragma mark - cell event method
- (void)filterByMACAddress {
    MKCGFilterByMacController *vc = [[MKCGFilterByMacController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)filterByTagID {
    MKCGFilterByTagController *vc = [[MKCGFilterByTagController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)configTimeOffset {
    MKCGTimeOffsetController *vc = [[MKCGTimeOffsetController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)configDecryptionKey {
    MKCGDecryptionKeyController *vc = [[MKCGDecryptionKeyController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    [self loadSection2Datas];
    [self loadSection3Datas];
    [self loadSection4Datas];
    
    for (NSInteger i = 0; i < 5; i ++) {
        MKTableSectionLineHeaderModel *headerModel = [[MKTableSectionLineHeaderModel alloc] init];
        [self.headerList addObject:headerModel];
    }
    
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKNormalSliderCellModel *cellModel = [[MKNormalSliderCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = [MKCustomUIAdopter attributedString:@[@"Filter by RSSI ",@"(-127dBm~0dBm)"] fonts:@[MKFont(15.f),MKFont(13.f)] colors:@[DEFAULT_TEXT_COLOR,RGBCOLOR(223, 223, 223)]];
    cellModel.unit = @"dBm";
    cellModel.changed = YES;
    cellModel.sliderValue = self.dataModel.rssi;
    cellModel.leftNoteMsg = @"*The device will uplink valid ADV data with RSSI no less than";
    cellModel.contentColor = RGBCOLOR(242, 242, 242);
    [self.section0List addObject:cellModel];
}

- (void)loadSection1Datas {
    MKNormalTextCellModel *cellModel1 = [[MKNormalTextCellModel alloc] init];
    cellModel1.showRightIcon = YES;
    cellModel1.leftMsg = @"Filter by MAC address";
    cellModel1.methodName = @"filterByMACAddress";
    [self.section1List addObject:cellModel1];
    
    MKNormalTextCellModel *cellModel2 = [[MKNormalTextCellModel alloc] init];
    cellModel2.showRightIcon = YES;
    cellModel2.leftMsg = @"Filter by Tag id";
    cellModel2.methodName = @"filterByTagID";
    [self.section1List addObject:cellModel2];
}

- (void)loadSection2Datas {
    MKCGFilterCellModel *cellModel = [[MKCGFilterCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = @"Filter Relationship";
    cellModel.dataList = @[@"Null",@"Only MAC",@"Only Tag id",@"MAC | Tag id",@"MAC & Tag id"];
    cellModel.dataListIndex = self.dataModel.relationship;
    [self.section2List addObject:cellModel];
}

- (void)loadSection3Datas {
    MKNormalTextCellModel *cellModel = [[MKNormalTextCellModel alloc] init];
    cellModel.showRightIcon = YES;
    cellModel.leftMsg = @"Time offset";
    cellModel.methodName = @"configTimeOffset";
    [self.section3List addObject:cellModel];
}

- (void)loadSection4Datas {
    MKNormalTextCellModel *cellModel = [[MKNormalTextCellModel alloc] init];
    cellModel.showRightIcon = YES;
    cellModel.leftMsg = @"Decryption key";
    cellModel.methodName = @"configDecryptionKey";
    [self.section4List addObject:cellModel];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = [MKCGDeviceModeManager shared].deviceName;
    [self.rightButton setImage:LOADICON(@"CommureGateway", @"MKCGUploadOptionController", @"cg_saveIcon.png")
                      forState:UIControlStateNormal];
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

- (NSMutableArray *)headerList {
    if (!_headerList) {
        _headerList = [NSMutableArray array];
    }
    return _headerList;
}

- (MKCGUploadOptionModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKCGUploadOptionModel alloc] init];
    }
    return _dataModel;
}

@end
