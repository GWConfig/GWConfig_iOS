//
//  MKCGBatchUpdateKeyHeaderView.h
//  CommureGateway_Example
//
//  Created by aa on 2023/4/21.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKCGBatchUpdateKeyHeaderViewDelegate <NSObject>

- (void)cg_encryptionKeyChanged:(NSString *)encryptionKey;

- (void)cg_dataPasswordChanged:(NSString *)password;

- (void)cg_beaconListButtonPressed;

- (void)cg_scanCodeButtonPressed;

@end

@interface MKCGBatchUpdateKeyHeaderView : UIView

@property (nonatomic, weak)id <MKCGBatchUpdateKeyHeaderViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
