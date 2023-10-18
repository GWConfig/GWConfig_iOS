//
//  MKCMServerForAppModel.h
//  MKCommureApp_Example
//
//  Created by aa on 2023/2/7.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKCMServerConfigDefines.h"
#import "MKCMExcelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKCMServerForAppModel : NSObject<MKCMServerParamsProtocol,MKCMExcelAppProtocol>

@property (nonatomic, copy)NSString *host;

@property (nonatomic, copy)NSString *port;

@property (nonatomic, copy)NSString *clientID;

@property (nonatomic, assign)BOOL cleanSession;

@property (nonatomic, assign)NSInteger qos;

@property (nonatomic, copy)NSString *keepAlive;

@property (nonatomic, copy)NSString *userName;

@property (nonatomic, copy)NSString *password;

@property (nonatomic, assign)BOOL sslIsOn;

/// 0:CA signed server certificate     1:CA certificate     2:Self signed certificates
@property (nonatomic, assign)NSInteger certificate;

@property (nonatomic, copy)NSString *caFileName;

/// P12证书
@property (nonatomic, copy)NSString *clientFileName;

/// 清除所有参数
- (void)clearAllParams;

/// 校验参数，如果有问题则提示具体问题，如果参数全部校验通过则返回空
- (NSString *)checkParams;

/// 更新数据
/// @param model 数据源
- (void)updateValue:(MKCMServerForAppModel *)model;

@end

NS_ASSUME_NONNULL_END
