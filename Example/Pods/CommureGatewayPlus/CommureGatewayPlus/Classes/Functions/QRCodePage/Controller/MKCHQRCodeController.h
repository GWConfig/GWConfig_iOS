//
//  MKCHQRCodeController.h
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/7/7.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCHQRCodeController : UIViewController

@property (nonatomic, copy)void(^scanMacAddressBlock)(NSString *macAddress);

@end

NS_ASSUME_NONNULL_END
