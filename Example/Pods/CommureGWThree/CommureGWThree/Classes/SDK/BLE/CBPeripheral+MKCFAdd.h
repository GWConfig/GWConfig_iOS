//
//  CBPeripheral+MKCFAdd.h
//  CommureGWThree_Example
//
//  Created by aa on 2023/1/29.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBPeripheral (MKCFAdd)

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *cf_manufacturer;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *cf_deviceModel;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *cf_hardware;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *cf_software;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *cf_firmware;

#pragma mark - custom

/// W/N
@property (nonatomic, strong, readonly)CBCharacteristic *cf_password;

/// N
@property (nonatomic, strong, readonly)CBCharacteristic *cf_disconnectType;

/// W/N
@property (nonatomic, strong, readonly)CBCharacteristic *cf_custom;

- (void)cf_updateCharacterWithService:(CBService *)service;

- (void)cf_updateCurrentNotifySuccess:(CBCharacteristic *)characteristic;

- (BOOL)cf_connectSuccess;

- (void)cf_setNil;

@end

NS_ASSUME_NONNULL_END
