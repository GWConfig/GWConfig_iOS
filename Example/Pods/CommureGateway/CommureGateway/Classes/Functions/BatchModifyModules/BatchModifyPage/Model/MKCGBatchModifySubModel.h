//
//  MKCGBatchModifySubModel.h
//  CommureGateway
//
//  Created by aa on 2023/12/14.
//

#import <Foundation/Foundation.h>

#import "MKCGMQTTInterface.h"
#import "MKCGMQTTConfigDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKCGBatchModifySubModel : NSObject

- (void)configDataWithMacAddress:(NSString *)macAddress
                        pubTopic:(NSString *)pubTopic
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
