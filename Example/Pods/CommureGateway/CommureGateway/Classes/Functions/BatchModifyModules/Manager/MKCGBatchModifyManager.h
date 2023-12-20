//
//  MKCGBatchModifyManager.h
//  CommureGateway_Example
//
//  Created by aa on 2023/12/14.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCGBatchModifyManager : NSObject

/// 用户从网上文件导入的配置
@property (nonatomic, strong)NSDictionary *params;

+ (MKCGBatchModifyManager *)shared;

+ (void)sharedDealloc;

@end

NS_ASSUME_NONNULL_END
