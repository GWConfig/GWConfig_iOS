//
//  MKCFInterface+MKCFConfig.h
//  CommureGWThree_Example
//
//  Created by aa on 2023/1/29.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCFInterface.h"

#import "MKCFSDKNormalDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKCFInterface (MKCFConfig)

#pragma mark ******************Custom parameter configuration*********************

#pragma mark *********************System Params************************

/// The device enter STA mode.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cf_enterSTAModeWithSucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure NTP server domain name.
/// @param host 0~64 character ascii code.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cf_configNTPServerHost:(NSString *)host
                      sucBlock:(void (^)(void))sucBlock
                   failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the current time zone to the device.(MK107)
/// @param timeZone Time Zone(-12~12)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cf_configTimeZone:(NSInteger)timeZone
                 sucBlock:(void (^)(void))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock;

/// Sync device time.
/// @param timestamp UTC
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cf_configDeviceTime:(unsigned long)timestamp
                   sucBlock:(void (^)(void))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark *********************MQTT Params************************
/// Configure the domain name of the MQTT server.
/// @param host 1~64 character ascii code.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cf_configServerHost:(NSString *)host
                   sucBlock:(void (^)(void))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the port number of the MQTT server.
/// @param port 0~65535
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cf_configServerPort:(NSInteger)port
                   sucBlock:(void (^)(void))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure Client ID of the MQTT server.
/// @param clientID 1~64 character ascii code.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cf_configClientID:(NSString *)clientID
                 sucBlock:(void (^)(void))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the user name for the device to connect to the server. If the server passes the certificate or does not require any authentication, you do not need to fill in.
/// @param userName 0~256 character ascii code.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cf_configServerUserName:(NSString *)userName
                       sucBlock:(void (^)(void))sucBlock
                    failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the password for the device to connect to the server. If the server passes the certificate or does not require any authentication, you do not need to fill in.
/// @param password 0~256 character ascii code.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cf_configServerPassword:(NSString *)password
                       sucBlock:(void (^)(void))sucBlock
                    failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure clean session of the  MQTT server.
/// @param clean clean
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cf_configServerCleanSession:(BOOL)clean
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure Keep Alive of the MQTT server.
/// @param interval 10s~120s.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cf_configServerKeepAlive:(NSInteger)interval
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure Qos of the MQTT server.
/// @param mode mode
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cf_configServerQos:(mk_cf_mqttServerQosMode)mode
                  sucBlock:(void (^)(void))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the subscription topic of the device.
/// @param subscibeTopic 1~128 character ascii code.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cf_configSubscibeTopic:(NSString *)subscibeTopic
                      sucBlock:(void (^)(void))sucBlock
                   failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the publishing theme of the device.
/// @param publishTopic 1~128 character ascii code.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cf_configPublishTopic:(NSString *)publishTopic
                     sucBlock:(void (^)(void))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the device tcp communication encryption method.
/// @param mode mode
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cf_configConnectMode:(mk_cf_connectMode)mode
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the root certificate of the MQTT server.
/// @param caFile caFile
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cf_configCAFile:(NSData *)caFile
               sucBlock:(void (^)(void))sucBlock
            failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure client certificate.
/// @param cert cert
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cf_configClientCert:(NSData *)cert
                   sucBlock:(void (^)(void))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure client private key.
/// @param privateKey privateKey
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cf_configClientPrivateKey:(NSData *)privateKey
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock;


#pragma mark *********************WIFI Params************************

/// WIFI Security.
/// @param security security
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cf_configWIFISecurity:(mk_cf_wifiSecurity)security
                     sucBlock:(void (^)(void))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure SSID of WIFI.
/// @param ssid 1~32 character ascii code.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cf_configWIFISSID:(NSString *)ssid
                 sucBlock:(void (^)(void))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure password of WIFI.(WIFI Security is persional.)
/// @param password 0~64 character ascii code.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cf_configWIFIPassword:(NSString *)password
                     sucBlock:(void (^)(void))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock;

/// WIFI EAP Type.(WIFI Security is enterprise.)
/// @param eapType eapType
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cf_configWIFIEAPType:(mk_cf_eapType)eapType
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock;

/// WIFI EAP username.(EAP Type is PEAP-MSCHAPV2 or  TTLS-MSCHAPV2.)
/// @param username 0~32 character ascii code.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cf_configWIFIEAPUsername:(NSString *)username
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock;

/// WIFI EAP password.(EAP Type is PEAP-MSCHAPV2 or  TTLS-MSCHAPV2.)
/// @param password 0~64 character ascii code.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cf_configWIFIEAPPassword:(NSString *)password
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock;

/// WIFI EAP Domain ID.(EAP Type is TLS.)
/// @param domainID 0~64 character ascii code.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cf_configWIFIEAPDomainID:(NSString *)domainID
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock;

/// Whether the server verification is enabled on WIFI.(EAP Type is PEAP-MSCHAPV2 or  TTLS-MSCHAPV2.)
/// @param verify verify
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cf_configWIFIVerifyServerStatus:(BOOL)verify
                               sucBlock:(void (^)(void))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the root certificate of the WIFI.(WIFI Security is enterprise.)
/// @param caFile caFile
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cf_configWIFICAFile:(NSData *)caFile
                   sucBlock:(void (^)(void))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the client certificate of the WIFI.(EAP Type is TLS.)
/// @param cert cert
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cf_configWIFIClientCert:(NSData *)cert
                       sucBlock:(void (^)(void))sucBlock
                    failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the client private key of the WIFI.(EAP Type is TLS.)
/// @param privateKey privateKey
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cf_configWIFIClientPrivateKey:(NSData *)privateKey
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// DHCP Status For Wifi.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cf_configWIFIDHCPStatus:(BOOL)isOn
                       sucBlock:(void (^)(void))sucBlock
                    failedBlock:(void (^)(NSError *error))failedBlock;

/// IP Information For Wifi.
/// @param ip e.g.(@"47.104.81.55")
/// @param mask e.g.(@"255.255.255.255")
/// @param gateway e.g.(@"255.255.255.1")
/// @param dns e.g.(@"47.104.81.55")
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cf_configWIFIIpAddress:(NSString *)ip
                          mask:(NSString *)mask
                       gateway:(NSString *)gateway
                           dns:(NSString *)dns
                      sucBlock:(void (^)(void))sucBlock
                   failedBlock:(void (^)(NSError *error))failedBlock;

/// Type For Network.
/// @param type type
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cf_configNetworkType:(mk_cf_networkType)type
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock;

/// DHCP Status For Ethernet.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cf_configEthernetDHCPStatus:(BOOL)isOn
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

/// IP Information For Ethernet.
/// @param ip e.g.(@"47.104.81.55")
/// @param mask e.g.(@"255.255.255.255")
/// @param gateway e.g.(@"255.255.255.1")
/// @param dns e.g.(@"47.104.81.55")
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cf_configEthernetIpAddress:(NSString *)ip
                              mask:(NSString *)mask
                           gateway:(NSString *)gateway
                               dns:(NSString *)dns
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
