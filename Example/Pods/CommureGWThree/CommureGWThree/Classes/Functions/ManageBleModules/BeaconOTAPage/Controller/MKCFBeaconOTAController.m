//
//  MKCFBeaconOTAController.m
//  CommureGWThree_Example
//
//  Created by aa on 2023/2/13.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCFBeaconOTAController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "NSString+MKAdd.h"

#import "MKHudManager.h"
#import "MKCustomUIAdopter.h"
#import "MKTextFieldCell.h"

#import "MKCFMQTTDataManager.h"
#import "MKCFMQTTInterface.h"

#import "MKCFDeviceModeManager.h"
#import "MKCFDeviceModel.h"

#import "MKCFBeaconOTAPageModel.h"

@interface MKCFBeaconOTAController ()<UITableViewDelegate,
UITableViewDataSource,
MKTextFieldCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)MKCFBeaconOTAPageModel *dataModel;

@property (nonatomic, strong)UILabel *progressLabel;

@property (nonatomic, assign)BOOL receiveComplete;

@end

@implementation MKCFBeaconOTAController

- (void)dealloc {
    NSLog(@"MKCFBeaconOTAController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    [self addNotes];
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
    MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
    cell.dataModel = self.dataList[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - MKTextFieldCellDelegate
/// textField内容发送改变时的回调事件
/// @param index 当前cell所在的index
/// @param value 当前textField的值
- (void)mk_deviceTextCellValueChanged:(NSInteger)index textValue:(NSString *)value {
    MKTextFieldCellModel *cellModel = self.dataList[index];
    cellModel.textFieldValue = value;
    if (index == 0) {
        //Firmware file URL
        self.dataModel.firmwareUrl = value;
        return;
    }
    if (index == 1) {
        //
        self.dataModel.dataUrl = value;
        return;
    }
}

#pragma mark - notes
- (void)receiveDisconnect:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user) || !ValidStr(user[@"device_info"][@"mac"]) || ![[MKCFDeviceModeManager shared].macAddress isEqualToString:user[@"device_info"][@"mac"]]) {
        return;
    }
    NSDictionary *dataDic = user[@"data"];
    if (![dataDic[@"mac"] isEqualToString:self.bleMac]) {
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_cf_needDismissAlert" object:nil];
    [self gotoLastPage];
}

- (void)receiveDfuProgress:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user) || !ValidStr(user[@"device_info"][@"mac"]) || ![[MKCFDeviceModeManager shared].macAddress isEqualToString:user[@"device_info"][@"mac"]]) {
        return;
    }
    if (!ValidStr(user[@"data"][@"mac"]) || ![self.bleMac isEqualToString:user[@"data"][@"mac"]]) {
        return;
    }
    if (self.receiveComplete) {
        return;
    }
    [[MKHudManager share] hide];
    self.progressLabel.hidden = NO;
    self.progressLabel.text = [NSString stringWithFormat:@"Beacon DFU process: %@%@",user[@"data"][@"percent"],@"%"];
}

- (void)receiveDfuResult:(NSNotification *)note {
    NSDictionary *user = note.userInfo;
    if (!ValidDict(user) || !ValidStr(user[@"device_info"][@"mac"]) || ![[MKCFDeviceModeManager shared].macAddress isEqualToString:user[@"device_info"][@"mac"]]) {
        return;
    }
    [[MKHudManager share] hide];
    self.receiveComplete = YES;
    self.progressLabel.hidden = YES;
    self.leftButton.enabled = YES;
    NSDictionary *dataDic = user[@"data"];
    NSInteger result = [dataDic[@"multi_dfu_result_code"] integerValue];
    NSArray *failureList = dataDic[@"fail_dev"];
    NSString *updateResult = @"Beacon DFU failed!";
    if (result == 1 && !ValidArray(failureList)) {
        //升级成功
        updateResult = @"Beacon DFU successfully!";
    }
    [self.view showCentralToast:updateResult];
    [self performSelector:@selector(gotoLastPage) withObject:nil afterDelay:0.5f];
}

#pragma mark - event method
- (void)startButtonPressed {
    [self configDataToDevice];
}

#pragma mark - interface
- (void)configDataToDevice {
    [[MKHudManager share] showHUDWithTitle:@"Waiting..." inView:self.view isPenetration:NO];
    @weakify(self);
    self.leftButton.enabled = NO;
    self.receiveComplete = NO;
    [self.dataModel configDataWithSucBlock:^{
        
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        self.leftButton.enabled = YES;
        self.receiveComplete = YES;
    }];
}

#pragma mark - private method
- (void)addNotes {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveDfuProgress:)
                                                 name:MKCFReceiveBxpButtonDfuProgressNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveDfuResult:)
                                                 name:MKCFReceiveBxpButtonBatchDfuResultNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveDisconnect:)
                                                 name:MKCFReceiveGatewayDisconnectBXPButtonNotification
                                               object:nil];
}

- (void)gotoLastPage {
    //返回上一级页面
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:NSClassFromString(@"MKCFManageBleDevicesController")]) {
            //如果是从Manage BLE devices页面进来的
            [self popToViewControllerWithClassName:@"MKCFManageBleDevicesController"];
            break;
        }
        if ([vc isKindOfClass:NSClassFromString(@"MKCFDeviceDataController")]) {
            //如果是从扫描页面进来的
            [self popToViewControllerWithClassName:@"MKCFDeviceDataController"];
            break;
        }
    }
}

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    MKTextFieldCellModel *cellModel1 = [[MKTextFieldCellModel alloc] init];
    cellModel1.index = 0;
    cellModel1.msg = @"Firmware file URL";
    cellModel1.textPlaceholder = @"1-256 Characters";
    cellModel1.textFieldType = mk_normal;
    cellModel1.maxLength = 256;
    [self.dataList addObject:cellModel1];
    
    MKTextFieldCellModel *cellModel2 = [[MKTextFieldCellModel alloc] init];
    cellModel2.index = 1;
    cellModel2.msg = @"Init data file URL";
    cellModel2.textPlaceholder = @"1-256 Characters";
    cellModel2.textFieldType = mk_normal;
    cellModel2.maxLength = 256;
    [self.dataList addObject:cellModel2];
    
    [self.tableView reloadData];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"DFU";
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
        
        _tableView.tableFooterView = [self tableFooterView];
    }
    return _tableView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (MKCFBeaconOTAPageModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKCFBeaconOTAPageModel alloc] init];
        _dataModel.bleMac = self.bleMac;
    }
    return _dataModel;
}

- (UILabel *)progressLabel {
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc] init];
        _progressLabel.textAlignment = NSTextAlignmentCenter;
        _progressLabel.backgroundColor = RGBACOLOR(33, 33, 33, 0.8);
        _progressLabel.textColor = COLOR_WHITE_MACROS;
        _progressLabel.font = MKFont(14.f);
        _progressLabel.numberOfLines = 0;
        
        _progressLabel.layer.masksToBounds = YES;
        _progressLabel.layer.cornerRadius = 6.f;
    }
    return _progressLabel;
}

- (UIView *)tableFooterView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 250.f)];
    footerView.backgroundColor = COLOR_WHITE_MACROS;
    
    [footerView addSubview:self.progressLabel];
    self.progressLabel.frame = CGRectMake((kViewWidth - 150.f) / 2, 50.f, 150.f, 60.f);
    self.progressLabel.hidden = YES;
    
    UIButton *startButton = [MKCustomUIAdopter customButtonWithTitle:@"Start Update"
                                                              target:self
                                                              action:@selector(startButtonPressed)];
    startButton.frame = CGRectMake((kViewWidth - 130.f) / 2, 120.f, 130.f, 40.f);
    [footerView addSubview:startButton];
    
    return footerView;
}

@end
