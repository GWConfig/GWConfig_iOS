//
//  MKCFBatchDfuBeaconModel.h
//  CommureGWThree_Example
//
//  Created by aa on 2023/4/21.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCFBatchDfuBeaconModel : NSObject

@property (nonatomic, copy)NSString *firmwareUrl;

@property (nonatomic, copy)NSString *dataUrl;

@property (nonatomic, copy)NSString *password;

- (void)configDataWithBeaconList:(NSArray <NSString *>*)list
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
