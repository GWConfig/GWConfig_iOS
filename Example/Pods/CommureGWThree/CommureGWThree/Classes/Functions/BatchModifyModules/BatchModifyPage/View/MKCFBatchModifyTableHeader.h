//
//  MKCFBatchModifyTableHeader.h
//  CommureGWThree_Example
//
//  Created by aa on 2023/12/14.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKCFBatchModifyTableHeaderDelegate <NSObject>

/// topic输入框内容改变
/// - Parameters:
///   - topic: 当前输入框内容
///   - type: 0:Subscribe topic  1:Publish topic
- (void)cf_topicValueChanged:(NSString *)topic type:(NSInteger)type;

- (void)cf_listButtonPressed;

- (void)cf_scanCodeButtonPressed;

@end

@interface MKCFBatchModifyTableHeader : UIView

@property (nonatomic, weak)id <MKCFBatchModifyTableHeaderDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
