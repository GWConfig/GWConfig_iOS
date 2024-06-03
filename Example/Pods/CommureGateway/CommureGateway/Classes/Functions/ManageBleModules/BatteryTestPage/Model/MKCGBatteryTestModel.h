//
//  MKCGBatteryTestModel.h
//  CommureGateway_Example
//
//  Created by aa on 2023/4/23.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCGBatteryTestModel : NSObject

@property (nonatomic, copy)NSString *bleMac;



@property (nonatomic, copy)NSString *ledDuration;

@property (nonatomic, copy)NSString *beepingInterval;

@property (nonatomic, copy)NSString *beepingDuration;

@property (nonatomic, assign)BOOL batteryLedSwitch;

@property (nonatomic, copy)NSString *voltageThreshold;

@property (nonatomic, assign)NSInteger overColor;

@property (nonatomic, copy)NSString *overInterval;

@property (nonatomic, copy)NSString *overDuration;

@property (nonatomic, assign)NSInteger underColor;

@property (nonatomic, copy)NSString *underInterval;

@property (nonatomic, copy)NSString *underDuration;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
