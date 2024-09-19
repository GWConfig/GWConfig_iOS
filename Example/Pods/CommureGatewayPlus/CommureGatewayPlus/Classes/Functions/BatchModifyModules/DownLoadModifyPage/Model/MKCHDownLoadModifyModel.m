//
//  MKCHDownLoadModifyModel.m
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/12/14.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import "MKCHDownLoadModifyModel.h"

#import <AFNetworking/AFNetworking.h>

#import "MKMacroDefines.h"

#import "MKCHExcelDataManager.h"

@interface MKCHDownLoadModifyModel ()

@property (nonatomic, strong)AFURLSessionManager *manager;

@property (nonatomic, copy)void (^sucBlock)(NSDictionary *params);

@property (nonatomic, copy)void (^failedBlock)(NSError *error);

@property (nonatomic, strong)dispatch_queue_t downloadQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKCHDownLoadModifyModel

- (void)startDownFileWithSucBlock:(void (^)(NSDictionary *params))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    if (!ValidStr(self.url)) {
        [self operationFailedBlockWithMsg:@"Url Error" block:failedBlock];
        return;
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
        
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock(excelData);
            }
        });
    });
}

#pragma mark - down method

- (BOOL)downExcelData {
    NSString *excelPath = [self filePathWithName:@"MK110 MQTT Settings for Device.xlsx"];
    
    if (![self deleteFile:excelPath]) {
        [self operationFailedBlockWithMsg:@"Delete Excel Failed" block:self.failedBlock];
        return NO;
    }
    
    return [self downloadWithPath:self.url filePath:excelPath];
}

- (NSDictionary *)parseExcelData {
    __block NSDictionary *result = nil;
    NSString *excelPath = [self filePathWithName:@"MK110 MQTT Settings for Device.xlsx"];
    
    NSURL *url = [NSURL URLWithString:excelPath];
    
    [MKCHExcelDataManager parseDeviceAllParams:url sucBlock:^(NSDictionary * _Nonnull returnData) {
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
