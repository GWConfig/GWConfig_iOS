//
//  MKCFBatchOtaModel.h
//  CommureGWThree_Example
//
//  Created by aa on 2023/7/10.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, cf_batchOtaStatus) {
    cf_batchOtaStatus_nornal,           //对应Wait
    cf_batchOtaStatus_upgrading,        //对应Upgrading
    cf_batchOtaStatus_timeout,          //对应timeout
    cf_batchOtaStatus_success,          //对应Success
    cf_batchOtaStatus_failed,           //对应Failed
};

NS_ASSUME_NONNULL_BEGIN

@interface MKCFBatchOtaModel : NSObject

@property (nonatomic, copy)NSString *macAddress;

@property (nonatomic, copy)NSString *subTopic;

@property (nonatomic, copy)NSString *pubTopic;

@property (nonatomic, copy)NSString *filePath;

- (void)otaWithResultBlock:(void (^)(NSString *macAddress, cf_batchOtaStatus status))block;

@end

NS_ASSUME_NONNULL_END
