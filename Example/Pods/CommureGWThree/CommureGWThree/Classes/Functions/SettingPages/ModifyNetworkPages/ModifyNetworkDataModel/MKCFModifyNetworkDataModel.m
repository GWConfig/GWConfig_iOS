//
//  MKCFModifyNetworkDataModel.m
//  CommureGWThree_Example
//
//  Created by aa on 2023/11/23.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import "MKCFModifyNetworkDataModel.h"

static MKCFModifyNetworkDataModel *paramsModel = nil;
static dispatch_once_t onceToken;

@implementation MKCFModifyNetworkDataModel

+ (MKCFModifyNetworkDataModel *)shared {
    dispatch_once(&onceToken, ^{
        if (!paramsModel) {
            paramsModel = [MKCFModifyNetworkDataModel new];
        }
    });
    return paramsModel;
}

+ (void)sharedDealloc {
    paramsModel = nil;
    onceToken = 0;
}

@end
