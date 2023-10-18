//
//  MKCMSettingModel.h
//  MKCommureApp_Example
//
//  Created by aa on 2023/2/4.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCMSettingModel : NSObject

@property (nonatomic, assign)BOOL advIsOn;

@property (nonatomic, assign)BOOL powerSwitch;

@property (nonatomic, copy)NSString *advTime;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
