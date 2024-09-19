//
//  MKCHExcelDataManager.h
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/2/7.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKCHExcelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKCHExcelDataManager : NSObject

+ (void)exportAppExcel:(id <MKCHExcelAppProtocol>)protocol
              sucBlock:(void(^)(void))sucBlock
           failedBlock:(void(^)(NSError *error))failedBlock;

+ (void)parseAppExcel:(NSString *)excelName
             sucBlock:(void (^)(NSDictionary *returnData))sucBlock
          failedBlock:(void (^)(NSError *error))failedBlock;

+ (void)exportDeviceExcel:(id <MKCHExcelDeviceProtocol>)protocol
                 sucBlock:(void(^)(void))sucBlock
              failedBlock:(void(^)(NSError *error))failedBlock;

+ (void)parseDeviceExcel:(NSString *)excelName
                sucBlock:(void (^)(NSDictionary *returnData))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock;

+ (void)parseBeaconExcel:(NSString *)excelName
                sucBlock:(void (^)(NSArray <NSDictionary *>*beaconInfoList))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock;

+ (void)parseBeaconOtaExcel:(NSString *)excelName
                   sucBlock:(void (^)(NSArray <NSString *>*beaconList))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock;


+ (void)parseDeviceAllParams:(NSURL *)filePath 
                    sucBlock:(void (^)(NSDictionary *returnData))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
