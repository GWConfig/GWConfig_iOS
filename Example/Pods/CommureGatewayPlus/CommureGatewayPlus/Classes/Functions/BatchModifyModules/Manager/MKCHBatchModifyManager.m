//
//  MKCHBatchModifyManager.m
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/12/14.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import "MKCHBatchModifyManager.h"

static MKCHBatchModifyManager *paramsModel = nil;
static dispatch_once_t onceToken;

@implementation MKCHBatchModifyManager

+ (MKCHBatchModifyManager *)shared {
    dispatch_once(&onceToken, ^{
        if (!paramsModel) {
            paramsModel = [MKCHBatchModifyManager new];
        }
    });
    return paramsModel;
}

+ (void)sharedDealloc {
    paramsModel = nil;
    onceToken = 0;
}

@end
