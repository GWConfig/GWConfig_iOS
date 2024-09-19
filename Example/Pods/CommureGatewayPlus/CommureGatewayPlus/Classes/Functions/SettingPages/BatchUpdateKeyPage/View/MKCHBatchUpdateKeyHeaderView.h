//
//  MKCHBatchUpdateKeyHeaderView.h
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/4/21.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKCHBatchUpdateKeyHeaderViewDelegate <NSObject>

- (void)ch_encryptionKeyChanged:(NSString *)encryptionKey;

- (void)ch_dataPasswordChanged:(NSString *)password;

- (void)ch_beaconListButtonPressed;

- (void)ch_scanCodeButtonPressed;

@end

@interface MKCHBatchUpdateKeyHeaderView : UIView

@property (nonatomic, weak)id <MKCHBatchUpdateKeyHeaderViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
