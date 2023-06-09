//
//  MKCMServerForAppModel.m
//  MKCommureApp_Example
//
//  Created by aa on 2023/2/7.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCMServerForAppModel.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKCMMQTTDataManager.h"

@implementation MKCMServerForAppModel

- (instancetype)init {
    if (self = [super init]) {
        [self loadServerParams];
    }
    return self;
}

- (void)clearAllParams {
    _host = @"";
    _port = @"";
    _clientID = @"";
    _cleanSession = YES;
    _qos = 0;
    _keepAlive = @"";
    _userName = @"";
    _password = @"";
    _sslIsOn = NO;
    _certificate = 0;
    _caFileName = @"";
    _clientFileName = @"";
}

- (NSString *)checkParams {
    if (!ValidStr(self.host) || self.host.length > 64 || ![self.host isAsciiString]) {
        return @"Host error";
    }
    if (!ValidStr(self.port) || [self.port integerValue] < 1 || [self.port integerValue] > 65535) {
        return @"Port error";
    }
    if (!ValidStr(self.clientID) || self.clientID.length > 64 || ![self.clientID isAsciiString]) {
        return @"ClientID error";
    }
    if (self.qos < 0 || self.qos > 2) {
        return @"Qos error";
    }
    if (!ValidStr(self.keepAlive) || [self.keepAlive integerValue] < 10 || [self.keepAlive integerValue] > 120) {
        return @"KeepAlive error";
    }
    if (self.userName.length > 256 || (ValidStr(self.userName) && ![self.userName isAsciiString])) {
        return @"UserName error";
    }
    if (self.password.length > 256 || (ValidStr(self.password) && ![self.password isAsciiString])) {
        return @"Password error";
    }
    if (self.sslIsOn) {
        if (self.certificate < 0 || self.certificate > 2) {
            return @"Certificate error";
        }
        if (self.certificate == 0) {
            return @"";
        }
        if (!ValidStr(self.caFileName)) {
            return @"CA File cannot be empty.";
        }
        if (self.certificate == 2 && !ValidStr(self.clientFileName)) {
            return @"Client File cannot be empty.";
        }
    }
    return @"";
}

- (void)updateValue:(MKCMServerForAppModel *)model {
    if (!model || ![model isKindOfClass:MKCMServerForAppModel.class]) {
        return;
    }
    self.host = model.host;
    self.port = model.port;
    self.clientID = model.clientID;
    self.cleanSession = model.cleanSession;
    
    self.qos = model.qos;
    self.keepAlive = model.keepAlive;
    self.userName = model.userName;
    self.password = model.password;
    self.sslIsOn = model.sslIsOn;
    self.certificate = model.certificate;
}

#pragma mark - private method
- (void)loadServerParams {
    if (!ValidStr([MKCMMQTTDataManager shared].serverParams.host)) {
        //本地没有服务器参数
        self.host = @"iot.csafe.cloud";
        self.port = @"1883";
        self.clientID = [NSString stringWithFormat:@"%ld",(long)((1000000 + (arc4random() % 90000000)))];
        self.cleanSession = YES;
        self.keepAlive = @"60";
        self.qos = 0;
        return;
    }
    self.host = [MKCMMQTTDataManager shared].serverParams.host;
    self.port = [MKCMMQTTDataManager shared].serverParams.port;
    self.clientID = [MKCMMQTTDataManager shared].serverParams.clientID;
    self.cleanSession = [MKCMMQTTDataManager shared].serverParams.cleanSession;
    
    self.qos = [MKCMMQTTDataManager shared].serverParams.qos;
    self.keepAlive = [MKCMMQTTDataManager shared].serverParams.keepAlive;
    self.userName = [MKCMMQTTDataManager shared].serverParams.userName;
    self.password = [MKCMMQTTDataManager shared].serverParams.password;
    self.sslIsOn = [MKCMMQTTDataManager shared].serverParams.sslIsOn;
    self.certificate = [MKCMMQTTDataManager shared].serverParams.certificate;
    self.caFileName = [MKCMMQTTDataManager shared].serverParams.caFileName;
    self.clientFileName = [MKCMMQTTDataManager shared].serverParams.clientFileName;
}

@end
