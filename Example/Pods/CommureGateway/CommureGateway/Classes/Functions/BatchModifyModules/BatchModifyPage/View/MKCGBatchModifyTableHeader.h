//
//  MKCGBatchModifyTableHeader.h
//  CommureGateway_Example
//
//  Created by aa on 2023/12/14.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKCGBatchModifyTableHeaderDelegate <NSObject>

/// topic输入框内容改变
/// - Parameters:
///   - topic: 当前输入框内容
///   - type: 0:Subscribe topic  1:Publish topic
- (void)cg_topicValueChanged:(NSString *)topic type:(NSInteger)type;

- (void)cg_listButtonPressed;

- (void)cg_scanCodeButtonPressed;

@end

@interface MKCGBatchModifyTableHeader : UIView

@property (nonatomic, weak)id <MKCGBatchModifyTableHeaderDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
