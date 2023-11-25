//
//  MKCGInterface.m
//  CommureGateway_Example
//
//  Created by aa on 2023/1/29.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCGInterface.h"

#import "MKBLEBaseSDKDefines.h"
#import "MKBLEBaseSDKAdopter.h"

#import "MKCGCentralManager.h"
#import "MKCGOperationID.h"
#import "MKCGOperation.h"
#import "CBPeripheral+MKCGAdd.h"
#import "MKCGSDKDataAdopter.h"

#define centralManager [MKCGCentralManager shared]
#define peripheral ([MKCGCentralManager shared].peripheral)

@implementation MKCGInterface

#pragma mark **********************Device Service Information************************

+ (void)cg_readDeviceModelWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_cg_taskReadDeviceModelOperation
                           characteristic:peripheral.cg_deviceModel
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)cg_readFirmwareWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_cg_taskReadFirmwareOperation
                           characteristic:peripheral.cg_firmware
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)cg_readHardwareWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_cg_taskReadHardwareOperation
                           characteristic:peripheral.cg_hardware
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)cg_readSoftwareWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_cg_taskReadSoftwareOperation
                           characteristic:peripheral.cg_software
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)cg_readManufacturerWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_cg_taskReadManufacturerOperation
                           characteristic:peripheral.cg_manufacturer
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

#pragma mark *******************************自定义协议读取*****************************************

#pragma mark *********************System Params************************

+ (void)cg_readDeviceNameWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed000500";
    [centralManager addTaskWithTaskID:mk_cg_taskReadDeviceNameOperation
                       characteristic:peripheral.cg_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cg_readMacAddressWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed000900";
    [centralManager addTaskWithTaskID:mk_cg_taskReadDeviceMacAddressOperation
                       characteristic:peripheral.cg_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cg_readDeviceWifiSTAMacAddressWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed000a00";
    [centralManager addTaskWithTaskID:mk_cg_taskReadDeviceWifiSTAMacAddressOperation
                       characteristic:peripheral.cg_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cg_readNTPServerHostWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed001100";
    [centralManager addTaskWithTaskID:mk_cg_taskReadNTPServerHostOperation
                       characteristic:peripheral.cg_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cg_readTimeZoneWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed001200";
    [centralManager addTaskWithTaskID:mk_cg_taskReadTimeZoneOperation
                       characteristic:peripheral.cg_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

#pragma mark *********************MQTT Params************************

+ (void)cg_readServerHostWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed002000";
    [centralManager addTaskWithTaskID:mk_cg_taskReadServerHostOperation
                       characteristic:peripheral.cg_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cg_readServerPortWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed002100";
    [centralManager addTaskWithTaskID:mk_cg_taskReadServerPortOperation
                       characteristic:peripheral.cg_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cg_readClientIDWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed002200";
    [centralManager addTaskWithTaskID:mk_cg_taskReadClientIDOperation
                       characteristic:peripheral.cg_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cg_readServerUserNameWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ee002300";
    [centralManager addTaskWithTaskID:mk_cg_taskReadServerUserNameOperation
                       characteristic:peripheral.cg_custom
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

+ (void)cg_readServerPasswordWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ee002400";
    [centralManager addTaskWithTaskID:mk_cg_taskReadServerPasswordOperation
                       characteristic:peripheral.cg_custom
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

+ (void)cg_readServerCleanSessionWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed002500";
    [centralManager addTaskWithTaskID:mk_cg_taskReadServerCleanSessionOperation
                       characteristic:peripheral.cg_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cg_readServerKeepAliveWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed002600";
    [centralManager addTaskWithTaskID:mk_cg_taskReadServerKeepAliveOperation
                       characteristic:peripheral.cg_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cg_readServerQosWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed002700";
    [centralManager addTaskWithTaskID:mk_cg_taskReadServerQosOperation
                       characteristic:peripheral.cg_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cg_readSubscibeTopicWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed002800";
    [centralManager addTaskWithTaskID:mk_cg_taskReadSubscibeTopicOperation
                       characteristic:peripheral.cg_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cg_readPublishTopicWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed002900";
    [centralManager addTaskWithTaskID:mk_cg_taskReadPublishTopicOperation
                       characteristic:peripheral.cg_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cg_readConnectModeWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed002f00";
    [centralManager addTaskWithTaskID:mk_cg_taskReadConnectModeOperation
                       characteristic:peripheral.cg_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}









+ (void)cg_readWIFISecurityWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed004000";
    [centralManager addTaskWithTaskID:mk_cg_taskReadWIFISecurityOperation
                       characteristic:peripheral.cg_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cg_readWIFISSIDWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed004100";
    [centralManager addTaskWithTaskID:mk_cg_taskReadWIFISSIDOperation
                       characteristic:peripheral.cg_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cg_readWIFIPasswordWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed004200";
    [centralManager addTaskWithTaskID:mk_cg_taskReadWIFIPasswordOperation
                       characteristic:peripheral.cg_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cg_readWIFIEAPTypeWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed004300";
    [centralManager addTaskWithTaskID:mk_cg_taskReadWIFIEAPTypeOperation
                       characteristic:peripheral.cg_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cg_readWIFIEAPUsernameWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed004400";
    [centralManager addTaskWithTaskID:mk_cg_taskReadWIFIEAPUsernameOperation
                       characteristic:peripheral.cg_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cg_readWIFIEAPPasswordWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed004500";
    [centralManager addTaskWithTaskID:mk_cg_taskReadWIFIEAPPasswordOperation
                       characteristic:peripheral.cg_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cg_readWIFIEAPDomainIDWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed004600";
    [centralManager addTaskWithTaskID:mk_cg_taskReadWIFIEAPDomainIDOperation
                       characteristic:peripheral.cg_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cg_readWIFIVerifyServerStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed004700";
    [centralManager addTaskWithTaskID:mk_cg_taskReadWIFIVerifyServerStatusOperation
                       characteristic:peripheral.cg_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cg_readWIFIDHCPStatusWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed004b00";
    [centralManager addTaskWithTaskID:mk_cg_taskReadWIFIDHCPStatusOperation
                       characteristic:peripheral.cg_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cg_readWIFINetworkIpInfosWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed004c00";
    [centralManager addTaskWithTaskID:mk_cg_taskReadWIFINetworkIpInfosOperation
                       characteristic:peripheral.cg_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cg_readNetworkTypeWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed004d00";
    [centralManager addTaskWithTaskID:mk_cg_taskReadNetworkTypeOperation
                       characteristic:peripheral.cg_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cg_readEthernetDHCPStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed004e00";
    [centralManager addTaskWithTaskID:mk_cg_taskReadEthernetDHCPStatusOperation
                       characteristic:peripheral.cg_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cg_readEthernetNetworkIpInfosWithSucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed004f00";
    [centralManager addTaskWithTaskID:mk_cg_taskReadEthernetNetworkIpInfosOperation
                       characteristic:peripheral.cg_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

@end
