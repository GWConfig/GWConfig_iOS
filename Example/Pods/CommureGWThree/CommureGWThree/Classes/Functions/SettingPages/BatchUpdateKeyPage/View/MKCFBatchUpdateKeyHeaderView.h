//
//  MKCFBatchUpdateKeyHeaderView.h
//  CommureGWThree_Example
//
//  Created by aa on 2023/4/21.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKCFBatchUpdateKeyHeaderViewDelegate <NSObject>

- (void)cf_encryptionKeyChanged:(NSString *)encryptionKey;

- (void)cf_dataPasswordChanged:(NSString *)password;

- (void)cf_beaconListButtonPressed;

- (void)cf_scanCodeButtonPressed;

@end

@interface MKCFBatchUpdateKeyHeaderView : UIView

@property (nonatomic, weak)id <MKCFBatchUpdateKeyHeaderViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
