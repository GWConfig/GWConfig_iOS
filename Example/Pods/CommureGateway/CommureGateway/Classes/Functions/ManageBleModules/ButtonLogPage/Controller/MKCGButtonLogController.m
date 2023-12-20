//
//  MKCGButtonLogController.m
//  CommureGateway_Example
//
//  Created by aa on 2023/10/20.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import "MKCGButtonLogController.h"

#import <MessageUI/MessageUI.h>

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "NSString+MKAdd.h"

#import "MKHudManager.h"
#import "MKCustomUIAdopter.h"
#import "MKAlertView.h"

#import "MKCGMQTTDataManager.h"
#import "MKCGMQTTInterface.h"

#import "MKCGDeviceModeManager.h"
#import "MKCGDeviceModel.h"

#import "MKCGButtonLogHeader.h"

@interface MKCGButtonLogController ()<MFMailComposeViewControllerDelegate,
MKCGButtonLogHeaderDelegate>

@property (nonatomic, strong)MKCGButtonLogHeader *headerView;

@property (nonatomic, strong)UITextView *textView;

@property (nonatomic, strong)NSDateFormatter *formatter;

@end

@implementation MKCGButtonLogController

- (void)dealloc {
    NSLog(@"MKCGButtonLogController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveButtonLog:)
                                                 name:MKCGReceiveButtonLogNotification
                                               object:nil];
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result) {
        case MFMailComposeResultCancelled:  //取消
            break;
        case MFMailComposeResultSaved:      //用户保存
            break;
        case MFMailComposeResultSent:       //用户点击发送
            [self.view showCentralToast:@"send success"];
            break;
        case MFMailComposeResultFailed: //用户尝试保存或发送邮件失败
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MKCGButtonLogHeaderDelegate
- (void)cg_syncButtonPressed {
    self.textView.text = @"";
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    [MKCGMQTTInterface cg_readButtonLogWithBleMacAddress:self.bleMac macAddress:[MKCGDeviceModeManager shared].macAddress topic:[MKCGDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Setup succeed!"];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"setup failed!"];
    }];
}

- (void)cg_deleteButtonPressed {
    @weakify(self);
    MKAlertViewAction *cancelAction = [[MKAlertViewAction alloc] initWithTitle:@"Cancel" handler:^{
        
    }];
    
    MKAlertViewAction *confirmAction = [[MKAlertViewAction alloc] initWithTitle:@"OK" handler:^{
        @strongify(self);
        [self sendClearCommand];
    }];
    NSString *msg = @"Are you sure to erase all the saved button log ?";
    MKAlertView *alertView = [[MKAlertView alloc] init];
    [alertView addAction:cancelAction];
    [alertView addAction:confirmAction];
    [alertView showAlertWithTitle:@"Warning!" message:msg notificationName:@"mk_cg_needDismissAlert"];
}

- (void)cg_exportButtonPressed {
    if (![MFMailComposeViewController canSendMail]) {
        //如果是未绑定有效的邮箱，则跳转到系统自带的邮箱去处理
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"MESSAGE://"]
                                          options:@{}
                                completionHandler:nil];
        return;
    }
    NSString *text = self.textView.text;
    if (!ValidStr(text)) {
        [self.view showCentralToast:@"No data to send"];
        return;
    }
    NSData *textData = [text dataUsingEncoding:NSUTF8StringEncoding];
    
    if (!ValidData(textData)) {
        [self.view showCentralToast:@"Log data error"];
        return;
    }
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *bodyMsg = [NSString stringWithFormat:@"APP Version: %@ + + OS: %@",
                         version,
                         kSystemVersionString];
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate = self;
    
    //收件人
    [mailComposer setToRecipients:@[@"Development@mokotechnology.com"]];
    //邮件主题
    [mailComposer setSubject:@"Feedback of mail"];
    [mailComposer addAttachmentData:textData
                           mimeType:@"application/txt"
                           fileName:@"Button Log.txt"];
    [mailComposer setMessageBody:bodyMsg isHTML:NO];
    [self presentViewController:mailComposer animated:YES completion:nil];
}

#pragma mark - note
- (void)receiveButtonLog:(NSNotification *)note {
    NSDictionary *userInfo = note.userInfo;
    if (!ValidDict(userInfo) || ![userInfo[@"data"][@"mac"] isEqualToString:self.bleMac]) {
        return;
    }
    long long milliseconds = [userInfo[@"data"][@"timestamp"] longLongValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(milliseconds / 1000.f)];
    NSString *timeString = [self.formatter stringFromDate:date];
    // 添加毫秒
    NSString *millisecondString = [NSString stringWithFormat:@".%03d", (int)(milliseconds) % 1000];
    
    timeString = [timeString stringByAppendingString:millisecondString];
    
    
    NSString *status = [NSString stringWithFormat:@"%@%@",@"0",userInfo[@"data"][@"key_status"]];
    NSString *text = [NSString stringWithFormat:@"\n%@\t%@\t%@",timeString,@"+",status];
    self.textView.text = [self.textView.text stringByAppendingString:text];
    [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length, 1)];
}

#pragma mark - private method
- (void)sendClearCommand {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    [MKCGMQTTInterface cg_clearButtonLogWithBleMacAddress:self.bleMac macAddress:[MKCGDeviceModeManager shared].macAddress topic:[MKCGDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        self.textView.text = @"";
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Setup succeed!"];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"setup failed!"];
    }];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Button log";
    [self.view addSubview:self.headerView];
    [self.headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.height.mas_equalTo(80.f);
    }];
    [self.view addSubview:self.textView];
    [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.headerView.mas_bottom).mas_equalTo(10.f);
        make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).mas_offset(-30.f);
    }];
}

#pragma mark - getter
- (MKCGButtonLogHeader *)headerView {
    if (!_headerView) {
        _headerView = [[MKCGButtonLogHeader alloc] init];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.textColor = DEFAULT_TEXT_COLOR;
        _textView.font = MKFont(13.f);
    }
    return _textView;
}

- (NSDateFormatter *)formatter {
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        _formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    return _formatter;
}

@end
