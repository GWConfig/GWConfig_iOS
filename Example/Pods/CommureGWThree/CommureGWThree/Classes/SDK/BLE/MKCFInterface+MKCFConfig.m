//
//  MKCFInterface+MKCFConfig.m
//  CommureGWThree_Example
//
//  Created by aa on 2023/1/29.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCFInterface+MKCFConfig.h"

#import "MKBLEBaseCentralManager.h"
#import "MKBLEBaseSDKDefines.h"
#import "MKBLEBaseSDKAdopter.h"

#import "MKCFCentralManager.h"
#import "MKCFOperationID.h"
#import "CBPeripheral+MKCFAdd.h"
#import "MKCFOperation.h"
#import "MKCFSDKDataAdopter.h"

static const NSInteger packDataMaxLen = 150;

#define centralManager [MKCFCentralManager shared]
#define peripheral ([MKCFCentralManager shared].peripheral)

@implementation MKCFInterface (MKCFConfig)

#pragma mark ********************自定义参数配置************************

#pragma mark *********************System Params************************
+ (void)cf_enterSTAModeWithSucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed010200";
    [self configDataWithTaskID:mk_cf_taskEnterSTAModeOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)cf_configNTPServerHost:(NSString *)host
                      sucBlock:(void (^)(void))sucBlock
                   failedBlock:(void (^)(NSError *error))failedBlock {
    if (host.length > 64) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *tempString = [MKCFSDKDataAdopter fetchAsciiCode:host];
    NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:host.length byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed0111",lenString,tempString];
    
    [self configDataWithTaskID:mk_cf_taskConfigNTPServerHostOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)cf_configTimeZone:(NSInteger)timeZone
                 sucBlock:(void (^)(void))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock {
    if (timeZone < -24 || timeZone > 28) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *zoneValue = [MKBLEBaseSDKAdopter hexStringFromSignedNumber:timeZone];
    NSString *commandString = [@"ed011201" stringByAppendingString:zoneValue];
    [self configDataWithTaskID:mk_cf_taskConfigTimeZoneOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)cf_configDeviceTime:(unsigned long)timestamp
                   sucBlock:(void (^)(void))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *value = [NSString stringWithFormat:@"%1lx",timestamp];
    NSString *commandString = [@"ed011404" stringByAppendingString:value];
    [self configDataWithTaskID:mk_cf_taskConfigDeviceTimeOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

#pragma mark *********************MQTT Params************************

+ (void)cf_configServerHost:(NSString *)host
                   sucBlock:(void (^)(void))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(host) || host.length > 64) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *tempString = [MKCFSDKDataAdopter fetchAsciiCode:host];
    NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:host.length byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed0120",lenString,tempString];
    [self configDataWithTaskID:mk_cf_taskConfigServerHostOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)cf_configServerPort:(NSInteger)port
                   sucBlock:(void (^)(void))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock {
    if (port < 0 || port > 65535) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:port byteLen:2];
    NSString *commandString = [@"ed012102" stringByAppendingString:value];
    [self configDataWithTaskID:mk_cf_taskConfigServerPortOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)cf_configClientID:(NSString *)clientID
                 sucBlock:(void (^)(void))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(clientID) || clientID.length > 64) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *tempString = [MKCFSDKDataAdopter fetchAsciiCode:clientID];
    NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:clientID.length byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed0122",lenString,tempString];
    [self configDataWithTaskID:mk_cf_taskConfigClientIDOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)cf_configServerUserName:(NSString *)userName
                       sucBlock:(void (^)(void))sucBlock
                    failedBlock:(void (^)(NSError *error))failedBlock {
    if (userName.length > 256) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    if (!MKValidStr(userName)) {
        //空的
        NSString *commandString = @"ee0123010000";
        [self configDataWithTaskID:mk_cf_taskConfigServerUserNameOperation
                              data:commandString
                          sucBlock:sucBlock
                       failedBlock:failedBlock];
        return;
    }
    NSInteger totalNum = userName.length / packDataMaxLen;
    NSInteger packRemain = userName.length % packDataMaxLen;
    if (packRemain > 0) {
        totalNum ++;
    }
    NSString *totalNumHex = [MKBLEBaseSDKAdopter fetchHexValue:totalNum byteLen:1];
    NSString *commandHeader = @"ee0123";
    dispatch_queue_t queue = dispatch_queue_create("configUserNameQueue", 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < totalNum; i ++) {
            NSString *packIndex = [MKBLEBaseSDKAdopter fetchHexValue:i byteLen:1];
            NSInteger len = packDataMaxLen;
            if ((i == totalNum - 1) && (packRemain > 0)) {
                //最后一帧
                len = packRemain;
            }
            NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:len byteLen:1];
            NSString *asciiChar = [MKCFSDKDataAdopter fetchAsciiCode:[userName substringWithRange:NSMakeRange(i * packDataMaxLen, len)]];
            NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@",commandHeader,totalNumHex,packIndex,lenString,asciiChar];
            BOOL success = [self sendDataToPeripheral:commandString
                                               taskID:mk_cf_taskConfigServerUserNameOperation
                                            semaphore:semaphore];
            if (!success) {
                [MKBLEBaseSDKAdopter operationSetParamsErrorBlock:failedBlock];
                return;
            }
        }
        MKBLEBase_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

+ (void)cf_configServerPassword:(NSString *)password
                       sucBlock:(void (^)(void))sucBlock
                    failedBlock:(void (^)(NSError *error))failedBlock {
    if (password.length > 256) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    if (!MKValidStr(password)) {
        //空的
        NSString *commandString = @"ee0124010000";
        [self configDataWithTaskID:mk_cf_taskConfigServerPasswordOperation
                              data:commandString
                          sucBlock:sucBlock
                       failedBlock:failedBlock];
        return;
    }
    NSInteger totalNum = password.length / packDataMaxLen;
    NSInteger packRemain = password.length % packDataMaxLen;
    if (packRemain > 0) {
        totalNum ++;
    }
    NSString *totalNumHex = [MKBLEBaseSDKAdopter fetchHexValue:totalNum byteLen:1];
    NSString *commandHeader = @"ee0124";
    dispatch_queue_t queue = dispatch_queue_create("configUserPasswordQueue", 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < totalNum; i ++) {
            NSString *packIndex = [MKBLEBaseSDKAdopter fetchHexValue:i byteLen:1];
            NSInteger len = packDataMaxLen;
            if ((i == totalNum - 1) && (packRemain > 0)) {
                //最后一帧
                len = packRemain;
            }
            NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:len byteLen:1];
            NSString *asciiChar = [MKCFSDKDataAdopter fetchAsciiCode:[password substringWithRange:NSMakeRange(i * packDataMaxLen, len)]];
            NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@",commandHeader,totalNumHex,packIndex,lenString,asciiChar];
            BOOL success = [self sendDataToPeripheral:commandString
                                               taskID:mk_cf_taskConfigServerPasswordOperation
                                            semaphore:semaphore];
            if (!success) {
                [MKBLEBaseSDKAdopter operationSetParamsErrorBlock:failedBlock];
                return;
            }
        }
        MKBLEBase_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

+ (void)cf_configServerCleanSession:(BOOL)clean
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (clean ? @"ed01250101" : @"ed01250100");
    [self configDataWithTaskID:mk_cf_taskConfigServerCleanSessionOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)cf_configServerKeepAlive:(NSInteger)interval
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 10 || interval > 120) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:interval byteLen:1];
    NSString *commandString = [@"ed012601" stringByAppendingString:value];
    [self configDataWithTaskID:mk_cf_taskConfigServerKeepAliveOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)cf_configServerQos:(mk_cf_mqttServerQosMode)mode
                  sucBlock:(void (^)(void))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *qosString = [MKCFSDKDataAdopter fetchMqttServerQosMode:mode];
    NSString *commandString = [@"ed012701" stringByAppendingString:qosString];
    [self configDataWithTaskID:mk_cf_taskConfigServerQosOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)cf_configSubscibeTopic:(NSString *)subscibeTopic
                      sucBlock:(void (^)(void))sucBlock
                   failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(subscibeTopic) || subscibeTopic.length > 128) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *tempString = [MKCFSDKDataAdopter fetchAsciiCode:subscibeTopic];
    NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:subscibeTopic.length byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed0128",lenString,tempString];
    [self configDataWithTaskID:mk_cf_taskConfigSubscibeTopicOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)cf_configPublishTopic:(NSString *)publishTopic
                     sucBlock:(void (^)(void))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(publishTopic) || publishTopic.length > 128) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *tempString = [MKCFSDKDataAdopter fetchAsciiCode:publishTopic];
    NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:publishTopic.length byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed0129",lenString,tempString];
    [self configDataWithTaskID:mk_cf_taskConfigPublishTopicOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)cf_configConnectMode:(mk_cf_connectMode)mode
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *modeString = [MKCFSDKDataAdopter fetchConnectModeString:mode];
    NSString *commandString = [@"ed012f01" stringByAppendingString:modeString];
    [self configDataWithTaskID:mk_cf_taskConfigConnectModeOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)cf_configCAFile:(NSData *)caFile
               sucBlock:(void (^)(void))sucBlock
            failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidData(caFile)) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *caStrings = [MKBLEBaseSDKAdopter hexStringFromData:caFile];
    NSInteger totalNum = (caStrings.length / 2) / packDataMaxLen;
    NSInteger packRemain = (caStrings.length / 2) % packDataMaxLen;
    if (packRemain > 0) {
        totalNum ++;
    }
    NSString *commandHeader = [NSString stringWithFormat:@"%@%@",@"ee0130",[MKBLEBaseSDKAdopter fetchHexValue:totalNum byteLen:1]];
    dispatch_queue_t queue = dispatch_queue_create("configCAFileQueue", 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < totalNum; i ++) {
            NSString *index = [MKBLEBaseSDKAdopter fetchHexValue:i byteLen:1];
            NSInteger len = packDataMaxLen;
            if ((i == totalNum - 1) && (packRemain > 0)) {
                //最后一帧
                len = packRemain;
            }
            NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:len byteLen:1];
            NSString *subChar = [caStrings substringWithRange:NSMakeRange(i * 2 * packDataMaxLen, 2 * len)];
            NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@",commandHeader,index,lenString,subChar];
            BOOL success = [self sendDataToPeripheral:commandString
                                               taskID:mk_cf_taskConfigCAFileOperation
                                            semaphore:semaphore];
            if (!success) {
                [MKBLEBaseSDKAdopter operationSetParamsErrorBlock:failedBlock];
                return;
            }
        }
        MKBLEBase_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

+ (void)cf_configClientCert:(NSData *)cert
                   sucBlock:(void (^)(void))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidData(cert)) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *certStrings = [MKBLEBaseSDKAdopter hexStringFromData:cert];
    NSInteger totalNum = (certStrings.length / 2) / packDataMaxLen;
    NSInteger packRemain = (certStrings.length / 2) % packDataMaxLen;
    if (packRemain > 0) {
        totalNum ++;
    }
    NSString *commandHeader = [NSString stringWithFormat:@"%@%@",@"ee0131",[MKBLEBaseSDKAdopter fetchHexValue:totalNum byteLen:1]];
    dispatch_queue_t queue = dispatch_queue_create("configCertQueue", 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < totalNum; i ++) {
            NSString *index = [MKBLEBaseSDKAdopter fetchHexValue:i byteLen:1];
            NSInteger len = packDataMaxLen;
            if ((i == totalNum - 1) && (packRemain > 0)) {
                //最后一帧
                len = packRemain;
            }
            NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:len byteLen:1];
            NSString *subChar = [certStrings substringWithRange:NSMakeRange(i * 2 * packDataMaxLen, 2 * len)];
            NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@",commandHeader,index,lenString,subChar];
            BOOL success = [self sendDataToPeripheral:commandString
                                               taskID:mk_cf_taskConfigClientCertOperation
                                            semaphore:semaphore];
            if (!success) {
                [MKBLEBaseSDKAdopter operationSetParamsErrorBlock:failedBlock];
                return;
            }
        }
        MKBLEBase_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

+ (void)cf_configClientPrivateKey:(NSData *)privateKey
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidData(privateKey)) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *privateKeyStrings = [MKBLEBaseSDKAdopter hexStringFromData:privateKey];
    NSInteger totalNum = (privateKeyStrings.length / 2) / packDataMaxLen;
    NSInteger packRemain = (privateKeyStrings.length / 2) % packDataMaxLen;
    if (packRemain > 0) {
        totalNum ++;
    }
    NSString *commandHeader = [NSString stringWithFormat:@"%@%@",@"ee0132",[MKBLEBaseSDKAdopter fetchHexValue:totalNum byteLen:1]];
    dispatch_queue_t queue = dispatch_queue_create("configPrivateKeyQueue", 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < totalNum; i ++) {
            NSString *index = [MKBLEBaseSDKAdopter fetchHexValue:i byteLen:1];
            NSInteger len = packDataMaxLen;
            if ((i == totalNum - 1) && (packRemain > 0)) {
                //最后一帧
                len = packRemain;
            }
            NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:len byteLen:1];
            NSString *subChar = [privateKeyStrings substringWithRange:NSMakeRange(i * 2 * packDataMaxLen, 2 * len)];
            NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@",commandHeader,index,lenString,subChar];
            BOOL success = [self sendDataToPeripheral:commandString
                                               taskID:mk_cf_taskConfigClientPrivateKeyOperation
                                            semaphore:semaphore];
            if (!success) {
                [MKBLEBaseSDKAdopter operationSetParamsErrorBlock:failedBlock];
                return;
            }
        }
        MKBLEBase_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}


#pragma mark *********************WIFI Params************************

+ (void)cf_configWIFISecurity:(mk_cf_wifiSecurity)security
                     sucBlock:(void (^)(void))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *type = [MKCFSDKDataAdopter fetchWifiSecurity:security];
    NSString *commandString = [@"ed014001" stringByAppendingString:type];
    [self configDataWithTaskID:mk_cf_taskConfigWIFISecurityOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)cf_configWIFISSID:(NSString *)ssid
                 sucBlock:(void (^)(void))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(ssid) || ssid.length > 32) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *tempString = [MKCFSDKDataAdopter fetchAsciiCode:ssid];
    NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:ssid.length byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed0141",lenString,tempString];
    [self configDataWithTaskID:mk_cf_taskConfigWIFISSIDOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)cf_configWIFIPassword:(NSString *)password
                     sucBlock:(void (^)(void))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock {
    if (password.length > 64) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *tempString = [MKCFSDKDataAdopter fetchAsciiCode:password];
    NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:password.length byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed0142",lenString,tempString];
    
    [self configDataWithTaskID:mk_cf_taskConfigWIFIPasswordOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)cf_configWIFIEAPType:(mk_cf_eapType)eapType
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *type = [MKCFSDKDataAdopter fetchWifiEapType:eapType];
    NSString *commandString = [@"ed014301" stringByAppendingString:type];
    [self configDataWithTaskID:mk_cf_taskConfigWIFIEAPTypeOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)cf_configWIFIEAPUsername:(NSString *)username
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock {
    if (username.length > 32) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *tempString = [MKCFSDKDataAdopter fetchAsciiCode:username];
    NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:username.length byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed0144",lenString,tempString];
    
    [self configDataWithTaskID:mk_cf_taskConfigWIFIEAPUsernameOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)cf_configWIFIEAPPassword:(NSString *)password
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock {
    if (password.length > 64) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *tempString = [MKCFSDKDataAdopter fetchAsciiCode:password];
    NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:password.length byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed0145",lenString,tempString];
    
    [self configDataWithTaskID:mk_cf_taskConfigWIFIEAPPasswordOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)cf_configWIFIEAPDomainID:(NSString *)domainID
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock {
    if (domainID.length > 64) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *tempString = [MKCFSDKDataAdopter fetchAsciiCode:domainID];
    NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:domainID.length byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed0146",lenString,tempString];
    
    [self configDataWithTaskID:mk_cf_taskConfigWIFIEAPDomainIDOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)cf_configWIFIVerifyServerStatus:(BOOL)verify
                               sucBlock:(void (^)(void))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (verify ? @"ed01470101" : @"ed01470100");
    [self configDataWithTaskID:mk_cf_taskConfigWIFIVerifyServerStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)cf_configWIFICAFile:(NSData *)caFile
                   sucBlock:(void (^)(void))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidData(caFile)) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *caStrings = [MKBLEBaseSDKAdopter hexStringFromData:caFile];
    NSInteger totalNum = (caStrings.length / 2) / packDataMaxLen;
    NSInteger packRemain = (caStrings.length / 2) % packDataMaxLen;
    if (packRemain > 0) {
        totalNum ++;
    }
    NSString *commandHeader = [NSString stringWithFormat:@"%@%@",@"ee0148",[MKBLEBaseSDKAdopter fetchHexValue:totalNum byteLen:1]];
    dispatch_queue_t queue = dispatch_queue_create("configWIFICAFileQueue", 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < totalNum; i ++) {
            NSString *index = [MKBLEBaseSDKAdopter fetchHexValue:i byteLen:1];
            NSInteger len = packDataMaxLen;
            if ((i == totalNum - 1) && (packRemain > 0)) {
                //最后一帧
                len = packRemain;
            }
            NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:len byteLen:1];
            NSString *subChar = [caStrings substringWithRange:NSMakeRange(i * 2 * packDataMaxLen, 2 * len)];
            NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@",commandHeader,index,lenString,subChar];
            BOOL success = [self sendDataToPeripheral:commandString
                                               taskID:mk_cf_taskConfigWIFICAFileOperation
                                            semaphore:semaphore];
            if (!success) {
                [MKBLEBaseSDKAdopter operationSetParamsErrorBlock:failedBlock];
                return;
            }
        }
        MKBLEBase_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

+ (void)cf_configWIFIClientCert:(NSData *)cert
                       sucBlock:(void (^)(void))sucBlock
                    failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidData(cert)) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *certStrings = [MKBLEBaseSDKAdopter hexStringFromData:cert];
    NSInteger totalNum = (certStrings.length / 2) / packDataMaxLen;
    NSInteger packRemain = (certStrings.length / 2) % packDataMaxLen;
    if (packRemain > 0) {
        totalNum ++;
    }
    NSString *commandHeader = [NSString stringWithFormat:@"%@%@",@"ee0149",[MKBLEBaseSDKAdopter fetchHexValue:totalNum byteLen:1]];
    dispatch_queue_t queue = dispatch_queue_create("configWIFICertQueue", 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < totalNum; i ++) {
            NSString *index = [MKBLEBaseSDKAdopter fetchHexValue:i byteLen:1];
            NSInteger len = packDataMaxLen;
            if ((i == totalNum - 1) && (packRemain > 0)) {
                //最后一帧
                len = packRemain;
            }
            NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:len byteLen:1];
            NSString *subChar = [certStrings substringWithRange:NSMakeRange(i * 2 * packDataMaxLen, 2 * len)];
            NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@",commandHeader,index,lenString,subChar];
            BOOL success = [self sendDataToPeripheral:commandString
                                               taskID:mk_cf_taskConfigWIFIClientCertOperation
                                            semaphore:semaphore];
            if (!success) {
                [MKBLEBaseSDKAdopter operationSetParamsErrorBlock:failedBlock];
                return;
            }
        }
        MKBLEBase_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

+ (void)cf_configWIFIClientPrivateKey:(NSData *)privateKey
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidData(privateKey)) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *privateKeyStrings = [MKBLEBaseSDKAdopter hexStringFromData:privateKey];
    NSInteger totalNum = (privateKeyStrings.length / 2) / packDataMaxLen;
    NSInteger packRemain = (privateKeyStrings.length / 2) % packDataMaxLen;
    if (packRemain > 0) {
        totalNum ++;
    }
    NSString *commandHeader = [NSString stringWithFormat:@"%@%@",@"ee014a",[MKBLEBaseSDKAdopter fetchHexValue:totalNum byteLen:1]];
    dispatch_queue_t queue = dispatch_queue_create("configWIFIPrivateKeyQueue", 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < totalNum; i ++) {
            NSString *index = [MKBLEBaseSDKAdopter fetchHexValue:i byteLen:1];
            NSInteger len = packDataMaxLen;
            if ((i == totalNum - 1) && (packRemain > 0)) {
                //最后一帧
                len = packRemain;
            }
            NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:len byteLen:1];
            NSString *subChar = [privateKeyStrings substringWithRange:NSMakeRange(i * 2 * packDataMaxLen, 2 * len)];
            NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@",commandHeader,index,lenString,subChar];
            BOOL success = [self sendDataToPeripheral:commandString
                                               taskID:mk_cf_taskConfigWIFIClientPrivateKeyOperation
                                            semaphore:semaphore];
            if (!success) {
                [MKBLEBaseSDKAdopter operationSetParamsErrorBlock:failedBlock];
                return;
            }
        }
        MKBLEBase_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

+ (void)cf_configWIFIDHCPStatus:(BOOL)isOn
                       sucBlock:(void (^)(void))sucBlock
                    failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed014b0101" : @"ed014b0100");
    [self configDataWithTaskID:mk_cf_taskConfigWIFIDHCPStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)cf_configWIFIIpAddress:(NSString *)ip
                          mask:(NSString *)mask
                       gateway:(NSString *)gateway
                           dns:(NSString *)dns
                      sucBlock:(void (^)(void))sucBlock
                   failedBlock:(void (^)(NSError *error))failedBlock {
    if (![MKCFSDKDataAdopter isIpAddress:ip] || ![MKCFSDKDataAdopter isIpAddress:mask]
        || ![MKCFSDKDataAdopter isIpAddress:gateway] || ![MKCFSDKDataAdopter isIpAddress:dns]) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *ipValue = [MKCFSDKDataAdopter ipAddressToHex:ip];
    NSString *maskValue = [MKCFSDKDataAdopter ipAddressToHex:mask];
    NSString *gatewayValue = [MKCFSDKDataAdopter ipAddressToHex:gateway];
    NSString *dnsValue = [MKCFSDKDataAdopter ipAddressToHex:dns];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@",@"ed014c10",ipValue,maskValue,gatewayValue,dnsValue];
    [self configDataWithTaskID:mk_cf_taskConfigWIFIIpInfoOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)cf_configNetworkType:(mk_cf_networkType)type
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:type byteLen:1];
    NSString *commandString = [@"ed014d01" stringByAppendingString:value];
    [self configDataWithTaskID:mk_cf_taskConfigNetworkTypeOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)cf_configEthernetDHCPStatus:(BOOL)isOn
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed014e0101" : @"ed014e0100");
    [self configDataWithTaskID:mk_cf_taskConfigEthernetDHCPStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)cf_configEthernetIpAddress:(NSString *)ip
                              mask:(NSString *)mask
                           gateway:(NSString *)gateway
                               dns:(NSString *)dns
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    if (![MKCFSDKDataAdopter isIpAddress:ip] || ![MKCFSDKDataAdopter isIpAddress:mask]
        || ![MKCFSDKDataAdopter isIpAddress:gateway] || ![MKCFSDKDataAdopter isIpAddress:dns]) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *ipValue = [MKCFSDKDataAdopter ipAddressToHex:ip];
    NSString *maskValue = [MKCFSDKDataAdopter ipAddressToHex:mask];
    NSString *gatewayValue = [MKCFSDKDataAdopter ipAddressToHex:gateway];
    NSString *dnsValue = [MKCFSDKDataAdopter ipAddressToHex:dns];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@",@"ed014f10",ipValue,maskValue,gatewayValue,dnsValue];
    [self configDataWithTaskID:mk_cf_taskConfigEthernetIpInfoOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

#pragma mark - Private method

+ (void)configDataWithTaskID:(mk_cf_taskOperationID)taskID
                        data:(NSString *)data
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:taskID characteristic:peripheral.cf_custom commandData:data successBlock:^(id  _Nonnull returnData) {
        BOOL success = [returnData[@"result"][@"success"] boolValue];
        if (!success) {
            [MKBLEBaseSDKAdopter operationSetParamsErrorBlock:failedBlock];
            return ;
        }
        if (sucBlock) {
            sucBlock();
        }
    } failureBlock:failedBlock];
}

+ (BOOL)sendDataToPeripheral:(NSString *)commandString
                      taskID:(mk_cf_taskOperationID)taskID
                   semaphore:(dispatch_semaphore_t)semaphore {
    __block BOOL success = NO;
    [self configDataWithTaskID:taskID data:commandString sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(semaphore);
    } failedBlock:^(NSError *error) {
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return success;
}


@end
