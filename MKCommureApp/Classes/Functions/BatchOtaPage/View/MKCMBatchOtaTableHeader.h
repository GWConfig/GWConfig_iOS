//
//  MKCMBatchOtaTableHeader.h
//  MKCommureApp_Example
//
//  Created by aa on 2023/7/7.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKCMBatchOtaTableHeaderDelegate <NSObject>

- (void)cm_urlValueChanged:(NSString *)url;

/// topic输入框内容改变
/// - Parameters:
///   - topic: 当前输入框内容
///   - type: 0:Subscribe topic  1:Publish topic
- (void)cm_topicValueChanged:(NSString *)topic type:(NSInteger)type;

- (void)cm_listButtonPressed;

- (void)cm_scanCodeButtonPressed;

@end

@interface MKCMBatchOtaTableHeader : UIView

@property (nonatomic, weak)id <MKCMBatchOtaTableHeaderDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
