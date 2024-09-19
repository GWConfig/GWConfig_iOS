//
//  MKCHSosAlarmNotiController.h
//  CommureGatewayPlus_Example
//
//  Created by aa on 2024/5/9.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import "MKCHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, mk_ch_sosAlarmNotiPageType) {
    mk_ch_sosAlarmNotiPageType_normal,
    mk_ch_sosAlarmNotiPageType_dismiss
};

@interface MKCHSosAlarmNotiController : MKCHBaseViewController

@property (nonatomic, copy)NSString *bleMac;

@property (nonatomic, assign)mk_ch_sosAlarmNotiPageType pageType;

@end

NS_ASSUME_NONNULL_END
