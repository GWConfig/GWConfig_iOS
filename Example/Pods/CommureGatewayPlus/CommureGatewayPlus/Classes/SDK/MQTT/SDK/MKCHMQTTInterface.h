//
//  MKCHMQTTInterface.h
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/1/29.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKCHMQTTConfigDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKCHMQTTInterface : NSObject

#pragma mark *********************Config************************

/// Reboot.
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_rebootDeviceWithMacAddress:(NSString *)macAddress
                                topic:(NSString *)topic
                             sucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Reset device by button.
/// @param type type
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_configKeyResetType:(mk_ch_keyResetType)type
                   macAddress:(NSString *)macAddress
                        topic:(NSString *)topic
                     sucBlock:(void (^)(id returnData))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock;

/// The reporting interval of the device's network status.
/// @param interval 0s or 30s ~ 86400s
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_configNetworkStatusReportInterval:(NSInteger)interval
                                  macAddress:(NSString *)macAddress
                                       topic:(NSString *)topic
                                    sucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock;

/// Reconnect timeout.
/// @param timeout 0~1440 Mins.
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_configReconnectTimeout:(NSInteger)timeout
                       macAddress:(NSString *)macAddress
                            topic:(NSString *)topic
                         sucBlock:(void (^)(id returnData))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock;

/// OTA.
/// @param filePath 1-256 Characters
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_configOTAWithFilePath:(NSString *)filePath
                      macAddress:(NSString *)macAddress
                           topic:(NSString *)topic
                        sucBlock:(void (^)(id returnData))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the NTP server.
/// @param isOn isOn
/// @param host 0-64 Characters
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_configNTPServer:(BOOL)isOn
                      host:(NSString *)host
                macAddress:(NSString *)macAddress
                     topic:(NSString *)topic
                  sucBlock:(void (^)(id returnData))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the UTC time zone of the device, and the device will reset the time according to the time zone.
/// @param timeZone Time Zone(-24~28,Unit:0.5)
/// @param timestamp timestamp
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_configDeviceTimeZone:(NSInteger)timeZone
                      timestamp:(NSTimeInterval)timestamp
                     macAddress:(NSString *)macAddress
                          topic:(NSString *)topic
                       sucBlock:(void (^)(id returnData))sucBlock
                    failedBlock:(void (^)(NSError *error))failedBlock;

/// Communication timeout.
/// @param timeout 0s~60s.
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_configCommunicationTimeout:(NSInteger)timeout
                           macAddress:(NSString *)macAddress
                                topic:(NSString *)topic
                             sucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Connect beacon timeout.
/// @param timeout 1~200 s.
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_configConnectBeaconTimeout:(NSInteger)timeout
                           macAddress:(NSString *)macAddress
                                topic:(NSString *)topic
                             sucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure indicator status.
/// @param protocol protocol.
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_configIndicatorLightStatus:(id <ch_indicatorLightStatusProtocol>)protocol
                           macAddress:(NSString *)macAddress
                                topic:(NSString *)topic
                             sucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Reset.
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_resetDeviceWithMacAddress:(NSString *)macAddress
                               topic:(NSString *)topic
                            sucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Ble Adv Status
/// @param isOn isOn
/// @param advTime 1 s ~ 65535 s.
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_configBleAdvStatus:(BOOL)isOn
                      advTime:(NSInteger)advTime
                   macAddress:(NSString *)macAddress
                        topic:(NSString *)topic
                     sucBlock:(void (^)(id returnData))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Power Switch Status.
/// @param isOn isOn
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_configPowerSwitchStatus:(BOOL)isOn
                        macAddress:(NSString *)macAddress
                             topic:(NSString *)topic
                          sucBlock:(void (^)(id returnData))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;

/// NPC OTA.
/// @param filePath 1-256 Characters
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_configNpcOTAWithFilePath:(NSString *)filePath
                         macAddress:(NSString *)macAddress
                              topic:(NSString *)topic
                           sucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

/// Modify Wifi.
/// @param protocol protocol
/// @param macAddress WIFI_STA Mac address of the device(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_modifyWifiInfos:(id <mk_ch_mqttModifyWifiProtocol>)protocol
                macAddress:(NSString *)macAddress
                     topic:(NSString *)topic
                  sucBlock:(void (^)(id returnData))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock;

/// EAP certificate update.
/// @param protocol protocol
/// @param macAddress WIFI_STA Mac address of the device(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_modifyWifiCerts:(id <mk_ch_mqttModifyWifiEapCertProtocol>)protocol
                macAddress:(NSString *)macAddress
                     topic:(NSString *)topic
                  sucBlock:(void (^)(id returnData))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock;

/// Wifi Network Settings.
/// @param protocol protocol
/// @param macAddress WIFI_STA Mac address of the device(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_modifyWifiNetworkInfos:(id <mk_ch_mqttModifyNetworkProtocol>)protocol
                       macAddress:(NSString *)macAddress
                            topic:(NSString *)topic
                         sucBlock:(void (^)(id returnData))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock;

/// MQTT Settings.
/// @param protocol protocol
/// @param macAddress WIFI_STA Mac address of the device(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_modifyMqttInfos:(id <mk_ch_modifyMqttServerProtocol>)protocol
                macAddress:(NSString *)macAddress
                     topic:(NSString *)topic
                  sucBlock:(void (^)(id returnData))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock;

/// MQTT certificate update.
/// @param protocol protocol
/// @param macAddress WIFI_STA Mac address of the device(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_modifyMqttCerts:(id <mk_ch_modifyMqttServerCertsProtocol>)protocol
                macAddress:(NSString *)macAddress
                     topic:(NSString *)topic
                  sucBlock:(void (^)(id returnData))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock;

/// Config scan status.
/// @param isOn isOn
/// @param macAddress WIFI_STA Mac address of the device(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_configScanSwitchStatus:(BOOL)isOn
                       macAddress:(NSString *)macAddress
                            topic:(NSString *)topic
                         sucBlock:(void (^)(id returnData))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the filter relationship.
/// @param relationship relationship
/// @param macAddress WIFI_STA Mac address of the device(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_configFilterRelationship:(mk_ch_filterRelationship)relationship
                         macAddress:(NSString *)macAddress
                              topic:(NSString *)topic
                           sucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

/// Filter by RSSI
/// @param rssi -127dBm~0dBm
/// @param macAddress WIFI_STA Mac address of the device(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_configFilterByRSSI:(NSInteger)rssi
                   macAddress:(NSString *)macAddress
                        topic:(NSString *)topic
                     sucBlock:(void (^)(id returnData))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Filter by MAC Address.
/// @param macList The filtered mac address list contains up to 10 filtering options, and the length of each option should be 1 to 6 bytes of hexadecimal data.If the number is 0, it means that the historical configuration data is cleared.
/// @param preciseMatch Precise Match is On.
/// @param reverseFilter Reverse Filter is On.
/// @param macAddress WIFI_STA Mac address of the device(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_configFilterByMacAddress:(nonnull NSArray <NSString *>*)macList
                       preciseMatch:(BOOL)preciseMatch
                      reverseFilter:(BOOL)reverseFilter
                         macAddress:(NSString *)macAddress
                              topic:(NSString *)topic
                           sucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

/// Filter by BXP-Tag.
/// @param preciseMatch Precise Match is On.
/// @param reverseFilter Reverse Filter is On.
/// @param tagIDList The filtered tag ID list contains up to 10 filtering options, and the length of each option should be 1 to 6 bytes of hexadecimal data.If the number is 0, it means that the historical configuration data is cleared.
/// @param macAddress WIFI_STA Mac address of the device(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_configFilterByTag:(BOOL)preciseMatch
               reverseFilter:(BOOL)reverseFilter
                   tagIDList:(NSArray <NSString *>*)tagIDList
                  macAddress:(NSString *)macAddress
                       topic:(NSString *)topic
                    sucBlock:(void (^)(id returnData))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock;

/// Data report timeout.
/// @param timeout 100ms ~ 3000ms
/// @param macAddress WIFI_STA Mac address of the device(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_configDataReportTimeout:(NSInteger)timeout
                        macAddress:(NSString *)macAddress
                             topic:(NSString *)topic
                          sucBlock:(void (^)(id returnData))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;

/// The allowed time offset between gateway and badge.
/// @param timeOffset 0Min ~ 600Mins.
/// @param macAddress WIFI_STA Mac address of the device(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_configBXBDecryptTimeOffset:(NSInteger)timeOffset
                           macAddress:(NSString *)macAddress
                                topic:(NSString *)topic
                             sucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// The allowed decrypt key between gateway and badge.
/// @param key 26 Bytes.
/// @param macAddress WIFI_STA Mac address of the device(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_configBXBDecryptKey:(NSString *)key
                    macAddress:(NSString *)macAddress
                         topic:(NSString *)topic
                      sucBlock:(void (^)(id returnData))sucBlock
                   failedBlock:(void (^)(NSError *error))failedBlock;

/// The gateway connects to the BXP-Button with the specified MAC address.
/// @param password 0-16 Characters
/// @param bleMacAddress The mac address of the target bluetooth device.(e.g.AABBCCDDEEFF)
/// @param macAddress WIFI_STA Mac address of the device(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_connectBXPButtonWithPassword:(NSString *)password
                                 bleMac:(NSString *)bleMacAddress
                             macAddress:(NSString *)macAddress
                                  topic:(NSString *)topic
                               sucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock;

/// LED Reminder.
/// @param bleMacAddress The mac address of the target bluetooth device.(e.g.AABBCCDDEEFF)
/// @param color LED Color.
/// @param interval flash interval.0-10000
/// @param duration flash time.1s-255s.
/// @param macAddress WIFI_STA Mac address of the device(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_configDeviceLedReminderWithBleMac:(NSString *)bleMacAddress
                                       color:(mk_ch_reminderLedColor)color
                                    interval:(NSInteger)interval
                                    duration:(NSInteger)duration
                                  macAddress:(NSString *)macAddress
                                       topic:(NSString *)topic
                                    sucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock;

/// Buzzer Reminder.
/// @param bleMacAddress The mac address of the target bluetooth device.(e.g.AABBCCDDEEFF)
/// @param interval ring interval.0-10000
/// @param duration ring time.1s-255s.
/// @param macAddress WIFI_STA Mac address of the device(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_configDeviceBuzzerReminderWithBleMac:(NSString *)bleMacAddress
                                       interval:(NSInteger)interval
                                       duration:(NSInteger)duration
                                     macAddress:(NSString *)macAddress
                                          topic:(NSString *)topic
                                       sucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock;

/// Power off the beacon that connected by the gateway.
/// @param bleMacAddress The mac address of the target bluetooth device.(e.g.AABBCCDDEEFF)
/// @param macAddress WIFI_STA Mac address of the device(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_powerOffConnectedDeviceWithBleMac:(NSString *)bleMacAddress
                                  macAddress:(NSString *)macAddress
                                       topic:(NSString *)topic
                                    sucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock;

/// Reset the beacon that connected by the gateway.
/// @param bleMacAddress The mac address of the target bluetooth device.(e.g.AABBCCDDEEFF)
/// @param macAddress WIFI_STA Mac address of the device(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_resetConnectedDeviceWithBleMac:(NSString *)bleMacAddress
                               macAddress:(NSString *)macAddress
                                    topic:(NSString *)topic
                                 sucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/// Sync Timestamp.
/// @param bleMacAddress The mac address of the target bluetooth device.(e.g.AABBCCDDEEFF)
/// @param timestamp ms
/// @param macAddress WIFI_STA Mac address of the device(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_configDeviceTimestampWithBleMac:(NSString *)bleMacAddress
                                 timestamp:(long)timestamp
                                macAddress:(NSString *)macAddress
                                     topic:(NSString *)topic
                                  sucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock;

/// Modify the device's tag ID that connected by the gateway.
/// @param tagID 3 Bytes.
/// @param bleMacAddress The mac address of the target bluetooth device.(e.g.AABBCCDDEEFF)
/// @param macAddress WIFI_STA Mac address of the device(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_configTagID:(NSString *)tagID
                bleMac:(NSString *)bleMacAddress
            macAddress:(NSString *)macAddress
                 topic:(NSString *)topic
              sucBlock:(void (^)(id returnData))sucBlock
           failedBlock:(void (^)(NSError *error))failedBlock;

/// SOS triggered by button
/// @param triggerType triggerType.
/// @param bleMacAddress The mac address of the target bluetooth device.(e.g.AABBCCDDEEFF)
/// @param macAddress WIFI_STA Mac address of the device(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_configSosTriggerType:(mk_ch_sosTriggerType)triggerType
                         bleMac:(NSString *)bleMacAddress
                     macAddress:(NSString *)macAddress
                          topic:(NSString *)topic
                       sucBlock:(void (^)(id returnData))sucBlock
                    failedBlock:(void (^)(NSError *error))failedBlock;

/// Self test triggered by button.
/// @param time 1s~255s.
/// @param bleMacAddress The mac address of the target bluetooth device.(e.g.AABBCCDDEEFF)
/// @param macAddress WIFI_STA Mac address of the device(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_configSelfTestTriggeredByButton:(NSInteger)time
                                    bleMac:(NSString *)bleMacAddress
                                macAddress:(NSString *)macAddress
                                     topic:(NSString *)topic
                                  sucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock;

/// Batch DFU Beacon.
/// @param firmwareUrl Firmware file URL.1- 256 Characters.
/// @param dataUrl Init data file URL.1- 256 Characters.
/// @param beaconList @[@{@"macAddress":@"AABBCCDDEEFF",@"password":@"Moko4321"}]
/// @param macAddress WIFI_STA Mac address of the device(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_batchDfuBeacon:(NSString *)firmwareUrl
              dataFileUrl:(NSString *)dataUrl
               beaconList:(NSArray <NSDictionary *>*)beaconList
               macAddress:(NSString *)macAddress
                    topic:(NSString *)topic
                 sucBlock:(void (^)(id returnData))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock;

/// Batch update key.
/// @param key Encryption key,26 Bytes.
/// @param beaconList @[@{@"macAddress":@"AABBCCDDEEFF",@"password":@"Moko4321"}]
/// @param macAddress WIFI_STA Mac address of the device(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_batchUpdateKey:(NSString *)key
               beaconList:(NSArray <NSDictionary *>*)beaconList
               macAddress:(NSString *)macAddress
                    topic:(NSString *)topic
                 sucBlock:(void (^)(id returnData))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock;

/// BXP-Button DFU.
/// @param firmwareUrl Firmware file URL.1- 256 Characters.
/// @param dataUrl Init data file URL.1- 256 Characters.
/// @param bleMacAddress The mac address of the target bluetooth device.(e.g.AABBCCDDEEFF)
/// @param macAddress WIFI_STA Mac address of the device(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_startBXPButtonDfuWithFirmwareUrl:(NSString *)firmwareUrl
                                    dataUrl:(NSString *)dataUrl
                                     bleMac:(NSString *)bleMacAddress
                                 macAddress:(NSString *)macAddress
                                      topic:(NSString *)topic
                                   sucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;


/// The gateway connects to the Bluetooth device with the specified MAC address.
/// @param bleMacAddress The mac address of the target bluetooth device.(e.g.AABBCCDDEEFF)
/// @param macAddress WIFI_STA Mac address of the device(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_connectNormalBleDeviceWithBleMac:(NSString *)bleMacAddress
                                 macAddress:(NSString *)macAddress
                                      topic:(NSString *)topic
                                   sucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;


#pragma mark *********************Read************************

/// Reset device by button.
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_readKeyResetTypeWithMacAddress:(NSString *)macAddress
                                    topic:(NSString *)topic
                                 sucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/// Reset device Infomation.
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_readDeviceInfoWithMacAddress:(NSString *)macAddress
                                  topic:(NSString *)topic
                               sucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the reporting interval of the device's network status.
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_readNetworkStatusReportIntervalWithMacAddress:(NSString *)macAddress
                                                   topic:(NSString *)topic
                                                sucBlock:(void (^)(id returnData))sucBlock
                                             failedBlock:(void (^)(NSError *error))failedBlock;

/// Reconnect Timeout.
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_readNetworkReconnectTimeoutWithMacAddress:(NSString *)macAddress
                                               topic:(NSString *)topic
                                            sucBlock:(void (^)(id returnData))sucBlock
                                         failedBlock:(void (^)(NSError *error))failedBlock;
/// NTP Server.
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_readNTPServerWithMacAddress:(NSString *)macAddress
                                 topic:(NSString *)topic
                              sucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// UTC Time.
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_readDeviceUTCTimeWithMacAddress:(NSString *)macAddress
                                     topic:(NSString *)topic
                                  sucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock;

/// Communicate Timeout.
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_readCommunicateTimeoutWithMacAddress:(NSString *)macAddress
                                          topic:(NSString *)topic
                                       sucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock;

/// Connect Beacon Timeout.
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_readConnectBeaconTimeoutWithMacAddress:(NSString *)macAddress
                                            topic:(NSString *)topic
                                         sucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock;

/// Indicator Status
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_readIndicatorLightStatusWithMacAddress:(NSString *)macAddress
                                            topic:(NSString *)topic
                                         sucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock;

/// Query whether the device can perform OTA upgrade.
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_readOtaStatusWithMacAddress:(NSString *)macAddress
                                 topic:(NSString *)topic
                              sucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Status of the ble advertising.
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_readBleAdvStatusWithMacAddress:(NSString *)macAddress
                                    topic:(NSString *)topic
                                 sucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/// Status of the power switch.
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_readPowerSwitchStatusWithMacAddress:(NSString *)macAddress
                                         topic:(NSString *)topic
                                      sucBlock:(void (^)(id returnData))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the wifi information that the device is currently connected to.
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_readWifiInfosWithMacAddress:(NSString *)macAddress
                                 topic:(NSString *)topic
                              sucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the wifi's network information that the device is currently connected to.
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_readWifiNetworkInfosWithMacAddress:(NSString *)macAddress
                                        topic:(NSString *)topic
                                     sucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Network Type.
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_readNetworkTypeWithMacAddress:(NSString *)macAddress
                                   topic:(NSString *)topic
                                sucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the MQTT Params.
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_readMQTTParamsWithMacAddress:(NSString *)macAddress
                                  topic:(NSString *)topic
                               sucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock;

/// Read scan status.
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_readScanSwitchStatusWithMacAddress:(NSString *)macAddress
                                        topic:(NSString *)topic
                                     sucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Filter Relationship.
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_readFilterRelationshipWithMacAddress:(NSString *)macAddress
                                          topic:(NSString *)topic
                                       sucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock;

/// Filter by Mac.
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_readFilterByRSSIWithMacAddress:(NSString *)macAddress
                                    topic:(NSString *)topic
                                 sucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/// Filter by MAC Address.
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_readFilterByMacWithMacAddress:(NSString *)macAddress
                                   topic:(NSString *)topic
                                sucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

/// Filter By BXP-Tag.
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_readFilterBXPTagWithMacAddress:(NSString *)macAddress
                                    topic:(NSString *)topic
                                 sucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/// Data report timeout.
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_readDataReportTimeoutWithMacAddress:(NSString *)macAddress
                                         topic:(NSString *)topic
                                      sucBlock:(void (^)(id returnData))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock;

/// The allowed time offset between gateway and badge.
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_readBXBDecryptTimeOffsetWithMacAddress:(NSString *)macAddress
                                            topic:(NSString *)topic
                                         sucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock;

/// The allowed Decryption key  between gateway and badge.
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_readBXBDecryptKeyWithMacAddress:(NSString *)macAddress
                                     topic:(NSString *)topic
                                  sucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the service and feature information of the specified BXP-Button connected to the current gateway.
/// @param bleMacAddress The mac address of the target bluetooth device.(e.g.AABBCCDDEEFF)
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_readBXPButtonConnectedDeviceInfoWithBleMacAddress:(NSString *)bleMacAddress
                                                  macAddress:(NSString *)macAddress
                                                       topic:(NSString *)topic
                                                    sucBlock:(void (^)(id returnData))sucBlock
                                                 failedBlock:(void (^)(NSError *error))failedBlock;

/// The gateway disconnect the Bluetooth device with the specified MAC address.
/// @param bleMacAddress The mac address of the target bluetooth device.(e.g.AABBCCDDEEFF)
/// @param macAddress WIFI_STA Mac address of the device(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_disconnectBleDeviceWithBleMac:(NSString *)bleMacAddress
                              macAddress:(NSString *)macAddress
                                   topic:(NSString *)topic
                                sucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;


/// Dismiss Alarm Status.
/// @param bleMacAddress The mac address of the target bluetooth device.(e.g.AABBCCDDEEFF)
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_dismissBXPButtonAlarmStatusWithBleMacAddress:(NSString *)bleMacAddress
                                             macAddress:(NSString *)macAddress
                                                  topic:(NSString *)topic
                                               sucBlock:(void (^)(id returnData))sucBlock
                                            failedBlock:(void (^)(NSError *error))failedBlock;

/// Query whether the Bluetooth gateway is connected to the device.
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_readGatewayBleConnectStatusWithMacAddress:(NSString *)macAddress
                                               topic:(NSString *)topic
                                            sucBlock:(void (^)(id returnData))sucBlock
                                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the  battery voltage that connected to the current gateway.
/// @param bleMacAddress The mac address of the target bluetooth device.(e.g.AABBCCDDEEFF)
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_readDeviceBatteryVoltageWithBleMacAddress:(NSString *)bleMacAddress
                                          macAddress:(NSString *)macAddress
                                               topic:(NSString *)topic
                                            sucBlock:(void (^)(id returnData))sucBlock
                                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the  Tag ID that connected to the current gateway.
/// @param bleMacAddress The mac address of the target bluetooth device.(e.g.AABBCCDDEEFF)
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_readTagIDWithBleMacAddress:(NSString *)bleMacAddress
                           macAddress:(NSString *)macAddress
                                topic:(NSString *)topic
                             sucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// SOS triggered by button.
/// @param bleMacAddress The mac address of the target bluetooth device.(e.g.AABBCCDDEEFF)
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_readSosTriggerTypeWithBleMacAddress:(NSString *)bleMacAddress
                                    macAddress:(NSString *)macAddress
                                         topic:(NSString *)topic
                                      sucBlock:(void (^)(id returnData))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock;

/// Self test triggered by button.
/// @param bleMacAddress The mac address of the target bluetooth device.(e.g.AABBCCDDEEFF)
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_readSelfTestTriggeredByButtonWithBleMacAddress:(NSString *)bleMacAddress
                                               macAddress:(NSString *)macAddress
                                                    topic:(NSString *)topic
                                                 sucBlock:(void (^)(id returnData))sucBlock
                                              failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the  Tag ID that connected to the current gateway.
/// @param bleMacAddress The mac address of the target bluetooth device.(e.g.AABBCCDDEEFF)
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_readAlarmStatusWithBleMacAddress:(NSString *)bleMacAddress
                                 macAddress:(NSString *)macAddress
                                      topic:(NSString *)topic
                                   sucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;


/// Battery test parameters.
/// @param bleMacAddress The mac address of the target bluetooth device.(e.g.AABBCCDDEEFF)
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_readBatterySelfTestWithBleMacAddress:(NSString *)bleMacAddress
                                     macAddress:(NSString *)macAddress
                                          topic:(NSString *)topic
                                       sucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock;

/// Battery test parameters.
/// @param isOn Led is on.
/// @param voltage Voltage threshold.2000mV~3600mV.
/// @param bleMacAddressThe mac address of the target bluetooth device.(e.g.AABBCCDDEEFF)
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_configBatterySelfTestWithLedState:(BOOL)isOn
                            voltageThreshold:(NSInteger)voltage
                               bleMacAddress:(NSString *)bleMacAddress
                                  macAddress:(NSString *)macAddress
                                       topic:(NSString *)topic
                                    sucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock;

/// Battery self test led Params .
/// @param mode 0:When battery voltage<threshold    1:When battery voltage>=threshold
/// @param bleMacAddress The mac address of the target bluetooth device.(e.g.AABBCCDDEEFF)
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_readBatterySelfTestLedParamsWithMode:(NSInteger)mode
                                  bleMacAddress:(NSString *)bleMacAddress
                                     macAddress:(NSString *)macAddress
                                          topic:(NSString *)topic
                                       sucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock;

/// Battery self test led Params .
/// @param mode 0:When battery voltage<threshold    1:When battery voltage>=threshold
/// @param ledColor led color.
/// @param interval Blinking interval.(0 * 100ms~100 * 100ms)
/// @param duration Blinking duration.(0s~255s)
/// @param bleMacAddressThe mac address of the target bluetooth device.(e.g.AABBCCDDEEFF)
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_configBatterySelfTestLedParams:(NSInteger)mode
                                 ledColor:(mk_ch_reminderLedColor)ledColor
                                 interval:(NSInteger)interval
                                 duration:(NSInteger)duration
                            bleMacAddress:(NSString *)bleMacAddress
                               macAddress:(NSString *)macAddress
                                    topic:(NSString *)topic
                                 sucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/// Accelerometer parameters.
/// @param bleMacAddress The mac address of the target bluetooth device.(e.g.AABBCCDDEEFF)
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_readAccelerometerParamsWithBleMacAddress:(NSString *)bleMacAddress
                                         macAddress:(NSString *)macAddress
                                              topic:(NSString *)topic
                                           sucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock;

/// Accelerometer parameters.
/// @param bleMacAddress The mac address of the target bluetooth device.(e.g.AABBCCDDEEFF)
/// @param sampleRate Sample rate.
/// @param fullScale Full scale
/// @param sensitivity 0~255.If the fullScale is mk_ch_threeAxisDataFullScale0,unit of sensitivity is 3.91mg. If the fullScale is mk_ch_threeAxisDataFullScale1,unit of sensitivity is 7.81mg. If the fullScale is mk_ch_threeAxisDataFullScale2,unit of sensitivity is 15.63mg. If the fullScale is mk_ch_threeAxisDataFullScale3,unit of sensitivity is 31.25mg.
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_configAccelerometerParamsWithBleMacAddress:(NSString *)bleMacAddress
                                           sampleRate:(mk_ch_threeAxisSampleRate)sampleRate
                                            fullScale:(mk_ch_threeAxisDataFullScale)fullScale
                                          sensitivity:(NSInteger)sensitivity
                                           macAddress:(NSString *)macAddress
                                                topic:(NSString *)topic
                                             sucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Sleep mode parameters.
/// @param bleMacAddress The mac address of the target bluetooth device.(e.g.AABBCCDDEEFF)
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_readSleepModeParametersWithBleMacAddress:(NSString *)bleMacAddress
                                         macAddress:(NSString *)macAddress
                                              topic:(NSString *)topic
                                           sucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock;

/// Sleep mode parameters.
/// @param bleMacAddress The mac address of the target bluetooth device.(e.g.AABBCCDDEEFF)
/// @param time 0s~65535s.
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_configSleepModeParametersWithBleMacAddress:(NSString *)bleMacAddress
                                                 time:(NSInteger)time
                                           macAddress:(NSString *)macAddress
                                                topic:(NSString *)topic
                                             sucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError *error))failedBlock;


///ADV parameters
/// @param type type
/// @param bleMacAddress The mac address of the target bluetooth device.(e.g.AABBCCDDEEFF)
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_readAdvParamsWithType:(mk_ch_advParamsType)type
                   bleMacAddress:(NSString *)bleMacAddress
                      macAddress:(NSString *)macAddress
                           topic:(NSString *)topic
                        sucBlock:(void (^)(id returnData))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock;

///ADV parameters
/// @param type type
/// @param bleMacAddress The mac address of the target bluetooth device.(e.g.AABBCCDDEEFF)
/// @param interval Adv interval.100ms-65535ms.
/// @param duration Adv duration.1s-65535s.
/// @param txPower txPower
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_configAdvParamsWithType:(mk_ch_advParamsType)type
                     bleMacAddress:(NSString *)bleMacAddress
                          interval:(NSInteger)interval
                          duration:(NSInteger)duration
                           txPower:(mk_ch_txPower)txPower
                        macAddress:(NSString *)macAddress
                             topic:(NSString *)topic
                          sucBlock:(void (^)(id returnData))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;

/// Change Password.
/// @param bleMacAddress The mac address of the target bluetooth device.(e.g.AABBCCDDEEFF)
/// @param password 1~16 Characters.
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_configPasswordVerificationWithBleMacAddress:(NSString *)bleMacAddress
                                              password:(NSString *)password
                                            macAddress:(NSString *)macAddress
                                                 topic:(NSString *)topic
                                              sucBlock:(void (^)(id returnData))sucBlock
                                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Password verification.
/// @param bleMacAddress The mac address of the target bluetooth device.(e.g.AABBCCDDEEFF)
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_readPasswordVerificationStatusWithBleMacAddress:(NSString *)bleMacAddress
                                                macAddress:(NSString *)macAddress
                                                     topic:(NSString *)topic
                                                  sucBlock:(void (^)(id returnData))sucBlock
                                               failedBlock:(void (^)(NSError *error))failedBlock;

/// Password verification.
/// @param bleMacAddress The mac address of the target bluetooth device.(e.g.AABBCCDDEEFF)
/// @param isOn isOn
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_configPasswordVerificationStatusWithBleMacAddress:(NSString *)bleMacAddress
                                                        isOn:(NSInteger)isOn
                                                  macAddress:(NSString *)macAddress
                                                       topic:(NSString *)topic
                                                    sucBlock:(void (^)(id returnData))sucBlock
                                                 failedBlock:(void (^)(NSError *error))failedBlock;

/// Read Button Log.
/// @param bleMacAddress The mac address of the target bluetooth device.(e.g.AABBCCDDEEFF)
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_readButtonLogWithBleMacAddress:(NSString *)bleMacAddress
                               macAddress:(NSString *)macAddress
                                    topic:(NSString *)topic
                                 sucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/// Clear Button Log.
/// @param bleMacAddress The mac address of the target bluetooth device.(e.g.AABBCCDDEEFF)
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_clearButtonLogWithBleMacAddress:(NSString *)bleMacAddress
                                macAddress:(NSString *)macAddress
                                     topic:(NSString *)topic
                                  sucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock;

/// SOS alarm notifications.
/// @param bleMacAddress The mac address of the target bluetooth device.(e.g.AABBCCDDEEFF)
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_readSosAlarmNotiWithBleMacAddress:(NSString *)bleMacAddress
                                  macAddress:(NSString *)macAddress
                                       topic:(NSString *)topic
                                    sucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock;

/// SOS alarm notifications.
/// @param color LED Color.
/// @param ledBlinkingInterval Led off time Range: 0 x 100ms~100 x 100ms
/// @param ledBlinkingDuration Led flash time Range: 1s~255s
/// @param buzzerBeepingInterval Buzzer off time Range: 0 x 100ms~100 x 100ms
/// @param buzzerBeepingDuration Buzzer work time.(0 * 100ms~655 * 100ms)
/// @param bleMacAddressThe mac address of the target bluetooth device.(e.g.AABBCCDDEEFF)
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_configSosAlarmNotiWithColor:(mk_ch_reminderLedColor)color
                   ledBlinkingInterval:(NSInteger)ledBlinkingInterval
                   ledBlinkingDuration:(NSInteger)ledBlinkingDuration
                 buzzerBeepingInterval:(NSInteger)buzzerBeepingInterval
                 buzzerBeepingDuration:(NSInteger)buzzerBeepingDuration
                         bleMacAddress:(NSString *)bleMacAddress
                            macAddress:(NSString *)macAddress
                                 topic:(NSString *)topic
                              sucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Hardware test parameters.(Led and buzzer parameters)
/// @param bleMacAddress The mac address of the target bluetooth device.(e.g.AABBCCDDEEFF)
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_readHardwareSelfTestWithBleMacAddress:(NSString *)bleMacAddress
                                      macAddress:(NSString *)macAddress
                                           topic:(NSString *)topic
                                        sucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock;

/// Hardware test parameters.(Led and buzzer parameters)
/// @param ledBlinkingDuration Led flash time Range: 1s~255s
/// @param buzzerBeepingInterval Buzzer off time Range: 0 x 100ms~100 x 100ms
/// @param buzzerBeepingDuration Buzzer work time.(0 * 100ms~655 * 100ms)
/// @param bleMacAddressThe mac address of the target bluetooth device.(e.g.AABBCCDDEEFF)
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_configHardwareSelfTestLedBlinkingDuration:(NSInteger)ledBlinkingDuration
                               buzzerBeepingInterval:(NSInteger)buzzerBeepingInterval
                               buzzerBeepingDuration:(NSInteger)buzzerBeepingDuration
                                       bleMacAddress:(NSString *)bleMacAddress
                                          macAddress:(NSString *)macAddress
                                               topic:(NSString *)topic
                                            sucBlock:(void (^)(id returnData))sucBlock
                                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Dismiss SOS alarm notifications.
/// @param bleMacAddress The mac address of the target bluetooth device.(e.g.AABBCCDDEEFF)
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_readDismissSosAlarmNotiWithBleMacAddress:(NSString *)bleMacAddress
                                         macAddress:(NSString *)macAddress
                                              topic:(NSString *)topic
                                           sucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock;

/// Dismiss SOS alarm notifications.
/// @param color LED Color.
/// @param ledBlinkingInterval Led off time Range: 0 x 100ms~100 x 100ms
/// @param ledBlinkingDuration Led flash time Range: (0 * 100ms~655 * 100ms)
/// @param buzzerBeepingInterval Buzzer off time Range: 0 x 100ms~100 x 100ms
/// @param buzzerBeepingDuration Buzzer work time.(0 * 100ms~655 * 100ms)
/// @param bleMacAddressThe mac address of the target bluetooth device.(e.g.AABBCCDDEEFF)
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_configDismissSosAlarmNotiWithColor:(mk_ch_reminderLedColor)color
                          ledBlinkingInterval:(NSInteger)ledBlinkingInterval
                          ledBlinkingDuration:(NSInteger)ledBlinkingDuration
                        buzzerBeepingInterval:(NSInteger)buzzerBeepingInterval
                        buzzerBeepingDuration:(NSInteger)buzzerBeepingDuration
                                bleMacAddress:(NSString *)bleMacAddress
                                   macAddress:(NSString *)macAddress
                                        topic:(NSString *)topic
                                     sucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Button press effective interval.
/// @param bleMacAddress The mac address of the target bluetooth device.(e.g.AABBCCDDEEFF)
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_readButtonPressEffectiveIntervalWithBleMacAddress:(NSString *)bleMacAddress
                                                  macAddress:(NSString *)macAddress
                                                       topic:(NSString *)topic
                                                    sucBlock:(void (^)(id returnData))sucBlock
                                                 failedBlock:(void (^)(NSError *error))failedBlock;

/// Button press effective interval.
/// @param bleMacAddress The mac address of the target bluetooth device.(e.g.AABBCCDDEEFF)
/// @param interval 5 x 100ms~20 x 100ms.
/// @param macAddress WIFI_STA Mac address of the device.(e.g.AABBCCDDEEFF)
/// @param topic topic 1-128 Characters
/// @param sucBlock Success callback
/// @param failedBlock Failed callback
+ (void)ch_configButtonPressEffectiveIntervalWithBleMacAddress:(NSString *)bleMacAddress
                                                      interval:(NSInteger)interval
                                                    macAddress:(NSString *)macAddress
                                                         topic:(NSString *)topic
                                                      sucBlock:(void (^)(id returnData))sucBlock
                                                   failedBlock:(void (^)(NSError *error))failedBlock;


@end

NS_ASSUME_NONNULL_END
