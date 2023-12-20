//
//  MKCFDeviceListTableHeader.h
//  CommureGWThree_Example
//
//  Created by aa on 2023/12/14.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKCFDeviceListTableHeaderDelegate <NSObject>

/// 过滤
/// - Parameter type: 0:All   1:Online
- (void)cf_deviceListFilter:(NSInteger)type;

@end

@interface MKCFDeviceListTableHeader : UIView

@property (nonatomic, weak)id <MKCFDeviceListTableHeaderDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
