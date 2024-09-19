//
//  MKCHButtonLogHeader.h
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/10/20.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKCHButtonLogHeaderDelegate <NSObject>

- (void)ch_syncButtonPressed;

- (void)ch_deleteButtonPressed;

- (void)ch_exportButtonPressed;

@end

@interface MKCHButtonLogHeader : UIView

@property (nonatomic, weak)id <MKCHButtonLogHeaderDelegate>delegate;

- (void)updateSyncStatus:(BOOL)sync;

@end

NS_ASSUME_NONNULL_END
