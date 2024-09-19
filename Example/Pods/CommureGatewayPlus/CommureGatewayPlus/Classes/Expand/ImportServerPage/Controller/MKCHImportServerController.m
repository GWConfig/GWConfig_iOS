//
//  MKCHImportServerController.m
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/2/7.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCHImportServerController.h"

#import "Masonry.h"
#import "MKBaseTableView.h"
#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"

#import "MKNormalTextCell.h"
#import "MKHudManager.h"

@interface MKCHImportServerController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)dispatch_queue_t monitorQueue;

@property (nonatomic, strong)dispatch_source_t monitorSource;

@end

@implementation MKCHImportServerController

- (void)dealloc {
    NSLog(@"MKCHImportServerController销毁");
    if (self.monitorSource) {
        dispatch_cancel(self.monitorSource);
    }
}

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
    [self loadFileList];
    [self startMonitoringServerFiles];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MKNormalTextCellModel *model = self.dataList[indexPath.row];
    if (!ValidStr(model.leftMsg)) {
        [self.view showCentralToast:@"File cannot be empty!"];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(ch_selectedServerParams:)]) {
        [self.delegate ch_selectedServerParams:model.leftMsg];
    }
    [self leftButtonMethod];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
    cell.dataModel = self.dataList[indexPath.row];
    return cell;
}

#pragma mark - 监听文件
- (void)startMonitoringServerFiles {
    NSString *directoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL *directoryURL = [NSURL URLWithString:directoryPath];
    int filedes = open([[directoryURL path] fileSystemRepresentation], O_EVTONLY);
    if (filedes < 0) {
        return;
    }
    // 创建 dispatch queue, 当文件改变事件发生时会发送到该 queue
    self.monitorQueue = dispatch_queue_create("ZFileMonitorQueue", 0);
    
    // 创建 GCD source. 将用于监听 file descriptor 来判断是否有文件写入操作
    self.monitorSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE, filedes, DISPATCH_VNODE_WRITE, self.monitorQueue);
    // 当文件发生改变时会调用该 block
    @weakify(self);
    dispatch_source_set_event_handler(self.monitorSource, ^{
        @strongify(self);
        // 在文件发生改变时发出通知
        dispatch_async(dispatch_get_main_queue(), ^{
            //监听到有文件了
            [self loadFileList];
        });
    });
    
    // 当文件监听停止时会调用该 block
    dispatch_source_set_cancel_handler(self.monitorSource, ^{
        // 关闭文件监听时, 关闭该 file descriptor
        close(filedes);
    });
    
    // 开始监听文件
    dispatch_resume(self.monitorSource);
}

- (NSArray *)currentFileList{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    // 获取指定路径对应文件夹下的所有文件
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:document error:&error];
    return fileList;
}

- (void)loadFileList {
    NSArray *list = [self currentFileList];
    if (ValidArray(list)) {
        [self.dataList removeAllObjects];
        for (NSInteger i = 0; i < list.count; i ++) {
            NSString *msg = list[i];
            if ([msg containsString:@".xlsx"]) {
                MKNormalTextCellModel *model = [[MKNormalTextCellModel alloc] init];
                model.leftMsg = msg;
                [self.dataList addObject:model];
            }
        }
        [self.tableView reloadData];
    }
}

- (void)loadSubViews {
    self.defaultTitle = @"Settings for Server";
    [self.rightButton setHidden:YES];
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
        _tableView.backgroundColor = COLOR_WHITE_MACROS;
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
