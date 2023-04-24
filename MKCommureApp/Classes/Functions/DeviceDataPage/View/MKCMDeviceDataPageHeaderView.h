//
//  MKCMDeviceDataPageHeaderView.h
//  MKCommureApp_Example
//
//  Created by aa on 2023/2/4.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCMDeviceDataPageHeaderViewModel : NSObject

@property (nonatomic, assign)BOOL isOn;

@end

@protocol MKCMDeviceDataPageHeaderViewDelegate <NSObject>

- (void)cm_updateLoadButtonAction;

- (void)cm_scannerStatusChanged:(BOOL)isOn;

- (void)cm_manageBleDeviceAction;

@end

@interface MKCMDeviceDataPageHeaderView : UIView

@property (nonatomic, strong)MKCMDeviceDataPageHeaderViewModel *dataModel;

@property (nonatomic, weak)id <MKCMDeviceDataPageHeaderViewDelegate>delegate;

- (void)updateTotalNumbers:(NSInteger)numbers;

@end

NS_ASSUME_NONNULL_END
