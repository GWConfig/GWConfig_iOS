//
//  MKCGInterface.h
//  CommureGateway_Example
//
//  Created by aa on 2023/1/29.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCGInterface : NSObject

#pragma mark *********************Device Service Information******************************
/// Read product model
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cg_readDeviceModelWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Read device firmware information
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cg_readFirmwareWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

/// Read device hardware information
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cg_readHardwareWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

/// Read device software information
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cg_readSoftwareWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

/// Read device manufacturer information
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cg_readManufacturerWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark *********************Custom protocol read************************

#pragma mark *********************System Params************************

/// Read the broadcast name of the device.
/*
 @{
 @"deviceName":@"MOKO"
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cg_readDeviceNameWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the wifi sta mac address of the device.
/*
    @{
    @"macAddress":@"AA:BB:CC:DD:EE:FF"
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cg_readMacAddressWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the mac address of the Wifi STA.
/*
    @{
    @"macAddress":@"AA:BB:CC:DD:EE:FF"
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cg_readDeviceWifiSTAMacAddressWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock;

/// Read NTP server domain name.
/*
    @{
    @"host":@"47.104.81.55"
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cg_readNTPServerHostWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the current time zone to the device.
/*
 @{
 @"timeZone":@(-23)       //UTC-11:30
 }
 //-24~28((The time zone is in units of 30 minutes, UTC-12:00~UTC+14:00))
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cg_readTimeZoneWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark *********************MQTT Params************************

/// Read the domain name of the MQTT server.
/*
 @{
    @"host":@"47.104.81.55"
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cg_readServerHostWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the port number of the MQTT server.
/*
    @{
    @"port":@"1883"
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cg_readServerPortWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Read Client ID of the MQTT server.
/*
    @{
    @"clientID":@"appToDevice_mk_110"
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cg_readClientIDWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

/// Read User Name of the MQTT server.
/*
    @{
    @"username":@"mokoTest"
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cg_readServerUserNameWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/// Read Password of the MQTT server.
/*
    @{
    @"password":@"Moko4321"
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cg_readServerPasswordWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/// Read clean session status of the  MQTT server.
/*
    @{
    @"clean":@(YES)
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cg_readServerCleanSessionWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Read Keep Alive of the MQTT server.
/*
    @{
    @"keepAlive":@"60",      //Unit:s
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cg_readServerKeepAliveWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock;

/// Read Qos of the MQTT server.
/*
    @{
    @"qos":@"0",        //@"0":At most once. The message sender to find ways to send messages, but an accident and will not try again.   @"1":At least once.If the message receiver does not know or the message itself is lost, the message sender sends it again to ensure that the message receiver will receive at least one, and of course, duplicate the message.     @"2":Exactly once.Ensuring this semantics will reduce concurrency or increase latency, but level 2 is most appropriate when losing or duplicating messages is unacceptable.
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cg_readServerQosWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the subscription topic of the device.
/*
    @{
    @"topic":@"xxxx"
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cg_readSubscibeTopicWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the publishing theme of the device.
/*
    @{
    @"topic":@"xxxx"
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cg_readPublishTopicWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the device tcp communication encryption method.
/*
 @{
 @"mode":@"0"
 }
 @"0":TCP
 @"1":SSL.Do not verify the server certificate.
 @"2":SSL.Verify the server's certificate.
 @"3":SSL.Two-way authentication
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cg_readConnectModeWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;


#pragma mark *********************WIFI Params************************

/// Read WIFI Security.
/*
 @{
    @"security":@"0",           //@"0":persional   @"1":enterprise
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cg_readWIFISecurityWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock;


/// Read SSID of WIFI.
/*
    @{
    @"ssid":@"moko"
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cg_readWIFISSIDWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

/// Read password of WIFI.(WIFI Security is persional.)
/*
    @{
    @"password":@"123456"
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cg_readWIFIPasswordWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock;

/// Read WIFI EAP Type.(WIFI Security is enterprise.)
/*
    @{
    @"eapType":@"0",         //@"0":PEAP-MSCHAPV2   @"1":TTLS-MSCHAPV2  @"2":TLS
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cg_readWIFIEAPTypeWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Read WIFI EAP username.(EAP Type is PEAP-MSCHAPV2 or  TTLS-MSCHAPV2.)
/*
    @{
    @"username":@"moko",
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cg_readWIFIEAPUsernameWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock;

/// Read WIFI EAP password.(EAP Type is PEAP-MSCHAPV2 or  TTLS-MSCHAPV2.)
/*
    @{
    @"password":@"moko",
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cg_readWIFIEAPPasswordWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock;

/// Read WIFI EAP Domain ID.(EAP Type is TLS.)
/*
    @{
    @"domainID":@"1111111"
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cg_readWIFIEAPDomainIDWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock;

/// Whether the server verification is enabled on WIFI.(EAP Type is PEAP-MSCHAPV2 or  TTLS-MSCHAPV2.)
/*
    @{
    @"verify":@(YES)
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cg_readWIFIVerifyServerStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock;

/// DHCP Status For Wifi.
/*
    @{
    @"isOn":@(YES)
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cg_readWIFIDHCPStatusWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/// IP Information For Wifi.
/*
    @{
    @"ip":@"47.104.81.55",
    @"mask":@"255.255.255.255",
    @"gateway":@"255.255.255.1",
    @"dns":@"47.104.81.55",
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)cg_readWIFINetworkIpInfosWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
