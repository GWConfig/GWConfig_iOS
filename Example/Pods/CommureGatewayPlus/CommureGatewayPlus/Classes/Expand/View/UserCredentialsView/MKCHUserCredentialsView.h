//
//  MKCHUserCredentialsView.h
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/2/7.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCHUserCredentialsViewModel : NSObject

@property (nonatomic, copy)NSString *userName;

@property (nonatomic, copy)NSString *password;

@end

@protocol MKCHUserCredentialsViewDelegate <NSObject>

- (void)ch_mqtt_userCredentials_userNameChanged:(NSString *)userName;

- (void)ch_mqtt_userCredentials_passwordChanged:(NSString *)password;

@end

@interface MKCHUserCredentialsView : UIView

@property (nonatomic, strong)MKCHUserCredentialsViewModel *dataModel;

@property (nonatomic, weak)id <MKCHUserCredentialsViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
