//
//  MKCGDeviceListModel.h
//  CommureGateway_Example
//
//  Created by aa on 2023/2/3.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCGDeviceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKCGDeviceListModel : MKCGDeviceModel

/// rssi
@property (nonatomic, assign)NSInteger wifiLevel;

@end

NS_ASSUME_NONNULL_END
