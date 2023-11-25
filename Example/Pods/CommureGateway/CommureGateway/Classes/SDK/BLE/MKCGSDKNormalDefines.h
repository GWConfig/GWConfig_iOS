
typedef NS_ENUM(NSInteger, mk_cg_centralConnectStatus) {
    mk_cg_centralConnectStatusUnknow,                                           //未知状态
    mk_cg_centralConnectStatusConnecting,                                       //正在连接
    mk_cg_centralConnectStatusConnected,                                        //连接成功
    mk_cg_centralConnectStatusConnectedFailed,                                  //连接失败
    mk_cg_centralConnectStatusDisconnect,
};

typedef NS_ENUM(NSInteger, mk_cg_centralManagerStatus) {
    mk_cg_centralManagerStatusUnable,                           //不可用
    mk_cg_centralManagerStatusEnable,                           //可用状态
};

typedef NS_ENUM(NSInteger, mk_cg_networkType) {
    mk_cg_networkType_ethernet,
    mk_cg_networkType_wifi,
};


typedef NS_ENUM(NSInteger, mk_cg_wifiSecurity) {
    mk_cg_wifiSecurity_personal,
    mk_cg_wifiSecurity_enterprise,
};

typedef NS_ENUM(NSInteger, mk_cg_eapType) {
    mk_cg_eapType_peap_mschapv2,
    mk_cg_eapType_ttls_mschapv2,
    mk_cg_eapType_tls,
};

typedef NS_ENUM(NSInteger, mk_cg_connectMode) {
    mk_cg_connectMode_TCP,                                          //TCP
    mk_cg_connectMode_CASignedServerCertificate,                    //SSL.Do not verify the server certificate.
    mk_cg_connectMode_CACertificate,                                //SSL.Verify the server's certificate
    mk_cg_connectMode_SelfSignedCertificates,                       //SSL.Two-way authentication
};

//Quality of MQQT service
typedef NS_ENUM(NSInteger, mk_cg_mqttServerQosMode) {
    mk_cg_mqttQosLevelAtMostOnce,      //At most once. The message sender to find ways to send messages, but an accident and will not try again.
    mk_cg_mqttQosLevelAtLeastOnce,     //At least once.If the message receiver does not know or the message itself is lost, the message sender sends it again to ensure that the message receiver will receive at least one, and of course, duplicate the message.
    mk_cg_mqttQosLevelExactlyOnce,     //Exactly once.Ensuring this semantics will reduce concurrency or increase latency, but level 2 is most appropriate when losing or duplicating messages is unacceptable.
};

typedef NS_ENUM(NSInteger, mk_cg_filterRelationship) {
    mk_cg_filterRelationship_null,
    mk_cg_filterRelationship_mac,
    mk_cg_filterRelationship_advName,
    mk_cg_filterRelationship_rawData,
    mk_cg_filterRelationship_advNameAndRawData,
    mk_cg_filterRelationship_macAndadvNameAndRawData,
    mk_cg_filterRelationship_advNameOrRawData,
    mk_cg_filterRelationship_advNameAndMacData,
};


@protocol mk_cg_centralManagerScanDelegate <NSObject>

/// Scan to new device.
/// @param deviceModel device
- (void)mk_cg_receiveDevice:(NSDictionary *)deviceModel;

@optional

/// Starts scanning equipment.
- (void)mk_cg_startScan;

/// Stops scanning equipment.
- (void)mk_cg_stopScan;

@end
