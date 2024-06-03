//
//  MKCGMQTTInterface.m
//  CommureGateway_Example
//
//  Created by aa on 2023/1/29.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCGMQTTInterface.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKCGMQTTDataManager.h"

@implementation MKCGMQTTInterface

#pragma mark *********************Config************************

+ (void)cg_rebootDeviceWithMacAddress:(NSString *)macAddress
                                topic:(NSString *)topic
                             sucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1000),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
                @"reset":@(0),
        },
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskRebootDeviceOperation
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_configKeyResetType:(mk_cg_keyResetType)type
                   macAddress:(NSString *)macAddress
                        topic:(NSString *)topic
                     sucBlock:(void (^)(id returnData))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1001),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
                @"key_reset_type":@(type),
        },
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskKeyResetTypeOperation
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_configNetworkStatusReportInterval:(NSInteger)interval
                                  macAddress:(NSString *)macAddress
                                       topic:(NSString *)topic
                                    sucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (interval < 0 || (interval > 0 && interval < 30) || interval > 86400) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1003),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
                @"report_interval":@(interval),
        },
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskConfigNetworkStatusReportIntervalOperation
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_configReconnectTimeout:(NSInteger)timeout
                       macAddress:(NSString *)macAddress
                            topic:(NSString *)topic
                         sucBlock:(void (^)(id returnData))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (timeout < 0 || timeout > 1440) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1005),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
                @"timeout":@(timeout),
        },
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskConfigReconnectTimeoutOperation
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_configOTAWithFilePath:(NSString *)filePath
                      macAddress:(NSString *)macAddress
                           topic:(NSString *)topic
                        sucBlock:(void (^)(id returnData))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (!ValidStr(filePath) || filePath.length > 256 || ![filePath isAsciiString]) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1006),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
                @"firmware_url":filePath
        },
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskConfigOTAHostOperation
                                   timeout:30
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_configNTPServer:(BOOL)isOn
                      host:(NSString *)host
                macAddress:(NSString *)macAddress
                     topic:(NSString *)topic
                  sucBlock:(void (^)(id returnData))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (!host || ![host isKindOfClass:NSString.class] || host.length > 64) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1008),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
            @"switch_value":(isOn ? @(1) : @(0)),
            @"server":SafeStr(host),
        },
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskConfigNTPServerOperation
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_configDeviceTimeZone:(NSInteger)timeZone
                      timestamp:(NSTimeInterval)timestamp
                     macAddress:(NSString *)macAddress
                          topic:(NSString *)topic
                       sucBlock:(void (^)(id returnData))sucBlock
                    failedBlock:(void (^)(NSError *error))failedBlock {
    if (timeZone < -24 || timeZone > 28) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1009),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
                @"timestamp":@(timestamp),
                @"timezone":@(timeZone)
        },
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskConfigDeviceTimeZoneOperation
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_configCommunicationTimeout:(NSInteger)timeout
                           macAddress:(NSString *)macAddress
                                topic:(NSString *)topic
                             sucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (timeout < 0 || timeout > 60) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1048),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
                @"timeout":@(timeout),
        },
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskConfigCommunicationTimeoutOperation
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_configConnectBeaconTimeout:(NSInteger)timeout
                           macAddress:(NSString *)macAddress
                                topic:(NSString *)topic
                             sucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (timeout < 1 || timeout > 200) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1049),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
                @"timeout":@(timeout),
        },
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskConfigConnectBeaconTimeoutOperation
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_configIndicatorLightStatus:(id <cg_indicatorLightStatusProtocol>)protocol
                           macAddress:(NSString *)macAddress
                                topic:(NSString *)topic
                             sucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (![protocol conformsToProtocol:@protocol(cg_indicatorLightStatusProtocol)]) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1011),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
            @"ble_adv_led":(protocol.ble_advertising ? @(1) : @(0)),
            @"ble_connected_led":(protocol.ble_connected ? @(1) : @(0)),
            @"server_connecting_led":(protocol.server_connecting ? @(1) : @(0)),
            @"server_connected_led":(protocol.server_connected ? @(1) : @(0))
        },
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskConfigIndicatorLightStatusOperation
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_resetDeviceWithMacAddress:(NSString *)macAddress
                               topic:(NSString *)topic
                            sucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1013),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
                @"factory_reset":@(0),
        },
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskResetDeviceOperation
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_configBleAdvStatus:(BOOL)isOn
                      advTime:(NSInteger)advTime
                   macAddress:(NSString *)macAddress
                        topic:(NSString *)topic
                     sucBlock:(void (^)(id returnData))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (advTime < 1 || advTime > 65535) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1015),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
            @"adv_switch":(isOn ? @(1) : @(0)),
            @"adv_time":@(advTime)
        },
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskConfigBleAdvStatusOperation
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_configPowerSwitchStatus:(BOOL)isOn
                        macAddress:(NSString *)macAddress
                             topic:(NSString *)topic
                          sucBlock:(void (^)(id returnData))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1017),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
            @"switch_state":(isOn ? @(1) : @(0)),
        },
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskConfigPowerSwitchStatusOperation
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_modifyWifiInfos:(id <mk_cg_mqttModifyWifiProtocol>)protocol
                macAddress:(NSString *)macAddress
                     topic:(NSString *)topic
                  sucBlock:(void (^)(id returnData))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (![self isConfirmWifiProtocol:protocol]) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    NSDictionary *paramDic = @{
        @"security_type":@(protocol.security),
        @"ssid":SafeStr(protocol.ssid),
        @"passwd":SafeStr(protocol.wifiPassword),
        @"eap_type":@(protocol.eapType),
        @"eap_id":SafeStr(protocol.domainID),
        @"eap_username":SafeStr(protocol.eapUserName),
        @"eap_passwd":SafeStr(protocol.eapPassword),
        @"eap_verify_server":(protocol.verifyServer ? @(1) : @(0))
    };
    
    NSDictionary *data = @{
        @"msg_id":@(1020),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":paramDic
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskModifyWifiInfosOperation
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_modifyWifiCerts:(id <mk_cg_mqttModifyWifiEapCertProtocol>)protocol
                macAddress:(NSString *)macAddress
                     topic:(NSString *)topic
                  sucBlock:(void (^)(id returnData))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (![self isConfirmEAPCertProtocol:protocol]) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1021),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
                @"ca_url":SafeStr(protocol.caFilePath),
                @"client_cert_url":SafeStr(protocol.clientCertPath),
                @"client_key_url":SafeStr(protocol.clientKeyPath),
        },
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskModifyWifiCertsOperation
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_modifyWifiNetworkInfos:(id <mk_cg_mqttModifyNetworkProtocol>)protocol
                       macAddress:(NSString *)macAddress
                            topic:(NSString *)topic
                         sucBlock:(void (^)(id returnData))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (![self isConfirmNetworkProtocol:protocol]) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1023),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
            @"dhcp_en":(protocol.dhcp ? @(1) : @(0)),
            @"ip":SafeStr(protocol.ip),
            @"netmask":SafeStr(protocol.mask),
            @"gw":SafeStr(protocol.gateway),
            @"dns":SafeStr(protocol.dns),
        },
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskModifyWifiNetworkInfoOperation
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_modifyMqttInfos:(id <mk_cg_modifyMqttServerProtocol>)protocol
                macAddress:(NSString *)macAddress
                     topic:(NSString *)topic
                  sucBlock:(void (^)(id returnData))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (![self isConfirmMqttServerProtocol:protocol]) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1030),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
            @"security_type":@(protocol.connectMode),
            @"host":SafeStr(protocol.host),
            @"port":@([protocol.port integerValue]),
            @"client_id":SafeStr(protocol.clientID),
            @"username":SafeStr(protocol.userName),
            @"passwd":SafeStr(protocol.password),
            @"sub_topic":SafeStr(protocol.subscribeTopic),
            @"pub_topic":SafeStr(protocol.publishTopic),
            @"qos":@(protocol.qos),
            @"clean_session":(protocol.cleanSession ? @(1) : @(0)),
            @"keepalive":@([protocol.keepAlive integerValue]),
        },
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskModifyMqttInfoOperation
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_modifyMqttCerts:(id <mk_cg_modifyMqttServerCertsProtocol>)protocol
                macAddress:(NSString *)macAddress
                     topic:(NSString *)topic
                  sucBlock:(void (^)(id returnData))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (![self isConfirmMqttServerCertsProtocol:protocol]) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1031),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
                @"ca_url":SafeStr(protocol.caFilePath),
                @"client_cert_url":SafeStr(protocol.clientCertPath),
                @"client_key_url":SafeStr(protocol.clientKeyPath),
        },
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskModifyMqttCertsOperation
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_configScanSwitchStatus:(BOOL)isOn
                       macAddress:(NSString *)macAddress
                            topic:(NSString *)topic
                         sucBlock:(void (^)(id returnData))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1040),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
                @"scan_switch":(isOn ? @(1) : @(0)),
        },
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskConfigScanSwitchStatusOperation
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_configFilterRelationship:(mk_cg_filterRelationship)relationship
                         macAddress:(NSString *)macAddress
                              topic:(NSString *)topic
                           sucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1041),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
                @"relation":@(relationship),
        },
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskConfigFilterRelationshipsOperation
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_configFilterByRSSI:(NSInteger)rssi
                   macAddress:(NSString *)macAddress
                        topic:(NSString *)topic
                     sucBlock:(void (^)(id returnData))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (rssi > 0 || rssi < -127) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1042),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
                @"rssi":@(rssi),
        },
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskConfigFilterByRSSIOperation
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_configFilterByMacAddress:(nonnull NSArray <NSString *>*)macList
                       preciseMatch:(BOOL)preciseMatch
                      reverseFilter:(BOOL)reverseFilter
                         macAddress:(NSString *)macAddress
                              topic:(NSString *)topic
                           sucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (!macList || ![macList isKindOfClass:NSArray.class] || macList.count > 10) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    for (NSInteger i = 0; i < macList.count; i ++) {
        NSString *tempString = macList[i];
        if (tempString.length < 2 || tempString.length > 12 || tempString.length % 2 != 0 || ![tempString regularExpressions:isHexadecimal]) {
            [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
            return;
        }
    }
    NSDictionary *data = @{
        @"msg_id":@(1043),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
            @"precise":(preciseMatch ? @(1) : @(0)),
            @"reverse":(reverseFilter ? @(1) : @(0)),
            @"mac":macList
        },
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskConfigFilterByMacAddressOperation
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_configFilterByTag:(BOOL)preciseMatch
               reverseFilter:(BOOL)reverseFilter
                   tagIDList:(NSArray <NSString *>*)tagIDList
                  macAddress:(NSString *)macAddress
                       topic:(NSString *)topic
                    sucBlock:(void (^)(id returnData))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (!tagIDList || ![tagIDList isKindOfClass:NSArray.class] || tagIDList.count > 10) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    for (NSInteger i = 0; i < tagIDList.count; i ++) {
        NSString *tempString = tagIDList[i];
        if (tempString.length < 2 || tempString.length > 6 || tempString.length % 2 != 0 || ![tempString regularExpressions:isHexadecimal]) {
            [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
            return;
        }
    }
    NSDictionary *data = @{
        @"msg_id":@(1044),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
            @"precise":(preciseMatch ? @(1) : @(0)),
            @"reverse":(reverseFilter ? @(1) : @(0)),
            @"tagid":tagIDList,
        },
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskConfigFilterByTagOperation
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_configDataReportTimeout:(NSInteger)timeout
                        macAddress:(NSString *)macAddress
                             topic:(NSString *)topic
                          sucBlock:(void (^)(id returnData))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (timeout < 100 || timeout > 3000) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1045),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
            @"timeout":@(timeout),
        }
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskConfigDataReportTimeoutOperation
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_configBXBDecryptTimeOffset:(NSInteger)timeOffset
                           macAddress:(NSString *)macAddress
                                topic:(NSString *)topic
                             sucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (timeOffset < 0 || timeOffset > 600) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    
    NSDictionary *data = @{
        @"msg_id":@(1046),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
            @"bxp_b_decrypt_time_offset":@(timeOffset)
        },
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskConfigBXBDecryptTimeOffsetOperation
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_configBXBDecryptKey:(NSString *)key
                    macAddress:(NSString *)macAddress
                         topic:(NSString *)topic
                      sucBlock:(void (^)(id returnData))sucBlock
                   failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (!ValidStr(key) || key.length != 52 || ![key regularExpressions:isHexadecimal]) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    
    NSDictionary *data = @{
        @"msg_id":@(1047),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
            @"bxp_b_decrypt_key":key
        },
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskConfigBXBDecryptKeyOperation
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_connectBXPButtonWithPassword:(NSString *)password
                                 bleMac:(NSString *)bleMacAddress
                             macAddress:(NSString *)macAddress
                                  topic:(NSString *)topic
                               sucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (!ValidStr(bleMacAddress) || bleMacAddress.length != 12 || ![bleMacAddress regularExpressions:isHexadecimal]) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    if (password.length > 16) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1100),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
            @"mac":bleMacAddress,
            @"passwd":SafeStr(password),
        }
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskConnectBXPButtonWithMacOperation
                                   timeout:50
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_configDeviceLedReminderWithBleMac:(NSString *)bleMacAddress
                                       color:(mk_cg_reminderLedColor)color
                                    interval:(NSInteger)interval
                                    duration:(NSInteger)duration
                                  macAddress:(NSString *)macAddress
                                       topic:(NSString *)topic
                                    sucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (!ValidStr(bleMacAddress) || bleMacAddress.length != 12 || ![bleMacAddress regularExpressions:isHexadecimal]) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    if (interval < 0 || interval > 10000 || duration < 1 || duration > 255) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    NSString *ledColor = @"red";
    if (color == mk_cg_reminderLedColor_blue) {
        ledColor = @"blue";
    }else if (color == mk_cg_reminderLedColor_green) {
        ledColor = @"green";
    }
    NSDictionary *data = @{
        @"msg_id":@(1114),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
            @"mac":bleMacAddress,
            @"led_color":ledColor,
            @"flash_interval":@(interval),
            @"flash_time":@(duration)
        }
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskConfigDeviceLedReminderOperation
                                   timeout:50
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_configDeviceBuzzerReminderWithBleMac:(NSString *)bleMacAddress
                                       interval:(NSInteger)interval
                                       duration:(NSInteger)duration
                                     macAddress:(NSString *)macAddress
                                          topic:(NSString *)topic
                                       sucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (!ValidStr(bleMacAddress) || bleMacAddress.length != 12 || ![bleMacAddress regularExpressions:isHexadecimal]) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    if (interval < 0 || interval > 10000 || duration < 1 || duration > 255) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    
    NSDictionary *data = @{
        @"msg_id":@(1116),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
            @"mac":bleMacAddress,
            @"ring_interval":@(interval),
            @"ring_time":@(duration)
        }
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskConfigDeviceBuzzerReminderOperation
                                   timeout:50
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_powerOffConnectedDeviceWithBleMac:(NSString *)bleMacAddress
                                  macAddress:(NSString *)macAddress
                                       topic:(NSString *)topic
                                    sucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (!ValidStr(bleMacAddress) || bleMacAddress.length != 12 || ![bleMacAddress regularExpressions:isHexadecimal]) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    
    NSDictionary *data = @{
        @"msg_id":@(1122),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
            @"mac":bleMacAddress,
        }
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskPowerOffConnectedDeviceOperation
                                   timeout:50
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_resetConnectedDeviceWithBleMac:(NSString *)bleMacAddress
                               macAddress:(NSString *)macAddress
                                    topic:(NSString *)topic
                                 sucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (!ValidStr(bleMacAddress) || bleMacAddress.length != 12 || ![bleMacAddress regularExpressions:isHexadecimal]) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    
    NSDictionary *data = @{
        @"msg_id":@(1124),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
            @"mac":bleMacAddress,
        }
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskResetConnectedDeviceOperation
                                   timeout:50
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_configDeviceTimestampWithBleMac:(NSString *)bleMacAddress
                                 timestamp:(long long)timestamp
                                macAddress:(NSString *)macAddress
                                     topic:(NSString *)topic
                                  sucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (!ValidStr(bleMacAddress) || bleMacAddress.length != 12 || ![bleMacAddress regularExpressions:isHexadecimal]) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    
    NSDictionary *data = @{
        @"msg_id":@(1118),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
            @"mac":bleMacAddress,
            @"timestamp":@(timestamp),
        }
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskConfigDeviceTimestampOperation
                                   timeout:50
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_configTagID:(NSString *)tagID
                bleMac:(NSString *)bleMacAddress
            macAddress:(NSString *)macAddress
                 topic:(NSString *)topic
              sucBlock:(void (^)(id returnData))sucBlock
           failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (!ValidStr(bleMacAddress) || bleMacAddress.length != 12 || ![bleMacAddress regularExpressions:isHexadecimal]) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    if (!ValidStr(tagID) || tagID.length != 6 || ![tagID regularExpressions:isHexadecimal]) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1138),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
            @"mac":bleMacAddress,
            @"tag_id":tagID,
        }
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskConfigTagIDOperation
                                   timeout:50
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_configSosTriggerType:(mk_cg_sosTriggerType)triggerType
                         bleMac:(NSString *)bleMacAddress
                     macAddress:(NSString *)macAddress
                          topic:(NSString *)topic
                       sucBlock:(void (^)(id returnData))sucBlock
                    failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (!ValidStr(bleMacAddress) || bleMacAddress.length != 12 || ![bleMacAddress regularExpressions:isHexadecimal]) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1142),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
            @"mac":bleMacAddress,
            @"mode":@(triggerType + 1),
        }
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskConfigSosTriggerTypeOperation
                                   timeout:50
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_configSelfTestTriggeredByButton:(NSInteger)time
                                    bleMac:(NSString *)bleMacAddress
                                macAddress:(NSString *)macAddress
                                     topic:(NSString *)topic
                                  sucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (!ValidStr(bleMacAddress) || bleMacAddress.length != 12 || ![bleMacAddress regularExpressions:isHexadecimal]) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    if (time < 1 || time > 255) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1146),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
            @"mac":bleMacAddress,
            @"time":@(time),
        }
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskConfigSelfTestTriggeredByButtonOperation
                                   timeout:50
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_batchDfuBeacon:(NSString *)firmwareUrl
              dataFileUrl:(NSString *)dataUrl
               beaconList:(NSArray <NSDictionary *>*)beaconList
               macAddress:(NSString *)macAddress
                    topic:(NSString *)topic
                 sucBlock:(void (^)(id returnData))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (!firmwareUrl || firmwareUrl.length > 256 || !dataUrl || dataUrl.length > 256) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    if (!ValidArray(beaconList) || beaconList.count > 20) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    NSMutableArray *devList = [NSMutableArray array];
    for (NSInteger i = 0; i < beaconList.count; i ++) {
        NSDictionary *dic = beaconList[i];
        NSString *macAddress = SafeStr(dic[@"macAddress"]);
        NSString *password = SafeStr(dic[@"password"]);
        if (macAddress.length != 12 || ![macAddress regularExpressions:isHexadecimal]) {
            [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
            return;
        }
        if (password.length > 16) {
            [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
            return;
        }
        NSDictionary *dataDic = @{
            @"mac":macAddress,
            @"passwd":password,
        };
        [devList addObject:dataDic];
    }
    NSDictionary *data = @{
        @"msg_id":@(1200),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
            @"firmware_url":firmwareUrl,
            @"init_data_url":dataUrl,
            @"ble_dev":devList,
        }
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskBatchDfuBeaconWithMacOperation
                                   timeout:50
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_batchUpdateKey:(NSString *)key
               beaconList:(NSArray <NSDictionary *>*)beaconList
               macAddress:(NSString *)macAddress
                    topic:(NSString *)topic
                 sucBlock:(void (^)(id returnData))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (!ValidStr(key) || key.length != 52 || ![key regularExpressions:isHexadecimal]) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    if (!ValidArray(beaconList) || beaconList.count > 20) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    NSMutableArray *devList = [NSMutableArray array];
    for (NSInteger i = 0; i < beaconList.count; i ++) {
        NSDictionary *dic = beaconList[i];
        NSString *macAddress = SafeStr(dic[@"macAddress"]);
        NSString *password = SafeStr(dic[@"password"]);
        if (macAddress.length != 12 || ![macAddress regularExpressions:isHexadecimal]) {
            [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
            return;
        }
        if (password.length > 16) {
            [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
            return;
        }
        NSDictionary *dataDic = @{
            @"mac":macAddress,
            @"passwd":password,
        };
        [devList addObject:dataDic];
    }
    NSDictionary *data = @{
        @"msg_id":@(1205),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
            @"key":key,
            @"ble_dev":devList,
        }
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskBatchUpdateKeyWithMacOperation
                                   timeout:50
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_startBXPButtonDfuWithFirmwareUrl:(NSString *)firmwareUrl
                                    dataUrl:(NSString *)dataUrl
                                     bleMac:(NSString *)bleMacAddress
                                 macAddress:(NSString *)macAddress
                                      topic:(NSString *)topic
                                   sucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (!ValidStr(bleMacAddress) || bleMacAddress.length != 12 || ![bleMacAddress regularExpressions:isHexadecimal]) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    if (!firmwareUrl || firmwareUrl.length > 256 || !dataUrl || dataUrl.length > 256) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1202),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
            @"mac":bleMacAddress,
            @"firmware_url":SafeStr(firmwareUrl),
            @"init_data_url":SafeStr(dataUrl),
        }
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskStartBXPButtonDfuWithMacOperation
                                   timeout:50
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_connectNormalBleDeviceWithBleMac:(NSString *)bleMacAddress
                                 macAddress:(NSString *)macAddress
                                      topic:(NSString *)topic
                                   sucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (!ValidStr(bleMacAddress) || bleMacAddress.length != 12 || ![bleMacAddress regularExpressions:isHexadecimal]) {
        [self operationFailedBlockWithMsg:@"Params error" failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1300),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
            @"mac":bleMacAddress,
        }
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskConnectNormalBleDeviceWithMacOperation
                                   timeout:50
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

#pragma mark *********************Read************************
+ (void)cg_readKeyResetTypeWithMacAddress:(NSString *)macAddress
                                    topic:(NSString *)topic
                                 sucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(2001),
        @"device_info":@{
                @"mac":macAddress
        },
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskReadKeyResetTypeOperation
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_readDeviceInfoWithMacAddress:(NSString *)macAddress
                                  topic:(NSString *)topic
                               sucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(2002),
        @"device_info":@{
                @"mac":macAddress
        },
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskReadDeviceInfoOperation
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_readNetworkStatusReportIntervalWithMacAddress:(NSString *)macAddress
                                                   topic:(NSString *)topic
                                                sucBlock:(void (^)(id returnData))sucBlock
                                             failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(2003),
        @"device_info":@{
                @"mac":macAddress
        },
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskReadNetworkStatusReportIntervalOperation
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_readNetworkReconnectTimeoutWithMacAddress:(NSString *)macAddress
                                               topic:(NSString *)topic
                                            sucBlock:(void (^)(id returnData))sucBlock
                                         failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(2005),
        @"device_info":@{
                @"mac":macAddress
        },
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskReadNetworkReconnectTimeoutOperation
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_readNTPServerWithMacAddress:(NSString *)macAddress
                                 topic:(NSString *)topic
                              sucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(2008),
        @"device_info":@{
                @"mac":macAddress
        },
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskReadNTPServerOperation
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_readDeviceUTCTimeWithMacAddress:(NSString *)macAddress
                                     topic:(NSString *)topic
                                  sucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(2009),
        @"device_info":@{
                @"mac":macAddress
        },
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskReadDeviceUTCTimeOperation
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_readCommunicateTimeoutWithMacAddress:(NSString *)macAddress
                                          topic:(NSString *)topic
                                       sucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(2048),
        @"device_info":@{
                @"mac":macAddress
        },
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskReadCommunicateTimeoutOperation
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_readConnectBeaconTimeoutWithMacAddress:(NSString *)macAddress
                                            topic:(NSString *)topic
                                         sucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(2049),
        @"device_info":@{
                @"mac":macAddress
        },
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskReadConnectBeaconTimeoutOperation
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_readIndicatorLightStatusWithMacAddress:(NSString *)macAddress
                                            topic:(NSString *)topic
                                         sucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(2011),
        @"device_info":@{
                @"mac":macAddress
        },
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskReadIndicatorLightStatusOperation
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_readOtaStatusWithMacAddress:(NSString *)macAddress
                                 topic:(NSString *)topic
                              sucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(2012),
        @"device_info":@{
                @"mac":macAddress
        },
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskReadOtaStatusOperation
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_readBleAdvStatusWithMacAddress:(NSString *)macAddress
                                    topic:(NSString *)topic
                                 sucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(2016),
        @"device_info":@{
                @"mac":macAddress
        },
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskReadBleAdvStatusOperation
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_readPowerSwitchStatusWithMacAddress:(NSString *)macAddress
                                         topic:(NSString *)topic
                                      sucBlock:(void (^)(id returnData))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(2017),
        @"device_info":@{
                @"mac":macAddress
        },
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskReadPowerSwitchStatusOperation
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_readWifiInfosWithMacAddress:(NSString *)macAddress
                                 topic:(NSString *)topic
                              sucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(2020),
        @"device_info":@{
                @"mac":macAddress
        },
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskReadWifiInfosOperation
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_readWifiNetworkInfosWithMacAddress:(NSString *)macAddress
                                        topic:(NSString *)topic
                                     sucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(2023),
        @"device_info":@{
                @"mac":macAddress
        },
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskReadWifiNetworkInfosOperation
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_readNetworkTypeWithMacAddress:(NSString *)macAddress
                                   topic:(NSString *)topic
                                sucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(2024),
        @"device_info":@{
                @"mac":macAddress
        },
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskReadNetworkTypeOperation
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_readMQTTParamsWithMacAddress:(NSString *)macAddress
                                  topic:(NSString *)topic
                               sucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(2030),
        @"device_info":@{
                @"mac":macAddress
        },
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskReadMQTTParamsOperation
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_readScanSwitchStatusWithMacAddress:(NSString *)macAddress
                                        topic:(NSString *)topic
                                     sucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(2040),
        @"device_info":@{
                @"mac":macAddress
        },
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskReadScanSwitchStatusOperation
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_readFilterRelationshipWithMacAddress:(NSString *)macAddress
                                          topic:(NSString *)topic
                                       sucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(2041),
        @"device_info":@{
                @"mac":macAddress
        },
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskReadFilterRelationshipsOperation
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_readFilterByRSSIWithMacAddress:(NSString *)macAddress
                                    topic:(NSString *)topic
                                 sucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(2042),
        @"device_info":@{
                @"mac":macAddress
        },
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskReadFilterByRSSIOperation
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_readFilterByMacWithMacAddress:(NSString *)macAddress
                                   topic:(NSString *)topic
                                sucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(2043),
        @"device_info":@{
                @"mac":macAddress
        },
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskReadFilterByMacOperation
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_readFilterBXPTagWithMacAddress:(NSString *)macAddress
                                    topic:(NSString *)topic
                                 sucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(2044),
        @"device_info":@{
                @"mac":macAddress
        },
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskReadFilterBXPTagOperation
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_readDataReportTimeoutWithMacAddress:(NSString *)macAddress
                                         topic:(NSString *)topic
                                      sucBlock:(void (^)(id returnData))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(2045),
        @"device_info":@{
                @"mac":macAddress
        },
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskReadDataReportTimeoutOperation
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_readBXBDecryptTimeOffsetWithMacAddress:(NSString *)macAddress
                                            topic:(NSString *)topic
                                         sucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(2046),
        @"device_info":@{
                @"mac":macAddress
        },
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskReadBXBDecryptTimeOffsetOperation
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_readBXBDecryptKeyWithMacAddress:(NSString *)macAddress
                                     topic:(NSString *)topic
                                  sucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(2047),
        @"device_info":@{
                @"mac":macAddress
        },
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskReadBXBDecryptKeyOperation
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_readBXPButtonConnectedDeviceInfoWithBleMacAddress:(NSString *)bleMacAddress
                                                  macAddress:(NSString *)macAddress
                                                       topic:(NSString *)topic
                                                    sucBlock:(void (^)(id returnData))sucBlock
                                                 failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (!ValidStr(bleMacAddress) || bleMacAddress.length != 12 || ![bleMacAddress regularExpressions:isHexadecimal]) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1110),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
            @"mac":bleMacAddress,
        }
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskReadBXPButtonConnectedDeviceInfoOperation
                                   timeout:50
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_disconnectBleDeviceWithBleMac:(NSString *)bleMacAddress
                              macAddress:(NSString *)macAddress
                                   topic:(NSString *)topic
                                sucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (!ValidStr(bleMacAddress) || bleMacAddress.length != 12 || ![bleMacAddress regularExpressions:isHexadecimal]) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1103),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
            @"mac":bleMacAddress,
        }
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskDisconnectBleDeviceOperation
                                   timeout:50
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_dismissBXPButtonAlarmStatusWithBleMacAddress:(NSString *)bleMacAddress
                                             macAddress:(NSString *)macAddress
                                                  topic:(NSString *)topic
                                               sucBlock:(void (^)(id returnData))sucBlock
                                            failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (!ValidStr(bleMacAddress) || bleMacAddress.length != 12 || ![bleMacAddress regularExpressions:isHexadecimal]) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1154),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
            @"mac":bleMacAddress,
        }
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskDismissAlarmStatusOperation
                                   timeout:50
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_readGatewayBleConnectStatusWithMacAddress:(NSString *)macAddress
                                               topic:(NSString *)topic
                                            sucBlock:(void (^)(id returnData))sucBlock
                                         failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(2102),
        @"device_info":@{
                @"mac":macAddress
        },
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskReadGatewayBleConnectStatusOperation
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_readDeviceBatteryVoltageWithBleMacAddress:(NSString *)bleMacAddress
                                          macAddress:(NSString *)macAddress
                                               topic:(NSString *)topic
                                            sucBlock:(void (^)(id returnData))sucBlock
                                         failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (!ValidStr(bleMacAddress) || bleMacAddress.length != 12 || ![bleMacAddress regularExpressions:isHexadecimal]) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1112),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
            @"mac":bleMacAddress,
        }
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskReadDeviceBatteryVoltageOperation
                                   timeout:50
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_readTagIDWithBleMacAddress:(NSString *)bleMacAddress
                           macAddress:(NSString *)macAddress
                                topic:(NSString *)topic
                             sucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (!ValidStr(bleMacAddress) || bleMacAddress.length != 12 || ![bleMacAddress regularExpressions:isHexadecimal]) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1136),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
            @"mac":bleMacAddress,
        }
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskReadTagIDOperation
                                   timeout:50
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_readSosTriggerTypeWithBleMacAddress:(NSString *)bleMacAddress
                                    macAddress:(NSString *)macAddress
                                         topic:(NSString *)topic
                                      sucBlock:(void (^)(id returnData))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (!ValidStr(bleMacAddress) || bleMacAddress.length != 12 || ![bleMacAddress regularExpressions:isHexadecimal]) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1140),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
            @"mac":bleMacAddress,
        }
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskReadSosTriggerTypeOperation
                                   timeout:50
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_readSelfTestTriggeredByButtonWithBleMacAddress:(NSString *)bleMacAddress
                                               macAddress:(NSString *)macAddress
                                                    topic:(NSString *)topic
                                                 sucBlock:(void (^)(id returnData))sucBlock
                                              failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (!ValidStr(bleMacAddress) || bleMacAddress.length != 12 || ![bleMacAddress regularExpressions:isHexadecimal]) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1144),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
            @"mac":bleMacAddress,
        }
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskReadSelfTestTriggeredByButtonOperation
                                   timeout:50
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_readAlarmStatusWithBleMacAddress:(NSString *)bleMacAddress
                                 macAddress:(NSString *)macAddress
                                      topic:(NSString *)topic
                                   sucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (!ValidStr(bleMacAddress) || bleMacAddress.length != 12 || ![bleMacAddress regularExpressions:isHexadecimal]) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1152),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
            @"mac":bleMacAddress,
        }
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskReadAlarmStatusOperation
                                   timeout:50
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_readBatterySelfTestWithBleMacAddress:(NSString *)bleMacAddress
                                     macAddress:(NSString *)macAddress
                                          topic:(NSString *)topic
                                       sucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (!ValidStr(bleMacAddress) || bleMacAddress.length != 12 || ![bleMacAddress regularExpressions:isHexadecimal]) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1148),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
            @"mac":bleMacAddress,
        }
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskReadBatterySelfTestOperation
                                   timeout:50
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_configBatterySelfTestWithLedState:(BOOL)isOn
                            voltageThreshold:(NSInteger)voltage
                               bleMacAddress:(NSString *)bleMacAddress
                                  macAddress:(NSString *)macAddress
                                       topic:(NSString *)topic
                                    sucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (!ValidStr(bleMacAddress) || bleMacAddress.length != 12 || ![bleMacAddress regularExpressions:isHexadecimal]) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (voltage < 2000 || voltage > 4200) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1150),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
            @"mac":bleMacAddress,
            @"batt_warn_threshold":@(voltage),
            @"led_warn_switch":(isOn ? @(1) : @(0))
        }
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskConfigBatterySelfTestOperation
                                   timeout:50
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_readBatterySelfTestLedParamsWithMode:(NSInteger)mode
                                  bleMacAddress:(NSString *)bleMacAddress
                                     macAddress:(NSString *)macAddress
                                          topic:(NSString *)topic
                                       sucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (!ValidStr(bleMacAddress) || bleMacAddress.length != 12 || ![bleMacAddress regularExpressions:isHexadecimal]) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1168),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
            @"mac":bleMacAddress,
            @"batt_warn_mode":@(mode),
        }
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskReadBatterySelfTestLedParamsOperation
                                   timeout:50
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_configBatterySelfTestLedParams:(NSInteger)mode
                                 ledColor:(mk_cg_reminderLedColor)ledColor
                                 interval:(NSInteger)interval
                                 duration:(NSInteger)duration
                            bleMacAddress:(NSString *)bleMacAddress
                               macAddress:(NSString *)macAddress
                                    topic:(NSString *)topic
                                 sucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (!ValidStr(bleMacAddress) || bleMacAddress.length != 12 || ![bleMacAddress regularExpressions:isHexadecimal]) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (interval < 0 || interval > 100 || duration < 0 || duration > 255) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSString *color = @"red";
    if (ledColor == mk_cg_reminderLedColor_blue) {
        color = @"blue";
    }else if (ledColor == mk_cg_reminderLedColor_green) {
        color = @"green";
    }
    NSDictionary *data = @{
        @"msg_id":@(1170),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
            @"mac":bleMacAddress,
            @"batt_warn_mode":@(mode),
            @"led_color":color,
            @"led_off_time":@(interval * 100),
            @"led_flash_time":@(duration)
        }
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskConfigBatterySelfTestLedParamsOperation
                                   timeout:50
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_readAccelerometerParamsWithBleMacAddress:(NSString *)bleMacAddress
                                         macAddress:(NSString *)macAddress
                                              topic:(NSString *)topic
                                           sucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (!ValidStr(bleMacAddress) || bleMacAddress.length != 12 || ![bleMacAddress regularExpressions:isHexadecimal]) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1156),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
            @"mac":bleMacAddress,
        }
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskReadAccelerometerParamsOperation
                                   timeout:50
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_configAccelerometerParamsWithBleMacAddress:(NSString *)bleMacAddress
                                           sampleRate:(mk_cg_threeAxisSampleRate)sampleRate
                                            fullScale:(mk_cg_threeAxisDataFullScale)fullScale
                                          sensitivity:(NSInteger)sensitivity
                                           macAddress:(NSString *)macAddress
                                                topic:(NSString *)topic
                                             sucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (!ValidStr(bleMacAddress) || bleMacAddress.length != 12 || ![bleMacAddress regularExpressions:isHexadecimal]) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (sensitivity < 0 || sensitivity > 255) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    
    NSDictionary *data = @{
        @"msg_id":@(1158),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
            @"mac":bleMacAddress,
            @"sampling_rate":@(sampleRate),
            @"full_scale":@(fullScale),
            @"sensitivity":@(sensitivity),
        }
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskConfigAccelerometerParamsOperation
                                   timeout:50
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_readSleepModeParametersWithBleMacAddress:(NSString *)bleMacAddress
                                         macAddress:(NSString *)macAddress
                                              topic:(NSString *)topic
                                           sucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (!ValidStr(bleMacAddress) || bleMacAddress.length != 12 || ![bleMacAddress regularExpressions:isHexadecimal]) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1160),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
            @"mac":bleMacAddress,
        }
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskReadSleepModeParametersOperation
                                   timeout:50
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_configSleepModeParametersWithBleMacAddress:(NSString *)bleMacAddress
                                                 time:(NSInteger)time
                                           macAddress:(NSString *)macAddress
                                                topic:(NSString *)topic
                                             sucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (!ValidStr(bleMacAddress) || bleMacAddress.length != 12 || ![bleMacAddress regularExpressions:isHexadecimal]) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (time < 0 || time > 65535) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    
    NSDictionary *data = @{
        @"msg_id":@(1162),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
            @"mac":bleMacAddress,
            @"time":@(time),
        }
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskConfigSleepModeParametersOperation
                                   timeout:50
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_readAdvParamsWithType:(mk_cg_advParamsType)type
                   bleMacAddress:(NSString *)bleMacAddress
                      macAddress:(NSString *)macAddress
                           topic:(NSString *)topic
                        sucBlock:(void (^)(id returnData))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (!ValidStr(bleMacAddress) || bleMacAddress.length != 12 || ![bleMacAddress regularExpressions:isHexadecimal]) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1132),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
            @"mac":bleMacAddress,
            @"adv_mode":@(type),
        }
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskReadAdvParamsOperation
                                   timeout:50
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_configAdvParamsWithType:(mk_cg_advParamsType)type
                     bleMacAddress:(NSString *)bleMacAddress
                          interval:(NSInteger)interval
                          duration:(NSInteger)duration
                           txPower:(mk_cg_txPower)txPower
                        macAddress:(NSString *)macAddress
                             topic:(NSString *)topic
                          sucBlock:(void (^)(id returnData))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (!ValidStr(bleMacAddress) || bleMacAddress.length != 12 || ![bleMacAddress regularExpressions:isHexadecimal]) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (interval < 100 || interval > 65535 || duration < 1 || duration > 65535) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    
    NSDictionary *data = @{
        @"msg_id":@(1134),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
            @"mac":bleMacAddress,
            @"adv_mode":@(type),
            @"adv_interval":@(interval),
            @"adv_time":@(duration),
            @"tx_power":@([self getTxPowerValue:txPower])
        }
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskConfigAdvParamsOperation
                                   timeout:50
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_configPasswordVerificationWithBleMacAddress:(NSString *)bleMacAddress
                                              password:(NSString *)password
                                            macAddress:(NSString *)macAddress
                                                 topic:(NSString *)topic
                                              sucBlock:(void (^)(id returnData))sucBlock
                                           failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (!ValidStr(bleMacAddress) || bleMacAddress.length != 12 || ![bleMacAddress regularExpressions:isHexadecimal]) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (!ValidStr(password) || password.length > 16 || ![password isAsciiString]) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    
    NSDictionary *data = @{
        @"msg_id":@(1126),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
            @"mac":bleMacAddress,
            @"passwd":password,
        }
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskConfigPasswordVerificationOperation
                                   timeout:50
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_readPasswordVerificationStatusWithBleMacAddress:(NSString *)bleMacAddress
                                                macAddress:(NSString *)macAddress
                                                     topic:(NSString *)topic
                                                  sucBlock:(void (^)(id returnData))sucBlock
                                               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (!ValidStr(bleMacAddress) || bleMacAddress.length != 12 || ![bleMacAddress regularExpressions:isHexadecimal]) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1128),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
            @"mac":bleMacAddress,
        }
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskReadPasswordVerificationStatusOperation
                                   timeout:50
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_configPasswordVerificationStatusWithBleMacAddress:(NSString *)bleMacAddress
                                                        isOn:(NSInteger)isOn
                                                  macAddress:(NSString *)macAddress
                                                       topic:(NSString *)topic
                                                    sucBlock:(void (^)(id returnData))sucBlock
                                                 failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (!ValidStr(bleMacAddress) || bleMacAddress.length != 12 || ![bleMacAddress regularExpressions:isHexadecimal]) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    
    NSDictionary *data = @{
        @"msg_id":@(1130),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
            @"mac":bleMacAddress,
            @"switch_value":(isOn ? @(1) : @(0)),
        }
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskConfigPasswordVerificationStatusOperation
                                   timeout:50
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_readButtonLogWithBleMacAddress:(NSString *)bleMacAddress
                               macAddress:(NSString *)macAddress
                                    topic:(NSString *)topic
                                 sucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (!ValidStr(bleMacAddress) || bleMacAddress.length != 12 || ![bleMacAddress regularExpressions:isHexadecimal]) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    
    NSDictionary *data = @{
        @"msg_id":@(1172),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
            @"mac":bleMacAddress,
        }
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskReadButtonLogOperation
                                   timeout:50
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_clearButtonLogWithBleMacAddress:(NSString *)bleMacAddress
                                macAddress:(NSString *)macAddress
                                     topic:(NSString *)topic
                                  sucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (!ValidStr(bleMacAddress) || bleMacAddress.length != 12 || ![bleMacAddress regularExpressions:isHexadecimal]) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    
    NSDictionary *data = @{
        @"msg_id":@(1174),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
            @"mac":bleMacAddress,
        }
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskClearButtonLogOperation
                                   timeout:50
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_readSosAlarmNotiWithBleMacAddress:(NSString *)bleMacAddress
                                  macAddress:(NSString *)macAddress
                                       topic:(NSString *)topic
                                    sucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (!ValidStr(bleMacAddress) || bleMacAddress.length != 12 || ![bleMacAddress regularExpressions:isHexadecimal]) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1177),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
            @"mac":bleMacAddress,
        }
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskReadSosAlarmNotiOperation
                                   timeout:50
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_configSosAlarmNotiWithColor:(mk_cg_reminderLedColor)color
                   ledBlinkingInterval:(NSInteger)ledBlinkingInterval
                   ledBlinkingDuration:(NSInteger)ledBlinkingDuration
                 buzzerBeepingInterval:(NSInteger)buzzerBeepingInterval
                 buzzerBeepingDuration:(NSInteger)buzzerBeepingDuration
                         bleMacAddress:(NSString *)bleMacAddress
                            macAddress:(NSString *)macAddress
                                 topic:(NSString *)topic
                              sucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (!ValidStr(bleMacAddress) || bleMacAddress.length != 12 || ![bleMacAddress regularExpressions:isHexadecimal]) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (ledBlinkingInterval < 0 || ledBlinkingInterval > 100 || ledBlinkingDuration < 1 || ledBlinkingDuration > 255 || buzzerBeepingInterval < 0 || buzzerBeepingInterval > 100 || buzzerBeepingDuration < 0 || buzzerBeepingDuration > 655) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSString *ledColor = @"red";
    if (color == mk_cg_reminderLedColor_blue) {
        ledColor = @"blue";
    }else if (color == mk_cg_reminderLedColor_green) {
        ledColor = @"green";
    }
    NSDictionary *data = @{
        @"msg_id":@(1179),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
            @"mac":bleMacAddress,
            @"led_color":ledColor,
            @"led_off_time":@(ledBlinkingInterval * 100),
            @"led_work_time":@(ledBlinkingDuration),
            @"buzzer_off_time":@(buzzerBeepingInterval * 100),
            @"buzzer_work_time":@(buzzerBeepingDuration * 100),
        }
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskConfigSosAlarmNotiOperation
                                   timeout:50
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_readHardwareSelfTestWithBleMacAddress:(NSString *)bleMacAddress
                                      macAddress:(NSString *)macAddress
                                           topic:(NSString *)topic
                                        sucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (!ValidStr(bleMacAddress) || bleMacAddress.length != 12 || ![bleMacAddress regularExpressions:isHexadecimal]) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1181),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
            @"mac":bleMacAddress,
        }
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskReadHardwareSelfTestOperation
                                   timeout:50
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_configHardwareSelfTestLedBlinkingDuration:(NSInteger)ledBlinkingDuration
                               buzzerBeepingInterval:(NSInteger)buzzerBeepingInterval
                               buzzerBeepingDuration:(NSInteger)buzzerBeepingDuration
                                       bleMacAddress:(NSString *)bleMacAddress
                                          macAddress:(NSString *)macAddress
                                               topic:(NSString *)topic
                                            sucBlock:(void (^)(id returnData))sucBlock
                                         failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (!ValidStr(bleMacAddress) || bleMacAddress.length != 12 || ![bleMacAddress regularExpressions:isHexadecimal]) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (ledBlinkingDuration < 1 || ledBlinkingDuration > 255 || buzzerBeepingInterval < 0 || buzzerBeepingInterval > 100 || buzzerBeepingDuration < 0 || buzzerBeepingDuration > 655) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1183),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
            @"mac":bleMacAddress,
            @"led_flash_time":@(ledBlinkingDuration),
            @"buzzer_off_time":@(buzzerBeepingInterval * 100),
            @"buzzer_work_time":@(buzzerBeepingDuration * 100),
        }
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskConfigHardwareSelfTestOperation
                                   timeout:50
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_readDismissSosAlarmNotiWithBleMacAddress:(NSString *)bleMacAddress
                                         macAddress:(NSString *)macAddress
                                              topic:(NSString *)topic
                                           sucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (!ValidStr(bleMacAddress) || bleMacAddress.length != 12 || ![bleMacAddress regularExpressions:isHexadecimal]) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1185),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
            @"mac":bleMacAddress,
        }
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskReadDismissSosAlarmNotiOperation
                                   timeout:50
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_configDismissSosAlarmNotiWithColor:(mk_cg_reminderLedColor)color
                          ledBlinkingInterval:(NSInteger)ledBlinkingInterval
                          ledBlinkingDuration:(NSInteger)ledBlinkingDuration
                        buzzerBeepingInterval:(NSInteger)buzzerBeepingInterval
                        buzzerBeepingDuration:(NSInteger)buzzerBeepingDuration
                                bleMacAddress:(NSString *)bleMacAddress
                                   macAddress:(NSString *)macAddress
                                        topic:(NSString *)topic
                                     sucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (!ValidStr(bleMacAddress) || bleMacAddress.length != 12 || ![bleMacAddress regularExpressions:isHexadecimal]) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (ledBlinkingInterval < 0 || ledBlinkingInterval > 100 || ledBlinkingDuration < 0 || ledBlinkingDuration > 655 || buzzerBeepingInterval < 0 || buzzerBeepingInterval > 100 || buzzerBeepingDuration < 0 || buzzerBeepingDuration > 655) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSString *ledColor = @"red";
    if (color == mk_cg_reminderLedColor_blue) {
        ledColor = @"blue";
    }else if (color == mk_cg_reminderLedColor_green) {
        ledColor = @"green";
    }
    NSDictionary *data = @{
        @"msg_id":@(1187),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
            @"mac":bleMacAddress,
            @"led_color":ledColor,
            @"led_off_time":@(ledBlinkingInterval * 100),
            @"led_work_time":@(ledBlinkingDuration * 100),
            @"buzzer_off_time":@(buzzerBeepingInterval * 100),
            @"buzzer_work_time":@(buzzerBeepingDuration * 100),
        }
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskConfigDismissSosAlarmNotiOperation
                                   timeout:50
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_readButtonPressEffectiveIntervalWithBleMacAddress:(NSString *)bleMacAddress
                                                  macAddress:(NSString *)macAddress
                                                       topic:(NSString *)topic
                                                    sucBlock:(void (^)(id returnData))sucBlock
                                                 failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (!ValidStr(bleMacAddress) || bleMacAddress.length != 12 || ![bleMacAddress regularExpressions:isHexadecimal]) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    NSDictionary *data = @{
        @"msg_id":@(1189),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
            @"mac":bleMacAddress,
        }
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskReadButtonPressEffectiveIntervalOperation
                                   timeout:50
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

+ (void)cg_configButtonPressEffectiveIntervalWithBleMacAddress:(NSString *)bleMacAddress
                                                      interval:(NSInteger)interval
                                                    macAddress:(NSString *)macAddress
                                                         topic:(NSString *)topic
                                                      sucBlock:(void (^)(id returnData))sucBlock
                                                   failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *checkMsg = [self checkMacAddress:macAddress topic:topic];
    if (ValidStr(checkMsg)) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (!ValidStr(bleMacAddress) || bleMacAddress.length != 12 || ![bleMacAddress regularExpressions:isHexadecimal]) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    if (interval < 5 || interval > 20) {
        [self operationFailedBlockWithMsg:checkMsg failedBlock:failedBlock];
        return;
    }
    
    NSDictionary *data = @{
        @"msg_id":@(1191),
        @"device_info":@{
                @"mac":macAddress
        },
        @"data":@{
            @"mac":bleMacAddress,
            @"key_valid_interval":@(interval),
        }
    };
    [[MKCGMQTTDataManager shared] sendData:data
                                     topic:topic
                                macAddress:macAddress
                                    taskID:mk_cg_server_taskConfigButtonPressEffectiveIntervalOperation
                                   timeout:50
                                  sucBlock:sucBlock
                               failedBlock:failedBlock];
}

#pragma mark - private method
+ (NSString *)checkMacAddress:(NSString *)macAddress
                      topic:(NSString *)topic {
    if (!ValidStr(topic) || topic.length > 128 || ![topic isAsciiString]) {
        return @"Topic error";
    }
    if (!ValidStr(macAddress)) {
        return @"Mac error";
    }
    macAddress = [macAddress stringByReplacingOccurrencesOfString:@" " withString:@""];
    macAddress = [macAddress stringByReplacingOccurrencesOfString:@":" withString:@""];
    macAddress = [macAddress stringByReplacingOccurrencesOfString:@"-" withString:@""];
    macAddress = [macAddress stringByReplacingOccurrencesOfString:@"_" withString:@""];
    if (macAddress.length != 12 || ![macAddress regularExpressions:isHexadecimal]) {
        return @"Mac error";
    }
    return @"";
}

+ (void)operationFailedBlockWithMsg:(NSString *)message failedBlock:(void (^)(NSError *error))failedBlock {
    NSError *error = [[NSError alloc] initWithDomain:@"com.moko.RGMQTTManager"
                                                code:-999
                                            userInfo:@{@"errorInfo":message}];
    moko_dispatch_main_safe(^{
        if (failedBlock) {
            failedBlock(error);
        }
    });
}

+ (BOOL)isConfirmRawFilterProtocol:(id <mk_cg_BLEFilterRawDataProtocol>)protocol {
    if (![protocol conformsToProtocol:@protocol(mk_cg_BLEFilterRawDataProtocol)]) {
        return NO;
    }
    if (!ValidStr(protocol.dataType) || protocol.dataType.length != 2 || ![protocol.dataType regularExpressions:isHexadecimal]) {
        return NO;
    }
    if (protocol.minIndex == 0 && protocol.maxIndex == 0) {
        if (!ValidStr(protocol.rawData) || protocol.rawData.length > 58 || ![protocol.rawData regularExpressions:isHexadecimal] || (protocol.rawData.length % 2 != 0)) {
            return NO;
        }
        return YES;
    }
    if (protocol.maxIndex == 0 && protocol.minIndex != 0) {
        return NO;
    }
    if (protocol.minIndex == 0 && protocol.maxIndex != 0) {
        return NO;
    }
    if (protocol.minIndex < 0 || protocol.minIndex > 29 || protocol.maxIndex < 0 || protocol.maxIndex > 29) {
        return NO;
    }
    
    if (protocol.maxIndex < protocol.minIndex) {
        return NO;
    }
    if (!ValidStr(protocol.rawData) || protocol.rawData.length > 58 || ![protocol.rawData regularExpressions:isHexadecimal]) {
        return NO;
    }
    NSInteger totalLen = (protocol.maxIndex - protocol.minIndex + 1) * 2;
    if (protocol.rawData.length != totalLen) {
        return NO;
    }
    return YES;
}

+ (BOOL)isConfirmPirPresenceProtocol:(id <mk_cg_BLEFilterPirProtocol>)protocol {
    if (![protocol conformsToProtocol:@protocol(mk_cg_BLEFilterPirProtocol)]) {
        return NO;
    }
    if (protocol.delayRespneseStatus < 0 || protocol.delayRespneseStatus > 3) {
        return NO;
    }
    if (protocol.doorStatus < 0 || protocol.doorStatus > 2) {
        return NO;
    }
    if (protocol.sensorSensitivity < 0 || protocol.sensorSensitivity > 3) {
        return NO;
    }
    if (protocol.sensorDetectionStatus < 0 || protocol.sensorDetectionStatus > 2) {
        return NO;
    }
    return YES;
}

+ (BOOL)isConfirmWifiProtocol:(id <mk_cg_mqttModifyWifiProtocol>)protocol {
    if (![protocol conformsToProtocol:@protocol(mk_cg_mqttModifyWifiProtocol)]) {
        return NO;
    }
    if (!ValidStr(protocol.ssid) || protocol.ssid.length > 32) {
        return NO;
    }
    if (protocol.security == 0) {
        //Personal
        if (protocol.wifiPassword.length > 64) {
            return NO;
        }
        return YES;
    }
    //Enterprise
    if (protocol.eapType == 0 || protocol.eapType == 1) {
        //PEAP-MSCHAPV2/TTLS-MSCHAPV2
        if (protocol.eapUserName.length > 32) {
            return NO;
        }
        if (protocol.eapPassword.length > 64) {
            return NO;
        }
    }
    if (protocol.eapType == 2) {
        //TLS
        if (protocol.domainID.length > 64) {
            return NO;
        }
    }
    return YES;
}

+ (BOOL)isConfirmEAPCertProtocol:(id <mk_cg_mqttModifyWifiEapCertProtocol>)protocol {
    if (![protocol conformsToProtocol:@protocol(mk_cg_mqttModifyWifiEapCertProtocol)]) {
        return NO;
    }
    if (!ValidStr(protocol.caFilePath) && !ValidStr(protocol.clientKeyPath) && !ValidStr(protocol.clientCertPath)) {
        return NO;
    }
    if (protocol.clientKeyPath.length > 256 || protocol.clientCertPath.length > 256 || protocol.caFilePath.length > 256) {
        return NO;
    }
    return YES;
}

+ (BOOL)isConfirmNetworkProtocol:(id <mk_cg_mqttModifyNetworkProtocol>)protocol {
    if (![protocol conformsToProtocol:@protocol(mk_cg_mqttModifyNetworkProtocol)]) {
        return NO;
    }
    if (protocol.dhcp) {
        return YES;
    }
    if (![protocol.ip regularExpressions:isIPAddress]) {
        return NO;
    }
    if (![protocol.mask regularExpressions:isIPAddress]) {
        return NO;
    }
    if (![protocol.gateway regularExpressions:isIPAddress]) {
        return NO;
    }
    if (![protocol.dns regularExpressions:isIPAddress]) {
        return NO;
    }
    return YES;
}

+ (BOOL)isConfirmMqttServerProtocol:(id <mk_cg_modifyMqttServerProtocol>)protocol {
    if (![protocol conformsToProtocol:@protocol(mk_cg_modifyMqttServerProtocol)]) {
        return NO;
    }
    if (!ValidStr(protocol.host) || protocol.host.length > 64 || ![protocol.host isAsciiString]) {
        return NO;
    }
    if (!ValidStr(protocol.port) || [protocol.port integerValue] < 1 || [protocol.port integerValue] > 65535) {
        return NO;
    }
    if (!ValidStr(protocol.clientID) || protocol.clientID.length > 64 || ![protocol.clientID isAsciiString]) {
        return NO;
    }
    if (!ValidStr(protocol.publishTopic) || protocol.publishTopic.length > 128 || ![protocol.publishTopic isAsciiString]) {
        return NO;
    }
    if (!ValidStr(protocol.subscribeTopic) || protocol.subscribeTopic.length > 128 || ![protocol.subscribeTopic isAsciiString]) {
        return NO;
    }
    if (protocol.qos < 0 || protocol.qos > 2) {
        return NO;
    }
    if (!ValidStr(protocol.keepAlive) || [protocol.keepAlive integerValue] < 10 || [protocol.keepAlive integerValue] > 120) {
        return NO;
    }
    if (protocol.userName.length > 256 || (ValidStr(protocol.userName) && ![protocol.userName isAsciiString])) {
        return NO;
    }
    if (protocol.password.length > 256 || (ValidStr(protocol.password) && ![protocol.password isAsciiString])) {
        return NO;
    }
    if (protocol.connectMode < 0 || protocol.connectMode > 3) {
        return NO;
    }
    
    return YES;
}

+ (BOOL)isConfirmMqttServerCertsProtocol:(id <mk_cg_modifyMqttServerCertsProtocol>)protocol {
    if (![protocol conformsToProtocol:@protocol(mk_cg_modifyMqttServerCertsProtocol)]) {
        return NO;
    }
    if (!ValidStr(protocol.caFilePath) && !ValidStr(protocol.clientKeyPath) && !ValidStr(protocol.clientCertPath)) {
        return NO;
    }
    if (protocol.clientKeyPath.length > 256 || protocol.clientCertPath.length > 256 || protocol.caFilePath.length > 256) {
        return NO;
    }
    return YES;
}

+ (NSInteger)getTxPowerValue:(mk_cg_txPower)txPower {
    switch (txPower) {
        case mk_cg_txPowerNeg40dBm:
            return -40;
        case mk_cg_txPowerNeg20dBm:
            return -20;
        case mk_cg_txPowerNeg16dBm:
            return -16;
        case mk_cg_txPowerNeg12dBm:
            return -12;
        case mk_cg_txPowerNeg8dBm:
            return -8;
        case mk_cg_txPowerNeg4dBm:
            return -4;
        case mk_cg_txPower0dBm:
            return 0;
        case mk_cg_txPower3dBm:
            return 3;
        case mk_cg_txPower4dBm:
            return 4;
    }
}

@end
