//
//  MKCGFilterTestAlert.h
//  CommureGateway_Example
//
//  Created by aa on 2023/6/26.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCGFilterTestAlert : UIView

- (void)showWithHandler:(void (^)(NSString *duration,NSString *alarmStatus))handler;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
