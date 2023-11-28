//
//  MKCFBleMqttConfigSelectModel.m
//  CommureGWThree_Example
//
//  Created by aa on 2023/11/22.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import "MKCFBleMqttConfigSelectModel.h"

#import <AFNetworking/AFNetworking.h>

#import "MKMacroDefines.h"

#import "MKCFExcelDataManager.h"

@interface MKCFBleMqttConfigSelectModel ()

@property (nonatomic, strong)AFURLSessionManager *manager;

@property (nonatomic, copy)void (^sucBlock)(NSDictionary *params);

@property (nonatomic, copy)void (^failedBlock)(NSError *error);

@property (nonatomic, strong)dispatch_queue_t downloadQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKCFBleMqttConfigSelectModel

- (void)startDownFileWithSucBlock:(void (^)(NSDictionary *params))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    if (self.fileType == 1) {
        //不需要下载
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock(@{});
            }
        });
        return;
    }
    if (self.fileType == 0) {
        if (!ValidStr(self.url)) {
            [self operationFailedBlockWithMsg:@"Url Error" block:failedBlock];
            return;
        }
    }
    
    dispatch_async(self.downloadQueue, ^{
        if (![self downExcelData]) {
            [self operationFailedBlockWithMsg:@"Download Excel Data Failed" block:failedBlock];
            return;
        }
        NSDictionary *excelData = [self parseExcelData];
        if (!ValidDict(excelData)) {
            [self operationFailedBlockWithMsg:@"Parse Excel Data Failed" block:failedBlock];
            return;
        }
        if (![self downCAData:excelData[@"caPath"]]) {
            [self operationFailedBlockWithMsg:@"Download CA Data Failed" block:failedBlock];
            return;
        }
        if (![self downClientCertData:excelData[@"clientCertPath"]]) {
            [self operationFailedBlockWithMsg:@"Download Client Cert Data Failed" block:failedBlock];
            return;
        }
        if (![self downClientKeyData:excelData[@"clientKeyPath"]]) {
            [self operationFailedBlockWithMsg:@"Download Client Key Data Failed" block:failedBlock];
            return;
        }
        if (![self downWifiCAData:excelData[@"wifiCaPath"]]) {
            [self operationFailedBlockWithMsg:@"Download Wifi CA Data Failed" block:failedBlock];
            return;
        }
        if (![self downWifiClientCertData:excelData[@"wifiClientCertPath"]]) {
            [self operationFailedBlockWithMsg:@"Download Wifi Client Cert Failed" block:failedBlock];
            return;
        }
        if (![self downWifiClientKeyData:excelData[@"wifiClientKeyPath"]]) {
            [self operationFailedBlockWithMsg:@"Download Wifi Client Key Failed" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock(excelData);
            }
        });
    });
}

#pragma mark - down method

- (BOOL)downExcelData {
    NSString *excelPath = [self filePathWithName:@"MKGW3 Settings for Device.xlsx"];
    
    if (![self deleteFile:excelPath]) {
        [self operationFailedBlockWithMsg:@"Delete Excel Failed" block:self.failedBlock];
        return NO;
    }
    
    return [self downloadWithPath:self.url filePath:excelPath];
}

- (BOOL)downCAData:(NSString *)filePath {
    NSString *caPath = [self filePathWithName:@"gw3_ca.pem"];
    
    if (![self deleteFile:caPath]) {
        [self operationFailedBlockWithMsg:@"Delete CA Failed" block:self.failedBlock];
        return NO;
    }
    
    return [self downloadWithPath:filePath filePath:caPath];
}

- (BOOL)downClientCertData:(NSString *)filePath {
    NSString *clientCertPath = [self filePathWithName:@"gw3_certificate.pem.crt"];
    
    if (![self deleteFile:clientCertPath]) {
        [self operationFailedBlockWithMsg:@"Delete Client Cert Failed" block:self.failedBlock];
        return NO;
    }
    
    return [self downloadWithPath:filePath filePath:clientCertPath];
}

- (BOOL)downClientKeyData:(NSString *)filePath {
    NSString *clientKeyPath = [self filePathWithName:@"gw3_private.pem.key"];
    
    if (![self deleteFile:clientKeyPath]) {
        [self operationFailedBlockWithMsg:@"Delete Client Key Failed" block:self.failedBlock];
        return NO;
    }
    
    return [self downloadWithPath:filePath filePath:clientKeyPath];
}

- (BOOL)downWifiCAData:(NSString *)filePath {
    NSString *wifiCaPath = [self filePathWithName:@"gw3_wifi_ca.pem"];
    
    if (![self deleteFile:wifiCaPath]) {
        [self operationFailedBlockWithMsg:@"Delete Wifi CA Failed" block:self.failedBlock];
        return NO;
    }
    
    return [self downloadWithPath:filePath filePath:wifiCaPath];
}

- (BOOL)downWifiClientCertData:(NSString *)filePath {
    NSString *wifiClientCertPath = [self filePathWithName:@"gw3_wifi_client.crt"];
    
    if (![self deleteFile:wifiClientCertPath]) {
        [self operationFailedBlockWithMsg:@"Delete Wifi Client Cert Failed" block:self.failedBlock];
        return NO;
    }
    
    return [self downloadWithPath:filePath filePath:wifiClientCertPath];
}

- (BOOL)downWifiClientKeyData:(NSString *)filePath {
    NSString *wifiClientKeyPath = [self filePathWithName:@"gw3_wifi_client.key"];
    
    if (![self deleteFile:wifiClientKeyPath]) {
        [self operationFailedBlockWithMsg:@"Delete Wifi Client Key Failed" block:self.failedBlock];
        return NO;
    }
    
    return [self downloadWithPath:filePath filePath:wifiClientKeyPath];
}

- (NSDictionary *)parseExcelData {
    __block NSDictionary *result = nil;
    NSString *excelPath = [self filePathWithName:@"MKGW3 Settings for Device.xlsx"];
    
    NSURL *url = [NSURL URLWithString:excelPath];
    
    [MKCFExcelDataManager parseDeviceAllParams:url sucBlock:^(NSDictionary * _Nonnull returnData) {
        NSLog(@"%@",returnData);
        result = returnData;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return result;
}

- (NSString *)filePathWithName:(NSString *)fileName {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:fileName];
}

- (BOOL)deleteFile:(NSString *)filePath {
    // 检查本地文件是否存在，如果存在则删除
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:filePath]) {
        NSError *error;
        [fileManager removeItemAtPath:filePath error:&error];
        if (error) {
            NSLog(@"删除本地文件失败：%@", error);
            return NO;
        }
    }
    return YES;
}

- (BOOL)downloadWithPath:(NSString *)path filePath:(NSString *)localPath {
    
    __block BOOL success = NO;
    
    NSURL *url = [NSURL URLWithString:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    @weakify(self);
    NSURLSessionDownloadTask *downloadTask = [self.manager downloadTaskWithRequest:request progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        // 指定文件的保存路径
            return [NSURL fileURLWithPath:localPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        @strongify(self);
        if (!error) {
            success = YES;
        }
        NSLog(@"下载完成，文件保存在：%@", localPath);
        dispatch_semaphore_signal(self.semaphore);
    }];
    
    // 开始下载任务
    [downloadTask resume];
    
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - private method
- (void)operationFailedBlockWithMsg:(NSString *)msg block:(void (^)(NSError *error))block {
    if (block) {
        moko_dispatch_main_safe(^{
            NSError *error = [[NSError alloc] initWithDomain:@"DownTask"
                                                        code:-999
                                                    userInfo:@{@"errorInfo":msg}];
            block(error);
        })
    }
}

#pragma mark - getter
- (AFURLSessionManager *)manager {
    if (!_manager) {
        _manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return _manager;
}

- (dispatch_semaphore_t)semaphore {
    if (!_semaphore) {
        _semaphore = dispatch_semaphore_create(0);
    }
    return _semaphore;
}

- (dispatch_queue_t)downloadQueue {
    if (!_downloadQueue) {
        _downloadQueue = dispatch_queue_create("DownTaskQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _downloadQueue;
}

@end
