//
//  MKCGBatchModifyManager.m
//  CommureGateway_Example
//
//  Created by aa on 2023/12/14.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import "MKCGBatchModifyManager.h"

static MKCGBatchModifyManager *paramsModel = nil;
static dispatch_once_t onceToken;

@implementation MKCGBatchModifyManager

+ (MKCGBatchModifyManager *)shared {
    dispatch_once(&onceToken, ^{
        if (!paramsModel) {
            paramsModel = [MKCGBatchModifyManager new];
        }
    });
    return paramsModel;
}

+ (void)sharedDealloc {
    paramsModel = nil;
    onceToken = 0;
}

@end
