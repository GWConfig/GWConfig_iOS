//
//  MKCHImportServerController.h
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/2/7.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseViewController.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKCHImportServerControllerDelegate <NSObject>

- (void)ch_selectedServerParams:(NSString *)fileName;

@end

@interface MKCHImportServerController : MKBaseViewController

@property (nonatomic, weak)id <MKCHImportServerControllerDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
