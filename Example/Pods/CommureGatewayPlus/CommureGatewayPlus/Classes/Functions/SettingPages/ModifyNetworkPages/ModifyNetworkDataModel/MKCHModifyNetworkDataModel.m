//
//  MKCHModifyNetworkDataModel.m
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/11/23.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import "MKCHModifyNetworkDataModel.h"

static MKCHModifyNetworkDataModel *paramsModel = nil;
static dispatch_once_t onceToken;

@implementation MKCHModifyNetworkDataModel

+ (MKCHModifyNetworkDataModel *)shared {
    dispatch_once(&onceToken, ^{
        if (!paramsModel) {
            paramsModel = [MKCHModifyNetworkDataModel new];
        }
    });
    return paramsModel;
}

+ (void)sharedDealloc {
    paramsModel = nil;
    onceToken = 0;
}

@end
