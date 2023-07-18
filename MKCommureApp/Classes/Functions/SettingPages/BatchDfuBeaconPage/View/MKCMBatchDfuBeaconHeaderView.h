//
//  MKCMBatchDfuBeaconHeaderView.h
//  MKCommureApp_Example
//
//  Created by aa on 2023/4/21.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKCMBatchDfuBeaconHeaderViewDelegate <NSObject>

- (void)cm_firmwareUrlChanged:(NSString *)url;

- (void)cm_dataFileUrlChanged:(NSString *)url;

- (void)cm_beaconListButtonPressed;

@end

@interface MKCMBatchDfuBeaconHeaderView : UIView

@property (nonatomic, weak)id <MKCMBatchDfuBeaconHeaderViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
