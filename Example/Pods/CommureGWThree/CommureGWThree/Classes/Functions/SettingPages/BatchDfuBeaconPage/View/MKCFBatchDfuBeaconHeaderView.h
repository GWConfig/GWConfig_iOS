//
//  MKCFBatchDfuBeaconHeaderView.h
//  CommureGWThree_Example
//
//  Created by aa on 2023/4/21.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKCFBatchDfuBeaconHeaderViewDelegate <NSObject>

- (void)cf_firmwareUrlChanged:(NSString *)url;

- (void)cf_dataFileUrlChanged:(NSString *)url;

- (void)cf_dataPasswordChanged:(NSString *)password;

- (void)cf_beaconListButtonPressed;

- (void)cf_scanCodeButtonPressed;

@end

@interface MKCFBatchDfuBeaconHeaderView : UIView

@property (nonatomic, weak)id <MKCFBatchDfuBeaconHeaderViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
