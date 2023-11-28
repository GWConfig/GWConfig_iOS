//
//  MKCFBleDeviceInfoModel.m
//  CommureGWThree_Example
//
//  Created by aa on 2023/1/31.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCFBleDeviceInfoModel.h"

#import "MKMacroDefines.h"

#import "MKCFInterface.h"

@interface MKCFBleDeviceInfoModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKCFBleDeviceInfoModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readDeviceName]) {
            [self operationFailedBlockWithMsg:@"Read Device Name error" block:failedBlock];
            return ;
        }
        if (![self readDeviceModel]) {
            [self operationFailedBlockWithMsg:@"Read device model error" block:failedBlock];
            return ;
        }
        if (![self readSoftware]) {
            [self operationFailedBlockWithMsg:@"Read software error" block:failedBlock];
            return ;
        }
        if (![self readHardware]) {
            [self operationFailedBlockWithMsg:@"Read hardware error" block:failedBlock];
            return ;
        }
        if (![self readFirmware]) {
            [self operationFailedBlockWithMsg:@"Read firmware error" block:failedBlock];
            return ;
        }
        if (![self readManu]) {
            [self operationFailedBlockWithMsg:@"Read manu error" block:failedBlock];
            return ;
        }
        if (![self readMacAddress]) {
            [self operationFailedBlockWithMsg:@"Read mac address error" block:failedBlock];
            return ;
        }
        if (![self readWifiStaMAC]) {
            [self operationFailedBlockWithMsg:@"Read WIFI STA MAC error" block:failedBlock];
            return ;
        }
        moko_dispatch_main_safe(^{
            sucBlock();
        });
    });
}

#pragma mark - interface
- (BOOL)readDeviceName {
    __block BOOL success = NO;
    [MKCFInterface cf_readDeviceNameWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.deviceName = returnData[@"result"][@"deviceName"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readDeviceModel {
    __block BOOL success = NO;
    [MKCFInterface cf_readDeviceModelWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.productMode = returnData[@"result"][@"modeID"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readSoftware {
    __block BOOL success = NO;
    [MKCFInterface cf_readSoftwareWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.software = returnData[@"result"][@"software"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readFirmware {
    __block BOOL success = NO;
    [MKCFInterface cf_readFirmwareWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.firmware = returnData[@"result"][@"firmware"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readHardware {
    __block BOOL success = NO;
    [MKCFInterface cf_readHardwareWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.hardware = returnData[@"result"][@"hardware"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readManu {
    __block BOOL success = NO;
    [MKCFInterface cf_readManufacturerWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.manu = returnData[@"result"][@"manufacturer"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readMacAddress {
    __block BOOL success = NO;
    [MKCFInterface cf_readMacAddressWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.btMac = returnData[@"result"][@"macAddress"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readWifiStaMAC {
    __block BOOL success = NO;
    [MKCFInterface cf_readDeviceWifiSTAMacAddressWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.wifiStaMac = returnData[@"result"][@"macAddress"];
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
