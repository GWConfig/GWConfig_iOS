//
//  CBPeripheral+MKCHAdd.m
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/1/29.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "CBPeripheral+MKCHAdd.h"

#import <objc/runtime.h>

static const char *ch_manufacturerKey = "ch_manufacturerKey";
static const char *ch_deviceModelKey = "ch_deviceModelKey";
static const char *ch_hardwareKey = "ch_hardwareKey";
static const char *ch_softwareKey = "ch_softwareKey";
static const char *ch_firmwareKey = "ch_firmwareKey";

static const char *ch_passwordKey = "ch_passwordKey";
static const char *ch_disconnectTypeKey = "ch_disconnectTypeKey";
static const char *ch_customKey = "ch_customKey";

static const char *ch_passwordNotifySuccessKey = "ch_passwordNotifySuccessKey";
static const char *ch_disconnectTypeNotifySuccessKey = "ch_disconnectTypeNotifySuccessKey";
static const char *ch_customNotifySuccessKey = "ch_customNotifySuccessKey";

@implementation CBPeripheral (MKCHAdd)

- (void)ch_updateCharacterWithService:(CBService *)service {
    NSArray *characteristicList = service.characteristics;
    if ([service.UUID isEqual:[CBUUID UUIDWithString:@"180A"]]) {
        //设备信息
        for (CBCharacteristic *characteristic in characteristicList) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A24"]]) {
                objc_setAssociatedObject(self, &ch_deviceModelKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A26"]]) {
                objc_setAssociatedObject(self, &ch_firmwareKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A27"]]) {
                objc_setAssociatedObject(self, &ch_hardwareKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A28"]]) {
                objc_setAssociatedObject(self, &ch_softwareKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A29"]]) {
                objc_setAssociatedObject(self, &ch_manufacturerKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
        return;
    }
    if ([service.UUID isEqual:[CBUUID UUIDWithString:@"AA00"]]) {
        //自定义
        for (CBCharacteristic *characteristic in characteristicList) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA00"]]) {
                objc_setAssociatedObject(self, &ch_passwordKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA01"]]) {
                objc_setAssociatedObject(self, &ch_disconnectTypeKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA03"]]) {
                objc_setAssociatedObject(self, &ch_customKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            [self setNotifyValue:YES forCharacteristic:characteristic];
        }
        return;
    }
}

- (void)ch_updateCurrentNotifySuccess:(CBCharacteristic *)characteristic {
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA00"]]) {
        objc_setAssociatedObject(self, &ch_passwordNotifySuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA01"]]) {
        objc_setAssociatedObject(self, &ch_disconnectTypeNotifySuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA03"]]) {
        objc_setAssociatedObject(self, &ch_customNotifySuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
}

- (BOOL)ch_connectSuccess {
    if (![objc_getAssociatedObject(self, &ch_customNotifySuccessKey) boolValue] || ![objc_getAssociatedObject(self, &ch_passwordNotifySuccessKey) boolValue] || ![objc_getAssociatedObject(self, &ch_disconnectTypeNotifySuccessKey) boolValue]) {
        return NO;
    }
    if (!self.ch_hardware || !self.ch_firmware) {
        return NO;
    }
    if (!self.ch_password || !self.ch_disconnectType || !self.ch_custom) {
        return NO;
    }
    return YES;
}

- (void)ch_setNil {
    objc_setAssociatedObject(self, &ch_manufacturerKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &ch_deviceModelKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &ch_hardwareKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &ch_softwareKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &ch_firmwareKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(self, &ch_passwordKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &ch_disconnectTypeKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &ch_customKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(self, &ch_passwordNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &ch_disconnectTypeNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &ch_customNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - getter

- (CBCharacteristic *)ch_manufacturer {
    return objc_getAssociatedObject(self, &ch_manufacturerKey);
}

- (CBCharacteristic *)ch_deviceModel {
    return objc_getAssociatedObject(self, &ch_deviceModelKey);
}

- (CBCharacteristic *)ch_hardware {
    return objc_getAssociatedObject(self, &ch_hardwareKey);
}

- (CBCharacteristic *)ch_software {
    return objc_getAssociatedObject(self, &ch_softwareKey);
}

- (CBCharacteristic *)ch_firmware {
    return objc_getAssociatedObject(self, &ch_firmwareKey);
}

- (CBCharacteristic *)ch_password {
    return objc_getAssociatedObject(self, &ch_passwordKey);
}

- (CBCharacteristic *)ch_disconnectType {
    return objc_getAssociatedObject(self, &ch_disconnectTypeKey);
}

- (CBCharacteristic *)ch_custom {
    return objc_getAssociatedObject(self, &ch_customKey);
}

@end
