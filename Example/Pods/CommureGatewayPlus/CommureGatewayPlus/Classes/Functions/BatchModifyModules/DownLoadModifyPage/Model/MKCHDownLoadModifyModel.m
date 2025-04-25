//
//  MKCHDownLoadModifyModel.m
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/12/14.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import "MKCHDownLoadModifyModel.h"
#import "MKMacroDefines.h"
#import "MKCHExcelDataManager.h"

@interface MKCHDownLoadModifyModel ()

@property (nonatomic, strong) NSURLSession *urlSession;
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;

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
    
    NSURL *url = [NSURL fileURLWithPath:excelPath];
    
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
    if (!url) {
        return NO;
    }
    
    NSURLSessionDownloadTask *downloadTask = [self.urlSession downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSError *fileError = nil;
            
            // Remove existing file if it exists
            if ([fileManager fileExistsAtPath:localPath]) {
                [fileManager removeItemAtPath:localPath error:&fileError];
                if (fileError) {
                    NSLog(@"Error removing existing file: %@", fileError);
                }
            }
            
            // Move the downloaded file to the desired location
            if (!fileError) {
                [fileManager moveItemAtURL:location toURL:[NSURL fileURLWithPath:localPath] error:&fileError];
                if (!fileError) {
                    success = YES;
                }
            }
        }
        dispatch_semaphore_signal(self.semaphore);
    }];
    
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
        });
    }
}

#pragma mark - getter
- (NSURLSession *)urlSession {
    if (!_urlSession) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _urlSession = [NSURLSession sessionWithConfiguration:configuration];
    }
    return _urlSession;
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
