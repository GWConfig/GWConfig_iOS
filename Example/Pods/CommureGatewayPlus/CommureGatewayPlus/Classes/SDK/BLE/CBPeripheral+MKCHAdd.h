//
//  CBPeripheral+MKCHAdd.h
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/1/29.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBPeripheral (MKCHAdd)

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *ch_manufacturer;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *ch_deviceModel;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *ch_hardware;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *ch_software;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *ch_firmware;

#pragma mark - custom

/// W/N
@property (nonatomic, strong, readonly)CBCharacteristic *ch_password;

/// N
@property (nonatomic, strong, readonly)CBCharacteristic *ch_disconnectType;

/// W/N
@property (nonatomic, strong, readonly)CBCharacteristic *ch_custom;

- (void)ch_updateCharacterWithService:(CBService *)service;

- (void)ch_updateCurrentNotifySuccess:(CBCharacteristic *)characteristic;

- (BOOL)ch_connectSuccess;

- (void)ch_setNil;

@end

NS_ASSUME_NONNULL_END
