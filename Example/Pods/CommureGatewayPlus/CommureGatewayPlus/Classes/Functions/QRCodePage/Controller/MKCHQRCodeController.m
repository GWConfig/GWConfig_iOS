//
//  MKCHQRCodeController.m
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/7/7.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCHQRCodeController.h"

#import "SGQRCode.h"
#import "MKCHQRToolBar.h"

@interface MKCHQRCodeController () <SGScanCodeDelegate, SGScanCodeSampleBufferDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    SGScanCode *scanCode;
}
@property (nonatomic, strong) SGScanView *scanView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) MKCHQRToolBar *toolBar;
@property (nonatomic, assign)BOOL received;
@end

@implementation MKCHQRCodeController

- (void)dealloc {
    NSLog(@"MKCHQRCodeController销毁");
    
    [self stop];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self start];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self stop];
}

- (void)start {
    [scanCode startRunning];
    [self.scanView startScanning];
}

- (void)stop {
    [scanCode stopRunning];
    [self.scanView stopScanning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configUI];
    
    [self configScanCode];
}

- (void)configUI {
    [self.view addSubview:self.scanView];

    [self.view addSubview:self.bottomView];
    
    [self.view addSubview:self.toolBar];
}

- (void)configScanCode {
    scanCode = [[SGScanCode alloc] init];
    if (![scanCode checkCameraDeviceRearAvailable]) {
        return;;
    }
    scanCode.delegate = self;
    scanCode.sampleBufferDelegate = self;
    scanCode.preview = self.view;
}

- (void)scanCode:(SGScanCode *)scanCode result:(NSString *)result {
    if (self.received) {
        return;
    }
    [self stop];
    if (self.scanMacAddressBlock) {
        self.scanMacAddressBlock([result lowercaseString]);
    }
    self.received = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scanCode:(SGScanCode *)scanCode brightness:(CGFloat)brightness {
    if (brightness < - 1.5) {
        [self.toolBar showTorch];
    }
    
    if (brightness > 0) {
        [self.toolBar dismissTorch];
    }
}

- (SGScanView *)scanView {
    if (!_scanView) {
        SGScanViewConfigure *configure = [[SGScanViewConfigure alloc] init];
        
        CGFloat x = 0;
        CGFloat y = 0;
        CGFloat w = self.view.frame.size.width;
        CGFloat h = self.view.frame.size.height;
        _scanView = [[SGScanView alloc] initWithFrame:CGRectMake(x, y, w, h) configure:configure];
        
        CGFloat scan_x = 0;
        CGFloat scan_y = 0.18 * self.view.frame.size.height;
        CGFloat scan_w = self.view.frame.size.width - 2 * x;
        CGFloat scan_h = self.view.frame.size.height - 2.55 * scan_y;
        _scanView.scanFrame = CGRectMake(scan_x, scan_y, scan_w, scan_h);

        __weak typeof(self) weakSelf = self;
        _scanView.doubleTapBlock = ^(BOOL selected) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            if (selected) {
                [strongSelf->scanCode setVideoZoomFactor:4.0];
            } else {
                [strongSelf->scanCode setVideoZoomFactor:1.0];
            }
        };
    }
    return _scanView;
}

- (MKCHQRToolBar *)toolBar {
    if (!_toolBar) {
        _toolBar = [(MKCHQRToolBar *)[MKCHQRToolBar alloc] init];
        CGFloat h = 220;
        CGFloat y = CGRectGetMinY(self.bottomView.frame) - h;
        _toolBar.frame = CGRectMake(0, y, self.view.frame.size.width, h);
    }
    return _toolBar;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        CGFloat h = 100;
        CGFloat x = 0;
        CGFloat y = self.view.frame.size.height - h;
        CGFloat w = self.view.frame.size.width;
        _bottomView.frame = CGRectMake(x, y, w, h);
        _bottomView.backgroundColor = [UIColor blackColor];
        
        UILabel *lab = [[UILabel alloc] init];
        lab.text = @"Scan";
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [UIColor whiteColor];
        lab.frame = CGRectMake(0, 0, w, h - 34);
        [_bottomView addSubview:lab];
    }
    return _bottomView;
}

@end
