//
//  MKCMButtonLogHeader.h
//  MKCommureApp_Example
//
//  Created by aa on 2023/10/20.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKCMButtonLogHeaderDelegate <NSObject>

- (void)cm_syncButtonPressed;

- (void)cm_deleteButtonPressed;

- (void)cm_exportButtonPressed;

@end

@interface MKCMButtonLogHeader : UIView

@property (nonatomic, weak)id <MKCMButtonLogHeaderDelegate>delegate;

- (void)updateSyncStatus:(BOOL)sync;

@end

NS_ASSUME_NONNULL_END
