//
//  MKCMAccelerometerModel.h
//  MKCommureApp_Example
//
//  Created by aa on 2023/4/23.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCMAccelerometerModel : NSObject

@property (nonatomic, copy)NSString *bleMac;


/// 1/10/25/50/100Hz
@property (nonatomic, assign)NSInteger sampleRate;

/// 2/4/8/16g
@property (nonatomic, assign)NSInteger fullScale;

@property (nonatomic, copy)NSString *sensitivity;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
