//
//  CBPeripheral+MKCGAdd.m
//  CommureGateway_Example
//
//  Created by aa on 2023/1/29.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "CBPeripheral+MKCGAdd.h"

#import <objc/runtime.h>

static const char *cg_manufacturerKey = "cg_manufacturerKey";
static const char *cg_deviceModelKey = "cg_deviceModelKey";
static const char *cg_hardwareKey = "cg_hardwareKey";
static const char *cg_softwareKey = "cg_softwareKey";
static const char *cg_firmwareKey = "cg_firmwareKey";

static const char *cg_passwordKey = "cg_passwordKey";
static const char *cg_disconnectTypeKey = "cg_disconnectTypeKey";
static const char *cg_customKey = "cg_customKey";

static const char *cg_passwordNotifySuccessKey = "cg_passwordNotifySuccessKey";
static const char *cg_disconnectTypeNotifySuccessKey = "cg_disconnectTypeNotifySuccessKey";
static const char *cg_customNotifySuccessKey = "cg_customNotifySuccessKey";

@implementation CBPeripheral (MKCGAdd)

- (void)cg_updateCharacterWithService:(CBService *)service {
    NSArray *characteristicList = service.characteristics;
    if ([service.UUID isEqual:[CBUUID UUIDWithString:@"180A"]]) {
        //设备信息
        for (CBCharacteristic *characteristic in characteristicList) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A24"]]) {
                objc_setAssociatedObject(self, &cg_deviceModelKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A26"]]) {
                objc_setAssociatedObject(self, &cg_firmwareKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A27"]]) {
                objc_setAssociatedObject(self, &cg_hardwareKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A28"]]) {
                objc_setAssociatedObject(self, &cg_softwareKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A29"]]) {
                objc_setAssociatedObject(self, &cg_manufacturerKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
        return;
    }
    if ([service.UUID isEqual:[CBUUID UUIDWithString:@"AA00"]]) {
        //自定义
        for (CBCharacteristic *characteristic in characteristicList) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA00"]]) {
                objc_setAssociatedObject(self, &cg_passwordKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA01"]]) {
                objc_setAssociatedObject(self, &cg_disconnectTypeKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA03"]]) {
                objc_setAssociatedObject(self, &cg_customKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            [self setNotifyValue:YES forCharacteristic:characteristic];
        }
        return;
    }
}

- (void)cg_updateCurrentNotifySuccess:(CBCharacteristic *)characteristic {
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA00"]]) {
        objc_setAssociatedObject(self, &cg_passwordNotifySuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA01"]]) {
        objc_setAssociatedObject(self, &cg_disconnectTypeNotifySuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA03"]]) {
        objc_setAssociatedObject(self, &cg_customNotifySuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
}

- (BOOL)cg_connectSuccess {
    if (![objc_getAssociatedObject(self, &cg_customNotifySuccessKey) boolValue] || ![objc_getAssociatedObject(self, &cg_passwordNotifySuccessKey) boolValue] || ![objc_getAssociatedObject(self, &cg_disconnectTypeNotifySuccessKey) boolValue]) {
        return NO;
    }
    if (!self.cg_hardware || !self.cg_firmware) {
        return NO;
    }
    if (!self.cg_password || !self.cg_disconnectType || !self.cg_custom) {
        return NO;
    }
    return YES;
}

- (void)cg_setNil {
    objc_setAssociatedObject(self, &cg_manufacturerKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &cg_deviceModelKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &cg_hardwareKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &cg_softwareKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &cg_firmwareKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(self, &cg_passwordKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &cg_disconnectTypeKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &cg_customKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(self, &cg_passwordNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &cg_disconnectTypeNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &cg_customNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - getter

- (CBCharacteristic *)cg_manufacturer {
    return objc_getAssociatedObject(self, &cg_manufacturerKey);
}

- (CBCharacteristic *)cg_deviceModel {
    return objc_getAssociatedObject(self, &cg_deviceModelKey);
}

- (CBCharacteristic *)cg_hardware {
    return objc_getAssociatedObject(self, &cg_hardwareKey);
}

- (CBCharacteristic *)cg_software {
    return objc_getAssociatedObject(self, &cg_softwareKey);
}

- (CBCharacteristic *)cg_firmware {
    return objc_getAssociatedObject(self, &cg_firmwareKey);
}

- (CBCharacteristic *)cg_password {
    return objc_getAssociatedObject(self, &cg_passwordKey);
}

- (CBCharacteristic *)cg_disconnectType {
    return objc_getAssociatedObject(self, &cg_disconnectTypeKey);
}

- (CBCharacteristic *)cg_custom {
    return objc_getAssociatedObject(self, &cg_customKey);
}

@end
