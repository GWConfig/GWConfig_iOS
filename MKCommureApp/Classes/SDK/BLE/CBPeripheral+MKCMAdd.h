//
//  CBPeripheral+MKCMAdd.h
//  MKCommureApp_Example
//
//  Created by aa on 2023/1/29.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBPeripheral (MKCMAdd)

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *cm_manufacturer;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *cm_deviceModel;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *cm_hardware;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *cm_software;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *cm_firmware;

#pragma mark - custom

/// W/N
@property (nonatomic, strong, readonly)CBCharacteristic *cm_password;

/// N
@property (nonatomic, strong, readonly)CBCharacteristic *cm_disconnectType;

/// W/N
@property (nonatomic, strong, readonly)CBCharacteristic *cm_custom;

- (void)cm_updateCharacterWithService:(CBService *)service;

- (void)cm_updateCurrentNotifySuccess:(CBCharacteristic *)characteristic;

- (BOOL)cm_connectSuccess;

- (void)cm_setNil;

@end

NS_ASSUME_NONNULL_END
