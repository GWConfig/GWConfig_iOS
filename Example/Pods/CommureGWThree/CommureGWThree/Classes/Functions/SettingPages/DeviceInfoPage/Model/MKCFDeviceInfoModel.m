//
//  MKCFDeviceInfoModel.m
//  CommureGWThree_Example
//
//  Created by aa on 2023/1/31.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCFDeviceInfoModel.h"

#import "MKMacroDefines.h"

#import "MKCFDeviceModeManager.h"

#import "MKCFMQTTInterface.h"

@interface MKCFDeviceInfoModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKCFDeviceInfoModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readDeviceInfo]) {
            [self operationFailedBlockWithMsg:@"Read Data Error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            sucBlock();
        });
    });
}

#pragma mark - interface
- (BOOL)readDeviceInfo {
    __block BOOL success = NO;
    [MKCFMQTTInterface cf_readDeviceInfoWithMacAddress:[MKCFDeviceModeManager shared].macAddress topic:[MKCFDeviceModeManager shared].subscribedTopic sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.deviceName = returnData[@"data"][@"device_name"];
        self.productMode = returnData[@"data"][@"product_model"];
        self.manu = returnData[@"data"][@"company_name"];
        self.firmware = returnData[@"data"][@"firmware_version"];
        self.hardware = returnData[@"data"][@"hardware_version"];
        self.software = returnData[@"data"][@"software_version"];
        self.btMac = returnData[@"data"][@"ble_mac"];
        self.wifiStaMac = [MKCFDeviceModeManager shared].macAddress;
        self.ethernetMac = returnData[@"data"][@"eth_mac"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (void)operationFailedBlockWithMsg:(NSString *)msg block:(void (^)(NSError *error))block {
    moko_dispatch_main_safe(^{
        NSError *error = [[NSError alloc] initWithDomain:@"deviceInformation"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    });
}

#pragma mark - getter
- (dispatch_semaphore_t)semaphore {
    if (!_semaphore) {
        _semaphore = dispatch_semaphore_create(0);
    }
    return _semaphore;
}

- (dispatch_queue_t)readQueue {
    if (!_readQueue) {
        _readQueue = dispatch_queue_create("deviceInfoParamsQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
