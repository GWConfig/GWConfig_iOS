//
//  MKCHDeviceDataPageHeaderView.h
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/2/4.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCHDeviceDataPageHeaderViewModel : NSObject

@property (nonatomic, assign)BOOL isOn;

@end

@protocol MKCHDeviceDataPageHeaderViewDelegate <NSObject>

- (void)ch_updateLoadButtonAction;

- (void)ch_scannerStatusChanged:(BOOL)isOn;

- (void)ch_manageBleDeviceAction;

- (void)ch_filterTestButtonAction;

@end

@interface MKCHDeviceDataPageHeaderView : UIView

@property (nonatomic, strong)MKCHDeviceDataPageHeaderViewModel *dataModel;

@property (nonatomic, weak)id <MKCHDeviceDataPageHeaderViewDelegate>delegate;

- (void)updateTotalNumbers:(NSInteger)numbers;

@end

NS_ASSUME_NONNULL_END
