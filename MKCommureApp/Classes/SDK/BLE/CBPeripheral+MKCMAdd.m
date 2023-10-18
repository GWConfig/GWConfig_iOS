//
//  CBPeripheral+MKCMAdd.m
//  MKCommureApp_Example
//
//  Created by aa on 2023/1/29.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "CBPeripheral+MKCMAdd.h"

#import <objc/runtime.h>

static const char *cm_manufacturerKey = "cm_manufacturerKey";
static const char *cm_deviceModelKey = "cm_deviceModelKey";
static const char *cm_hardwareKey = "cm_hardwareKey";
static const char *cm_softwareKey = "cm_softwareKey";
static const char *cm_firmwareKey = "cm_firmwareKey";

static const char *cm_passwordKey = "cm_passwordKey";
static const char *cm_disconnectTypeKey = "cm_disconnectTypeKey";
static const char *cm_customKey = "cm_customKey";

static const char *cm_passwordNotifySuccessKey = "cm_passwordNotifySuccessKey";
static const char *cm_disconnectTypeNotifySuccessKey = "cm_disconnectTypeNotifySuccessKey";
static const char *cm_customNotifySuccessKey = "cm_customNotifySuccessKey";

@implementation CBPeripheral (MKCMAdd)

- (void)cm_updateCharacterWithService:(CBService *)service {
    NSArray *characteristicList = service.characteristics;
    if ([service.UUID isEqual:[CBUUID UUIDWithString:@"180A"]]) {
        //设备信息
        for (CBCharacteristic *characteristic in characteristicList) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A24"]]) {
                objc_setAssociatedObject(self, &cm_deviceModelKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A26"]]) {
                objc_setAssociatedObject(self, &cm_firmwareKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A27"]]) {
                objc_setAssociatedObject(self, &cm_hardwareKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A28"]]) {
                objc_setAssociatedObject(self, &cm_softwareKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A29"]]) {
                objc_setAssociatedObject(self, &cm_manufacturerKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
        return;
    }
    if ([service.UUID isEqual:[CBUUID UUIDWithString:@"AA00"]]) {
        //自定义
        for (CBCharacteristic *characteristic in characteristicList) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA00"]]) {
                objc_setAssociatedObject(self, &cm_passwordKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA01"]]) {
                objc_setAssociatedObject(self, &cm_disconnectTypeKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA03"]]) {
                objc_setAssociatedObject(self, &cm_customKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            [self setNotifyValue:YES forCharacteristic:characteristic];
        }
        return;
    }
}

- (void)cm_updateCurrentNotifySuccess:(CBCharacteristic *)characteristic {
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA00"]]) {
        objc_setAssociatedObject(self, &cm_passwordNotifySuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA01"]]) {
        objc_setAssociatedObject(self, &cm_disconnectTypeNotifySuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA03"]]) {
        objc_setAssociatedObject(self, &cm_customNotifySuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
}

- (BOOL)cm_connectSuccess {
    if (![objc_getAssociatedObject(self, &cm_customNotifySuccessKey) boolValue] || ![objc_getAssociatedObject(self, &cm_passwordNotifySuccessKey) boolValue] || ![objc_getAssociatedObject(self, &cm_disconnectTypeNotifySuccessKey) boolValue]) {
        return NO;
    }
    if (!self.cm_hardware || !self.cm_firmware) {
        return NO;
    }
    if (!self.cm_password || !self.cm_disconnectType || !self.cm_custom) {
        return NO;
    }
    return YES;
}

- (void)cm_setNil {
    objc_setAssociatedObject(self, &cm_manufacturerKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &cm_deviceModelKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &cm_hardwareKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &cm_softwareKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &cm_firmwareKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(self, &cm_passwordKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &cm_disconnectTypeKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &cm_customKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(self, &cm_passwordNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &cm_disconnectTypeNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &cm_customNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - getter

- (CBCharacteristic *)cm_manufacturer {
    return objc_getAssociatedObject(self, &cm_manufacturerKey);
}

- (CBCharacteristic *)cm_deviceModel {
    return objc_getAssociatedObject(self, &cm_deviceModelKey);
}

- (CBCharacteristic *)cm_hardware {
    return objc_getAssociatedObject(self, &cm_hardwareKey);
}

- (CBCharacteristic *)cm_software {
    return objc_getAssociatedObject(self, &cm_softwareKey);
}

- (CBCharacteristic *)cm_firmware {
    return objc_getAssociatedObject(self, &cm_firmwareKey);
}

- (CBCharacteristic *)cm_password {
    return objc_getAssociatedObject(self, &cm_passwordKey);
}

- (CBCharacteristic *)cm_disconnectType {
    return objc_getAssociatedObject(self, &cm_disconnectTypeKey);
}

- (CBCharacteristic *)cm_custom {
    return objc_getAssociatedObject(self, &cm_customKey);
}

@end
