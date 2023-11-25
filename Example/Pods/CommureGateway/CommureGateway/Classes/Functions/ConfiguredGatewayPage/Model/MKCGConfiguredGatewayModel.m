//
//  MKCGConfiguredGatewayModel.m
//  CommureGateway_Example
//
//  Created by aa on 2023/10/18.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import "MKCGConfiguredGatewayModel.h"

@implementation MKCGConfiguredGatewayModel

- (instancetype)init {
    if (self = [super init]) {
        self.pubTopic = @"/provision/gateway/data";
        self.subTopic = @"/provision/gateway/cmds";
    }
    return self;
}

@end
