//
//  MKCMInterface+MKCMConfig.m
//  MKCommureApp_Example
//
//  Created by aa on 2023/1/29.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCMInterface+MKCMConfig.h"

#import "MKBLEBaseCentralManager.h"
#import "MKBLEBaseSDKDefines.h"
#import "MKBLEBaseSDKAdopter.h"

#import "MKCMCentralManager.h"
#import "MKCMOperationID.h"
#import "CBPeripheral+MKCMAdd.h"
#import "MKCMOperation.h"
#import "MKCMSDKDataAdopter.h"

static const NSInteger packDataMaxLen = 150;

#define centralManager [MKCMCentralManager shared]
#define peripheral ([MKCMCentralManager shared].peripheral)

@implementation MKCMInterface (MKCMConfig)

#pragma mark ********************自定义参数配置************************

#pragma mark *********************System Params************************
+ (void)cm_enterSTAModeWithSucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed010200";
    [self configDataWithTaskID:mk_cm_taskEnterSTAModeOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)cm_configNTPServerHost:(NSString *)host
                      sucBlock:(void (^)(void))sucBlock
                   failedBlock:(void (^)(NSError *error))failedBlock {
    if (host.length > 64) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *tempString = [MKCMSDKDataAdopter fetchAsciiCode:host];
    NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:host.length byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed0111",lenString,tempString];
    
    [self configDataWithTaskID:mk_cm_taskConfigNTPServerHostOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)cm_configTimeZone:(NSInteger)timeZone
                 sucBlock:(void (^)(void))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock {
    if (timeZone < -24 || timeZone > 28) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *zoneValue = [MKBLEBaseSDKAdopter hexStringFromSignedNumber:timeZone];
    NSString *commandString = [@"ed011201" stringByAppendingString:zoneValue];
    [self configDataWithTaskID:mk_cm_taskConfigTimeZoneOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

#pragma mark *********************MQTT Params************************

+ (void)cm_configServerHost:(NSString *)host
                   sucBlock:(void (^)(void))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(host) || host.length > 64) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *tempString = [MKCMSDKDataAdopter fetchAsciiCode:host];
    NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:host.length byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed0120",lenString,tempString];
    [self configDataWithTaskID:mk_cm_taskConfigServerHostOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)cm_configServerPort:(NSInteger)port
                   sucBlock:(void (^)(void))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock {
    if (port < 0 || port > 65535) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:port byteLen:2];
    NSString *commandString = [@"ed012102" stringByAppendingString:value];
    [self configDataWithTaskID:mk_cm_taskConfigServerPortOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)cm_configClientID:(NSString *)clientID
                 sucBlock:(void (^)(void))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(clientID) || clientID.length > 64) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *tempString = [MKCMSDKDataAdopter fetchAsciiCode:clientID];
    NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:clientID.length byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed0122",lenString,tempString];
    [self configDataWithTaskID:mk_cm_taskConfigClientIDOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)cm_configServerUserName:(NSString *)userName
                       sucBlock:(void (^)(void))sucBlock
                    failedBlock:(void (^)(NSError *error))failedBlock {
    if (userName.length > 256) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    if (!MKValidStr(userName)) {
        //空的
        NSString *commandString = @"ee0123010000";
        [self configDataWithTaskID:mk_cm_taskConfigServerUserNameOperation
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
    NSString *commandHeader = @"ee0123";
    dispatch_queue_t queue = dispatch_queue_create("configUserNameQueue", 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < totalNum; i ++) {
            NSString *first = ((i == 0) ? @"01" : @"00");
            NSString *reamin = [MKBLEBaseSDKAdopter fetchHexValue:(totalNum - 1 - i) byteLen:1];
            NSInteger len = packDataMaxLen;
            if ((i == totalNum - 1) && (packRemain > 0)) {
                //最后一帧
                len = packRemain;
            }
            NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:len byteLen:1];
            NSString *asciiChar = [MKCMSDKDataAdopter fetchAsciiCode:[userName substringWithRange:NSMakeRange(i * packDataMaxLen, len)]];
            NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@",commandHeader,first,reamin,lenString,asciiChar];
            BOOL success = [self sendDataToPeripheral:commandString
                                               taskID:mk_cm_taskConfigServerUserNameOperation
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

+ (void)cm_configServerPassword:(NSString *)password
                       sucBlock:(void (^)(void))sucBlock
                    failedBlock:(void (^)(NSError *error))failedBlock {
    if (password.length > 256) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    if (!MKValidStr(password)) {
        //空的
        NSString *commandString = @"ee0124010000";
        [self configDataWithTaskID:mk_cm_taskConfigServerPasswordOperation
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
    NSString *commandHeader = @"ee0124";
    dispatch_queue_t queue = dispatch_queue_create("configUserPasswordQueue", 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < totalNum; i ++) {
            NSString *first = ((i == 0) ? @"01" : @"00");
            NSString *reamin = [MKBLEBaseSDKAdopter fetchHexValue:(totalNum - 1 - i) byteLen:1];
            NSInteger len = packDataMaxLen;
            if ((i == totalNum - 1) && (packRemain > 0)) {
                //最后一帧
                len = packRemain;
            }
            NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:len byteLen:1];
            NSString *asciiChar = [MKCMSDKDataAdopter fetchAsciiCode:[password substringWithRange:NSMakeRange(i * packDataMaxLen, len)]];
            NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@",commandHeader,first,reamin,lenString,asciiChar];
            BOOL success = [self sendDataToPeripheral:commandString
                                               taskID:mk_cm_taskConfigServerPasswordOperation
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

+ (void)cm_configServerCleanSession:(BOOL)clean
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (clean ? @"ed01250101" : @"ed01250100");
    [self configDataWithTaskID:mk_cm_taskConfigServerCleanSessionOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)cm_configServerKeepAlive:(NSInteger)interval
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 10 || interval > 120) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:interval byteLen:1];
    NSString *commandString = [@"ed012601" stringByAppendingString:value];
    [self configDataWithTaskID:mk_cm_taskConfigServerKeepAliveOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)cm_configServerQos:(mk_cm_mqttServerQosMode)mode
                  sucBlock:(void (^)(void))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *qosString = [MKCMSDKDataAdopter fetchMqttServerQosMode:mode];
    NSString *commandString = [@"ed012701" stringByAppendingString:qosString];
    [self configDataWithTaskID:mk_cm_taskConfigServerQosOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)cm_configSubscibeTopic:(NSString *)subscibeTopic
                      sucBlock:(void (^)(void))sucBlock
                   failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(subscibeTopic) || subscibeTopic.length > 128) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *tempString = [MKCMSDKDataAdopter fetchAsciiCode:subscibeTopic];
    NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:subscibeTopic.length byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed0128",lenString,tempString];
    [self configDataWithTaskID:mk_cm_taskConfigSubscibeTopicOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)cm_configPublishTopic:(NSString *)publishTopic
                     sucBlock:(void (^)(void))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(publishTopic) || publishTopic.length > 128) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *tempString = [MKCMSDKDataAdopter fetchAsciiCode:publishTopic];
    NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:publishTopic.length byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed0129",lenString,tempString];
    [self configDataWithTaskID:mk_cm_taskConfigPublishTopicOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)cm_configConnectMode:(mk_cm_connectMode)mode
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *modeString = [MKCMSDKDataAdopter fetchConnectModeString:mode];
    NSString *commandString = [@"ed012f01" stringByAppendingString:modeString];
    [self configDataWithTaskID:mk_cm_taskConfigConnectModeOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)cm_configCAFile:(NSData *)caFile
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
                                               taskID:mk_cm_taskConfigCAFileOperation
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

+ (void)cm_configClientCert:(NSData *)cert
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
                                               taskID:mk_cm_taskConfigClientCertOperation
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

+ (void)cm_configClientPrivateKey:(NSData *)privateKey
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
                                               taskID:mk_cm_taskConfigClientPrivateKeyOperation
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

+ (void)cm_configWIFISecurity:(mk_cm_wifiSecurity)security
                     sucBlock:(void (^)(void))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *type = [MKCMSDKDataAdopter fetchWifiSecurity:security];
    NSString *commandString = [@"ed014001" stringByAppendingString:type];
    [self configDataWithTaskID:mk_cm_taskConfigWIFISecurityOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)cm_configWIFISSID:(NSString *)ssid
                 sucBlock:(void (^)(void))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(ssid) || ssid.length > 32) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *tempString = [MKCMSDKDataAdopter fetchAsciiCode:ssid];
    NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:ssid.length byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed0141",lenString,tempString];
    [self configDataWithTaskID:mk_cm_taskConfigWIFISSIDOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)cm_configWIFIPassword:(NSString *)password
                     sucBlock:(void (^)(void))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock {
    if (password.length > 64) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *tempString = [MKCMSDKDataAdopter fetchAsciiCode:password];
    NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:password.length byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed0142",lenString,tempString];
    
    [self configDataWithTaskID:mk_cm_taskConfigWIFIPasswordOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)cm_configWIFIEAPType:(mk_cm_eapType)eapType
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *type = [MKCMSDKDataAdopter fetchWifiEapType:eapType];
    NSString *commandString = [@"ed014301" stringByAppendingString:type];
    [self configDataWithTaskID:mk_cm_taskConfigWIFIEAPTypeOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)cm_configWIFIEAPUsername:(NSString *)username
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock {
    if (username.length > 32) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *tempString = [MKCMSDKDataAdopter fetchAsciiCode:username];
    NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:username.length byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed0144",lenString,tempString];
    
    [self configDataWithTaskID:mk_cm_taskConfigWIFIEAPUsernameOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)cm_configWIFIEAPPassword:(NSString *)password
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock {
    if (password.length > 64) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *tempString = [MKCMSDKDataAdopter fetchAsciiCode:password];
    NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:password.length byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed0145",lenString,tempString];
    
    [self configDataWithTaskID:mk_cm_taskConfigWIFIEAPPasswordOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)cm_configWIFIEAPDomainID:(NSString *)domainID
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock {
    if (domainID.length > 64) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *tempString = [MKCMSDKDataAdopter fetchAsciiCode:domainID];
    NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:domainID.length byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed0146",lenString,tempString];
    
    [self configDataWithTaskID:mk_cm_taskConfigWIFIEAPDomainIDOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)cm_configWIFIVerifyServerStatus:(BOOL)verify
                               sucBlock:(void (^)(void))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (verify ? @"ed01470101" : @"ed01470100");
    [self configDataWithTaskID:mk_cm_taskConfigWIFIVerifyServerStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)cm_configWIFICAFile:(NSData *)caFile
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
                                               taskID:mk_cm_taskConfigWIFICAFileOperation
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

+ (void)cm_configWIFIClientCert:(NSData *)cert
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
                                               taskID:mk_cm_taskConfigWIFIClientCertOperation
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

+ (void)cm_configWIFIClientPrivateKey:(NSData *)privateKey
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
                                               taskID:mk_cm_taskConfigWIFIClientPrivateKeyOperation
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

+ (void)cm_configDHCPStatus:(BOOL)isOn
                   sucBlock:(void (^)(void))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed014b0101" : @"ed014b0100");
    [self configDataWithTaskID:mk_cm_taskConfigDHCPStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)cm_configIpAddress:(NSString *)ip
                      mask:(NSString *)mask
                   gateway:(NSString *)gateway
                       dns:(NSString *)dns
                  sucBlock:(void (^)(void))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock {
    if (![MKCMSDKDataAdopter isIpAddress:ip] || ![MKCMSDKDataAdopter isIpAddress:mask]
        || ![MKCMSDKDataAdopter isIpAddress:gateway] || ![MKCMSDKDataAdopter isIpAddress:dns]) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *ipValue = [MKCMSDKDataAdopter ipAddressToHex:ip];
    NSString *maskValue = [MKCMSDKDataAdopter ipAddressToHex:mask];
    NSString *gatewayValue = [MKCMSDKDataAdopter ipAddressToHex:gateway];
    NSString *dnsValue = [MKCMSDKDataAdopter ipAddressToHex:dns];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@",@"ed014c10",ipValue,maskValue,gatewayValue,dnsValue];
    [self configDataWithTaskID:mk_cm_taskConfigIpInfoOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

#pragma mark *********************Filter Params************************

+ (void)cm_configRssiFilterValue:(NSInteger)rssi
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock {
    if (rssi < -127 || rssi > 0) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *rssiValue = [MKBLEBaseSDKAdopter hexStringFromSignedNumber:rssi];
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed016001",rssiValue];
    [self configDataWithTaskID:mk_cm_taskConfigRssiFilterValueOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)cm_configFilterRelationship:(mk_cm_filterRelationship)relationship
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:relationship byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed016101",value];
    [self configDataWithTaskID:mk_cm_taskConfigFilterRelationshipOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)cm_configFilterMACAddressList:(NSArray <NSString *>*)macList
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    if (macList.count > 10) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *macString = @"";
    if (MKValidArray(macList)) {
        for (NSString *mac in macList) {
            if ((mac.length % 2 != 0) || !MKValidStr(mac) || mac.length > 12 || ![MKBLEBaseSDKAdopter checkHexCharacter:mac]) {
                [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
                return;
            }
            NSString *tempLen = [MKBLEBaseSDKAdopter fetchHexValue:(mac.length / 2) byteLen:1];
            NSString *string = [tempLen stringByAppendingString:mac];
            macString = [macString stringByAppendingString:string];
        }
    }
    NSString *dataLen = [MKBLEBaseSDKAdopter fetchHexValue:(macString.length / 2) byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"ed0164%@%@",dataLen,macString];
    [self configDataWithTaskID:mk_cm_taskConfigFilterMACAddressListOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)cm_configFilterAdvNameList:(NSArray <NSString *>*)nameList
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    if (nameList.count > 10) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    if (!MKValidArray(nameList)) {
        //无列表
        NSString *commandString = @"ee0167010000";
        [self configDataWithTaskID:mk_cm_taskConfigFilterAdvNameListOperation
                              data:commandString
                          sucBlock:sucBlock
                       failedBlock:failedBlock];
        return;
    }
    NSString *nameString = @"";
    if (MKValidArray(nameList)) {
        for (NSString *name in nameList) {
            if (!MKValidStr(name) || name.length > 20 || ![MKBLEBaseSDKAdopter asciiString:name]) {
                [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
                return;
            }
            NSString *nameAscii = @"";
            for (NSInteger i = 0; i < name.length; i ++) {
                int asciiCode = [name characterAtIndex:i];
                nameAscii = [nameAscii stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
            }
            NSString *tempLen = [MKBLEBaseSDKAdopter fetchHexValue:(nameAscii.length / 2) byteLen:1];
            NSString *string = [tempLen stringByAppendingString:nameAscii];
            nameString = [nameString stringByAppendingString:string];
        }
    }
    NSInteger totalLen = nameString.length / 2;
    NSInteger totalNum = (totalLen / packDataMaxLen);
    if (totalLen % packDataMaxLen != 0) {
        totalNum ++;
    }
    NSMutableArray *commandList = [NSMutableArray array];
    for (NSInteger i = 0; i < totalNum; i ++) {
        NSString *tempString = @"";
        if (i == totalNum - 1) {
            //最后一帧
            tempString = [nameString substringFromIndex:(i * 2 * packDataMaxLen)];
        }else {
            tempString = [nameString substringWithRange:NSMakeRange(i * 2 * packDataMaxLen, 2 * packDataMaxLen)];
        }
        [commandList addObject:tempString];
    }
    NSString *totalNumberHex = [MKBLEBaseSDKAdopter fetchHexValue:totalNum byteLen:1];
    
    __block NSInteger commandIndex = 0;
    dispatch_queue_t dataQueue = dispatch_queue_create("filterNameListQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dataQueue);
    //当2s内没有接收到新的数据的时候，也认为是接受超时
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 0.05 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        if (commandIndex >= commandList.count) {
            //停止
            dispatch_cancel(timer);
            MKCMOperation *operation = [[MKCMOperation alloc] initOperationWithID:mk_cm_taskConfigFilterAdvNameListOperation commandBlock:^{
                
            } completeBlock:^(NSError * _Nullable error, id  _Nullable returnData) {
                BOOL success = [returnData[@"success"] boolValue];
                if (!success) {
                    [MKBLEBaseSDKAdopter operationSetParamsErrorBlock:failedBlock];
                    return ;
                }
                if (sucBlock) {
                    sucBlock();
                }
            }];
            [[MKCMCentralManager shared] addOperation:operation];
            return;
        }
        NSString *tempCommandString = commandList[commandIndex];
        NSString *indexHex = [MKBLEBaseSDKAdopter fetchHexValue:commandIndex byteLen:1];
        NSString *totalLenHex = [MKBLEBaseSDKAdopter fetchHexValue:(tempCommandString.length / 2) byteLen:1];
        NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@",@"ee0167",totalNumberHex,indexHex,totalLenHex,tempCommandString];
        [[MKBLEBaseCentralManager shared] sendDataToPeripheral:commandString characteristic:peripheral.cm_custom type:CBCharacteristicWriteWithResponse];
        commandIndex ++;
    });
    dispatch_resume(timer);
}

#pragma mark - Private method

+ (void)configDataWithTaskID:(mk_cm_taskOperationID)taskID
                        data:(NSString *)data
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:taskID characteristic:peripheral.cm_custom commandData:data successBlock:^(id  _Nonnull returnData) {
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
                      taskID:(mk_cm_taskOperationID)taskID
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
