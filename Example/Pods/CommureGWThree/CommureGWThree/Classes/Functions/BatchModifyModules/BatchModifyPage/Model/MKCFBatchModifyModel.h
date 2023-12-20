//
//  MKCFBatchModifyModel.h
//  CommureGWThree_Example
//
//  Created by aa on 2023/12/14.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, cf_batchModifyStatus) {
    cf_batchModifyStatus_nornal,           //对应Wait
    cf_batchModifyStatus_upgrading,        //对应Upgrading
    cf_batchModifyStatus_timeout,          //对应timeout
    cf_batchModifyStatus_success,          //对应Success
    cf_batchModifyStatus_failed,           //对应Failed
};

@interface MKCFBatchModifyModel : NSObject

@property (nonatomic, copy)NSString *subTopic;

@property (nonatomic, copy)NSString *pubTopic;

- (void)configDataWithMacList:(NSArray <NSString *>*)macList
                progressBlock:(void (^)(NSString *macAddress,cf_batchModifyStatus status))progressBlock
                completeBlock:(void (^)(void))completeBlock;

@end

NS_ASSUME_NONNULL_END
