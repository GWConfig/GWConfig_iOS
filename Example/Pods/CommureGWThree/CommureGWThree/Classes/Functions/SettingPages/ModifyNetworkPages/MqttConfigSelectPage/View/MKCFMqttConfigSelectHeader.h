//
//  MKCFMqttConfigSelectHeader.h
//  CommureGWThree_Example
//
//  Created by aa on 2023/11/22.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKCFMqttConfigSelectHeaderDelegate <NSObject>

- (void)cf_mqttConfigSelectHeaderButtonPressed:(NSInteger)index;

- (void)cf_mqttConfigSelectHeaderUrlChanged:(NSString *)url;

@end

@interface MKCFMqttConfigSelectHeader : UIView

@property (nonatomic, weak)id <MKCFMqttConfigSelectHeaderDelegate>delegate;

- (void)updateUrl:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
