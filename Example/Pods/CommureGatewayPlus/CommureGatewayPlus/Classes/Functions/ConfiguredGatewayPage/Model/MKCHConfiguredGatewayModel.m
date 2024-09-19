//
//  MKCHConfiguredGatewayModel.m
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/10/18.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import "MKCHConfiguredGatewayModel.h"

@implementation MKCHConfiguredGatewayModel

- (instancetype)init {
    if (self = [super init]) {
        self.pubTopic = @"/provision/gateway/data";
        self.subTopic = @"/provision/gateway/cmds";
    }
    return self;
}

@end
