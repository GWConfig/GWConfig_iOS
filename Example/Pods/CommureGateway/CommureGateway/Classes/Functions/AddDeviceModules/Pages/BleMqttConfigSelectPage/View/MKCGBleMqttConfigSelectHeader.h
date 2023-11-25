//
//  MKCGBleMqttConfigSelectHeader.h
//  CommureGateway_Example
//
//  Created by aa on 2023/11/22.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKCGBleMqttConfigSelectHeaderDelegate <NSObject>

- (void)cg_mqttConfigSelectHeaderButtonPressed:(NSInteger)index;

- (void)cg_mqttConfigSelectHeaderUrlChanged:(NSString *)url;

@end

@interface MKCGBleMqttConfigSelectHeader : UIView

@property (nonatomic, weak)id <MKCGBleMqttConfigSelectHeaderDelegate>delegate;

- (void)updateUrl:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
