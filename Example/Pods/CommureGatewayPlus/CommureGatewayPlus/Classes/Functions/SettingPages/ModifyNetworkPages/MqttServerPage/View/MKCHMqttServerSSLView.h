//
//  MKCHMqttServerSSLView.h
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/2/14.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCHMqttServerSSLViewModel : NSObject

@property (nonatomic, assign)BOOL sslIsOn;

/// 0:CA certificate     1:Self signed certificates
@property (nonatomic, assign)NSInteger certificate;

@property (nonatomic, copy)NSString *caFilePath;

@property (nonatomic, copy)NSString *clientKeyPath;

@property (nonatomic, copy)NSString *clientCertPath;

@end

@protocol MKCHMqttServerSSLViewDelegate <NSObject>

- (void)ch_mqtt_sslParams_modifyDevice_sslStatusChanged:(BOOL)isOn;

/// 用户选择了加密方式
/// @param certificate 0:CA signed server certificate     1:CA certificate     2:Self signed certificates
- (void)ch_mqtt_sslParams_modifyDevice_certificateChanged:(NSInteger)certificate;

/// 用户输入事件
/// @param index 0:Host         1:Port         2:CA File Path     3:Client Key File           4:Client Cert  File
/// @param value value
- (void)ch_mqtt_sslParams_modifyDevice_textFieldValueChanged:(NSInteger)index value:(NSString *)value;

@end

@interface MKCHMqttServerSSLView : UIView

@property (nonatomic, strong)MKCHMqttServerSSLViewModel *dataModel;

@property (nonatomic, weak)id <MKCHMqttServerSSLViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
