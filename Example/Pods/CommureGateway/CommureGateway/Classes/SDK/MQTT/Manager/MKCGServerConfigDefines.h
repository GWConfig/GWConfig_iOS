

typedef NS_ENUM(NSInteger, MKCGMQTTSessionManagerState) {
    MKCGMQTTSessionManagerStateStarting,
    MKCGMQTTSessionManagerStateConnecting,
    MKCGMQTTSessionManagerStateError,
    MKCGMQTTSessionManagerStateConnected,
    MKCGMQTTSessionManagerStateClosing,
    MKCGMQTTSessionManagerStateClosed
};


@protocol MKCGServerManagerProtocol <NSObject>

- (void)cg_didReceiveMessage:(NSDictionary *)data onTopic:(NSString *)topic;

- (void)cg_didChangeState:(MKCGMQTTSessionManagerState)newState;

@end




#pragma mark ****************************************连接参数************************************************

@protocol MKCGServerParamsProtocol <NSObject>

/// 1-64 Characters
@property (nonatomic, copy)NSString *host;

/// 0~65535
@property (nonatomic, copy)NSString *port;

/// 1-64 Characters
@property (nonatomic, copy)NSString *clientID;

@property (nonatomic, assign)BOOL cleanSession;

/// 0、1、2
@property (nonatomic, assign)NSInteger qos;

/// 10-120
@property (nonatomic, copy)NSString *keepAlive;

/// 0-256 Characters
@property (nonatomic, copy)NSString *userName;

/// 0-256 Characters
@property (nonatomic, copy)NSString *password;

@property (nonatomic, assign)BOOL sslIsOn;

/// 0:CA signed server certificate     1:CA certificate     2:Self signed certificates
@property (nonatomic, assign)NSInteger certificate;

/// 根证书
@property (nonatomic, copy)NSString *caFileName;

/// 对于app是.p12证书
@property (nonatomic, copy)NSString *clientFileName;

@end
