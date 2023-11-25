//
//  MKCGUserCredentialsView.h
//  CommureGateway_Example
//
//  Created by aa on 2023/2/7.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCGUserCredentialsViewModel : NSObject

@property (nonatomic, copy)NSString *userName;

@property (nonatomic, copy)NSString *password;

@end

@protocol MKCGUserCredentialsViewDelegate <NSObject>

- (void)cg_mqtt_userCredentials_userNameChanged:(NSString *)userName;

- (void)cg_mqtt_userCredentials_passwordChanged:(NSString *)password;

@end

@interface MKCGUserCredentialsView : UIView

@property (nonatomic, strong)MKCGUserCredentialsViewModel *dataModel;

@property (nonatomic, weak)id <MKCGUserCredentialsViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
