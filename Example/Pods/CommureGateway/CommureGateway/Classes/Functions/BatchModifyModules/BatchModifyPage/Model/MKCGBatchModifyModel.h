//
//  MKCGBatchModifyModel.h
//  CommureGateway_Example
//
//  Created by aa on 2023/12/14.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, cg_batchModifyStatus) {
    cg_batchModifyStatus_nornal,           //对应Wait
    cg_batchModifyStatus_upgrading,        //对应Upgrading
    cg_batchModifyStatus_timeout,          //对应timeout
    cg_batchModifyStatus_success,          //对应Success
    cg_batchModifyStatus_failed,           //对应Failed
};

@interface MKCGBatchModifyModel : NSObject

@property (nonatomic, copy)NSString *subTopic;

@property (nonatomic, copy)NSString *pubTopic;

- (void)configDataWithMacList:(NSArray <NSString *>*)macList
                progressBlock:(void (^)(NSString *macAddress,cg_batchModifyStatus status))progressBlock
                completeBlock:(void (^)(void))completeBlock;

@end

NS_ASSUME_NONNULL_END
