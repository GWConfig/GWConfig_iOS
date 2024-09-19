//
//  MKCHReminderAlertView.h
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/4/22.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCHReminderAlertViewModel : NSObject

@property (nonatomic, assign)BOOL needColor;

@property (nonatomic, copy)NSString *title;

@property (nonatomic, copy)NSString *intervalMsg;

@property (nonatomic, copy)NSString *durationMsg;

/// needColor=YES的时候才有效.0:Red 1:Blue 2:Green
@property (nonatomic, assign)NSInteger color;

@property (nonatomic, copy)NSString *interval;

@property (nonatomic, copy)NSString *duration;

@end

@interface MKCHReminderAlertView : UIView

- (void)showAlertWithModel:(MKCHReminderAlertViewModel *)dataModel
             confirmAction:(void (^)(NSString *interval, NSString *duration, NSInteger color))confirmAction;

@end

NS_ASSUME_NONNULL_END
