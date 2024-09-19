//
//  MKCHBatchModifySubModel.h
//  CommureGatewayPlus
//
//  Created by aa on 2023/12/14.
//

#import <Foundation/Foundation.h>

#import "MKCHMQTTInterface.h"
#import "MKCHMQTTConfigDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKCHBatchModifySubModel : NSObject

- (void)configDataWithMacAddress:(NSString *)macAddress
                        pubTopic:(NSString *)pubTopic
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
