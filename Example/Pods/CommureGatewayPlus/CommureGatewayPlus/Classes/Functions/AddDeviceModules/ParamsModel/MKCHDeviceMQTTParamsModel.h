//
//  MKCHDeviceMQTTParamsModel.h
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/1/29.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MKCHDeviceModel;
@interface MKCHDeviceMQTTParamsModel : NSObject

@property (nonatomic, assign)BOOL wifiConfig;

@property (nonatomic, assign)BOOL mqttConfig;

@property (nonatomic, strong)MKCHDeviceModel *deviceModel;

/// 是否是从cloud下载了配置文件，如果下载了，就不需要再从设备端蓝牙读取了
@property (nonatomic, assign)BOOL cloud;

/// 用户从网上文件导入的配置
@property (nonatomic, strong)NSDictionary *params;

+ (MKCHDeviceMQTTParamsModel *)shared;

+ (void)sharedDealloc;

@end

NS_ASSUME_NONNULL_END
