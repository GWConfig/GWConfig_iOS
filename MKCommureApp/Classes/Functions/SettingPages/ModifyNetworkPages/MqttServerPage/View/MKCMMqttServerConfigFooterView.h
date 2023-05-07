//
//  MKCMMqttServerConfigFooterView.h
//  MKCommureApp_Example
//
//  Created by aa on 2023/2/7.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCMMqttServerConfigFooterViewModel : NSObject

@property (nonatomic, assign)BOOL cleanSession;

@property (nonatomic, assign)NSInteger qos;

@property (nonatomic, copy)NSString *keepAlive;

@property (nonatomic, copy)NSString *userName;

@property (nonatomic, copy)NSString *password;

@property (nonatomic, assign)BOOL sslIsOn;

/// 0:TCP    1:CA signed server certificate     2:CA certificate     3:Self signed certificates
@property (nonatomic, assign)NSInteger certificate;

@property (nonatomic, copy)NSString *caFilePath;

@property (nonatomic, copy)NSString *clientKeyPath;

@property (nonatomic, copy)NSString *clientCertPath;

@end

@protocol MKCMMqttServerConfigFooterViewDelegate <NSObject>

/// 用户改变了开关状态
/// @param isOn isOn
/// @param statusID 0:cleanSession   1:ssl
- (void)cm_mqtt_serverForDevice_switchStatusChanged:(BOOL)isOn statusID:(NSInteger)statusID;

/// 输入框内容发生了改变
/// @param text 最新的输入框内容
/// @param textID 0:keepAlive    1:userName     2:password    3:deviceID   4:ntpURL    7:CA File Path     8:Client Key File           9:Client Cert  File
- (void)cm_mqtt_serverForDevice_textFieldValueChanged:(NSString *)text textID:(NSInteger)textID;

/// Qos发生改变
/// @param qos qos
/// @param qosID 0:qos
- (void)cm_mqtt_serverForDevice_qosChanged:(NSInteger)qos qosID:(NSInteger)qosID;

/// 用户选择了加密方式
/// @param certificate 0:CA signed server certificate     1:CA certificate     2:Self signed certificates
- (void)cm_mqtt_serverForDevice_certificateChanged:(NSInteger)certificate;

/// 底部按钮
/// @param index 0:Export Demo File   1:Import Config File  2:Clear All Configurations
- (void)cm_mqtt_serverForDevice_bottomButtonPressed:(NSInteger)index;

@end

@interface MKCMMqttServerConfigFooterView : UIView

@property (nonatomic, strong)MKCMMqttServerConfigFooterViewModel *dataModel;

@property (nonatomic, weak)id <MKCMMqttServerConfigFooterViewDelegate>delegate;

/// 动态刷新高度
/// @param isOn ssl开关是否打开
/// @param caFile 根证书名字
/// @param clientKeyName 客户端私钥名字
/// @param clientCertName 客户端证书
/// @param certificate 当前ssl加密规则
- (CGFloat)fetchHeightWithSSLStatus:(BOOL)isOn
                         CAFileName:(NSString *)caFile
                      clientKeyName:(NSString *)clientKeyName
                     clientCertName:(NSString *)clientCertName
                        certificate:(NSInteger)certificate;

@end

NS_ASSUME_NONNULL_END
