//
//  MKCHBatchDfuBeaconHeaderView.h
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/4/21.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKCHBatchDfuBeaconHeaderViewDelegate <NSObject>

- (void)ch_firmwareUrlChanged:(NSString *)url;

- (void)ch_dataFileUrlChanged:(NSString *)url;

- (void)ch_dataPasswordChanged:(NSString *)password;

- (void)ch_beaconListButtonPressed;

- (void)ch_scanCodeButtonPressed;

@end

@interface MKCHBatchDfuBeaconHeaderView : UIView

@property (nonatomic, weak)id <MKCHBatchDfuBeaconHeaderViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
