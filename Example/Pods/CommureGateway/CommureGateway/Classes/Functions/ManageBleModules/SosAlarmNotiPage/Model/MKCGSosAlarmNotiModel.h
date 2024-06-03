//
//  MKCGSosAlarmNotiModel.h
//  CommureGateway_Example
//
//  Created by aa on 2024/5/9.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCGSosAlarmNotiModel : NSObject

@property (nonatomic, copy)NSString *bleMac;

@property (nonatomic, assign)BOOL dismiss;


@property (nonatomic, assign)NSInteger color;

@property (nonatomic, copy)NSString *ledInterval;

@property (nonatomic, copy)NSString *ledDuration;

@property (nonatomic, copy)NSString *beepingInterval;

@property (nonatomic, copy)NSString *beepingDuration;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
