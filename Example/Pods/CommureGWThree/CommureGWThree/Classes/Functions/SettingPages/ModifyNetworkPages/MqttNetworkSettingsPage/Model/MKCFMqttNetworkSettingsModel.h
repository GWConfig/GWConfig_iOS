//
//  MKCFMqttNetworkSettingsModel.h
//  CommureGWThree_Example
//
//  Created by aa on 2023/2/14.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKCFMQTTConfigDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKCFMqttNetworkSettingsModel : NSObject<mk_cf_mqttModifyWifiProtocol,
mk_cf_mqttModifyWifiEapCertProtocol>

/// 0:Ethernet    1:WiFi
@property (nonatomic, assign)NSInteger networkType;

#pragma mark - Wifi Settings

/// 0:personal  1:enterprise
@property (nonatomic, assign)NSInteger security;

/// security为enterprise的时候才有效。0:PEAP-MSCHAPV2  1:TTLS-MSCHAPV2  2:TLS
@property (nonatomic, assign)NSInteger eapType;

/// 1-32 Characters.
@property (nonatomic, copy)NSString *ssid;

/// 0-64 Characters.security为personal的时候才有效
@property (nonatomic, copy)NSString *wifiPassword;

/// 0-32 Characters.  eapType为PEAP-MSCHAPV2/TTLS-MSCHAPV2才有效
@property (nonatomic, copy)NSString *eapUserName;

/// 0-64 Characters.eapType为TLS的时候无此参数
@property (nonatomic, copy)NSString *eapPassword;

/// 0-64 Characters.eapType为TLS的时候有效
@property (nonatomic, copy)NSString *domainID;

/// eapType为PEAP-MSCHAPV2/TTLS-MSCHAPV2才有效
@property (nonatomic, assign)BOOL verifyServer;

/// security为personal无此参数
@property (nonatomic, copy)NSString *caFilePath;

/// eapType为TLS有效
@property (nonatomic, copy)NSString *clientKeyPath;

/// eapType为TLS有效
@property (nonatomic, copy)NSString *clientCertPath;


#pragma mark - Wifi Network Settings

@property (nonatomic, assign)BOOL wifi_dhcp;

@property (nonatomic, copy)NSString *wifi_ip;

@property (nonatomic, copy)NSString *wifi_mask;

@property (nonatomic, copy)NSString *wifi_gateway;

@property (nonatomic, copy)NSString *wifi_dns;


#pragma mark - Ethernet Network Settings

@property (nonatomic, assign)BOOL ethernet_dhcp;

@property (nonatomic, copy)NSString *ethernet_ip;

@property (nonatomic, copy)NSString *ethernet_mask;

@property (nonatomic, copy)NSString *ethernet_gateway;

@property (nonatomic, copy)NSString *ethernet_dns;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
