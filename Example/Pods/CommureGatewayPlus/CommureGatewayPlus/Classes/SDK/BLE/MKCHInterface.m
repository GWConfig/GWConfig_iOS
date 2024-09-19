//
//  MKCHInterface.m
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/1/29.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCHInterface.h"

#import "MKBLEBaseSDKDefines.h"
#import "MKBLEBaseSDKAdopter.h"

#import "MKCHCentralManager.h"
#import "MKCHOperationID.h"
#import "MKCHOperation.h"
#import "CBPeripheral+MKCHAdd.h"
#import "MKCHSDKDataAdopter.h"

#define centralManager [MKCHCentralManager shared]
#define peripheral ([MKCHCentralManager shared].peripheral)

@implementation MKCHInterface

#pragma mark **********************Device Service Information************************

+ (void)ch_readDeviceModelWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_ch_taskReadDeviceModelOperation
                           characteristic:peripheral.ch_deviceModel
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)ch_readFirmwareWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_ch_taskReadFirmwareOperation
                           characteristic:peripheral.ch_firmware
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)ch_readHardwareWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_ch_taskReadHardwareOperation
                           characteristic:peripheral.ch_hardware
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)ch_readSoftwareWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_ch_taskReadSoftwareOperation
                           characteristic:peripheral.ch_software
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)ch_readManufacturerWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_ch_taskReadManufacturerOperation
                           characteristic:peripheral.ch_manufacturer
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

#pragma mark *******************************自定义协议读取*****************************************

#pragma mark *********************System Params************************

+ (void)ch_readDeviceNameWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed000500";
    [centralManager addTaskWithTaskID:mk_ch_taskReadDeviceNameOperation
                       characteristic:peripheral.ch_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)ch_readMacAddressWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed000900";
    [centralManager addTaskWithTaskID:mk_ch_taskReadDeviceMacAddressOperation
                       characteristic:peripheral.ch_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)ch_readDeviceWifiSTAMacAddressWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed000a00";
    [centralManager addTaskWithTaskID:mk_ch_taskReadDeviceWifiSTAMacAddressOperation
                       characteristic:peripheral.ch_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)ch_readNTPServerHostWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed001100";
    [centralManager addTaskWithTaskID:mk_ch_taskReadNTPServerHostOperation
                       characteristic:peripheral.ch_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)ch_readTimeZoneWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed001200";
    [centralManager addTaskWithTaskID:mk_ch_taskReadTimeZoneOperation
                       characteristic:peripheral.ch_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)ch_readBleFirmwareWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed001500";
    [centralManager addTaskWithTaskID:mk_ch_taskReadBleFirmwareOperation
                       characteristic:peripheral.ch_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

#pragma mark *********************MQTT Params************************

+ (void)ch_readServerHostWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed002000";
    [centralManager addTaskWithTaskID:mk_ch_taskReadServerHostOperation
                       characteristic:peripheral.ch_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)ch_readServerPortWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed002100";
    [centralManager addTaskWithTaskID:mk_ch_taskReadServerPortOperation
                       characteristic:peripheral.ch_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)ch_readClientIDWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed002200";
    [centralManager addTaskWithTaskID:mk_ch_taskReadClientIDOperation
                       characteristic:peripheral.ch_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)ch_readServerUserNameWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ee002300";
    [centralManager addTaskWithTaskID:mk_ch_taskReadServerUserNameOperation
                       characteristic:peripheral.ch_custom
                          commandData:commandString
                         successBlock:^(id  _Nonnull returnData) {
        NSArray *tempList = returnData[@"result"];
        NSMutableData *usernameData = [NSMutableData data];
        for (NSInteger i = 0; i < tempList.count; i ++) {
            NSData *tempData = tempList[i];
            [usernameData appendData:tempData];
        }
        NSString *username = [[NSString alloc] initWithData:usernameData encoding:NSUTF8StringEncoding];
        NSDictionary *resultDic = @{@"msg":@"success",
                                    @"code":@"1",
                                    @"result":@{
                                        @"username":(MKValidStr(username) ? username : @""),
                                    },
                                    };
        MKBLEBase_main_safe(^{
            if (sucBlock) {
                sucBlock(resultDic);
            }
        });
    } failureBlock:failedBlock];
}

+ (void)ch_readServerPasswordWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ee002400";
    [centralManager addTaskWithTaskID:mk_ch_taskReadServerPasswordOperation
                       characteristic:peripheral.ch_custom
                          commandData:commandString
                         successBlock:^(id  _Nonnull returnData) {
        NSArray *tempList = returnData[@"result"];
        NSMutableData *passwordData = [NSMutableData data];
        for (NSInteger i = 0; i < tempList.count; i ++) {
            NSData *tempData = tempList[i];
            [passwordData appendData:tempData];
        }
        NSString *password = [[NSString alloc] initWithData:passwordData encoding:NSUTF8StringEncoding];
        NSDictionary *resultDic = @{@"msg":@"success",
                                    @"code":@"1",
                                    @"result":@{
                                        @"password":(MKValidStr(password) ? password : @""),
                                    },
                                    };
        MKBLEBase_main_safe(^{
            if (sucBlock) {
                sucBlock(resultDic);
            }
        });
    } failureBlock:failedBlock];
}

+ (void)ch_readServerCleanSessionWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed002500";
    [centralManager addTaskWithTaskID:mk_ch_taskReadServerCleanSessionOperation
                       characteristic:peripheral.ch_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)ch_readServerKeepAliveWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed002600";
    [centralManager addTaskWithTaskID:mk_ch_taskReadServerKeepAliveOperation
                       characteristic:peripheral.ch_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)ch_readServerQosWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed002700";
    [centralManager addTaskWithTaskID:mk_ch_taskReadServerQosOperation
                       characteristic:peripheral.ch_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)ch_readSubscibeTopicWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed002800";
    [centralManager addTaskWithTaskID:mk_ch_taskReadSubscibeTopicOperation
                       characteristic:peripheral.ch_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)ch_readPublishTopicWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed002900";
    [centralManager addTaskWithTaskID:mk_ch_taskReadPublishTopicOperation
                       characteristic:peripheral.ch_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)ch_readConnectModeWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed002f00";
    [centralManager addTaskWithTaskID:mk_ch_taskReadConnectModeOperation
                       characteristic:peripheral.ch_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}









+ (void)ch_readWIFISecurityWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed004000";
    [centralManager addTaskWithTaskID:mk_ch_taskReadWIFISecurityOperation
                       characteristic:peripheral.ch_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)ch_readWIFISSIDWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed004100";
    [centralManager addTaskWithTaskID:mk_ch_taskReadWIFISSIDOperation
                       characteristic:peripheral.ch_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)ch_readWIFIPasswordWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed004200";
    [centralManager addTaskWithTaskID:mk_ch_taskReadWIFIPasswordOperation
                       characteristic:peripheral.ch_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)ch_readWIFIEAPTypeWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed004300";
    [centralManager addTaskWithTaskID:mk_ch_taskReadWIFIEAPTypeOperation
                       characteristic:peripheral.ch_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)ch_readWIFIEAPUsernameWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed004400";
    [centralManager addTaskWithTaskID:mk_ch_taskReadWIFIEAPUsernameOperation
                       characteristic:peripheral.ch_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)ch_readWIFIEAPPasswordWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed004500";
    [centralManager addTaskWithTaskID:mk_ch_taskReadWIFIEAPPasswordOperation
                       characteristic:peripheral.ch_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)ch_readWIFIEAPDomainIDWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed004600";
    [centralManager addTaskWithTaskID:mk_ch_taskReadWIFIEAPDomainIDOperation
                       characteristic:peripheral.ch_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)ch_readWIFIVerifyServerStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed004700";
    [centralManager addTaskWithTaskID:mk_ch_taskReadWIFIVerifyServerStatusOperation
                       characteristic:peripheral.ch_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)ch_readWIFIDHCPStatusWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed004b00";
    [centralManager addTaskWithTaskID:mk_ch_taskReadWIFIDHCPStatusOperation
                       characteristic:peripheral.ch_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)ch_readWIFINetworkIpInfosWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed004c00";
    [centralManager addTaskWithTaskID:mk_ch_taskReadWIFINetworkIpInfosOperation
                       characteristic:peripheral.ch_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)ch_readCountryBandWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed005000";
    [centralManager addTaskWithTaskID:mk_ch_taskReadCountryBandOperation
                       characteristic:peripheral.ch_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

@end
