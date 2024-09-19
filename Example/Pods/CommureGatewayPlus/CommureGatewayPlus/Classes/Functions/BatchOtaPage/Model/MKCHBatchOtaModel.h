//
//  MKCHBatchOtaModel.h
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/7/10.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ch_batchOtaStatus) {
    ch_batchOtaStatus_nornal,           //对应Wait
    ch_batchOtaStatus_upgrading,        //对应Upgrading
    ch_batchOtaStatus_timeout,          //对应timeout
    ch_batchOtaStatus_success,          //对应Success
    ch_batchOtaStatus_failed,           //对应Failed
};

NS_ASSUME_NONNULL_BEGIN

@interface MKCHBatchOtaModel : NSObject

@property (nonatomic, copy)NSString *macAddress;

@property (nonatomic, copy)NSString *subTopic;

@property (nonatomic, copy)NSString *pubTopic;

@property (nonatomic, copy)NSString *filePath;

- (void)otaWithResultBlock:(void (^)(NSString *macAddress, ch_batchOtaStatus status))block;

@end

NS_ASSUME_NONNULL_END
