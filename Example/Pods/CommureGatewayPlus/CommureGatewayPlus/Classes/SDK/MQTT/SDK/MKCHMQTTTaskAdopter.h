//
//  MKCHMQTTTaskAdopter.h
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/2/4.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCHMQTTTaskAdopter : NSObject

+ (NSDictionary *)parseDataWithJson:(NSDictionary *)json topic:(NSString *)topic;

@end

NS_ASSUME_NONNULL_END
