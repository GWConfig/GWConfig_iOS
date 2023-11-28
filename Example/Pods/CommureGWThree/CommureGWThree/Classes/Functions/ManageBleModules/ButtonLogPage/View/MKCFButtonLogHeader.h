//
//  MKCFButtonLogHeader.h
//  CommureGWThree_Example
//
//  Created by aa on 2023/10/20.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKCFButtonLogHeaderDelegate <NSObject>

- (void)cf_syncButtonPressed;

- (void)cf_deleteButtonPressed;

- (void)cf_exportButtonPressed;

@end

@interface MKCFButtonLogHeader : UIView

@property (nonatomic, weak)id <MKCFButtonLogHeaderDelegate>delegate;

- (void)updateSyncStatus:(BOOL)sync;

@end

NS_ASSUME_NONNULL_END
