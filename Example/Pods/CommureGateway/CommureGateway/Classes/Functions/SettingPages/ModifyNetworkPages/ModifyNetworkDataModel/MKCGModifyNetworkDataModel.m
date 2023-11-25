//
//  MKCGModifyNetworkDataModel.m
//  CommureGateway_Example
//
//  Created by aa on 2023/11/23.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import "MKCGModifyNetworkDataModel.h"

static MKCGModifyNetworkDataModel *paramsModel = nil;
static dispatch_once_t onceToken;

@implementation MKCGModifyNetworkDataModel

+ (MKCGModifyNetworkDataModel *)shared {
    dispatch_once(&onceToken, ^{
        if (!paramsModel) {
            paramsModel = [MKCGModifyNetworkDataModel new];
        }
    });
    return paramsModel;
}

+ (void)sharedDealloc {
    paramsModel = nil;
    onceToken = 0;
}

@end
