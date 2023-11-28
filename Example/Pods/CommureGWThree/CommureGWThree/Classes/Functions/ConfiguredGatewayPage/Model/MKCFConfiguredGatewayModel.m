//
//  MKCFConfiguredGatewayModel.m
//  CommureGWThree_Example
//
//  Created by aa on 2023/10/18.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import "MKCFConfiguredGatewayModel.h"

@implementation MKCFConfiguredGatewayModel

- (instancetype)init {
    if (self = [super init]) {
        self.pubTopic = @"/provision/gateway/data";
        self.subTopic = @"/provision/gateway/cmds";
    }
    return self;
}

@end
