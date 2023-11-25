//
//  CBPeripheral+MKCGAdd.h
//  CommureGateway_Example
//
//  Created by aa on 2023/1/29.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBPeripheral (MKCGAdd)

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *cg_manufacturer;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *cg_deviceModel;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *cg_hardware;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *cg_software;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *cg_firmware;

#pragma mark - custom

/// W/N
@property (nonatomic, strong, readonly)CBCharacteristic *cg_password;

/// N
@property (nonatomic, strong, readonly)CBCharacteristic *cg_disconnectType;

/// W/N
@property (nonatomic, strong, readonly)CBCharacteristic *cg_custom;

- (void)cg_updateCharacterWithService:(CBService *)service;

- (void)cg_updateCurrentNotifySuccess:(CBCharacteristic *)characteristic;

- (BOOL)cg_connectSuccess;

- (void)cg_setNil;

@end

NS_ASSUME_NONNULL_END
