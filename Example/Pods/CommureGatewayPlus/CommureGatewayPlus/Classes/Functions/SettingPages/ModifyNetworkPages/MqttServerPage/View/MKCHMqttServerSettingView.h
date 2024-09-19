//
//  MKCHMqttServerSettingView.h
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/2/7.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKCHMqttServerSettingViewDelegate <NSObject>

/// 底部按钮
/// @param index 0:Export Demo File   1:Import Config File  2:Clear All Configurations
- (void)ch_mqtt_deviecSetting_fileButtonPressed:(NSInteger)index;

@end

@interface MKCHMqttServerSettingView : UIView

@property (nonatomic, weak)id <MKCHMqttServerSettingViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
