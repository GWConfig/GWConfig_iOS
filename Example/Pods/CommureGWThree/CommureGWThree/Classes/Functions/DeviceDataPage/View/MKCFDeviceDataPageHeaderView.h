//
//  MKCFDeviceDataPageHeaderView.h
//  CommureGWThree_Example
//
//  Created by aa on 2023/2/4.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCFDeviceDataPageHeaderViewModel : NSObject

@property (nonatomic, assign)BOOL isOn;

@end

@protocol MKCFDeviceDataPageHeaderViewDelegate <NSObject>

- (void)cf_updateLoadButtonAction;

- (void)cf_scannerStatusChanged:(BOOL)isOn;

- (void)cf_manageBleDeviceAction;

- (void)cf_filterTestButtonAction;

@end

@interface MKCFDeviceDataPageHeaderView : UIView

@property (nonatomic, strong)MKCFDeviceDataPageHeaderViewModel *dataModel;

@property (nonatomic, weak)id <MKCFDeviceDataPageHeaderViewDelegate>delegate;

- (void)updateTotalNumbers:(NSInteger)numbers;

@end

NS_ASSUME_NONNULL_END
