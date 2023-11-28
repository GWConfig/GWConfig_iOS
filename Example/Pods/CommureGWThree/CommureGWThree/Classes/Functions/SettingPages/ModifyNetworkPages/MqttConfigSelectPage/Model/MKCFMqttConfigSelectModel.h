//
//  MKCFMqttConfigSelectModel.h
//  CommureGWThree_Example
//
//  Created by aa on 2023/11/22.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCFMqttConfigSelectModel : NSObject

/// 0: Import Config File - Cloud       1:Manual setting
@property (nonatomic, assign)NSInteger fileType;

@property (nonatomic, copy)NSString *url;

- (void)startDownFileWithSucBlock:(void (^)(NSDictionary *params))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
