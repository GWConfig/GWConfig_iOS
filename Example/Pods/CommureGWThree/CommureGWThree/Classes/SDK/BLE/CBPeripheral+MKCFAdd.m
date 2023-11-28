//
//  CBPeripheral+MKCFAdd.m
//  CommureGWThree_Example
//
//  Created by aa on 2023/1/29.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "CBPeripheral+MKCFAdd.h"

#import <objc/runtime.h>

static const char *cf_manufacturerKey = "cf_manufacturerKey";
static const char *cf_deviceModelKey = "cf_deviceModelKey";
static const char *cf_hardwareKey = "cf_hardwareKey";
static const char *cf_softwareKey = "cf_softwareKey";
static const char *cf_firmwareKey = "cf_firmwareKey";

static const char *cf_passwordKey = "cf_passwordKey";
static const char *cf_disconnectTypeKey = "cf_disconnectTypeKey";
static const char *cf_customKey = "cf_customKey";

static const char *cf_passwordNotifySuccessKey = "cf_passwordNotifySuccessKey";
static const char *cf_disconnectTypeNotifySuccessKey = "cf_disconnectTypeNotifySuccessKey";
static const char *cf_customNotifySuccessKey = "cf_customNotifySuccessKey";

@implementation CBPeripheral (MKCFAdd)

- (void)cf_updateCharacterWithService:(CBService *)service {
    NSArray *characteristicList = service.characteristics;
    if ([service.UUID isEqual:[CBUUID UUIDWithString:@"180A"]]) {
        //设备信息
        for (CBCharacteristic *characteristic in characteristicList) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A24"]]) {
                objc_setAssociatedObject(self, &cf_deviceModelKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A26"]]) {
                objc_setAssociatedObject(self, &cf_firmwareKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A27"]]) {
                objc_setAssociatedObject(self, &cf_hardwareKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A28"]]) {
                objc_setAssociatedObject(self, &cf_softwareKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A29"]]) {
                objc_setAssociatedObject(self, &cf_manufacturerKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
        return;
    }
    if ([service.UUID isEqual:[CBUUID UUIDWithString:@"AA00"]]) {
        //自定义
        for (CBCharacteristic *characteristic in characteristicList) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA00"]]) {
                objc_setAssociatedObject(self, &cf_passwordKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA01"]]) {
                objc_setAssociatedObject(self, &cf_disconnectTypeKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA03"]]) {
                objc_setAssociatedObject(self, &cf_customKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            [self setNotifyValue:YES forCharacteristic:characteristic];
        }
        return;
    }
}

- (void)cf_updateCurrentNotifySuccess:(CBCharacteristic *)characteristic {
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA00"]]) {
        objc_setAssociatedObject(self, &cf_passwordNotifySuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA01"]]) {
        objc_setAssociatedObject(self, &cf_disconnectTypeNotifySuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA03"]]) {
        objc_setAssociatedObject(self, &cf_customNotifySuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
}

- (BOOL)cf_connectSuccess {
    if (![objc_getAssociatedObject(self, &cf_customNotifySuccessKey) boolValue] || ![objc_getAssociatedObject(self, &cf_passwordNotifySuccessKey) boolValue] || ![objc_getAssociatedObject(self, &cf_disconnectTypeNotifySuccessKey) boolValue]) {
        return NO;
    }
    if (!self.cf_hardware || !self.cf_firmware) {
        return NO;
    }
    if (!self.cf_password || !self.cf_disconnectType || !self.cf_custom) {
        return NO;
    }
    return YES;
}

- (void)cf_setNil {
    objc_setAssociatedObject(self, &cf_manufacturerKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &cf_deviceModelKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &cf_hardwareKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &cf_softwareKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &cf_firmwareKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(self, &cf_passwordKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &cf_disconnectTypeKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &cf_customKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(self, &cf_passwordNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &cf_disconnectTypeNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &cf_customNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - getter

- (CBCharacteristic *)cf_manufacturer {
    return objc_getAssociatedObject(self, &cf_manufacturerKey);
}

- (CBCharacteristic *)cf_deviceModel {
    return objc_getAssociatedObject(self, &cf_deviceModelKey);
}

- (CBCharacteristic *)cf_hardware {
    return objc_getAssociatedObject(self, &cf_hardwareKey);
}

- (CBCharacteristic *)cf_software {
    return objc_getAssociatedObject(self, &cf_softwareKey);
}

- (CBCharacteristic *)cf_firmware {
    return objc_getAssociatedObject(self, &cf_firmwareKey);
}

- (CBCharacteristic *)cf_password {
    return objc_getAssociatedObject(self, &cf_passwordKey);
}

- (CBCharacteristic *)cf_disconnectType {
    return objc_getAssociatedObject(self, &cf_disconnectTypeKey);
}

- (CBCharacteristic *)cf_custom {
    return objc_getAssociatedObject(self, &cf_customKey);
}

@end
