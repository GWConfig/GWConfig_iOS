//
//  MKCGAlertView.h
//  CommureGateway
//
//  Created by aa on 2023/2/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCGAlertViewModel : NSObject

/// Title
@property (nonatomic, copy)NSString *title;

/// Message
@property (nonatomic, copy)NSString *message;

/// Cancel按钮Title
@property (nonatomic, copy)NSString *cancelTitle;

/// Confirm按钮Title
@property (nonatomic, copy)NSString *confirmTitle;

/// 当收到该通知的时候，如果alert被弹出，则自动消失
@property (nonatomic, copy)NSString *notificationName;

@end

@interface MKCGAlertView : UIView

- (void)showWithModel:(MKCGAlertViewModel *)dataModel
         cancelAction:(void (^)(void))cancelBlock
        confirmAction:(void (^)(void))confirmBlock;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
