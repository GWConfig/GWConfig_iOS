//
//  MKCHDeviceConnectedModel.h
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/4/21.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCHDeviceConnectedModel : NSObject

@property (nonatomic, copy)NSString *deviceBleMacAddress;



@property (nonatomic, copy)NSString *tagID;

@property (nonatomic, copy)NSString *battery;

/// 0-Not triggered, 1-Triggered，2-Triggered&Dismissed,3-Self testing
@property (nonatomic, assign)NSInteger alarmStatus;

@property (nonatomic, assign)BOOL passwordVerification;


/// 0:Red 1:Blue 2:Green
@property (nonatomic, assign)NSInteger rgb;

@property (nonatomic, copy)NSString *blinkingInterval;

@property (nonatomic, copy)NSString *blinkingDuration;



@property (nonatomic, copy)NSString *ringInterval;

@property (nonatomic, copy)NSString *ringDuration;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
