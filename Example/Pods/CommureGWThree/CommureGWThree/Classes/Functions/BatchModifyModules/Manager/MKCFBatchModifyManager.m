//
//  MKCFBatchModifyManager.m
//  CommureGWThree_Example
//
//  Created by aa on 2023/12/14.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import "MKCFBatchModifyManager.h"

static MKCFBatchModifyManager *paramsModel = nil;
static dispatch_once_t onceToken;

@implementation MKCFBatchModifyManager

+ (MKCFBatchModifyManager *)shared {
    dispatch_once(&onceToken, ^{
        if (!paramsModel) {
            paramsModel = [MKCFBatchModifyManager new];
        }
    });
    return paramsModel;
}

+ (void)sharedDealloc {
    paramsModel = nil;
    onceToken = 0;
}

@end
