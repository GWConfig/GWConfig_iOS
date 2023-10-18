//
//  MKCMBleWifiSettingsController.h
//  MKCommureApp_Example
//
//  Created by aa on 2023/1/30.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCMBleBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKCMBleWifiSettingsController : MKCMBleBaseController

/// 是否支持Country&Band
@property (nonatomic, assign)BOOL supportBand;

@end

NS_ASSUME_NONNULL_END
