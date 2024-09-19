
@protocol MKCHExcelAppProtocol <NSObject>

/// 1-64 Characters
@property (nonatomic, copy)NSString *host;

/// 1~65535
@property (nonatomic, copy)NSString *port;

/// 1-64 Characters
@property (nonatomic, copy)NSString *clientID;

/// 0-128 Characters
@property (nonatomic, copy)NSString *subscribeTopic;

/// 0-128 Characters
@property (nonatomic, copy)NSString *publishTopic;

@property (nonatomic, assign)BOOL cleanSession;

/// 0、1、2
@property (nonatomic, assign)NSInteger qos;

/// 10-120
@property (nonatomic, copy)NSString *keepAlive;

/// 0-128 Characters
@property (nonatomic, copy)NSString *userName;

/// 0-128 Characters
@property (nonatomic, copy)NSString *password;

@property (nonatomic, assign)BOOL sslIsOn;

/// 0:CA signed server certificate     1:CA certificate     2:Self signed certificates    仅对sslIsOn=YES情况下有效
@property (nonatomic, assign)NSInteger certificate;

@end




@protocol MKCHExcelDeviceProtocol <NSObject>

/// 1-64 Characters
@property (nonatomic, copy)NSString *host;

/// 1~65535
@property (nonatomic, copy)NSString *port;

/// 1-64 Characters
@property (nonatomic, copy)NSString *clientID;

/// 1-128 Characters
@property (nonatomic, copy)NSString *subscribeTopic;

/// 1-128 Characters
@property (nonatomic, copy)NSString *publishTopic;

@property (nonatomic, assign)BOOL cleanSession;

/// 0、1、2
@property (nonatomic, assign)NSInteger qos;

/// 10-120
@property (nonatomic, copy)NSString *keepAlive;

/// 0-128 Characters
@property (nonatomic, copy)NSString *userName;

/// 0-128 Characters
@property (nonatomic, copy)NSString *password;

@property (nonatomic, assign)BOOL sslIsOn;

///0:CA signed server certificate     1:CA certificate     2:Self signed certificates    仅对sslIsOn=YES情况下有效
@property (nonatomic, assign)NSInteger certificate;

@end

