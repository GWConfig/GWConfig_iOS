//
//  MKCMQRToolBar.h
//  MKCommureApp_Example
//
//  Created by aa on 2023/7/7.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCMQRToolBar : UIView

- (void)addQRCodeTarget:(id)aTarget action:(SEL)aAction;
- (void)addAlbumTarget:(id)aTarget action:(SEL)aAction;

- (void)showTorch;
- (void)dismissTorch;

@end

NS_ASSUME_NONNULL_END
