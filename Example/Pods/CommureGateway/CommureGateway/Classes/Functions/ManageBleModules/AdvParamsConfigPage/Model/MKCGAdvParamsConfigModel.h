//
//  MKCGAdvParamsConfigModel.h
//  CommureGateway_Example
//
//  Created by aa on 2023/4/24.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCGAdvParamsConfigModel : NSObject

@property (nonatomic, copy)NSString *bleMac;

@property (nonatomic, copy)NSString *configInterval;

@property (nonatomic, copy)NSString *configDuration;

@property (nonatomic, assign)NSInteger configTxPower;

@property (nonatomic, copy)NSString *normalInterval;

@property (nonatomic, copy)NSString *normalDuration;

@property (nonatomic, assign)NSInteger normalTxPower;

@property (nonatomic, copy)NSString *triggerInterval;

@property (nonatomic, copy)NSString *triggerDuration;

@property (nonatomic, assign)NSInteger triggerTxPower;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
