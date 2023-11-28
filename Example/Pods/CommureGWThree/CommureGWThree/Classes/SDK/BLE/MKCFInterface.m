//
//  MKCFInterface.m
//  CommureGWThree_Example
//
//  Created by aa on 2023/1/29.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCFInterface.h"

#import "MKBLEBaseSDKDefines.h"
#import "MKBLEBaseSDKAdopter.h"

#import "MKCFCentralManager.h"
#import "MKCFOperationID.h"
#import "MKCFOperation.h"
#import "CBPeripheral+MKCFAdd.h"
#import "MKCFSDKDataAdopter.h"

#define centralManager [MKCFCentralManager shared]
#define peripheral ([MKCFCentralManager shared].peripheral)

@implementation MKCFInterface

#pragma mark **********************Device Service Information************************

+ (void)cf_readDeviceModelWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_cf_taskReadDeviceModelOperation
                           characteristic:peripheral.cf_deviceModel
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)cf_readFirmwareWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_cf_taskReadFirmwareOperation
                           characteristic:peripheral.cf_firmware
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)cf_readHardwareWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_cf_taskReadHardwareOperation
                           characteristic:peripheral.cf_hardware
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)cf_readSoftwareWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_cf_taskReadSoftwareOperation
                           characteristic:peripheral.cf_software
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)cf_readManufacturerWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_cf_taskReadManufacturerOperation
                           characteristic:peripheral.cf_manufacturer
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

#pragma mark *******************************自定义协议读取*****************************************

#pragma mark *********************System Params************************

+ (void)cf_readDeviceNameWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed000500";
    [centralManager addTaskWithTaskID:mk_cf_taskReadDeviceNameOperation
                       characteristic:peripheral.cf_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cf_readMacAddressWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed000900";
    [centralManager addTaskWithTaskID:mk_cf_taskReadDeviceMacAddressOperation
                       characteristic:peripheral.cf_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cf_readDeviceWifiSTAMacAddressWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed000a00";
    [centralManager addTaskWithTaskID:mk_cf_taskReadDeviceWifiSTAMacAddressOperation
                       characteristic:peripheral.cf_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cf_readNTPServerHostWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed001100";
    [centralManager addTaskWithTaskID:mk_cf_taskReadNTPServerHostOperation
                       characteristic:peripheral.cf_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cf_readTimeZoneWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed001200";
    [centralManager addTaskWithTaskID:mk_cf_taskReadTimeZoneOperation
                       characteristic:peripheral.cf_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

#pragma mark *********************MQTT Params************************

+ (void)cf_readServerHostWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed002000";
    [centralManager addTaskWithTaskID:mk_cf_taskReadServerHostOperation
                       characteristic:peripheral.cf_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cf_readServerPortWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed002100";
    [centralManager addTaskWithTaskID:mk_cf_taskReadServerPortOperation
                       characteristic:peripheral.cf_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cf_readClientIDWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed002200";
    [centralManager addTaskWithTaskID:mk_cf_taskReadClientIDOperation
                       characteristic:peripheral.cf_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cf_readServerUserNameWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ee002300";
    [centralManager addTaskWithTaskID:mk_cf_taskReadServerUserNameOperation
                       characteristic:peripheral.cf_custom
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

+ (void)cf_readServerPasswordWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ee002400";
    [centralManager addTaskWithTaskID:mk_cf_taskReadServerPasswordOperation
                       characteristic:peripheral.cf_custom
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

+ (void)cf_readServerCleanSessionWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed002500";
    [centralManager addTaskWithTaskID:mk_cf_taskReadServerCleanSessionOperation
                       characteristic:peripheral.cf_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cf_readServerKeepAliveWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed002600";
    [centralManager addTaskWithTaskID:mk_cf_taskReadServerKeepAliveOperation
                       characteristic:peripheral.cf_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cf_readServerQosWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed002700";
    [centralManager addTaskWithTaskID:mk_cf_taskReadServerQosOperation
                       characteristic:peripheral.cf_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cf_readSubscibeTopicWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed002800";
    [centralManager addTaskWithTaskID:mk_cf_taskReadSubscibeTopicOperation
                       characteristic:peripheral.cf_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cf_readPublishTopicWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed002900";
    [centralManager addTaskWithTaskID:mk_cf_taskReadPublishTopicOperation
                       characteristic:peripheral.cf_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cf_readConnectModeWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed002f00";
    [centralManager addTaskWithTaskID:mk_cf_taskReadConnectModeOperation
                       characteristic:peripheral.cf_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}









+ (void)cf_readWIFISecurityWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed004000";
    [centralManager addTaskWithTaskID:mk_cf_taskReadWIFISecurityOperation
                       characteristic:peripheral.cf_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cf_readWIFISSIDWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed004100";
    [centralManager addTaskWithTaskID:mk_cf_taskReadWIFISSIDOperation
                       characteristic:peripheral.cf_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cf_readWIFIPasswordWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed004200";
    [centralManager addTaskWithTaskID:mk_cf_taskReadWIFIPasswordOperation
                       characteristic:peripheral.cf_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cf_readWIFIEAPTypeWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed004300";
    [centralManager addTaskWithTaskID:mk_cf_taskReadWIFIEAPTypeOperation
                       characteristic:peripheral.cf_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cf_readWIFIEAPUsernameWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed004400";
    [centralManager addTaskWithTaskID:mk_cf_taskReadWIFIEAPUsernameOperation
                       characteristic:peripheral.cf_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cf_readWIFIEAPPasswordWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed004500";
    [centralManager addTaskWithTaskID:mk_cf_taskReadWIFIEAPPasswordOperation
                       characteristic:peripheral.cf_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cf_readWIFIEAPDomainIDWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed004600";
    [centralManager addTaskWithTaskID:mk_cf_taskReadWIFIEAPDomainIDOperation
                       characteristic:peripheral.cf_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cf_readWIFIVerifyServerStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed004700";
    [centralManager addTaskWithTaskID:mk_cf_taskReadWIFIVerifyServerStatusOperation
                       characteristic:peripheral.cf_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cf_readWIFIDHCPStatusWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed004b00";
    [centralManager addTaskWithTaskID:mk_cf_taskReadWIFIDHCPStatusOperation
                       characteristic:peripheral.cf_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cf_readWIFINetworkIpInfosWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed004c00";
    [centralManager addTaskWithTaskID:mk_cf_taskReadWIFINetworkIpInfosOperation
                       characteristic:peripheral.cf_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cf_readNetworkTypeWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed004d00";
    [centralManager addTaskWithTaskID:mk_cf_taskReadNetworkTypeOperation
                       characteristic:peripheral.cf_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cf_readEthernetDHCPStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed004e00";
    [centralManager addTaskWithTaskID:mk_cf_taskReadEthernetDHCPStatusOperation
                       characteristic:peripheral.cf_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)cf_readEthernetNetworkIpInfosWithSucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed004f00";
    [centralManager addTaskWithTaskID:mk_cf_taskReadEthernetNetworkIpInfosOperation
                       characteristic:peripheral.cf_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

@end
