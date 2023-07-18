//
//  Target_Commure_Module.h
//  MKCommureApp_Example
//
//  Created by aa on 2023/2/16.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Target_Commure_Module : NSObject

/// 设备列表页面
/// @param params @{}
- (UIViewController *)Action_Commure_DeviceListPage:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
