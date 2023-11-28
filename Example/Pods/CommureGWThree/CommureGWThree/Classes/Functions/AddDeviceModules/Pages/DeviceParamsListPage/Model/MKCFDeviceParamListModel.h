//
//  MKCFDeviceParamListModel.h
//  CommureGWThree_Example
//
//  Created by aa on 2023/11/23.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCFDeviceParamListModel : NSObject

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END