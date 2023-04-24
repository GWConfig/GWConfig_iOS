//
//  MKCMMqttServerLwtView.h
//  MKCommureApp_Example
//
//  Created by aa on 2023/2/7.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCMMqttServerLwtViewModel : NSObject

@property (nonatomic, assign)BOOL lwtStatus;

@property (nonatomic, assign)BOOL lwtRetain;

@property (nonatomic, assign)NSInteger lwtQos;

@property (nonatomic, copy)NSString *lwtTopic;

@property (nonatomic, copy)NSString *lwtPayload;

@end

@protocol MKCMMqttServerLwtViewDelegate <NSObject>

- (void)cm_lwt_statusChanged:(BOOL)isOn;

- (void)cm_lwt_retainChanged:(BOOL)isOn;

- (void)cm_lwt_qosChanged:(NSInteger)qos;

- (void)cm_lwt_topicChanged:(NSString *)text;

- (void)cm_lwt_payloadChanged:(NSString *)text;

@end

@interface MKCMMqttServerLwtView : UIView

@property (nonatomic, strong)MKCMMqttServerLwtViewModel *dataModel;

@property (nonatomic, weak)id <MKCMMqttServerLwtViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
