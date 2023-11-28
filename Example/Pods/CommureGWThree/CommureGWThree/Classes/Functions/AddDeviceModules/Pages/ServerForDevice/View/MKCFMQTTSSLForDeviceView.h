//
//  MKCFMQTTSSLForDeviceView.h
//  CommureGWThree_Example
//
//  Created by aa on 2023/2/7.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCFMQTTSSLForDeviceViewModel : NSObject

@property (nonatomic, assign)BOOL sslIsOn;

/// 0:CA signed server certificate     1:CA certificate     2:Self signed certificates
@property (nonatomic, assign)NSInteger certificate;

@property (nonatomic, copy)NSString *caFileName;

@property (nonatomic, copy)NSString *clientKeyName;

@property (nonatomic, copy)NSString *clientCertName;

@end

@protocol MKCFMQTTSSLForDeviceViewDelegate <NSObject>

- (void)cf_mqtt_sslParams_device_sslStatusChanged:(BOOL)isOn;

/// 用户选择了加密方式
/// @param certificate 0:CA signed server certificate     1:CA certificate     2:Self signed certificates
- (void)cf_mqtt_sslParams_device_certificateChanged:(NSInteger)certificate;

/// 用户点击选择了caFaile按钮
- (void)cf_mqtt_sslParams_device_caFilePressed;

/// 用户点击选择了Client Key按钮
- (void)cf_mqtt_sslParams_device_clientKeyPressed;

/// 用户点击了Client Cert File按钮
- (void)cf_mqtt_sslParams_device_clientCertPressed;

@end

@interface MKCFMQTTSSLForDeviceView : UIView

@property (nonatomic, strong)MKCFMQTTSSLForDeviceViewModel *dataModel;

@property (nonatomic, weak)id <MKCFMQTTSSLForDeviceViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
