//
//  MKCMConfiguredGatewayHeaderView.h
//  MKCommureApp_Example
//
//  Created by aa on 2023/10/18.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKCMConfiguredGatewayHeaderViewDelegate <NSObject>

/// 0:MK110   1:MK110 Plus   2:MKGW3
- (void)cm_deviceButtonChanged:(NSInteger)deviceType;

/// topic输入框内容改变
/// - Parameters:
///   - topic: 当前输入框内容
///   - type: 0:Subscribe topic  1:Publish topic
- (void)cm_topicValueChanged:(NSString *)topic type:(NSInteger)type;

- (void)cm_listButtonPressed;

- (void)cm_scanCodeButtonPressed;

@end

@interface MKCMConfiguredGatewayHeaderView : UIView

@property (nonatomic, weak)id <MKCMConfiguredGatewayHeaderViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
