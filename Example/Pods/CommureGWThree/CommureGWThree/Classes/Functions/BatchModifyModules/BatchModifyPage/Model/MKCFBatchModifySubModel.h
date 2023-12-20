//
//  MKCFBatchModifySubModel.h
//  CommureGWThree
//
//  Created by aa on 2023/12/14.
//

#import <Foundation/Foundation.h>

#import "MKCFMQTTInterface.h"
#import "MKCFMQTTConfigDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKCFBatchModifySubModel : NSObject

- (void)configDataWithMacAddress:(NSString *)macAddress
                        pubTopic:(NSString *)pubTopic
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
