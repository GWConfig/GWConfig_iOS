//
//  MKCHBatchModifyTableHeader.h
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/12/14.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKCHBatchModifyTableHeaderDelegate <NSObject>

/// topic输入框内容改变
/// - Parameters:
///   - topic: 当前输入框内容
///   - type: 0:Subscribe topic  1:Publish topic
- (void)ch_topicValueChanged:(NSString *)topic type:(NSInteger)type;

- (void)ch_listButtonPressed;

- (void)ch_scanCodeButtonPressed;

@end

@interface MKCHBatchModifyTableHeader : UIView

@property (nonatomic, weak)id <MKCHBatchModifyTableHeaderDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
