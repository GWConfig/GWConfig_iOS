//
//  MKCGSosAlarmNotiController.h
//  CommureGateway_Example
//
//  Created by aa on 2024/5/9.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import "MKCGBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, mk_cg_sosAlarmNotiPageType) {
    mk_cg_sosAlarmNotiPageType_normal,
    mk_cg_sosAlarmNotiPageType_dismiss
};

@interface MKCGSosAlarmNotiController : MKCGBaseViewController

@property (nonatomic, copy)NSString *bleMac;

@property (nonatomic, assign)mk_cg_sosAlarmNotiPageType pageType;

@end

NS_ASSUME_NONNULL_END
