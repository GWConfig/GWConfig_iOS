//
//  MKCGDeviceDataPageHeaderView.h
//  CommureGateway_Example
//
//  Created by aa on 2023/2/4.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCGDeviceDataPageHeaderViewModel : NSObject

@property (nonatomic, assign)BOOL isOn;

@end

@protocol MKCGDeviceDataPageHeaderViewDelegate <NSObject>

- (void)cg_updateLoadButtonAction;

- (void)cg_scannerStatusChanged:(BOOL)isOn;

- (void)cg_manageBleDeviceAction;

- (void)cg_filterTestButtonAction;

@end

@interface MKCGDeviceDataPageHeaderView : UIView

@property (nonatomic, strong)MKCGDeviceDataPageHeaderViewModel *dataModel;

@property (nonatomic, weak)id <MKCGDeviceDataPageHeaderViewDelegate>delegate;

- (void)updateTotalNumbers:(NSInteger)numbers;

@end

NS_ASSUME_NONNULL_END
