
typedef NS_ENUM(NSInteger, mk_ch_centralConnectStatus) {
    mk_ch_centralConnectStatusUnknow,                                           //未知状态
    mk_ch_centralConnectStatusConnecting,                                       //正在连接
    mk_ch_centralConnectStatusConnected,                                        //连接成功
    mk_ch_centralConnectStatusConnectedFailed,                                  //连接失败
    mk_ch_centralConnectStatusDisconnect,
};

typedef NS_ENUM(NSInteger, mk_ch_centralManagerStatus) {
    mk_ch_centralManagerStatusUnable,                           //不可用
    mk_ch_centralManagerStatusEnable,                           //可用状态
};


typedef NS_ENUM(NSInteger, mk_ch_wifiSecurity) {
    mk_ch_wifiSecurity_personal,
    mk_ch_wifiSecurity_enterprise,
};

typedef NS_ENUM(NSInteger, mk_ch_eapType) {
    mk_ch_eapType_peap_mschapv2,
    mk_ch_eapType_ttls_mschapv2,
    mk_ch_eapType_tls,
};

typedef NS_ENUM(NSInteger, mk_ch_connectMode) {
    mk_ch_connectMode_TCP,                                          //TCP
    mk_ch_connectMode_CASignedServerCertificate,                    //SSL.Do not verify the server certificate.
    mk_ch_connectMode_CACertificate,                                //SSL.Verify the server's certificate
    mk_ch_connectMode_SelfSignedCertificates,                       //SSL.Two-way authentication
};

//Quality of MQQT service
typedef NS_ENUM(NSInteger, mk_ch_mqttServerQosMode) {
    mk_ch_mqttQosLevelAtMostOnce,      //At most once. The message sender to find ways to send messages, but an accident and will not try again.
    mk_ch_mqttQosLevelAtLeastOnce,     //At least once.If the message receiver does not know or the message itself is lost, the message sender sends it again to ensure that the message receiver will receive at least one, and of course, duplicate the message.
    mk_ch_mqttQosLevelExactlyOnce,     //Exactly once.Ensuring this semantics will reduce concurrency or increase latency, but level 2 is most appropriate when losing or duplicating messages is unacceptable.
};

typedef NS_ENUM(NSInteger, mk_ch_filterRelationship) {
    mk_ch_filterRelationship_null,
    mk_ch_filterRelationship_mac,
    mk_ch_filterRelationship_advName,
    mk_ch_filterRelationship_rawData,
    mk_ch_filterRelationship_advNameAndRawData,
    mk_ch_filterRelationship_macAndadvNameAndRawData,
    mk_ch_filterRelationship_advNameOrRawData,
    mk_ch_filterRelationship_advNameAndMacData,
};


@protocol mk_ch_centralManagerScanDelegate <NSObject>

/// Scan to new device.
/// @param deviceModel device
- (void)mk_ch_receiveDevice:(NSDictionary *)deviceModel;

@optional

/// Starts scanning equipment.
- (void)mk_ch_startScan;

/// Stops scanning equipment.
- (void)mk_ch_stopScan;

@end
