//
//  MKCGBatchOtaModel.h
//  CommureGateway_Example
//
//  Created by aa on 2023/7/10.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, cg_batchOtaStatus) {
    cg_batchOtaStatus_nornal,           //对应Wait
    cg_batchOtaStatus_upgrading,        //对应Upgrading
    cg_batchOtaStatus_timeout,          //对应timeout
    cg_batchOtaStatus_success,          //对应Success
    cg_batchOtaStatus_failed,           //对应Failed
};

NS_ASSUME_NONNULL_BEGIN

@interface MKCGBatchOtaModel : NSObject

@property (nonatomic, copy)NSString *macAddress;

@property (nonatomic, copy)NSString *subTopic;

@property (nonatomic, copy)NSString *pubTopic;

@property (nonatomic, copy)NSString *filePath;

- (void)otaWithResultBlock:(void (^)(NSString *macAddress, cg_batchOtaStatus status))block;

@end

NS_ASSUME_NONNULL_END
