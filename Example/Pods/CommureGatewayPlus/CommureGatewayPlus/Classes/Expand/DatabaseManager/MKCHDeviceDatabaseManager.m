//
//  MKCHDeviceDatabaseManager.m
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/1/29.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCHDeviceDatabaseManager.h"

#import <FMDB/FMDB.h>

#import "MKMacroDefines.h"

#import "MKCHDeviceModel.h"

@implementation MKCHDeviceDatabaseManager

+ (BOOL)initDataBase {
    FMDatabase* db = [FMDatabase databaseWithPath:kFilePath(@"CGDeviceDB")];
    if (![db open]) {
        return NO;
    }
    NSString *sqlCreateTable = [NSString stringWithFormat:@"create table if not exists CGDeviceTable (deviceType text,clientID text,deviceName text,subscribedTopic text,publishedTopic text,macAddress text)"];
    BOOL resCreate = [db executeUpdate:sqlCreateTable];
    if (!resCreate) {
        [db close];
        return NO;
    }
    return YES;
}

+ (void)insertDeviceList:(NSArray <MKCHDeviceModel *>*)deviceList
                sucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock {
    if (!deviceList) {
        [self operationInsertFailedBlock:failedBlock];
        return ;
    }
    FMDatabase* db = [FMDatabase databaseWithPath:kFilePath(@"CGDeviceDB")];
    if (![db open]) {
        [self operationInsertFailedBlock:failedBlock];
        return;
    }
    NSString *sqlCreateTable = [NSString stringWithFormat:@"create table if not exists CGDeviceTable (deviceType text,clientID text,deviceName text,subscribedTopic text,publishedTopic text,macAddress text)"];
    BOOL resCreate = [db executeUpdate:sqlCreateTable];
    if (!resCreate) {
        [db close];
        [self operationInsertFailedBlock:failedBlock];
        return;
    }
    [[FMDatabaseQueue databaseQueueWithPath:kFilePath(@"CGDeviceDB")] inDatabase:^(FMDatabase *db) {
        
        for (MKCHDeviceModel *device in deviceList) {
            BOOL exist = NO;
            FMResultSet * result = [db executeQuery:@"select * from CGDeviceTable where macAddress = ?",device.macAddress];
            while (result.next) {
                if ([device.macAddress isEqualToString:[result stringForColumn:@"macAddress"]]) {
                    exist = YES;
                }
            }
            if (exist) {
                //存在该设备，更新设备
                [db executeUpdate:@"UPDATE CGDeviceTable SET deviceType = ?, clientID = ?, deviceName = ? ,subscribedTopic = ? ,publishedTopic = ? WHERE macAddress = ?",SafeStr(device.deviceType),SafeStr(device.clientID),SafeStr(device.deviceName),SafeStr(device.subscribedTopic),SafeStr(device.publishedTopic),SafeStr(device.macAddress)];
            }else{
                //不存在，插入设备
                [db executeUpdate:@"INSERT INTO CGDeviceTable (deviceType,clientID,deviceName,subscribedTopic,publishedTopic,macAddress) VALUES (?,?,?,?,?,?)",SafeStr(device.deviceType),SafeStr(device.clientID),SafeStr(device.deviceName),SafeStr(device.subscribedTopic),SafeStr(device.publishedTopic),SafeStr(device.macAddress)];
            }
        }
        
        if (sucBlock) {
            moko_dispatch_main_safe(^{
                sucBlock();
            });
        }
        [db close];
    }];
}

+ (void)deleteDeviceWithMacAddress:(NSString *)macAddress
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    if (!ValidStr(macAddress)) {
        [self operationDeleteFailedBlock:failedBlock];
        return;
    }
    
    [[FMDatabaseQueue databaseQueueWithPath:kFilePath(@"CGDeviceDB")] inDatabase:^(FMDatabase *db) {
        
        BOOL result = [db executeUpdate:@"DELETE FROM CGDeviceTable WHERE macAddress = ?",macAddress];
        if (!result) {
            [self operationDeleteFailedBlock:failedBlock];
            return;
        }
        if (sucBlock) {
            moko_dispatch_main_safe(^{
                sucBlock();
            });
        }
        [db close];
    }];
}

+ (void)readLocalDeviceWithSucBlock:(void (^)(NSArray <MKCHDeviceModel *> *deviceList))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    FMDatabase* db = [FMDatabase databaseWithPath:kFilePath(@"CGDeviceDB")];
    if (![db open]) {
        [self operationGetDataFailedBlock:failedBlock];
        return;
    }
    [[FMDatabaseQueue databaseQueueWithPath:kFilePath(@"CGDeviceDB")] inDatabase:^(FMDatabase *db) {
        NSMutableArray *tempDataList = [NSMutableArray array];
        FMResultSet * result = [db executeQuery:@"SELECT * FROM CGDeviceTable"];
        while ([result next]) {
            MKCHDeviceModel *dataModel = [[MKCHDeviceModel alloc] init];
            dataModel.clientID = [result stringForColumn:@"clientID"];
            dataModel.deviceName = [result stringForColumn:@"deviceName"];
            dataModel.subscribedTopic = [result stringForColumn:@"subscribedTopic"];
            dataModel.publishedTopic = [result stringForColumn:@"publishedTopic"];
            dataModel.macAddress = [result stringForColumn:@"macAddress"];
            dataModel.deviceType = [result stringForColumn:@"deviceType"];
        
            [tempDataList addObject:dataModel];
        }
        if (sucBlock) {
            moko_dispatch_main_safe(^{
                sucBlock(tempDataList);
            });
        }
        [db close];
    }];
}

+ (void)updateLocalName:(NSString *)localName
             macAddress:(NSString *)macAddress
               sucBlock:(void (^)(void))sucBlock
            failedBlock:(void (^)(NSError *error))failedBlock {
    if (!ValidStr(localName) || !ValidStr(macAddress)) {
        [self operationDeleteFailedBlock:failedBlock];
        return;
    }
    FMDatabase* db = [FMDatabase databaseWithPath:kFilePath(@"CGDeviceDB")];
    if (![db open]) {
        [self operationInsertFailedBlock:failedBlock];
        return;
    }
    [[FMDatabaseQueue databaseQueueWithPath:kFilePath(@"CGDeviceDB")] inDatabase:^(FMDatabase *db) {
        
        BOOL exist = NO;
        FMResultSet * result = [db executeQuery:@"select * from CGDeviceTable where macAddress = ?",macAddress];
        while (result.next) {
            if ([macAddress isEqualToString:[result stringForColumn:@"macAddress"]]) {
                exist = YES;
            }
        }
        if (!exist) {
            [self operationUpdateFailedBlock:failedBlock];
            [db close];
            return;
        }
        //存在该设备，更新设备
        [db executeUpdate:@"UPDATE CGDeviceTable SET deviceName = ? WHERE macAddress = ?",localName,macAddress];
        if (sucBlock) {
            moko_dispatch_main_safe(^{
                sucBlock();
            });
        }
        [db close];
    }];
}

+ (void)updateClientID:(NSString *)clientID
       subscribedTopic:(NSString *)subscribedTopic
        publishedTopic:(NSString *)publishedTopic
            macAddress:(NSString *)macAddress
              sucBlock:(void (^)(void))sucBlock
           failedBlock:(void (^)(NSError *error))failedBlock {
    if (!ValidStr(clientID) || !ValidStr(macAddress) || !ValidStr(subscribedTopic) || !ValidStr(publishedTopic)) {
        [self operationDeleteFailedBlock:failedBlock];
        return;
    }
    FMDatabase* db = [FMDatabase databaseWithPath:kFilePath(@"CGDeviceDB")];
    if (![db open]) {
        [self operationInsertFailedBlock:failedBlock];
        return;
    }
    [[FMDatabaseQueue databaseQueueWithPath:kFilePath(@"CGDeviceDB")] inDatabase:^(FMDatabase *db) {
        
        BOOL exist = NO;
        FMResultSet * result = [db executeQuery:@"select * from CGDeviceTable where macAddress = ?",macAddress];
        while (result.next) {
            if ([macAddress isEqualToString:[result stringForColumn:@"macAddress"]]) {
                exist = YES;
            }
        }
        if (!exist) {
            [self operationUpdateFailedBlock:failedBlock];
            [db close];
            return;
        }
        //存在该设备，更新设备
        [db executeUpdate:@"UPDATE CGDeviceTable SET clientID = ?, subscribedTopic = ? ,publishedTopic = ? WHERE macAddress = ?",SafeStr(clientID),SafeStr(subscribedTopic),SafeStr(publishedTopic),SafeStr(macAddress)];
        if (sucBlock) {
            moko_dispatch_main_safe(^{
                sucBlock();
            });
        }
        [db close];
    }];
}

+ (void)operationFailedBlock:(void (^)(NSError *error))block msg:(NSString *)msg{
    if (block) {
        NSError *error = [[NSError alloc] initWithDomain:@"com.moko.databaseOperation"
                                                    code:-111111
                                                userInfo:@{@"errorInfo":msg}];
        moko_dispatch_main_safe(^{
            block(error);
        });
    }
}

+ (void)operationInsertFailedBlock:(void (^)(NSError *error))block{
    [self operationFailedBlock:block msg:@"insert data error"];
}

+ (void)operationUpdateFailedBlock:(void (^)(NSError *error))block{
    [self operationFailedBlock:block msg:@"update data error"];
}

+ (void)operationDeleteFailedBlock:(void (^)(NSError *error))block{
    [self operationFailedBlock:block msg:@"fail to delete"];
}

+ (void)operationGetDataFailedBlock:(void (^)(NSError *error))block{
    [self operationFailedBlock:block msg:@"get data error"];
}

@end
