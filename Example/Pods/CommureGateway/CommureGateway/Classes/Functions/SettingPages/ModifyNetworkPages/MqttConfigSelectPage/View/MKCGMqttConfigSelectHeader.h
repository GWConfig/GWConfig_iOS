//
//  MKCGMqttConfigSelectHeader.h
//  CommureGateway_Example
//
//  Created by aa on 2023/11/22.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKCGMqttConfigSelectHeaderDelegate <NSObject>

- (void)cg_mqttConfigSelectHeaderButtonPressed:(NSInteger)index;

- (void)cg_mqttConfigSelectHeaderUrlChanged:(NSString *)url;

@end

@interface MKCGMqttConfigSelectHeader : UIView

@property (nonatomic, weak)id <MKCGMqttConfigSelectHeaderDelegate>delegate;

- (void)updateUrl:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
