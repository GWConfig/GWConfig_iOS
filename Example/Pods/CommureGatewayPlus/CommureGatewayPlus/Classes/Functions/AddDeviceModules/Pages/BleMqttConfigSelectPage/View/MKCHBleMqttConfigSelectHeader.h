//
//  MKCHBleMqttConfigSelectHeader.h
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/11/22.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKCHBleMqttConfigSelectHeaderDelegate <NSObject>

- (void)ch_mqttConfigSelectHeaderButtonPressed:(NSInteger)index;

- (void)ch_mqttConfigSelectHeaderUrlChanged:(NSString *)url;

@end

@interface MKCHBleMqttConfigSelectHeader : UIView

@property (nonatomic, weak)id <MKCHBleMqttConfigSelectHeaderDelegate>delegate;

- (void)updateUrl:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
