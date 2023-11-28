//
//  MKCFBleNetworkSettingsModel.m
//  CommureGWThree_Example
//
//  Created by aa on 2023/1/30.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCFBleNetworkSettingsModel.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKCFInterface.h"
#import "MKCFInterface+MKCFConfig.h"

#import "MKCFDeviceMQTTParamsModel.h"

@interface MKCFBleNetworkSettingsModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKCFBleNetworkSettingsModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        
        if ([MKCFDeviceMQTTParamsModel shared].cloud) {
            //从云端导入，不需要再读取了
            self.security = [[MKCFDeviceMQTTParamsModel shared].params[@"security"] integerValue];
            self.ssid = [MKCFDeviceMQTTParamsModel shared].params[@"wifiSSID"];
            self.wifiPassword = [MKCFDeviceMQTTParamsModel shared].params[@"wifiPassword"];
            self.eapType = [[MKCFDeviceMQTTParamsModel shared].params[@"eap"] integerValue];
            self.eapUserName = [MKCFDeviceMQTTParamsModel shared].params[@"eapUsername"];
            self.eapPassword = [MKCFDeviceMQTTParamsModel shared].params[@"eapPassword"];
            self.domainID = [MKCFDeviceMQTTParamsModel shared].params[@"domainID"];
            self.verifyServer = [[MKCFDeviceMQTTParamsModel shared].params[@"verifyServer"] boolValue];
            //参考MKCFBleMqttConfigSelectModel里面写死的证书名字
            self.caFileName = @"gw3_wifi_ca.pem";
            self.clientCertName = @"gw3_wifi_client.crt";
            self.clientKeyName = @"gw3_wifi_client.key";
            
            self.networkType = [[MKCFDeviceMQTTParamsModel shared].params[@"networkType"] integerValue];
            
            self.wifi_dhcp = [[MKCFDeviceMQTTParamsModel shared].params[@"wifiDHCP"] boolValue];
            self.wifi_ip = [MKCFDeviceMQTTParamsModel shared].params[@"wifiIP"];
            self.wifi_mask = [MKCFDeviceMQTTParamsModel shared].params[@"wifiMask"];
            self.wifi_gateway = [MKCFDeviceMQTTParamsModel shared].params[@"wifiGateway"];
            self.wifi_dns = [MKCFDeviceMQTTParamsModel shared].params[@"wifiDNS"];
            
            self.ethernet_dhcp = [[MKCFDeviceMQTTParamsModel shared].params[@"ethernetDHCP"] boolValue];
            self.ethernet_ip = [MKCFDeviceMQTTParamsModel shared].params[@"ethernetIP"];
            self.ethernet_mask = [MKCFDeviceMQTTParamsModel shared].params[@"ethernetMask"];
            self.ethernet_gateway = [MKCFDeviceMQTTParamsModel shared].params[@"ethernetGateway"];
            self.ethernet_dns = [MKCFDeviceMQTTParamsModel shared].params[@"ethernetDNS"];
            
            moko_dispatch_main_safe(^{
                if (sucBlock) {
                    sucBlock();
                }
            });
            return;
        }
        
        if (![self readNetworkType]) {
            [self operationFailedBlockWithMsg:@"Read Network Type Error" block:failedBlock];
            return;
        }
        if (![self readSecurityType]) {
            [self operationFailedBlockWithMsg:@"Read Security Type Error" block:failedBlock];
            return;
        }
        if (![self readWifiSSID]) {
            [self operationFailedBlockWithMsg:@"Read WIFI SSID Error" block:failedBlock];
            return;
        }
        if (![self readWifiPassword]) {
            [self operationFailedBlockWithMsg:@"Read WIFI Password Error" block:failedBlock];
            return;
        }
        if (![self readEAPType]) {
            [self operationFailedBlockWithMsg:@"Read EAP Type Error" block:failedBlock];
            return;
        }
        if (![self readEAPUsername]) {
            [self operationFailedBlockWithMsg:@"Read EAP Username Error" block:failedBlock];
            return;
        }
        if (![self readEAPPassword]) {
            [self operationFailedBlockWithMsg:@"Read EAP Password Error" block:failedBlock];
            return;
        }
        if (![self readEAPDomainID]) {
            [self operationFailedBlockWithMsg:@"Read EAP Domain ID Error" block:failedBlock];
            return;
        }
        if (![self readVerifyServer]) {
            [self operationFailedBlockWithMsg:@"Read EAP Verify Server Error" block:failedBlock];
            return;
        }
        if (![self readWifiDHCPStatus]) {
            [self operationFailedBlockWithMsg:@"Read Wifi DHCP Error" block:failedBlock];
            return;
        }
        if (![self readWifiIpAddress]) {
            [self operationFailedBlockWithMsg:@"Read Wifi Ip Error" block:failedBlock];
            return;
        }
        if (![self readEthernetDHCPStatus]) {
            [self operationFailedBlockWithMsg:@"Read Ethernet DHCP Error" block:failedBlock];
            return;
        }
        if (![self readEthernetIpAddress]) {
            [self operationFailedBlockWithMsg:@"Read Ethernet Ip Error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        NSString *msg = [self checkMsg];
        if (ValidStr(msg)) {
            [self operationFailedBlockWithMsg:msg block:failedBlock];
            return;
        }
        if (![self configNetworkType]) {
            [self operationFailedBlockWithMsg:@"Config Network Type Error" block:failedBlock];
            return;
        }
        if (self.networkType == 0) {
            //Network Type 为Ethernet
            
            if (![self configEthernetDHCPStatus]) {
                [self operationFailedBlockWithMsg:@"Config DHCP Error" block:failedBlock];
                return;
            }
            if (!self.ethernet_dhcp) {
                if (![self configEthernetIpAddress]) {
                    [self operationFailedBlockWithMsg:@"Config IP Error" block:failedBlock];
                    return;
                }
            }
            
            
            [self updateValues];
            
            moko_dispatch_main_safe(^{
                if (sucBlock) {
                    sucBlock();
                }
            });
            return;
        }
        //Network Type 为Wifi
        if (![self configSecurityType]) {
            [self operationFailedBlockWithMsg:@"Config Security Type Error" block:failedBlock];
            return;
        }
        if (![self configWifiSSID]) {
            [self operationFailedBlockWithMsg:@"Config WIFI SSID Error" block:failedBlock];
            return;
        }
        if (self.security == 0) {
            //Personal
            if (![self configWifiPassword]) {
                [self operationFailedBlockWithMsg:@"Config WIFI Password Error" block:failedBlock];
                return;
            }
        }
        if (self.security == 1) {
           //Enterprise
            if (![self configEAPType]) {
                [self operationFailedBlockWithMsg:@"Config EAP Type Error" block:failedBlock];
                return;
            }
            if (self.eapType == 0 || self.eapType == 1) {
                //PEAP-MSCHAPV2/TTLS-MSCHAPV2
                if (![self configEAPUsername]) {
                    [self operationFailedBlockWithMsg:@"Config EAP Username Error" block:failedBlock];
                    return;
                }
                if (![self configEAPPassword]) {
                    [self operationFailedBlockWithMsg:@"Config EAP Password Error" block:failedBlock];
                    return;
                }
                if (![self configVerifyServer]) {
                    [self operationFailedBlockWithMsg:@"Config Verify Server Error" block:failedBlock];
                    return;
                }
                if (self.verifyServer) {
                    if (![self configCAFile]) {
                        [self operationFailedBlockWithMsg:@"Config CA File Error" block:failedBlock];
                        return;
                    }
                }
            }
            if (self.eapType == 2) {
                //TLS
                if (![self configEAPDomainID]) {
                    [self operationFailedBlockWithMsg:@"Config EAP Domain ID Error" block:failedBlock];
                    return;
                }
                if (![self configCAFile]) {
                    [self operationFailedBlockWithMsg:@"Config CA File Error" block:failedBlock];
                    return;
                }
                if (ValidStr(self.clientKeyName)) {
                    if (![self configClientKey]) {
                        [self operationFailedBlockWithMsg:@"Config Client Key Error" block:failedBlock];
                        return;
                    }
                }
                if (ValidStr(self.clientCertName)) {
                    if (![self configClientCert]) {
                        [self operationFailedBlockWithMsg:@"Config Client Cert Error" block:failedBlock];
                        return;
                    }
                }
            }
        }
        if (![self configWifiDHCPStatus]) {
            [self operationFailedBlockWithMsg:@"Config DHCP Error" block:failedBlock];
            return;
        }
        if (!self.wifi_dhcp) {
            if (![self configWifiIpAddress]) {
                [self operationFailedBlockWithMsg:@"Config IP Error" block:failedBlock];
                return;
            }
        }
        
        [self updateValues];
        
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

#pragma mark - interface

#pragma mark - Network Type

- (BOOL)readNetworkType {
    __block BOOL success = NO;
    [MKCFInterface cf_readNetworkTypeWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.networkType = [returnData[@"result"][@"type"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configNetworkType {
    __block BOOL success = NO;
    [MKCFInterface cf_configNetworkType:self.networkType sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - Wifi Settings

- (BOOL)readSecurityType {
    __block BOOL success = NO;
    [MKCFInterface cf_readWIFISecurityWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.security = [returnData[@"result"][@"security"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configSecurityType {
    __block BOOL success = NO;
    [MKCFInterface cf_configWIFISecurity:self.security sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readWifiSSID {
    __block BOOL success = NO;
    [MKCFInterface cf_readWIFISSIDWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.ssid = returnData[@"result"][@"ssid"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configWifiSSID {
    __block BOOL success = NO;
    [MKCFInterface cf_configWIFISSID:self.ssid sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readWifiPassword {
    __block BOOL success = NO;
    [MKCFInterface cf_readWIFIPasswordWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.wifiPassword = returnData[@"result"][@"password"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configWifiPassword {
    __block BOOL success = NO;
    [MKCFInterface cf_configWIFIPassword:self.wifiPassword sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readEAPType {
    __block BOOL success = NO;
    [MKCFInterface cf_readWIFIEAPTypeWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.eapType = [returnData[@"result"][@"eapType"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configEAPType {
    __block BOOL success = NO;
    [MKCFInterface cf_configWIFIEAPType:self.eapType sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readEAPUsername {
    __block BOOL success = NO;
    [MKCFInterface cf_readWIFIEAPUsernameWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.eapUserName = returnData[@"result"][@"username"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configEAPUsername {
    __block BOOL success = NO;
    [MKCFInterface cf_configWIFIEAPUsername:self.eapUserName sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readEAPPassword {
    __block BOOL success = NO;
    [MKCFInterface cf_readWIFIEAPPasswordWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.eapPassword = returnData[@"result"][@"password"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configEAPPassword {
    __block BOOL success = NO;
    [MKCFInterface cf_configWIFIEAPPassword:self.eapPassword sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readEAPDomainID {
    __block BOOL success = NO;
    [MKCFInterface cf_readWIFIEAPDomainIDWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.domainID = returnData[@"result"][@"domainID"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configEAPDomainID {
    __block BOOL success = NO;
    [MKCFInterface cf_configWIFIEAPDomainID:self.domainID sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readVerifyServer {
    __block BOOL success = NO;
    [MKCFInterface cf_readWIFIVerifyServerStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.verifyServer = [returnData[@"result"][@"verify"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configVerifyServer {
    __block BOOL success = NO;
    [MKCFInterface cf_configWIFIVerifyServerStatus:self.verifyServer sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configCAFile {
    __block BOOL success = NO;
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [document stringByAppendingPathComponent:self.caFileName];
    NSData *caData = [NSData dataWithContentsOfFile:filePath];
    if (!ValidData(caData)) {
        return NO;
    }
    [MKCFInterface cf_configWIFICAFile:caData sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configClientKey {
    __block BOOL success = NO;
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [document stringByAppendingPathComponent:self.clientKeyName];
    NSData *clientKeyData = [NSData dataWithContentsOfFile:filePath];
    if (!ValidData(clientKeyData)) {
        return NO;
    }
    [MKCFInterface cf_configWIFIClientPrivateKey:clientKeyData sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configClientCert {
    __block BOOL success = NO;
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [document stringByAppendingPathComponent:self.clientCertName];
    NSData *clientCertData = [NSData dataWithContentsOfFile:filePath];
    if (!ValidData(clientCertData)) {
        return NO;
    }
    [MKCFInterface cf_configWIFIClientCert:clientCertData sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - Wifi Network Settings
- (BOOL)readWifiDHCPStatus {
    __block BOOL success = NO;
    [MKCFInterface cf_readWIFIDHCPStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.wifi_dhcp = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configWifiDHCPStatus {
    __block BOOL success = NO;
    [MKCFInterface cf_configWIFIDHCPStatus:self.wifi_dhcp sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readWifiIpAddress {
    __block BOOL success = NO;
    [MKCFInterface cf_readWIFINetworkIpInfosWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.wifi_ip = returnData[@"result"][@"ip"];
        self.wifi_mask = returnData[@"result"][@"mask"];
        self.wifi_gateway = returnData[@"result"][@"gateway"];
        self.wifi_dns = returnData[@"result"][@"dns"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configWifiIpAddress {
    __block BOOL success = NO;
    [MKCFInterface cf_configWIFIIpAddress:self.wifi_ip
                                     mask:self.wifi_mask
                                  gateway:self.wifi_gateway
                                      dns:self.wifi_dns
                                 sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    }
                          failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - Ethernet Network Settings
- (BOOL)readEthernetDHCPStatus {
    __block BOOL success = NO;
    [MKCFInterface cf_readEthernetDHCPStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.ethernet_dhcp = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configEthernetDHCPStatus {
    __block BOOL success = NO;
    [MKCFInterface cf_configEthernetDHCPStatus:self.ethernet_dhcp sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readEthernetIpAddress {
    __block BOOL success = NO;
    [MKCFInterface cf_readEthernetNetworkIpInfosWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.ethernet_ip = returnData[@"result"][@"ip"];
        self.ethernet_mask = returnData[@"result"][@"mask"];
        self.ethernet_gateway = returnData[@"result"][@"gateway"];
        self.ethernet_dns = returnData[@"result"][@"dns"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configEthernetIpAddress {
    __block BOOL success = NO;
    [MKCFInterface cf_configWIFIIpAddress:self.ethernet_ip
                                     mask:self.ethernet_mask
                                  gateway:self.ethernet_gateway
                                      dns:self.ethernet_dns
                                 sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    }
                          failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - private method
- (void)updateValues {
    if (![MKCFDeviceMQTTParamsModel shared].cloud) {
        return;
    }
    //从云端导入
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[MKCFDeviceMQTTParamsModel shared].params];
    
    [dic setObject:@(self.networkType) forKey:@"networkType"];
    
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)self.security] forKey:@"security"];
    [dic setObject:SafeStr(self.ssid) forKey:@"wifiSSID"];
    [dic setObject:SafeStr(self.wifiPassword) forKey:@"wifiPassword"];
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)self.eapType] forKey:@"eap"];
    [dic setObject:SafeStr(self.eapUserName) forKey:@"eapUsername"];
    [dic setObject:SafeStr(self.eapPassword) forKey:@"eapPassword"];
    [dic setObject:SafeStr(self.domainID) forKey:@"domainID"];
    [dic setObject:@(self.verifyServer) forKey:@"verifyServer"];
    
    [dic setObject:@(self.wifi_dhcp) forKey:@"wifiDHCP"];
    [dic setObject:SafeStr(self.wifi_ip) forKey:@"wifiIP"];
    [dic setObject:SafeStr(self.wifi_mask) forKey:@"wifiMask"];
    [dic setObject:SafeStr(self.wifi_gateway) forKey:@"wifiGateway"];
    [dic setObject:SafeStr(self.wifi_dns) forKey:@"wifiDNS"];
    
    [dic setObject:@(self.ethernet_dhcp) forKey:@"ethernetDHCP"];
    [dic setObject:SafeStr(self.ethernet_ip) forKey:@"ethernetIP"];
    [dic setObject:SafeStr(self.ethernet_mask) forKey:@"ethernetMask"];
    [dic setObject:SafeStr(self.ethernet_gateway) forKey:@"ethernetGateway"];
    [dic setObject:SafeStr(self.ethernet_dns) forKey:@"ethernetDNS"];
    
    [MKCFDeviceMQTTParamsModel shared].params = dic;
}

- (NSString *)checkMsg {
    if (self.networkType == 1) {
        //Wifi
        NSString *wifiMsg = [self checkWifiMsg];
        if (ValidStr(wifiMsg)) {
            return wifiMsg;
        }
    }
    
    NSString *networkMsg = [self checkNetworkMsg];
    if (ValidStr(networkMsg)) {
        return networkMsg;
    }
    return @"";
}

- (NSString *)checkNetworkMsg {
    if (self.networkType == 0) {
        //ethernet
        if (self.ethernet_dhcp) {
            return @"";
        }
        if (![self.ethernet_ip regularExpressions:isIPAddress]) {
            return @"IP Error";
        }
        if (![self.ethernet_mask regularExpressions:isIPAddress]) {
            return @"Mask Error";
        }
        if (![self.ethernet_gateway regularExpressions:isIPAddress]) {
            return @"Gateway Error";
        }
        if (![self.ethernet_dns regularExpressions:isIPAddress]) {
            return @"DNS Error";
        }
        return @"";
    }
    if (self.wifi_dhcp) {
        return @"";
    }
    if (![self.wifi_ip regularExpressions:isIPAddress]) {
        return @"IP Error";
    }
    if (![self.wifi_mask regularExpressions:isIPAddress]) {
        return @"Mask Error";
    }
    if (![self.wifi_gateway regularExpressions:isIPAddress]) {
        return @"Gateway Error";
    }
    if (![self.wifi_dns regularExpressions:isIPAddress]) {
        return @"DNS Error";
    }
    return @"";
}

- (NSString *)checkWifiMsg {
    if (!ValidStr(self.ssid) || self.ssid.length > 32) {
        return @"ssid error";
    }
    if (self.security == 0) {
        //Personal
        if (self.wifiPassword.length > 64) {
            return @"password error";
        }
        return @"";
    }
    //Enterprise
    if (self.eapType == 0 || self.eapType == 1) {
        //PEAP-MSCHAPV2/TTLS-MSCHAPV2
        if (self.eapUserName.length > 32) {
            return @"username error";
        }
        if (self.eapPassword.length > 64) {
            return @"password error";
        }
        if (self.verifyServer && !ValidStr(self.caFileName)) {
            return @"CA File cannot be empty.";
        }
    }
    if (self.eapType == 2) {
        //TLS
        if (self.domainID.length > 64) {
            return @"domain ID error";
        }
        if (!ValidStr(self.caFileName)) {
            return @"CA File cannot be empty.";
        }
//        if (!ValidStr(self.clientKeyName) || !ValidStr(self.clientCertName)) {
//            return @"Client File cannot be empty.";
//        }
    }
    return @"";
}

- (void)operationFailedBlockWithMsg:(NSString *)msg block:(void (^)(NSError *error))block {
    moko_dispatch_main_safe(^{
        NSError *error = [[NSError alloc] initWithDomain:@"NetworkSettings"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    })
}

#pragma mark - getter
- (dispatch_semaphore_t)semaphore {
    if (!_semaphore) {
        _semaphore = dispatch_semaphore_create(0);
    }
    return _semaphore;
}

- (dispatch_queue_t)readQueue {
    if (!_readQueue) {
        _readQueue = dispatch_queue_create("WifiSettingsQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
