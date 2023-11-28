//
//  MKCFBatchOtaTableHeader.h
//  CommureGWThree_Example
//
//  Created by aa on 2023/7/7.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKCFBatchOtaTableHeaderDelegate <NSObject>

- (void)cf_urlValueChanged:(NSString *)url;

/// topic输入框内容改变
/// - Parameters:
///   - topic: 当前输入框内容
///   - type: 0:Subscribe topic  1:Publish topic
- (void)cf_topicValueChanged:(NSString *)topic type:(NSInteger)type;

- (void)cf_listButtonPressed;

- (void)cf_scanCodeButtonPressed;

@end

@interface MKCFBatchOtaTableHeader : UIView

@property (nonatomic, weak)id <MKCFBatchOtaTableHeaderDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
