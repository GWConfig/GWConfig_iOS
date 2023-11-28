//
//  MKCGMQTTTaskAdopter.m
//  CommureGateway_Example
//
//  Created by aa on 2023/2/4.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCGMQTTTaskAdopter.h"

#import "MKMacroDefines.h"

#import "MKCGMQTTTaskID.h"

@implementation MKCGMQTTTaskAdopter

+ (NSDictionary *)parseDataWithJson:(NSDictionary *)json topic:(NSString *)topic {
    NSInteger msgID = [json[@"msg_id"] integerValue];
    if (msgID >= 1000 && msgID < 2000) {
        //配置指令
        return [self parseConfigParamsWithJson:json msgID:msgID topic:topic];
    }
    if (msgID >= 2000 && msgID < 3000) {
        //读取指令
        return [self parseReadParamsWithJson:json msgID:msgID topic:topic];
    }
    if (msgID == 3101) {
        //连接指定mac地址的BXP-Button设备
        BOOL success = ([json[@"result_code"] integerValue] == 0);
        if (!success) {
            return @{};
        }
        return [self dataParserGetDataSuccess:json operationID:mk_cg_server_taskConnectBXPButtonWithMacOperation];
    }
    if (msgID == 3111) {
        //读取已连接BXP-Button设备信息
        BOOL success = ([json[@"result_code"] integerValue] == 0);
        if (!success) {
            return @{};
        }
        return [self dataParserGetDataSuccess:json operationID:mk_cg_server_taskReadBXPButtonConnectedDeviceInfoOperation];
    }
    if (msgID == 3113) {
        //读取电池电压结果
        BOOL success = ([json[@"result_code"] integerValue] == 0);
        if (!success) {
            return @{};
        }
        return [self dataParserGetDataSuccess:json operationID:mk_cg_server_taskReadDeviceBatteryVoltageOperation];
    }
    if (msgID == 3115) {
        //控制LED提醒
        BOOL success = ([json[@"result_code"] integerValue] == 0);
        if (!success) {
            return @{};
        }
        return [self dataParserGetDataSuccess:json operationID:mk_cg_server_taskConfigDeviceLedReminderOperation];
    }
    
    if (msgID == 3117) {
        //控制Buzzer提醒
        BOOL success = ([json[@"result_code"] integerValue] == 0);
        if (!success) {
            return @{};
        }
        return [self dataParserGetDataSuccess:json operationID:mk_cg_server_taskConfigDeviceBuzzerReminderOperation];
    }
    
    if (msgID == 3119) {
        //控制时间戳
        BOOL success = ([json[@"result_code"] integerValue] == 0);
        if (!success) {
            return @{};
        }
        return [self dataParserGetDataSuccess:json operationID:mk_cg_server_taskConfigDeviceTimestampOperation];
    }
    if (msgID == 3123) {
        //关机
        BOOL success = ([json[@"result_code"] integerValue] == 0);
        if (!success) {
            return @{};
        }
        return [self dataParserGetDataSuccess:json operationID:mk_cg_server_taskPowerOffConnectedDeviceOperation];
    }
    if (msgID == 3125) {
        //恢复出厂设置
        BOOL success = ([json[@"result_code"] integerValue] == 0);
        if (!success) {
            return @{};
        }
        return [self dataParserGetDataSuccess:json operationID:mk_cg_server_taskResetConnectedDeviceOperation];
    }
    if (msgID == 3127) {
        //设置连接密码
        BOOL success = ([json[@"result_code"] integerValue] == 0);
        if (!success) {
            return @{};
        }
        return [self dataParserGetDataSuccess:json operationID:mk_cg_server_taskConfigPasswordVerificationOperation];
    }
    if (msgID == 3129) {
        //读取密码验证开关状态
        BOOL success = ([json[@"result_code"] integerValue] == 0);
        if (!success) {
            return @{};
        }
        return [self dataParserGetDataSuccess:json operationID:mk_cg_server_taskReadPasswordVerificationStatusOperation];
    }
    if (msgID == 3131) {
        //设置密码验证开关状态
        BOOL success = ([json[@"result_code"] integerValue] == 0);
        if (!success) {
            return @{};
        }
        return [self dataParserGetDataSuccess:json operationID:mk_cg_server_taskConfigPasswordVerificationStatusOperation];
    }
    if (msgID == 3133) {
        //读取广播参数
        BOOL success = ([json[@"result_code"] integerValue] == 0);
        if (!success) {
            return @{};
        }
        return [self dataParserGetDataSuccess:json operationID:mk_cg_server_taskReadAdvParamsOperation];
    }
    if (msgID == 3135) {
        //配置广播参数
        BOOL success = ([json[@"result_code"] integerValue] == 0);
        if (!success) {
            return @{};
        }
        return [self dataParserGetDataSuccess:json operationID:mk_cg_server_taskConfigAdvParamsOperation];
    }
    if (msgID == 3137) {
        //读取Tag ID结果
        BOOL success = ([json[@"result_code"] integerValue] == 0);
        if (!success) {
            return @{};
        }
        return [self dataParserGetDataSuccess:json operationID:mk_cg_server_taskReadTagIDOperation];
    }
    if (msgID == 3139) {
        //设置Tag ID结果
        BOOL success = ([json[@"result_code"] integerValue] == 0);
        if (!success) {
            return @{};
        }
        return [self dataParserGetDataSuccess:json operationID:mk_cg_server_taskConfigTagIDOperation];
    }
    if (msgID == 3141) {
        //读取SOS触发方式
        BOOL success = ([json[@"result_code"] integerValue] == 0);
        if (!success) {
            return @{};
        }
        return [self dataParserGetDataSuccess:json operationID:mk_cg_server_taskReadSosTriggerTypeOperation];
    }
    if (msgID == 3143) {
        //设置SOS触发方式
        BOOL success = ([json[@"result_code"] integerValue] == 0);
        if (!success) {
            return @{};
        }
        return [self dataParserGetDataSuccess:json operationID:mk_cg_server_taskConfigSosTriggerTypeOperation];
    }
    if (msgID == 3145) {
        //读取按键自检时长
        BOOL success = ([json[@"result_code"] integerValue] == 0);
        if (!success) {
            return @{};
        }
        return [self dataParserGetDataSuccess:json operationID:mk_cg_server_taskReadSelfTestTriggeredByButtonOperation];
    }
    if (msgID == 3147) {
        //设置按键自检时长
        BOOL success = ([json[@"result_code"] integerValue] == 0);
        if (!success) {
            return @{};
        }
        return [self dataParserGetDataSuccess:json operationID:mk_cg_server_taskConfigSelfTestTriggeredByButtonOperation];
    }
    if (msgID == 3149) {
        //读取电量自检参数
        BOOL success = ([json[@"result_code"] integerValue] == 0);
        if (!success) {
            return @{};
        }
        return [self dataParserGetDataSuccess:json operationID:mk_cg_server_taskReadBatterySelfTestOperation];
    }
    if (msgID == 3151) {
        //设置电量自检参数
        BOOL success = ([json[@"result_code"] integerValue] == 0);
        if (!success) {
            return @{};
        }
        return [self dataParserGetDataSuccess:json operationID:mk_cg_server_taskConfigBatterySelfTestOperation];
    }
    if (msgID == 3153) {
        //读取报警状态
        BOOL success = ([json[@"result_code"] integerValue] == 0);
        if (!success) {
            return @{};
        }
        return [self dataParserGetDataSuccess:json operationID:mk_cg_server_taskReadAlarmStatusOperation];
    }
    if (msgID == 3155) {
        //BXP-Button消警
        BOOL success = ([json[@"result_code"] integerValue] == 0);
        if (!success) {
            return @{};
        }
        return [self dataParserGetDataSuccess:json operationID:mk_cg_server_taskDismissAlarmStatusOperation];
    }
    if (msgID == 3157) {
        //读取三轴参数
        BOOL success = ([json[@"result_code"] integerValue] == 0);
        if (!success) {
            return @{};
        }
        return [self dataParserGetDataSuccess:json operationID:mk_cg_server_taskReadAccelerometerParamsOperation];
    }
    if (msgID == 3159) {
        //设置三轴参数
        BOOL success = ([json[@"result_code"] integerValue] == 0);
        if (!success) {
            return @{};
        }
        return [self dataParserGetDataSuccess:json operationID:mk_cg_server_taskConfigAccelerometerParamsOperation];
    }
    if (msgID == 3161) {
        //读取省电等待时间
        BOOL success = ([json[@"result_code"] integerValue] == 0);
        if (!success) {
            return @{};
        }
        return [self dataParserGetDataSuccess:json operationID:mk_cg_server_taskReadSleepModeParametersOperation];
    }
    if (msgID == 3163) {
        //设置省电等待时间
        BOOL success = ([json[@"result_code"] integerValue] == 0);
        if (!success) {
            return @{};
        }
        return [self dataParserGetDataSuccess:json operationID:mk_cg_server_taskConfigSleepModeParametersOperation];
    }
    if (msgID == 3169) {
        //读取电量自检LED参数
        BOOL success = ([json[@"result_code"] integerValue] == 0);
        if (!success) {
            return @{};
        }
        return [self dataParserGetDataSuccess:json operationID:mk_cg_server_taskReadBatterySelfTestLedParamsOperation];
    }
    if (msgID == 3171) {
        //设置电量自检LED参数
        BOOL success = ([json[@"result_code"] integerValue] == 0);
        if (!success) {
            return @{};
        }
        return [self dataParserGetDataSuccess:json operationID:mk_cg_server_taskConfigBatterySelfTestLedParamsOperation];
    }
    if (msgID == 3173) {
        //获取按键log
        BOOL success = ([json[@"result_code"] integerValue] == 0);
        if (!success) {
            return @{};
        }
        return [self dataParserGetDataSuccess:json operationID:mk_cg_server_taskReadButtonLogOperation];
    }
    if (msgID == 3175) {
        //清除按键log
        BOOL success = ([json[@"result_code"] integerValue] == 0);
        if (!success) {
            return @{};
        }
        return [self dataParserGetDataSuccess:json operationID:mk_cg_server_taskClearButtonLogOperation];
    }
    if (msgID == 3301) {
        //网关连接指定mac地址的蓝牙设备
        BOOL success = ([json[@"result_code"] integerValue] == 0);
        if (!success) {
            return @{};
        }
        return [self dataParserGetDataSuccess:json operationID:mk_cg_server_taskConnectNormalBleDeviceWithMacOperation];
    }
    
    return @{};
}

#pragma mark - private method
+ (NSDictionary *)parseConfigParamsWithJson:(NSDictionary *)json msgID:(NSInteger)msgID topic:(NSString *)topic {
    BOOL success = ([json[@"result_code"] integerValue] == 0);
    if (!success) {
        return @{};
    }
    mk_cg_serverOperationID operationID = mk_cg_defaultServerOperationID;
    if (msgID == 1000) {
        //重启设备
        operationID = mk_cg_server_taskRebootDeviceOperation;
    }else if (msgID == 1001) {
        //配置按键恢复出厂设置类型
        operationID = mk_cg_server_taskKeyResetTypeOperation;
    }else if (msgID == 1003) {
        //配置网络状态上报间隔
        operationID = mk_cg_server_taskConfigNetworkStatusReportIntervalOperation;
    }else if (msgID == 1005) {
        //配置网络重连超时时间
        operationID = mk_cg_server_taskConfigReconnectTimeoutOperation;
    }else if (msgID == 1006) {
        //OTA
        operationID = mk_cg_server_taskConfigOTAHostOperation;
    }else if (msgID == 1008) {
        //配置NTP服务器信息
        operationID = mk_cg_server_taskConfigNTPServerOperation;
    }else if (msgID == 1009) {
        //配置设备UTC时间
        operationID = mk_cg_server_taskConfigDeviceTimeZoneOperation;
    }else if (msgID == 1011) {
        //配置指示灯开关
        operationID = mk_cg_server_taskConfigIndicatorLightStatusOperation;
    }else if (msgID == 1013) {
        //恢复出厂设置
        operationID = mk_cg_server_taskResetDeviceOperation;
    }else if (msgID == 1015) {
        //配置蓝牙广播状态
        operationID = mk_cg_server_taskConfigBleAdvStatusOperation;
    }else if (msgID == 1017) {
        //配置开关状态
        operationID = mk_cg_server_taskConfigPowerSwitchStatusOperation;
    }else if (msgID == 1020) {
        //配置wifi
        operationID = mk_cg_server_taskModifyWifiInfosOperation;
    }else if (msgID == 1021) {
        //配置wifi的EAP证书
        operationID = mk_cg_server_taskModifyWifiCertsOperation;
    }else if (msgID == 1023) {
        //配置Wifi网络参数
        operationID = mk_cg_server_taskModifyWifiNetworkInfoOperation;
    }else if (msgID == 1030) {
        //配置MQTT参数
        operationID = mk_cg_server_taskModifyMqttInfoOperation;
    }else if (msgID == 1031) {
        //配置MQTT证书
        operationID = mk_cg_server_taskModifyMqttCertsOperation;
    }else if (msgID == 1040) {
        //设置扫描开关状态
        operationID = mk_cg_server_taskConfigScanSwitchStatusOperation;
    }else if (msgID == 1041) {
        //设置过滤逻辑
        operationID = mk_cg_server_taskConfigFilterRelationshipsOperation;
    }else if (msgID == 1042) {
        //设置过滤RSSI
        operationID = mk_cg_server_taskConfigFilterByRSSIOperation;
    }else if (msgID == 1043) {
        //设置过滤Mac
        operationID = mk_cg_server_taskConfigFilterByMacAddressOperation;
    }else if (msgID == 1044) {
        //设置过滤Tag
        operationID = mk_cg_server_taskConfigFilterByTagOperation;
    }else if (msgID == 1045) {
        //配置数据包上报超时时间
        operationID = mk_cg_server_taskConfigDataReportTimeoutOperation;
    }else if (msgID == 1046) {
        //配置BXP-B解析时间偏移
        operationID = mk_cg_server_taskConfigBXBDecryptTimeOffsetOperation;
    }else if (msgID == 1047) {
        //配置BXP-B秘钥
        operationID = mk_cg_server_taskConfigBXBDecryptKeyOperation;
    }else if (msgID == 1048) {
        //配置通信超时时间
        operationID = mk_cg_server_taskConfigCommunicationTimeoutOperation;
    }else if (msgID == 1049) {
        //配置BXP-B连接扫描等待超时时间
        operationID = mk_cg_server_taskConfigConnectBeaconTimeoutOperation;
    }else if (msgID == 1103) {
        //断开连接
        operationID = mk_cg_server_taskDisconnectBleDeviceOperation;
    }else if (msgID == 1200) {
        //批量升级
        operationID = mk_cg_server_taskBatchDfuBeaconWithMacOperation;
    }else if (msgID == 1202) {
        //指定BXP-Button设备DFU升级
        operationID = mk_cg_server_taskStartBXPButtonDfuWithMacOperation;
    }else if (msgID == 1205) {
        //批量更新秘钥
        operationID = mk_cg_server_taskBatchUpdateKeyWithMacOperation;
    }
    return [self dataParserGetDataSuccess:json operationID:operationID];
}

+ (NSDictionary *)parseReadParamsWithJson:(NSDictionary *)json msgID:(NSInteger)msgID topic:(NSString *)topic {
    mk_cg_serverOperationID operationID = mk_cg_defaultServerOperationID;
    if (msgID == 2001) {
        //读取按键恢复出厂设置类型
        operationID = mk_cg_server_taskReadKeyResetTypeOperation;
    }else if (msgID == 2002) {
        //读取设备信息
        operationID = mk_cg_server_taskReadDeviceInfoOperation;
    }else if (msgID == 2003) {
        //读取网络状态上报间隔
        operationID = mk_cg_server_taskReadNetworkStatusReportIntervalOperation;
    }else if (msgID == 2005) {
        //读取网络重连超时时间
        operationID = mk_cg_server_taskReadNetworkReconnectTimeoutOperation;
    }else if (msgID == 2008) {
        //读取NTP服务器信息
        operationID = mk_cg_server_taskReadNTPServerOperation;
    }else if (msgID == 2009) {
        //读取UTC时间
        operationID = mk_cg_server_taskReadDeviceUTCTimeOperation;
    }else if (msgID == 2011) {
        //读取指示灯开关
        operationID = mk_cg_server_taskReadIndicatorLightStatusOperation;
    }else if (msgID == 2012) {
        //读取设备当前OTA状态
        operationID = mk_cg_server_taskReadOtaStatusOperation;
    }else if (msgID == 2016) {
        //读取蓝牙广播状态
        operationID = mk_cg_server_taskReadBleAdvStatusOperation;
    }else if (msgID == 2017) {
        //读取开关状态
        operationID = mk_cg_server_taskReadPowerSwitchStatusOperation;
    }else if (msgID == 2020) {
        //读取设备当前连接的wifi信息
        operationID = mk_cg_server_taskReadWifiInfosOperation;
    }else if (msgID == 2023) {
        //读取Wifi网络参数
        operationID = mk_cg_server_taskReadWifiNetworkInfosOperation;
    }else if (msgID == 2024) {
        //读取网络接口选择
        operationID = mk_cg_server_taskReadNetworkTypeOperation;
    }else if (msgID == 2030) {
        //读取MQTT参数
        operationID = mk_cg_server_taskReadMQTTParamsOperation;
    }else if (msgID == 2040) {
        //读取扫描开关状态
        operationID = mk_cg_server_taskReadScanSwitchStatusOperation;
    }else if (msgID == 2041) {
        //读取过滤关系
        operationID = mk_cg_server_taskReadFilterRelationshipsOperation;
    }else if (msgID == 2042) {
        //读取过滤RSSI
        operationID = mk_cg_server_taskReadFilterByRSSIOperation;
    }else if (msgID == 2043) {
        //读取过滤Mac
        operationID = mk_cg_server_taskReadFilterByMacOperation;
    }else if (msgID == 2044) {
        //读取过滤Tag
        operationID = mk_cg_server_taskReadFilterBXPTagOperation;
    }else if (msgID == 2045) {
        //读取数据上报超时时间
        operationID = mk_cg_server_taskReadDataReportTimeoutOperation;
    }else if (msgID == 2046) {
        //读取BXP-B解析时间偏移
        operationID = mk_cg_server_taskReadBXBDecryptTimeOffsetOperation;
    }else if (msgID == 2047) {
        //读取BXP-B秘钥
        operationID = mk_cg_server_taskReadBXBDecryptKeyOperation;
    }else if (msgID == 2048) {
        //读取通信超时时间
        operationID = mk_cg_server_taskReadCommunicateTimeoutOperation;
    }else if (msgID == 2049) {
        //读取通信超时时间
        operationID = mk_cg_server_taskReadConnectBeaconTimeoutOperation;
    }else if (msgID == 2102) {
        //读取网关蓝牙连接的状态
        operationID = mk_cg_server_taskReadGatewayBleConnectStatusOperation;
    }
    return [self dataParserGetDataSuccess:json operationID:operationID];
}

+ (NSDictionary *)dataParserGetDataSuccess:(NSDictionary *)returnData operationID:(mk_cg_serverOperationID)operationID{
    if (!returnData) {
        return @{};
    }
    return @{@"returnData":returnData,@"operationID":@(operationID)};
}

@end
