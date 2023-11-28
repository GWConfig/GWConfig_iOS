//
//  MKCFUserCredentialsView.h
//  CommureGWThree_Example
//
//  Created by aa on 2023/2/7.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCFUserCredentialsViewModel : NSObject

@property (nonatomic, copy)NSString *userName;

@property (nonatomic, copy)NSString *password;

@end

@protocol MKCFUserCredentialsViewDelegate <NSObject>

- (void)cf_mqtt_userCredentials_userNameChanged:(NSString *)userName;

- (void)cf_mqtt_userCredentials_passwordChanged:(NSString *)password;

@end

@interface MKCFUserCredentialsView : UIView

@property (nonatomic, strong)MKCFUserCredentialsViewModel *dataModel;

@property (nonatomic, weak)id <MKCFUserCredentialsViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
