//
//  MKCMBatchUpdateKeyHeaderView.h
//  MKCommureApp_Example
//
//  Created by aa on 2023/4/21.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKCMBatchUpdateKeyHeaderViewDelegate <NSObject>

- (void)cm_encryptionKeyChanged:(NSString *)encryptionKey;

- (void)cm_beaconListButtonPressed;

@end

@interface MKCMBatchUpdateKeyHeaderView : UIView

@property (nonatomic, weak)id <MKCMBatchUpdateKeyHeaderViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
