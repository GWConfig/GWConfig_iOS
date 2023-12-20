//
//  MKCGDeviceListTableHeader.h
//  CommureGateway_Example
//
//  Created by aa on 2023/12/14.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKCGDeviceListTableHeaderDelegate <NSObject>

/// 过滤
/// - Parameter type: 0:All   1:Online
- (void)cg_deviceListFilter:(NSInteger)type;

@end

@interface MKCGDeviceListTableHeader : UIView

@property (nonatomic, weak)id <MKCGDeviceListTableHeaderDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
