//
//  MKCHBatchModifyModel.h
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/12/14.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ch_batchModifyStatus) {
    ch_batchModifyStatus_nornal,           //对应Wait
    ch_batchModifyStatus_upgrading,        //对应Upgrading
    ch_batchModifyStatus_timeout,          //对应timeout
    ch_batchModifyStatus_success,          //对应Success
    ch_batchModifyStatus_failed,           //对应Failed
};

@interface MKCHBatchModifyModel : NSObject

@property (nonatomic, copy)NSString *subTopic;

@property (nonatomic, copy)NSString *pubTopic;

- (void)configDataWithMacList:(NSArray <NSString *>*)macList
                progressBlock:(void (^)(NSString *macAddress,ch_batchModifyStatus status))progressBlock
                completeBlock:(void (^)(void))completeBlock;

@end

NS_ASSUME_NONNULL_END
