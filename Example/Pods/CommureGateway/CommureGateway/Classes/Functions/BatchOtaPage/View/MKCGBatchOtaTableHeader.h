//
//  MKCGBatchOtaTableHeader.h
//  CommureGateway_Example
//
//  Created by aa on 2023/7/7.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKCGBatchOtaTableHeaderDelegate <NSObject>

- (void)cg_urlValueChanged:(NSString *)url;

/// topic输入框内容改变
/// - Parameters:
///   - topic: 当前输入框内容
///   - type: 0:Subscribe topic  1:Publish topic
- (void)cg_topicValueChanged:(NSString *)topic type:(NSInteger)type;

- (void)cg_listButtonPressed;

- (void)cg_scanCodeButtonPressed;

@end

@interface MKCGBatchOtaTableHeader : UIView

@property (nonatomic, weak)id <MKCGBatchOtaTableHeaderDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
