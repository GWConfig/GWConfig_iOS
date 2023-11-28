//
//  MKCFModifyNetworkDataModel.h
//  CommureGWThree_Example
//
//  Created by aa on 2023/11/23.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCFModifyNetworkDataModel : NSObject

/// 是否是从cloud下载了配置文件，如果下载了，就不需要再从设备端MQTT读取了
@property (nonatomic, assign)BOOL cloud;

/// 用户从网上文件导入的配置
@property (nonatomic, strong)NSDictionary *params;

+ (MKCFModifyNetworkDataModel *)shared;

+ (void)sharedDealloc;

@end

NS_ASSUME_NONNULL_END
