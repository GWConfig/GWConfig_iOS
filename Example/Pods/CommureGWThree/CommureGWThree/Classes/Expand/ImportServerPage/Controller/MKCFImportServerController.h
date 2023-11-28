//
//  MKCFImportServerController.h
//  CommureGWThree_Example
//
//  Created by aa on 2023/2/7.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseViewController.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKCFImportServerControllerDelegate <NSObject>

- (void)cf_selectedServerParams:(NSString *)fileName;

@end

@interface MKCFImportServerController : MKBaseViewController

@property (nonatomic, weak)id <MKCFImportServerControllerDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
