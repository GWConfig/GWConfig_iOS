//
//  MKCGButtonLogHeader.h
//  CommureGateway_Example
//
//  Created by aa on 2023/10/20.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKCGButtonLogHeaderDelegate <NSObject>

- (void)cg_syncButtonPressed;

- (void)cg_deleteButtonPressed;

- (void)cg_exportButtonPressed;

@end

@interface MKCGButtonLogHeader : UIView

@property (nonatomic, weak)id <MKCGButtonLogHeaderDelegate>delegate;

- (void)updateSyncStatus:(BOOL)sync;

@end

NS_ASSUME_NONNULL_END
