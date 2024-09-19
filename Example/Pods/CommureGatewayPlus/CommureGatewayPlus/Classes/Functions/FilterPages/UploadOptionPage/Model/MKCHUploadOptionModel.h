//
//  MKCHUploadOptionModel.h
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/2/6.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCHUploadOptionModel : NSObject

@property (nonatomic, assign)NSInteger rssi;

/// 0:Null   1:Only MAC    2:Only Tag id   3:MAC | Tag id   4:MAC & Tag id
@property (nonatomic, assign)NSInteger relationship;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
