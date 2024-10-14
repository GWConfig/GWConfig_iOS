//
//  MKCHBatchOtaTableHeader.h
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/7/7.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKCHBatchOtaTableHeaderDelegate <NSObject>

- (void)ch_firwareTypeChanged:(NSInteger)type;

- (void)ch_urlValueChanged:(NSString *)url;

/// topic输入框内容改变
/// - Parameters:
///   - topic: 当前输入框内容
///   - type: 0:Subscribe topic  1:Publish topic
- (void)ch_topicValueChanged:(NSString *)topic type:(NSInteger)type;

- (void)ch_listButtonPressed;

- (void)ch_scanCodeButtonPressed;

@end

@interface MKCHBatchOtaTableHeader : UIView

@property (nonatomic, weak)id <MKCHBatchOtaTableHeaderDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
