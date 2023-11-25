//
//  MKCommureAboutController.m
//  MKCommureApp
//
//  Created by aa on 2023/11/24.
//

#import "MKCommureAboutController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "NSString+MKAdd.h"
#import "UIView+MKAdd.h"

#import "MKCustomUIAdopter.h"

#import "MKCommureAboutCell.h"

@interface MKCommureAboutController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UIImageView *aboutIcon;

@property (nonatomic, strong)UILabel *versionLabel;

@property (nonatomic, strong)UILabel *companyNameLabel;

@property (nonatomic, strong)UILabel *companyNetLabel;

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@end

@implementation MKCommureAboutController

- (void)dealloc {
    NSLog(@"MKCommureAboutController销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self loadTableDatas];
    // Do any additional setup after loading the view.
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKCommureAboutCellModel *model = self.dataList[indexPath.row];
    CGSize valueSize = [NSString sizeWithText:model.value
                                      andFont:MKFont(15.f)
                                   andMaxSize:CGSizeMake(kViewWidth - 30 - 25.f - 140 - 15, MAXFLOAT)];
    return MAX(44.f, valueSize.height + 20.f);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        [self openWebBrowser];
        return;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKCommureAboutCell *cell = [MKCommureAboutCell initCellWithTableView:tableView];
    cell.dataModel = self.dataList[indexPath.row];
    return cell;
}

#pragma mark -
- (void)loadSubViews {
    self.defaultTitle = @"About MOKO";
    [self.rightButton setHidden:YES];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    self.versionLabel.text = [@"Version:" stringByAppendingString:version];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(defaultTopInset);
        make.bottom.mas_equalTo(-VirtualHomeHeight);
    }];
}

- (void)loadTableDatas {
    MKCommureAboutCellModel *faxModel = [[MKCommureAboutCellModel alloc] init];
    faxModel.iconName = @"mk_commure_faxIcon";
    faxModel.typeMessage = @"Fax";
    faxModel.value = @"86-75523573370-808";
    [self.dataList addObject:faxModel];
    
    MKCommureAboutCellModel *telModel = [[MKCommureAboutCellModel alloc] init];
    telModel.iconName = @"mk_commure_telIcon";
    telModel.typeMessage = @"Tel";
    telModel.value = @"86-75523573370";
    [self.dataList addObject:telModel];
    
    MKCommureAboutCellModel *addModel = [[MKCommureAboutCellModel alloc] init];
    addModel.iconName = @"mk_commure_addUsIcon";
    addModel.typeMessage = @"Add";
    addModel.value = @"4F,Building2,Guanghui Technology Park,MinQing Rd,Longhua,Shenzhen,Guangdong,China";
    [self.dataList addObject:addModel];
    
    MKCommureAboutCellModel *linkModel = [[MKCommureAboutCellModel alloc] init];
    linkModel.iconName = @"mk_commure_shouceIcon";
    linkModel.typeMessage = @"Website";
    linkModel.value = @"www.mokosmart.com";
    linkModel.canAdit = YES;
    [self.dataList addObject:linkModel];
    
    [self.tableView reloadData];
}

#pragma mark - Private method
- (void)openWebBrowser{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.mokosmart.com"]
                                       options:@{}
                             completionHandler:nil];
}

#pragma mark - setter & getter
- (MKBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = RGBCOLOR(239, 239, 239);
        
        _tableView.tableHeaderView = [self tableHeader];
    }
    return _tableView;
}

- (UIImageView *)aboutIcon{
    if (!_aboutIcon) {
        _aboutIcon = [[UIImageView alloc] init];
        _aboutIcon.image = LOADIMAGE(@"mk_commure_aboutIcon", @"png");
    }
    return _aboutIcon;
}

- (UILabel *)versionLabel{
    if (!_versionLabel) {
        _versionLabel = [[UILabel alloc] init];
        _versionLabel.textColor = DEFAULT_TEXT_COLOR;
        _versionLabel.textAlignment = NSTextAlignmentCenter;
        _versionLabel.font = MKFont(16.f);
    }
    return _versionLabel;
}

- (UILabel *)companyNameLabel{
    if (!_companyNameLabel) {
        _companyNameLabel = [[UILabel alloc] init];
        _companyNameLabel.textColor = DEFAULT_TEXT_COLOR;
        _companyNameLabel.textAlignment = NSTextAlignmentCenter;
        _companyNameLabel.font = MKFont(16.f);
        _companyNameLabel.text = @"MOKO TECHNOLOGY LTD.";
    }
    return _companyNameLabel;
}

- (UILabel *)companyNetLabel{
    if (!_companyNetLabel) {
        _companyNetLabel = [[UILabel alloc] init];
        _companyNetLabel.textAlignment = NSTextAlignmentCenter;
        _companyNetLabel.textColor = UIColorFromRGB(0x0188cc);
        _companyNetLabel.font = MKFont(16.f);
        _companyNetLabel.text = @"www.mokosmart.com";
        [_companyNetLabel addTapAction:self selector:@selector(openWebBrowser)];
    }
    return _companyNetLabel;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (UIView *)tableHeader {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 200.f)];
    header.backgroundColor = RGBCOLOR(239, 239, 239);
    [header addSubview:self.aboutIcon];
    [header addSubview:self.versionLabel];
    
    [self.aboutIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(header.mas_centerX);
        make.width.mas_equalTo(110.f);
        make.top.mas_equalTo(40.f);
        make.height.mas_equalTo(110.f);
    }];
    [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.aboutIcon.mas_bottom).mas_offset(17.f);
        make.height.mas_equalTo(MKFont(17).lineHeight);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = CUTTING_LINE_COLOR;
    [header addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5f);
    }];
    
    return header;
}

@end
