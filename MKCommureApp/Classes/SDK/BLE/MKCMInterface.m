//
//  MKCMInterface.m
//  MKCommureApp_Example
//
//  Created by aa on 2023/1/29.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCMInterface.h"

#import "MKBLEBaseSDKDefines.h"
#import "MKBLEBaseSDKAdopter.h"

#import "MKCMCentralManager.h"
#import "MKCMOperationID.h"
#import "MKCMOperation.h"
#import "CBPeripheral+MKCMAdd.h"
#import "MKCMSDKDataAdopter.h"

#define centralManager [MKCMCentralManager shared]
#define peripheral ([MKCMCentralManager shared].peripheral)

@implementation MKCMInterface

#pragma mark **********************Device Service Information************************

+ (void)cm_readDeviceModelWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_cm_taskReadDeviceModelOperation
                           characteristic:peripheral.cm_deviceModel
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)cm_readFirmwareWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_cm_taskReadFirmwareOperation
                           characteristic:peripheral.cm_firmware
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)cm_readHardwareWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_cm_taskReadHardwareOperation
                           characteristic:peripheral.cm_hardware
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)cm_readSoftwareWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_cm_taskReadSoftwareOperation
                           characteristic:peripheral.cm_software
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)cm_readManufacturerWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_cm_taskReadManufacturerOperation
                           characteristic:peripheral.cm_manufacturer
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

#pragma mark *******************************自定义协议读取*****************************************

#pragma mark *********************System Params************************

+ (void)cm_readDeviceNameWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed000500";
    [centralManager addTaskWithTaskID:mk_cm_taskReadDeviceNameOperation
                       characteristic:peripheral.cm_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cm_readMacAddressWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed000900";
    [centralManager addTaskWithTaskID:mk_cm_taskReadDeviceMacAddressOperation
                       characteristic:peripheral.cm_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cm_readDeviceWifiSTAMacAddressWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed000a00";
    [centralManager addTaskWithTaskID:mk_cm_taskReadDeviceWifiSTAMacAddressOperation
                       characteristic:peripheral.cm_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cm_readNTPServerHostWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed001100";
    [centralManager addTaskWithTaskID:mk_cm_taskReadNTPServerHostOperation
                       characteristic:peripheral.cm_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cm_readTimeZoneWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed001200";
    [centralManager addTaskWithTaskID:mk_cm_taskReadTimeZoneOperation
                       characteristic:peripheral.cm_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

#pragma mark *********************MQTT Params************************

+ (void)cm_readServerHostWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed002000";
    [centralManager addTaskWithTaskID:mk_cm_taskReadServerHostOperation
                       characteristic:peripheral.cm_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cm_readServerPortWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed002100";
    [centralManager addTaskWithTaskID:mk_cm_taskReadServerPortOperation
                       characteristic:peripheral.cm_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cm_readClientIDWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed002200";
    [centralManager addTaskWithTaskID:mk_cm_taskReadClientIDOperation
                       characteristic:peripheral.cm_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cm_readServerUserNameWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ee002300";
    [centralManager addTaskWithTaskID:mk_cm_taskReadServerUserNameOperation
                       characteristic:peripheral.cm_custom
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

+ (void)cm_readServerPasswordWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ee002400";
    [centralManager addTaskWithTaskID:mk_cm_taskReadServerPasswordOperation
                       characteristic:peripheral.cm_custom
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

+ (void)cm_readServerCleanSessionWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed002500";
    [centralManager addTaskWithTaskID:mk_cm_taskReadServerCleanSessionOperation
                       characteristic:peripheral.cm_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cm_readServerKeepAliveWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed002600";
    [centralManager addTaskWithTaskID:mk_cm_taskReadServerKeepAliveOperation
                       characteristic:peripheral.cm_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cm_readServerQosWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed002700";
    [centralManager addTaskWithTaskID:mk_cm_taskReadServerQosOperation
                       characteristic:peripheral.cm_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cm_readSubscibeTopicWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed002800";
    [centralManager addTaskWithTaskID:mk_cm_taskReadSubscibeTopicOperation
                       characteristic:peripheral.cm_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cm_readPublishTopicWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed002900";
    [centralManager addTaskWithTaskID:mk_cm_taskReadPublishTopicOperation
                       characteristic:peripheral.cm_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cm_readConnectModeWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed002f00";
    [centralManager addTaskWithTaskID:mk_cm_taskReadConnectModeOperation
                       characteristic:peripheral.cm_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}









+ (void)cm_readWIFISecurityWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed004000";
    [centralManager addTaskWithTaskID:mk_cm_taskReadWIFISecurityOperation
                       characteristic:peripheral.cm_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cm_readWIFISSIDWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed004100";
    [centralManager addTaskWithTaskID:mk_cm_taskReadWIFISSIDOperation
                       characteristic:peripheral.cm_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cm_readWIFIPasswordWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed004200";
    [centralManager addTaskWithTaskID:mk_cm_taskReadWIFIPasswordOperation
                       characteristic:peripheral.cm_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cm_readWIFIEAPTypeWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed004300";
    [centralManager addTaskWithTaskID:mk_cm_taskReadWIFIEAPTypeOperation
                       characteristic:peripheral.cm_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cm_readWIFIEAPUsernameWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed004400";
    [centralManager addTaskWithTaskID:mk_cm_taskReadWIFIEAPUsernameOperation
                       characteristic:peripheral.cm_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cm_readWIFIEAPPasswordWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed004500";
    [centralManager addTaskWithTaskID:mk_cm_taskReadWIFIEAPPasswordOperation
                       characteristic:peripheral.cm_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cm_readWIFIEAPDomainIDWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed004600";
    [centralManager addTaskWithTaskID:mk_cm_taskReadWIFIEAPDomainIDOperation
                       characteristic:peripheral.cm_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cm_readWIFIVerifyServerStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed004700";
    [centralManager addTaskWithTaskID:mk_cm_taskReadWIFIVerifyServerStatusOperation
                       characteristic:peripheral.cm_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cm_readWIFIDHCPStatusWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed004b00";
    [centralManager addTaskWithTaskID:mk_cm_taskReadWIFIDHCPStatusOperation
                       characteristic:peripheral.cm_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cm_readWIFINetworkIpInfosWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed004c00";
    [centralManager addTaskWithTaskID:mk_cm_taskReadWIFINetworkIpInfosOperation
                       characteristic:peripheral.cm_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cm_readNetworkTypeWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed004d00";
    [centralManager addTaskWithTaskID:mk_cm_taskReadNetworkTypeOperation
                       characteristic:peripheral.cm_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cm_readEthernetDHCPStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed004e00";
    [centralManager addTaskWithTaskID:mk_cm_taskReadEthernetDHCPStatusOperation
                       characteristic:peripheral.cm_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cm_readEthernetNetworkIpInfosWithSucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed004f00";
    [centralManager addTaskWithTaskID:mk_cm_taskReadEthernetNetworkIpInfosOperation
                       characteristic:peripheral.cm_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cm_readCountryBandWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed005000";
    [centralManager addTaskWithTaskID:mk_cm_taskReadCountryBandOperation
                       characteristic:peripheral.cm_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

@end
