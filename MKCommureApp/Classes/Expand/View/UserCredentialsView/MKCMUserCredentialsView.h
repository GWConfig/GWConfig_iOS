//
//  MKCMUserCredentialsView.h
//  MKCommureApp_Example
//
//  Created by aa on 2023/2/7.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCMUserCredentialsViewModel : NSObject

@property (nonatomic, copy)NSString *userName;

@property (nonatomic, copy)NSString *password;

@end

@protocol MKCMUserCredentialsViewDelegate <NSObject>

- (void)cm_mqtt_userCredentials_userNameChanged:(NSString *)userName;

- (void)cm_mqtt_userCredentials_passwordChanged:(NSString *)password;

@end

@interface MKCMUserCredentialsView : UIView

@property (nonatomic, strong)MKCMUserCredentialsViewModel *dataModel;

@property (nonatomic, weak)id <MKCMUserCredentialsViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
