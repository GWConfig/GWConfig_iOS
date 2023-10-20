//
//  MKCMConfiguredGatewayModel.h
//  MKCommureApp_Example
//
//  Created by aa on 2023/10/18.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCMConfiguredGatewayModel : NSObject

/// 0:MK110   1:MK110 Plus   2:MKGW3
@property (nonatomic, assign)NSInteger deviceType;

@property (nonatomic, copy)NSString *pubTopic;

@property (nonatomic, copy)NSString *subTopic;

@end

NS_ASSUME_NONNULL_END
