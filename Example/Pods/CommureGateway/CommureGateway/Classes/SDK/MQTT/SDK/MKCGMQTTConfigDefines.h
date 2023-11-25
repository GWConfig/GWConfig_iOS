
typedef NS_ENUM(NSInteger, mk_cg_keyResetType) {
    mk_cg_keyResetType_powerOnOneMin,     //Press in 1 min after powered
    mk_cg_keyResetType_pressAnyTime,      //Press any time
};

typedef NS_ENUM(NSInteger, mk_cg_filterRelationship) {
    mk_cg_filterRelationship_null,
    mk_cg_filterRelationship_mac,
    mk_cg_filterRelationship_tagID,
    mk_cg_filterRelationship_macOrTagID,
    mk_cg_filterRelationship_macAndTagID
};

typedef NS_ENUM(NSInteger, mk_cg_filterByTLM) {
    mk_cg_filterByTLM_nonEncrypted,        //Non-encrypted type TLM
    mk_cg_filterByTLM_encrypted,           //Encryption type TLM
    mk_cg_filterByTLM_all,                //Filter all Eddystone_TLM data
};

typedef NS_ENUM(NSInteger, mk_cg_filterByOther) {
    mk_cg_filterByOther_A,                 //Filter by A condition.
    mk_cg_filterByOther_AB,                //Filter by A & B condition.
    mk_cg_filterByOther_AOrB,              //Filter by A | B condition.
    mk_cg_filterByOther_ABC,               //Filter by A & B & C condition.
    mk_cg_filterByOther_ABOrC,             //Filter by (A & B) | C condition.
    mk_cg_filterByOther_AOrBOrC,           //Filter by A | B | C condition.
};

typedef NS_ENUM(NSInteger, mk_cg_duplicateDataFilter) {
    mk_cg_duplicateDataFilter_none,
    mk_cg_duplicateDataFilter_mac,
    mk_cg_duplicateDataFilter_macAndDataType,
    mk_cg_duplicateDataFilter_macAndRawData
};

typedef NS_ENUM(NSInteger, mk_cg_reminderLedColor) {
    mk_cg_reminderLedColor_red,
    mk_cg_reminderLedColor_blue,
    mk_cg_reminderLedColor_green,
};

typedef NS_ENUM(NSInteger, mk_cg_sosTriggerType) {
    mk_cg_sosTriggerType_singleClick,
    mk_cg_sosTriggerType_doubleClick,
    mk_cg_sosTriggerType_tripleClick,
};


typedef NS_ENUM(NSInteger, mk_cg_threeAxisSampleRate) {
    mk_cg_threeAxisSampleRate1hz,           //1hz
    mk_cg_threeAxisSampleRate10hz,          //10hz
    mk_cg_threeAxisSampleRate25hz,          //25hz
    mk_cg_threeAxisSampleRate50hz,          //50hz
    mk_cg_threeAxisSampleRate100hz          //100hz
};

typedef NS_ENUM(NSInteger, mk_cg_threeAxisDataFullScale) {
    mk_cg_threeAxisDataFullScale0,               //±2g
    mk_cg_threeAxisDataFullScale1,               //±4g
    mk_cg_threeAxisDataFullScale2,               //±8g
    mk_cg_threeAxisDataFullScale3                //±16g
};

typedef NS_ENUM(NSInteger, mk_cg_advParamsType) {
    mk_cg_advParamsType_config,               //Config advertisement
    mk_cg_advParamsType_noraml,               //Normal advertisement
    mk_cg_advParamsType_trigger,              //Trigger advertisement
};

typedef NS_ENUM(NSInteger, mk_cg_txPower) {
    mk_cg_txPowerNeg40dBm,   //RadioTxPower:-40dBm
    mk_cg_txPowerNeg20dBm,   //-20dBm
    mk_cg_txPowerNeg16dBm,   //-16dBm
    mk_cg_txPowerNeg12dBm,   //-12dBm
    mk_cg_txPowerNeg8dBm,    //-8dBm
    mk_cg_txPowerNeg4dBm,    //-4dBm
    mk_cg_txPower0dBm,       //0dBm
    mk_cg_txPower3dBm,       //3dBm
    mk_cg_txPower4dBm,       //4dBm
};


typedef NS_ENUM(NSInteger, mk_cg_mqtt_networkType) {
    mk_cg_mqtt_networkType_ethernet,
    mk_cg_mqtt_networkType_wifi,
};


@protocol cg_indicatorLightStatusProtocol <NSObject>

@property (nonatomic, assign)BOOL ble_advertising;

@property (nonatomic, assign)BOOL ble_connected;

@property (nonatomic, assign)BOOL server_connecting;

@property (nonatomic, assign)BOOL server_connected;

@end



@protocol mk_cg_BLEFilterRawDataProtocol <NSObject>

/// The currently filtered data type, refer to the definition of different Bluetooth data types by the International Bluetooth Organization, 1 byte of hexadecimal data
@property (nonatomic, copy)NSString *dataType;

/// Data location to start filtering.if minIndex's value is 0,maxIndex must be 0;
@property (nonatomic, assign)NSInteger minIndex;

/// Data location to end filtering.if maxIndex's value is 0,minIndex must be 0;
@property (nonatomic, assign)NSInteger maxIndex;

/// The currently filtered content. The data length should be maxIndex-minIndex, if maxIndex=0&&minIndex==0, the item length is not checked whether it meets the requirements.MAX length:29 Bytes
@property (nonatomic, copy)NSString *rawData;

@end


@protocol mk_cg_BLEFilterBXPButtonProtocol <NSObject>

@property (nonatomic, assign)BOOL isOn;

@property (nonatomic, assign)BOOL singlePressIsOn;

@property (nonatomic, assign)BOOL doublePressIsOn;

@property (nonatomic, assign)BOOL longPressIsOn;

@property (nonatomic, assign)BOOL abnormalInactivityIsOn;

@end


@protocol mk_cg_BLEFilterPirProtocol <NSObject>

@property (nonatomic, assign)BOOL isOn;

/// 0：low delay 1：medium delay 2：high delay 3：all type
@property (nonatomic, assign)NSInteger delayRespneseStatus;

/// 0：close 1：open 2：all type
@property (nonatomic, assign)NSInteger doorStatus;

/// 0：low sensitivity 1：medium sensitivity 2：high sensitivity 3：all type
@property (nonatomic, assign)NSInteger sensorSensitivity;

/// 0：no effective motion detected 1：effective motion detected 2：all type
@property (nonatomic, assign)NSInteger sensorDetectionStatus;

@end


#pragma mark - 通过MQTT重新设置设备的wifi

@protocol mk_cg_mqttModifyWifiProtocol <NSObject>

/// 0:personal  1:enterprise
@property (nonatomic, assign)NSInteger security;

/// security为enterprise的时候才有效。0:PEAP-MSCHAPV2  1:TTLS-MSCHAPV2  2:TLS
@property (nonatomic, assign)NSInteger eapType;

/// 1-32 Characters.
@property (nonatomic, copy)NSString *ssid;

/// 0-64 Characters.security为personal的时候才有效
@property (nonatomic, copy)NSString *wifiPassword;

/// 0-32 Characters.  eapType为PEAP-MSCHAPV2/TTLS-MSCHAPV2才有效
@property (nonatomic, copy)NSString *eapUserName;

/// 0-64 Characters.eapType为TLS的时候无此参数
@property (nonatomic, copy)NSString *eapPassword;

/// 0-64 Characters.eapType为TLS的时候有效
@property (nonatomic, copy)NSString *domainID;

/// eapType为PEAP-MSCHAPV2/TTLS-MSCHAPV2才有效
@property (nonatomic, assign)BOOL verifyServer;

@end

@protocol mk_cg_mqttModifyWifiEapCertProtocol <NSObject>

/// security为personal无此参数
@property (nonatomic, copy)NSString *caFilePath;

/// eapType为TLS有效
@property (nonatomic, copy)NSString *clientKeyPath;

/// eapType为TLS有效
@property (nonatomic, copy)NSString *clientCertPath;

@end



@protocol mk_cg_mqttModifyNetworkProtocol <NSObject>

@property (nonatomic, assign)BOOL dhcp;

/// 47.104.81.55
@property (nonatomic, copy)NSString *ip;

/// 47.104.81.55
@property (nonatomic, copy)NSString *mask;

/// 47.104.81.55
@property (nonatomic, copy)NSString *gateway;

/// 47.104.81.55
@property (nonatomic, copy)NSString *dns;

@end


@protocol mk_cg_modifyMqttServerProtocol <NSObject>

/// 1-64 characters
@property (nonatomic, copy)NSString *host;

/// 1-65535
@property (nonatomic, copy)NSString *port;

/// 1-64 Characters
@property (nonatomic, copy)NSString *clientID;

/// 1-128 Characters
@property (nonatomic, copy)NSString *subscribeTopic;

/// 1-128 Characters
@property (nonatomic, copy)NSString *publishTopic;

@property (nonatomic, assign)BOOL cleanSession;

/// 0/1/2
@property (nonatomic, assign)NSInteger qos;

/// 10s~120s.
@property (nonatomic, copy)NSString *keepAlive;

/// 0-256 Characters
@property (nonatomic, copy)NSString *userName;

/// 0-256 Characters
@property (nonatomic, copy)NSString *password;

/// 0:TCP    1:CA signed server certificate     2:CA certificate     3:Self signed certificates
@property (nonatomic, assign)NSInteger connectMode;

@end


@protocol mk_cg_modifyMqttServerCertsProtocol <NSObject>

/// 0-256 Characters
@property (nonatomic, copy)NSString *caFilePath;

/// 0-256 Characters
@property (nonatomic, copy)NSString *clientKeyPath;

/// 0-256 Characters
@property (nonatomic, copy)NSString *clientCertPath;

@end


#pragma mark - 扫描数据上报内容选项protocol

@protocol cg_uploadDataOptionProtocol <NSObject>

@property (nonatomic, assign)BOOL timestamp;

@property (nonatomic, assign)BOOL rawData_advertising;

@property (nonatomic, assign)BOOL rawData_response;

@end
