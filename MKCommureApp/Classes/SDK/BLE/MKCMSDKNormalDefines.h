
typedef NS_ENUM(NSInteger, mk_cm_centralConnectStatus) {
    mk_cm_centralConnectStatusUnknow,                                           //未知状态
    mk_cm_centralConnectStatusConnecting,                                       //正在连接
    mk_cm_centralConnectStatusConnected,                                        //连接成功
    mk_cm_centralConnectStatusConnectedFailed,                                  //连接失败
    mk_cm_centralConnectStatusDisconnect,
};

typedef NS_ENUM(NSInteger, mk_cm_centralManagerStatus) {
    mk_cm_centralManagerStatusUnable,                           //不可用
    mk_cm_centralManagerStatusEnable,                           //可用状态
};


typedef NS_ENUM(NSInteger, mk_cm_wifiSecurity) {
    mk_cm_wifiSecurity_personal,
    mk_cm_wifiSecurity_enterprise,
};

typedef NS_ENUM(NSInteger, mk_cm_eapType) {
    mk_cm_eapType_peap_mschapv2,
    mk_cm_eapType_ttls_mschapv2,
    mk_cm_eapType_tls,
};

typedef NS_ENUM(NSInteger, mk_cm_connectMode) {
    mk_cm_connectMode_TCP,                                          //TCP
    mk_cm_connectMode_CASignedServerCertificate,                    //SSL.Do not verify the server certificate.
    mk_cm_connectMode_CACertificate,                                //SSL.Verify the server's certificate
    mk_cm_connectMode_SelfSignedCertificates,                       //SSL.Two-way authentication
};

//Quality of MQQT service
typedef NS_ENUM(NSInteger, mk_cm_mqttServerQosMode) {
    mk_cm_mqttQosLevelAtMostOnce,      //At most once. The message sender to find ways to send messages, but an accident and will not try again.
    mk_cm_mqttQosLevelAtLeastOnce,     //At least once.If the message receiver does not know or the message itself is lost, the message sender sends it again to ensure that the message receiver will receive at least one, and of course, duplicate the message.
    mk_cm_mqttQosLevelExactlyOnce,     //Exactly once.Ensuring this semantics will reduce concurrency or increase latency, but level 2 is most appropriate when losing or duplicating messages is unacceptable.
};

typedef NS_ENUM(NSInteger, mk_cm_filterRelationship) {
    mk_cm_filterRelationship_null,
    mk_cm_filterRelationship_mac,
    mk_cm_filterRelationship_advName,
    mk_cm_filterRelationship_rawData,
    mk_cm_filterRelationship_advNameAndRawData,
    mk_cm_filterRelationship_macAndadvNameAndRawData,
    mk_cm_filterRelationship_advNameOrRawData,
    mk_cm_filterRelationship_advNameAndMacData,
};


@protocol mk_cm_centralManagerScanDelegate <NSObject>

/// Scan to new device.
/// @param deviceModel device
- (void)mk_cm_receiveDevice:(NSDictionary *)deviceModel;

@optional

/// Starts scanning equipment.
- (void)mk_cm_startScan;

/// Stops scanning equipment.
- (void)mk_cm_stopScan;

@end
