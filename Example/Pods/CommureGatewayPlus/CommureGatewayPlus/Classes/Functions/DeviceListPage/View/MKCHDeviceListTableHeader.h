//
//  MKCHDeviceListTableHeader.h
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/12/14.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKCHDeviceListTableHeaderDelegate <NSObject>

/// 过滤
/// - Parameter type: 0:All   1:Online
- (void)ch_deviceListFilter:(NSInteger)type;

@end

@interface MKCHDeviceListTableHeader : UIView

@property (nonatomic, weak)id <MKCHDeviceListTableHeaderDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
