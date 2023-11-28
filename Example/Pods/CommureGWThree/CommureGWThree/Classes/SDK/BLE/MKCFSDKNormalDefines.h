
typedef NS_ENUM(NSInteger, mk_cf_centralConnectStatus) {
    mk_cf_centralConnectStatusUnknow,                                           //未知状态
    mk_cf_centralConnectStatusConnecting,                                       //正在连接
    mk_cf_centralConnectStatusConnected,                                        //连接成功
    mk_cf_centralConnectStatusConnectedFailed,                                  //连接失败
    mk_cf_centralConnectStatusDisconnect,
};

typedef NS_ENUM(NSInteger, mk_cf_centralManagerStatus) {
    mk_cf_centralManagerStatusUnable,                           //不可用
    mk_cf_centralManagerStatusEnable,                           //可用状态
};

typedef NS_ENUM(NSInteger, mk_cf_networkType) {
    mk_cf_networkType_ethernet,
    mk_cf_networkType_wifi,
};


typedef NS_ENUM(NSInteger, mk_cf_wifiSecurity) {
    mk_cf_wifiSecurity_personal,
    mk_cf_wifiSecurity_enterprise,
};

typedef NS_ENUM(NSInteger, mk_cf_eapType) {
    mk_cf_eapType_peap_mschapv2,
    mk_cf_eapType_ttls_mschapv2,
    mk_cf_eapType_tls,
};

typedef NS_ENUM(NSInteger, mk_cf_connectMode) {
    mk_cf_connectMode_TCP,                                          //TCP
    mk_cf_connectMode_CASignedServerCertificate,                    //SSL.Do not verify the server certificate.
    mk_cf_connectMode_CACertificate,                                //SSL.Verify the server's certificate
    mk_cf_connectMode_SelfSignedCertificates,                       //SSL.Two-way authentication
};

//Quality of MQQT service
typedef NS_ENUM(NSInteger, mk_cf_mqttServerQosMode) {
    mk_cf_mqttQosLevelAtMostOnce,      //At most once. The message sender to find ways to send messages, but an accident and will not try again.
    mk_cf_mqttQosLevelAtLeastOnce,     //At least once.If the message receiver does not know or the message itself is lost, the message sender sends it again to ensure that the message receiver will receive at least one, and of course, duplicate the message.
    mk_cf_mqttQosLevelExactlyOnce,     //Exactly once.Ensuring this semantics will reduce concurrency or increase latency, but level 2 is most appropriate when losing or duplicating messages is unacceptable.
};

typedef NS_ENUM(NSInteger, mk_cf_filterRelationship) {
    mk_cf_filterRelationship_null,
    mk_cf_filterRelationship_mac,
    mk_cf_filterRelationship_advName,
    mk_cf_filterRelationship_rawData,
    mk_cf_filterRelationship_advNameAndRawData,
    mk_cf_filterRelationship_macAndadvNameAndRawData,
    mk_cf_filterRelationship_advNameOrRawData,
    mk_cf_filterRelationship_advNameAndMacData,
};


@protocol mk_cf_centralManagerScanDelegate <NSObject>

/// Scan to new device.
/// @param deviceModel device
- (void)mk_cf_receiveDevice:(NSDictionary *)deviceModel;

@optional

/// Starts scanning equipment.
- (void)mk_cf_startScan;

/// Stops scanning equipment.
- (void)mk_cf_stopScan;

@end
