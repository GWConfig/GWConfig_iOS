//
//  MKCMDeviceListModel.h
//  MKCommureApp_Example
//
//  Created by aa on 2023/2/3.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCMDeviceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKCMDeviceListModel : MKCMDeviceModel

/// rssi
@property (nonatomic, assign)NSInteger wifiLevel;

@end

NS_ASSUME_NONNULL_END
