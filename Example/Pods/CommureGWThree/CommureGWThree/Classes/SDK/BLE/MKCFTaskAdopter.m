//
//  MKCFTaskAdopter.m
//  CommureGWThree_Example
//
//  Created by aa on 2023/1/29.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCFTaskAdopter.h"

#import <CoreBluetooth/CoreBluetooth.h>

#import "MKBLEBaseSDKAdopter.h"
#import "MKBLEBaseSDKDefines.h"

#import "MKCFOperationID.h"
#import "CBPeripheral+MKCFAdd.h"
#import "MKCFSDKDataAdopter.h"

NSString *const mk_cf_totalNumKey = @"mk_cf_totalNumKey";
NSString *const mk_cf_totalIndexKey = @"mk_cf_totalIndexKey";
NSString *const mk_cf_contentKey = @"mk_cf_contentKey";

@implementation MKCFTaskAdopter

+ (NSDictionary *)parseReadDataWithCharacteristic:(CBCharacteristic *)characteristic {
    NSData *readData = characteristic.value;
    NSLog(@"+++++%@-----%@",characteristic.UUID.UUIDString,readData);
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A24"]]) {
        //产品型号
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"modeID":tempString} operationID:mk_cf_taskReadDeviceModelOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A26"]]) {
        //firmware
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"firmware":tempString} operationID:mk_cf_taskReadFirmwareOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A27"]]) {
        //hardware
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"hardware":tempString} operationID:mk_cf_taskReadHardwareOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A28"]]) {
        //soft ware
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"software":tempString} operationID:mk_cf_taskReadSoftwareOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A29"]]) {
        //manufacturerKey
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"manufacturer":tempString} operationID:mk_cf_taskReadManufacturerOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA00"]]) {
        //密码相关
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:readData];
        NSString *state = @"";
        if (content.length == 10) {
            state = [content substringWithRange:NSMakeRange(8, 2)];
        }
        return [self dataParserGetDataSuccess:@{@"state":state} operationID:mk_cf_connectPasswordOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA03"]]) {
        return [self parseCustomData:readData];
    }
    return @{};
}

+ (NSDictionary *)parseWriteDataWithCharacteristic:(CBCharacteristic *)characteristic {
    return @{};
}

#pragma mark - Private method

+ (NSDictionary *)parseCustomData:(NSData *)readData {
    NSString *readString = [MKBLEBaseSDKAdopter hexStringFromData:readData];
    
    if ([[readString substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"ee"]) {
        //多帧数据
        return [self parseMultiData:readData];
    }
    
    NSInteger dataLen = [MKBLEBaseSDKAdopter getDecimalWithHex:readString range:NSMakeRange(6, 2)];
    if (readData.length != dataLen + 4) {
        return @{};
    }
    NSString *flag = [readString substringWithRange:NSMakeRange(2, 2)];
    NSString *cmd = [readString substringWithRange:NSMakeRange(4, 2)];
    NSString *content = [readString substringWithRange:NSMakeRange(8, dataLen * 2)];
    if ([[readString substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"ed"]) {
        //单帧数据
        if ([flag isEqualToString:@"00"]) {
            //读取
            return [self parseCustomReadData:content cmd:cmd data:readData];
        }
        if ([flag isEqualToString:@"01"]) {
            return [self parseCustomConfigData:content cmd:cmd];
        }
    }
    
    return @{};
}

+ (NSDictionary *)parseMultiData:(NSData *)readData {
    NSString *readString = [MKBLEBaseSDKAdopter hexStringFromData:readData];
    NSString *flag = [readString substringWithRange:NSMakeRange(2, 2)];
    NSString *cmd = [readString substringWithRange:NSMakeRange(4, 2)];
    NSString *content = [readString substringFromIndex:8];
    if ([flag isEqualToString:@"00"]) {
        return [self parseMultiPackageReadData:readData cmd:[readString substringWithRange:NSMakeRange(4, 2)]];
    }
    if ([flag isEqualToString:@"01"]) {
        return [self parseMultiPackageData:content cmd:[readString substringWithRange:NSMakeRange(4, 2)]];
    }
    return @{};
}

+ (NSDictionary *)parseCustomReadData:(NSString *)content cmd:(NSString *)cmd data:(NSData *)data {
    mk_cf_taskOperationID operationID = mk_cf_defaultTaskOperationID;
    NSDictionary *resultDic = @{};
    if ([cmd isEqualToString:@"02"]) {
        
    }else if ([cmd isEqualToString:@"05"]) {
        //读取deviceName
        NSString *deviceName = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(4, data.length - 4)] encoding:NSUTF8StringEncoding];
        resultDic = @{@"deviceName":deviceName};
        operationID = mk_cf_taskReadDeviceNameOperation;
    }else if ([cmd isEqualToString:@"09"]) {
        //读取MAC
        NSString *macAddress = [NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@",[content substringWithRange:NSMakeRange(0, 2)],[content substringWithRange:NSMakeRange(2, 2)],[content substringWithRange:NSMakeRange(4, 2)],[content substringWithRange:NSMakeRange(6, 2)],[content substringWithRange:NSMakeRange(8, 2)],[content substringWithRange:NSMakeRange(10, 2)]];
        resultDic = @{@"macAddress":[macAddress uppercaseString]};
        operationID = mk_cf_taskReadDeviceMacAddressOperation;
    }else if ([cmd isEqualToString:@"0a"]) {
        //读取WIFI STA MAC
        NSString *macAddress = [NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@",[content substringWithRange:NSMakeRange(0, 2)],[content substringWithRange:NSMakeRange(2, 2)],[content substringWithRange:NSMakeRange(4, 2)],[content substringWithRange:NSMakeRange(6, 2)],[content substringWithRange:NSMakeRange(8, 2)],[content substringWithRange:NSMakeRange(10, 2)]];
        resultDic = @{@"macAddress":[macAddress uppercaseString]};
        operationID = mk_cf_taskReadDeviceWifiSTAMacAddressOperation;
    }else if ([cmd isEqualToString:@"11"]) {
        //读取NTP服务器域名
        NSString *host = @"";
        if (data.length > 4) {
            NSData *hostData = [data subdataWithRange:NSMakeRange(4, data.length - 4)];
            host = [[NSString alloc] initWithData:hostData encoding:NSUTF8StringEncoding];
        }
        resultDic = @{
            @"host":(MKValidStr(host) ? host : @""),
        };
        operationID = mk_cf_taskReadNTPServerHostOperation;
    }else if ([cmd isEqualToString:@"12"]) {
        //读取时区
        resultDic = @{
            @"timeZone":[MKBLEBaseSDKAdopter signedHexTurnString:content],
        };
        operationID = mk_cf_taskReadTimeZoneOperation;
    }else if ([cmd isEqualToString:@"20"]) {
        //读取MQTT服务器域名
        NSString *host = @"";
        if (data.length > 4) {
            NSData *hostData = [data subdataWithRange:NSMakeRange(4, data.length - 4)];
            host = [[NSString alloc] initWithData:hostData encoding:NSUTF8StringEncoding];
        }
        resultDic = @{
            @"host":(MKValidStr(host) ? host : @""),
        };
        operationID = mk_cf_taskReadServerHostOperation;
    }else if ([cmd isEqualToString:@"21"]) {
        //读取MQTT服务器端口
        NSString *port = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{@"port":port};
        operationID = mk_cf_taskReadServerPortOperation;
    }else if ([cmd isEqualToString:@"22"]) {
        //读取ClientID
        NSString *clientID = @"";
        if (data.length > 4) {
            NSData *clientIDData = [data subdataWithRange:NSMakeRange(4, data.length - 4)];
            clientID = [[NSString alloc] initWithData:clientIDData encoding:NSUTF8StringEncoding];
        }
        resultDic = @{
            @"clientID":(MKValidStr(clientID) ? clientID : @""),
        };
        operationID = mk_cf_taskReadClientIDOperation;
    }else if ([cmd isEqualToString:@"25"]) {
        //读取MQTT Clean Session
        BOOL clean = ([content isEqualToString:@"01"]);
        resultDic = @{@"clean":@(clean)};
        operationID = mk_cf_taskReadServerCleanSessionOperation;
    }else if ([cmd isEqualToString:@"26"]) {
        //读取MQTT KeepAlive
        NSString *keepAlive = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{@"keepAlive":keepAlive};
        operationID = mk_cf_taskReadServerKeepAliveOperation;
    }else if ([cmd isEqualToString:@"27"]) {
        //读取MQTT Qos
        NSString *qos = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{@"qos":qos};
        operationID = mk_cf_taskReadServerQosOperation;
    }else if ([cmd isEqualToString:@"28"]) {
        //读取Subscribe topic
        NSString *topic = @"";
        if (data.length > 4) {
            NSData *topicData = [data subdataWithRange:NSMakeRange(4, data.length - 4)];
            topic = [[NSString alloc] initWithData:topicData encoding:NSUTF8StringEncoding];
        }
        resultDic = @{
            @"topic":(MKValidStr(topic) ? topic : @""),
        };
        operationID = mk_cf_taskReadSubscibeTopicOperation;
    }else if ([cmd isEqualToString:@"29"]) {
        //读取Publish topic
        NSString *topic = @"";
        if (data.length > 4) {
            NSData *topicData = [data subdataWithRange:NSMakeRange(4, data.length - 4)];
            topic = [[NSString alloc] initWithData:topicData encoding:NSUTF8StringEncoding];
        }
        resultDic = @{
            @"topic":(MKValidStr(topic) ? topic : @""),
        };
        operationID = mk_cf_taskReadPublishTopicOperation;
    }else if ([cmd isEqualToString:@"2f"]) {
        //读取MTQQ服务器通信加密方式
        NSString *mode = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{@"mode":mode};
        operationID = mk_cf_taskReadConnectModeOperation;
    }else if ([cmd isEqualToString:@"40"]) {
        //读取wifi加密模式
        NSString *security = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{@"security":security};
        operationID = mk_cf_taskReadWIFISecurityOperation;
    }else if ([cmd isEqualToString:@"41"]) {
        //读取WIFI SSID
        NSString *ssid = @"";
        if (data.length > 4) {
            NSData *ssidData = [data subdataWithRange:NSMakeRange(4, data.length - 4)];
            ssid = [[NSString alloc] initWithData:ssidData encoding:NSUTF8StringEncoding];
        }
        resultDic = @{
            @"ssid":(MKValidStr(ssid) ? ssid : @""),
        };
        operationID = mk_cf_taskReadWIFISSIDOperation;
    }else if ([cmd isEqualToString:@"42"]) {
        //读取WIFI password
        NSString *password = @"";
        if (data.length > 4) {
            NSData *passwordData = [data subdataWithRange:NSMakeRange(4, data.length - 4)];
            password = [[NSString alloc] initWithData:passwordData encoding:NSUTF8StringEncoding];
        }
        resultDic = @{
            @"password":(MKValidStr(password) ? password : @""),
        };
        operationID = mk_cf_taskReadWIFIPasswordOperation;
    }else if ([cmd isEqualToString:@"43"]) {
        //读取wifi EAP类型
        NSString *eapType = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{@"eapType":eapType};
        operationID = mk_cf_taskReadWIFIEAPTypeOperation;
    }else if ([cmd isEqualToString:@"44"]) {
        //读取wifi EAP用户名
        NSString *username = @"";
        if (data.length > 4) {
            NSData *usernameData = [data subdataWithRange:NSMakeRange(4, data.length - 4)];
            username = [[NSString alloc] initWithData:usernameData encoding:NSUTF8StringEncoding];
        }
        resultDic = @{
            @"username":(MKValidStr(username) ? username : @""),
        };
        operationID = mk_cf_taskReadWIFIEAPUsernameOperation;
    }else if ([cmd isEqualToString:@"45"]) {
        //读取WIFI EAP密码
        NSString *password = @"";
        if (data.length > 4) {
            NSData *passwordData = [data subdataWithRange:NSMakeRange(4, data.length - 4)];
            password = [[NSString alloc] initWithData:passwordData encoding:NSUTF8StringEncoding];
        }
        resultDic = @{
            @"password":(MKValidStr(password) ? password : @""),
        };
        operationID = mk_cf_taskReadWIFIEAPPasswordOperation;
    }else if ([cmd isEqualToString:@"46"]) {
        //读取wifi EAP域名ID
        NSString *domainID = @"";
        if (data.length > 4) {
            NSData *domainData = [data subdataWithRange:NSMakeRange(4, data.length - 4)];
            domainID = [[NSString alloc] initWithData:domainData encoding:NSUTF8StringEncoding];
        }
        resultDic = @{
            @"domainID":(MKValidStr(domainID) ? domainID : @""),
        };
        operationID = mk_cf_taskReadWIFIEAPDomainIDOperation;
    }else if ([cmd isEqualToString:@"47"]) {
        //读取是否校验服务器
        BOOL verify = ([content isEqualToString:@"01"]);
        resultDic = @{@"verify":@(verify)};
        operationID = mk_cf_taskReadWIFIVerifyServerStatusOperation;
    }else if ([cmd isEqualToString:@"4b"]) {
        //读取DHCP开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{@"isOn":@(isOn)};
        operationID = mk_cf_taskReadWIFIDHCPStatusOperation;
    }else if ([cmd isEqualToString:@"4c"]) {
        //读取IP信息
        NSString *ip = [MKCFSDKDataAdopter parseIpAddress:[content substringWithRange:NSMakeRange(0, 8)]];
        NSString *mask = [MKCFSDKDataAdopter parseIpAddress:[content substringWithRange:NSMakeRange(8, 8)]];
        NSString *gateway = [MKCFSDKDataAdopter parseIpAddress:[content substringWithRange:NSMakeRange(16, 8)]];
        NSString *dns = [MKCFSDKDataAdopter parseIpAddress:[content substringWithRange:NSMakeRange(24, 8)]];
        resultDic = @{
            @"ip":ip,
            @"mask":mask,
            @"gateway":gateway,
            @"dns":dns
        };
        operationID = mk_cf_taskReadWIFINetworkIpInfosOperation;
    }else if ([cmd isEqualToString:@"4d"]) {
        //读取网络接口类型
        resultDic = @{
            @"type":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)]
        };
        operationID = mk_cf_taskReadNetworkTypeOperation;
    }else if ([cmd isEqualToString:@"4e"]) {
        //读取Ethernet DHCP开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{@"isOn":@(isOn)};
        operationID = mk_cf_taskReadEthernetDHCPStatusOperation;
    }else if ([cmd isEqualToString:@"4f"]) {
        //读取Ethernet IP信息
        NSString *ip = [MKCFSDKDataAdopter parseIpAddress:[content substringWithRange:NSMakeRange(0, 8)]];
        NSString *mask = [MKCFSDKDataAdopter parseIpAddress:[content substringWithRange:NSMakeRange(8, 8)]];
        NSString *gateway = [MKCFSDKDataAdopter parseIpAddress:[content substringWithRange:NSMakeRange(16, 8)]];
        NSString *dns = [MKCFSDKDataAdopter parseIpAddress:[content substringWithRange:NSMakeRange(24, 8)]];
        resultDic = @{
            @"ip":ip,
            @"mask":mask,
            @"gateway":gateway,
            @"dns":dns
        };
        operationID = mk_cf_taskReadEthernetNetworkIpInfosOperation;
    }
    
    return [self dataParserGetDataSuccess:resultDic operationID:operationID];
}

+ (NSDictionary *)parseCustomConfigData:(NSString *)content cmd:(NSString *)cmd {
    mk_cf_taskOperationID operationID = mk_cf_defaultTaskOperationID;
    BOOL success = [content isEqualToString:@"01"];
    if ([cmd isEqualToString:@"02"]) {
        //重启进入STA模式
        operationID = mk_cf_taskEnterSTAModeOperation;
    }else if ([cmd isEqualToString:@"11"]) {
        //配置NTP服务器域名
        operationID = mk_cf_taskConfigNTPServerHostOperation;
    }else if ([cmd isEqualToString:@"12"]) {
        //配置时区
        operationID = mk_cf_taskConfigTimeZoneOperation;
    }else if ([cmd isEqualToString:@"14"]) {
        //配置UTC时间戳
        operationID = mk_cf_taskConfigDeviceTimeOperation;
    }else if ([cmd isEqualToString:@"20"]) {
        //配置MQTT服务器域名
        operationID = mk_cf_taskConfigServerHostOperation;
    }else if ([cmd isEqualToString:@"21"]) {
        //配置MQTT服务器端口
        operationID = mk_cf_taskConfigServerPortOperation;
    }else if ([cmd isEqualToString:@"22"]) {
        //配置ClientID
        operationID = mk_cf_taskConfigClientIDOperation;
    }else if ([cmd isEqualToString:@"25"]) {
        //配置MQTT Clean Session
        operationID = mk_cf_taskConfigServerCleanSessionOperation;
    }else if ([cmd isEqualToString:@"26"]) {
        //配置MQTT KeepAlive
        operationID = mk_cf_taskConfigServerKeepAliveOperation;
    }else if ([cmd isEqualToString:@"27"]) {
        //配置MQTT Qos
        operationID = mk_cf_taskConfigServerQosOperation;
    }else if ([cmd isEqualToString:@"28"]) {
        //配置Subscribe topic
        operationID = mk_cf_taskConfigSubscibeTopicOperation;
    }else if ([cmd isEqualToString:@"29"]) {
        //配置Publish topic
        operationID = mk_cf_taskConfigPublishTopicOperation;
    }else if ([cmd isEqualToString:@"2f"]) {
        //配置MTQQ服务器通信加密方式
        operationID = mk_cf_taskConfigConnectModeOperation;
    }else if ([cmd isEqualToString:@"40"]) {
        //配置WIFI 加密模式
        operationID = mk_cf_taskConfigWIFISecurityOperation;
    }else if ([cmd isEqualToString:@"41"]) {
        //配置WIFI SSID
        operationID = mk_cf_taskConfigWIFISSIDOperation;
    }else if ([cmd isEqualToString:@"42"]) {
        //配置WIFI password
        operationID = mk_cf_taskConfigWIFIPasswordOperation;
    }else if ([cmd isEqualToString:@"43"]) {
        //配置WIFI EAP 类型
        operationID = mk_cf_taskConfigWIFIEAPTypeOperation;
    }else if ([cmd isEqualToString:@"44"]) {
        //配置WIFI EAP 用户名
        operationID = mk_cf_taskConfigWIFIEAPUsernameOperation;
    }else if ([cmd isEqualToString:@"45"]) {
        //配置WIFI EAP 密码
        operationID = mk_cf_taskConfigWIFIEAPPasswordOperation;
    }else if ([cmd isEqualToString:@"46"]) {
        //配置wifi的EAP域名ID
        operationID = mk_cf_taskConfigWIFIEAPDomainIDOperation;
    }else if ([cmd isEqualToString:@"47"]) {
        //配置wifi是否校验服务器
        operationID = mk_cf_taskConfigWIFIVerifyServerStatusOperation;
    }else if ([cmd isEqualToString:@"4b"]) {
        //配置Wifi DHCP状态
        operationID = mk_cf_taskConfigWIFIDHCPStatusOperation;
    }else if ([cmd isEqualToString:@"4c"]) {
        //配置Wifi IP地址相关信息
        operationID = mk_cf_taskConfigWIFIIpInfoOperation;
    }else if ([cmd isEqualToString:@"4d"]) {
        //配置网络接口类型
        operationID = mk_cf_taskConfigNetworkTypeOperation;
    }else if ([cmd isEqualToString:@"4e"]) {
        //配置Ethernet DHCP状态
        operationID = mk_cf_taskConfigEthernetDHCPStatusOperation;
    }else if ([cmd isEqualToString:@"4f"]) {
        //配置Ethernet IP地址相关信息
        operationID = mk_cf_taskConfigEthernetIpInfoOperation;
    }
    
    return [self dataParserGetDataSuccess:@{@"success":@(success)} operationID:operationID];
}

+ (NSDictionary *)parseMultiPackageReadData:(NSData *)readData cmd:(NSString *)cmd {
    NSString *readString = [MKBLEBaseSDKAdopter hexStringFromData:readData];
    NSString *totalNum = [MKBLEBaseSDKAdopter getDecimalStringWithHex:readString range:NSMakeRange(6, 2)];
    NSString *index = [MKBLEBaseSDKAdopter getDecimalStringWithHex:readString range:NSMakeRange(8, 2)];
    NSInteger len = [MKBLEBaseSDKAdopter getDecimalWithHex:readString range:NSMakeRange(10, 2)];
    if ([index integerValue] >= [totalNum integerValue]) {
        return @{};
    }
    mk_cf_taskOperationID operationID = mk_cf_defaultTaskOperationID;
    
    NSData *subData = [readData subdataWithRange:NSMakeRange(6, len)];
    NSDictionary *resultDic= @{
        mk_cf_totalNumKey:totalNum,
        mk_cf_totalIndexKey:index,
        mk_cf_contentKey:(subData ? subData : [NSData data]),
    };
    if ([cmd isEqualToString:@"23"]) {
        //读取服务器登录用户名
        operationID = mk_cf_taskReadServerUserNameOperation;
    }else if ([cmd isEqualToString:@"24"]) {
        //读取服务器登录密码
        operationID = mk_cf_taskReadServerPasswordOperation;
    }
    return [self dataParserGetDataSuccess:resultDic operationID:operationID];
}

+ (NSDictionary *)parseMultiPackageData:(NSString *)content cmd:(NSString *)cmd {
    mk_cf_taskOperationID operationID = mk_cf_defaultTaskOperationID;
    BOOL success = [content isEqualToString:@"01"];
    if ([cmd isEqualToString:@"23"]) {
        //配置服务器登录用户名
        operationID = mk_cf_taskConfigServerUserNameOperation;
    }else if ([cmd isEqualToString:@"24"]) {
        //配置服务器登录密码
        operationID = mk_cf_taskConfigServerPasswordOperation;
    }else if ([cmd isEqualToString:@"30"]) {
        //配置CA file
        operationID = mk_cf_taskConfigCAFileOperation;
    }else if ([cmd isEqualToString:@"31"]) {
        //配置Client certificate file
        operationID = mk_cf_taskConfigClientCertOperation;
    }else if ([cmd isEqualToString:@"32"]) {
        //配置Client key file
        operationID = mk_cf_taskConfigClientPrivateKeyOperation;
    }else if ([cmd isEqualToString:@"48"]) {
        //配置WIFI CA file
        operationID = mk_cf_taskConfigWIFICAFileOperation;
    }else if ([cmd isEqualToString:@"49"]) {
        //配置WIFI Client certificate file
        operationID = mk_cf_taskConfigWIFIClientCertOperation;
    }else if ([cmd isEqualToString:@"4a"]) {
        //配置WIFI Client key file
        operationID = mk_cf_taskConfigWIFIClientPrivateKeyOperation;
    }
    return [self dataParserGetDataSuccess:@{@"success":@(success)} operationID:operationID];
}

+ (NSDictionary *)dataParserGetDataSuccess:(NSDictionary *)returnData operationID:(mk_cf_taskOperationID)operationID{
    if (!returnData) {
        return @{};
    }
    return @{@"returnData":returnData,@"operationID":@(operationID)};
}

@end