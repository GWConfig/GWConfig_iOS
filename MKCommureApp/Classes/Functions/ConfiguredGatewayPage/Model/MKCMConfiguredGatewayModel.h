//
//  MKCMConfiguredGatewayModel.h
//  MKCommureApp_Example
//
//  Created by aa on 2023/7/10.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, cm_ConfiguredGatewayStatus) {
    cm_ConfiguredGatewayStatus_nornal,           //对应Wait
    cm_ConfiguredGatewayStatus_upgrading,        //对应Upgrading
    cm_ConfiguredGatewayStatus_timeout,          //对应timeout
    cm_ConfiguredGatewayStatus_success,          //对应Success
    cm_ConfiguredGatewayStatus_failed,           //对应Failed
};

NS_ASSUME_NONNULL_BEGIN

@interface MKCMConfiguredGatewayModel : NSObject

@property (nonatomic, copy)NSString *macAddress;

@property (nonatomic, copy)NSString *subTopic;

@property (nonatomic, copy)NSString *pubTopic;

@property (nonatomic, copy)NSString *filePath;

- (void)otaWithResultBlock:(void (^)(NSString *macAddress, cm_ConfiguredGatewayStatus status))block;

@end

NS_ASSUME_NONNULL_END
