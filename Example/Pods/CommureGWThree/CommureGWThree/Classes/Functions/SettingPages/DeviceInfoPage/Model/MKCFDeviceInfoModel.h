//
//  MKCFDeviceInfoModel.h
//  CommureGWThree_Example
//
//  Created by aa on 2023/1/31.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCFDeviceInfoModel : NSObject

@property (nonatomic, copy)NSString *deviceName;

@property (nonatomic, copy)NSString *productMode;

@property (nonatomic, copy)NSString *manu;

@property (nonatomic, copy)NSString *firmware;

@property (nonatomic, copy)NSString *software;

@property (nonatomic, copy)NSString *hardware;

@property (nonatomic, copy)NSString *wifiStaMac;

@property (nonatomic, copy)NSString *ethernetMac;

@property (nonatomic, copy)NSString *btMac;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
