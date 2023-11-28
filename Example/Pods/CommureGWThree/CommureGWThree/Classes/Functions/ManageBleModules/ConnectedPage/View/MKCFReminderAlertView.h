//
//  MKCFReminderAlertView.h
//  CommureGWThree_Example
//
//  Created by aa on 2023/4/22.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCFReminderAlertViewModel : NSObject

@property (nonatomic, assign)BOOL needColor;

@property (nonatomic, copy)NSString *title;

@property (nonatomic, copy)NSString *intervalMsg;

@property (nonatomic, copy)NSString *durationMsg;

@end

@interface MKCFReminderAlertView : UIView

- (void)showAlertWithModel:(MKCFReminderAlertViewModel *)dataModel
             confirmAction:(void (^)(NSString *interval, NSString *duration, NSInteger color))confirmAction;

@end

NS_ASSUME_NONNULL_END
