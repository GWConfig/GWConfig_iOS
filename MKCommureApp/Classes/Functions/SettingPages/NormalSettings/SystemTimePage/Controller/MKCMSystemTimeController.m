//
//  MKCMSystemTimeController.m
//  MKCommureApp_Example
//
//  Created by aa on 2023/2/13.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCMSystemTimeController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKNormalTextCell.h"
#import "MKTableSectionLineHeader.h"
#import "MKTextButtonCell.h"

#import "MKCMMQTTInterface.h"

#import "MKCMDeviceModel.h"
#import "MKCMDeviceModeManager.h"

#import "MKCMSystemTimeCell.h"

#import "MKCMNTPServerController.h"

@interface MKCMSystemTimeController ()<UITableViewDelegate,
UITableViewDataSource,
MKCMSystemTimeCellDelegate,
MKTextButtonCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)NSMutableArray *sectionHeaderList;

@property (nonatomic, strong)dispatch_source_t readTimer;

@property (nonatomic, assign)NSInteger timeZone;

@property (nonatomic, strong)UILabel *timeLabel;

@property (nonatomic, strong)NSArray *timeZoneList;

@property (nonatomic, strong)NSDateFormatter *formatter;

@end

@implementation MKCMSystemTimeController

- (void)dealloc {
    NSLog(@"MKCMSystemTimeController销毁");
    if (self.readTimer) {
        dispatch_cancel(self.readTimer);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.timeZone = 24;
    [self loadSubViews];
    [self loadSectionDatas];
    [self startReceiveTimer];
//    [self readDataFromServer];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1 || section == 2) {
        return 10.f;
    }
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MKTableSectionLineHeader *headerView = [MKTableSectionLineHeader initHeaderViewWithTableView:tableView];
    headerView.headerModel = self.sectionHeaderList[section];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0)  {
        //Sync Time From NTP
        MKCMNTPServerController *vc = [[MKCMNTPServerController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionHeaderList.count;
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
        MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        return cell;
    }
    if (indexPath.section == 1) {
        MKCMSystemTimeCell *cell = [MKCMSystemTimeCell initCellWithTableView:tableView];
        cell.dataModel = self.section1List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:tableView];
    cell.dataModel = self.section2List[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - MKCMSystemTimeCellDelegate
- (void)cm_systemTimeButtonPressed:(NSInteger)index {
    [self syncTimeZoneToDevice:self.timeZone];
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
        //TimeZone
        [self syncTimeZoneToDevice:dataListIndex];
        return;
    }
}

#pragma mark - interface
- (void)readDataFromServer {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    [MKCMMQTTInterface cm_readDeviceUTCTimeWithMacAddress:[MKCMDeviceModeManager shared].macAddress topic:[MKCMDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        [self updateCellData:returnData[@"data"]];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)syncTimeZoneToDevice:(NSInteger)timeZone {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    [MKCMMQTTInterface cm_configDeviceTimeZone:timeZone - 24 timestamp:[[NSDate date] timeIntervalSince1970] macAddress:[MKCMDeviceModeManager shared].macAddress topic:[MKCMDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        self.timeZone = timeZone;
        MKTextButtonCellModel *cellModel = self.section2List[0];
        cellModel.dataListIndex = self.timeZone;
        [[MKHudManager share] hide];
        [self readDataFromServer];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        [self.tableView reloadData];
    }];
}

#pragma mark - private method
- (void)updateCellData:(NSDictionary *)dic {
    NSNumber *timeStamp = dic[@"timestamp"];
    if (!ValidNum(timeStamp)) {
        return;
    }
    self.timeZone = [dic[@"timezone"] integerValue] + 24;
    self.formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:([dic[@"timezone"] integerValue] * 0.5 * 60 * 60)];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp longLongValue]];
    NSString *timeString = [self.formatter stringFromDate:date];
    self.timeLabel.text = [NSString stringWithFormat:@"%@%@ %@",@"Device time:",timeString,self.timeZoneList[self.timeZone]];
    MKTextButtonCellModel *cellModel = self.section2List[0];
    cellModel.dataListIndex = self.timeZone;
    [self.tableView reloadData];
}

- (void)startReceiveTimer {
    @weakify(self);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.readTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.readTimer, dispatch_walltime(NULL, 0), 30 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.readTimer, ^{
        @strongify(self);
        moko_dispatch_main_safe(^{
            [self readDataFromServer];
        });
    });
    dispatch_resume(self.readTimer);
}

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    [self loadSection2Datas];
    [self loadSectionHeaderList];
    
    [self.tableView reloadData];
}

- (void)loadSectionHeaderList {
    for (NSInteger i = 0; i < 3; i ++) {
        MKTableSectionLineHeaderModel *headerModel = [[MKTableSectionLineHeaderModel alloc] init];
        [self.sectionHeaderList addObject:headerModel];
    }
}

- (void)loadSection0Datas {
    MKNormalTextCellModel *cellModel1 = [[MKNormalTextCellModel alloc] init];
    cellModel1.showRightIcon = YES;
    cellModel1.leftMsg = @"Sync Time From NTP";
    [self.section0List addObject:cellModel1];
}

- (void)loadSection1Datas {
    MKCMSystemTimeCellModel *cellModel = [[MKCMSystemTimeCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = @"Sync Time From Phone";
    cellModel.buttonTitle = @"Sync";
    [self.section1List addObject:cellModel];
}

- (void)loadSection2Datas {
    MKTextButtonCellModel *cellModel = [[MKTextButtonCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = @"TimeZone";
    cellModel.dataList = self.timeZoneList;
    [self.section2List addObject:cellModel];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"System time";
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
        
        _tableView.tableFooterView = [self footerView];
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

- (NSMutableArray *)sectionHeaderList {
    if (!_sectionHeaderList) {
        _sectionHeaderList = [NSMutableArray array];
    }
    return _sectionHeaderList;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = UIColorFromRGB(0xcccccc);
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = MKFont(13.f);
        _timeLabel.numberOfLines = 0;
    }
    return _timeLabel;
}

- (NSArray *)timeZoneList {
    if (!_timeZoneList) {
        _timeZoneList = @[@"UTC-12:00",@"UTC-11:30",@"UTC-11:00",@"UTC-10:30",@"UTC-10:00",@"UTC-09:30",
                          @"UTC-09:00",@"UTC-08:30",@"UTC-08:00",@"UTC-07:30",@"UTC-07:00",@"UTC-06:30",
                          @"UTC-06:00",@"UTC-05:30",@"UTC-05:00",@"UTC-04:30",@"UTC-04:00",@"UTC-03:30",
                          @"UTC-03:00",@"UTC-02:30",@"UTC-02:00",@"UTC-01:30",@"UTC-01:00",@"UTC-00:30",
                          @"UTC+00:00",@"UTC+00:30",@"UTC+01:00",@"UTC+01:30",@"UTC+02:00",@"UTC+02:30",
                          @"UTC+03:00",@"UTC+03:30",@"UTC+04:00",@"UTC+04:30",@"UTC+05:00",@"UTC+05:30",
                          @"UTC+06:00",@"UTC+06:30",@"UTC+07:00",@"UTC+07:30",@"UTC+08:00",@"UTC+08:30",
                          @"UTC+09:00",@"UTC+09:30",@"UTC+10:00",@"UTC+10:30",@"UTC+11:00",@"UTC+11:30",
                          @"UTC+12:00",@"UTC+12:30",@"UTC+13:00",@"UTC+13:30",@"UTC+14:00"];
    }
    return _timeZoneList;
}

- (NSDateFormatter *)formatter {
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        _formatter.dateFormat = @"YYYY-MM-dd hh:mm";
    }
    return _formatter;
}

- (UIView *)footerView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 120.f)];
    footerView.backgroundColor = RGBCOLOR(242, 242, 242);
    
    
    self.timeLabel.frame = CGRectMake(30.f, 30.f, kViewWidth - 2 * 30.f, 40.f);
    [footerView addSubview:self.timeLabel];
    
    return footerView;
}

@end
