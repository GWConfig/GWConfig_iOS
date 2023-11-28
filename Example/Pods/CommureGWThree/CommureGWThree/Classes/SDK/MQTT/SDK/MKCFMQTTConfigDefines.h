
typedef NS_ENUM(NSInteger, mk_cf_keyResetType) {
    mk_cf_keyResetType_powerOnOneMin,     //Press in 1 min after powered
    mk_cf_keyResetType_pressAnyTime,      //Press any time
};

typedef NS_ENUM(NSInteger, mk_cf_filterRelationship) {
    mk_cf_filterRelationship_null,
    mk_cf_filterRelationship_mac,
    mk_cf_filterRelationship_tagID,
    mk_cf_filterRelationship_macOrTagID,
    mk_cf_filterRelationship_macAndTagID
};

typedef NS_ENUM(NSInteger, mk_cf_filterByTLM) {
    mk_cf_filterByTLM_nonEncrypted,        //Non-encrypted type TLM
    mk_cf_filterByTLM_encrypted,           //Encryption type TLM
    mk_cf_filterByTLM_all,                //Filter all Eddystone_TLM data
};

typedef NS_ENUM(NSInteger, mk_cf_filterByOther) {
    mk_cf_filterByOther_A,                 //Filter by A condition.
    mk_cf_filterByOther_AB,                //Filter by A & B condition.
    mk_cf_filterByOther_AOrB,              //Filter by A | B condition.
    mk_cf_filterByOther_ABC,               //Filter by A & B & C condition.
    mk_cf_filterByOther_ABOrC,             //Filter by (A & B) | C condition.
    mk_cf_filterByOther_AOrBOrC,           //Filter by A | B | C condition.
};

typedef NS_ENUM(NSInteger, mk_cf_duplicateDataFilter) {
    mk_cf_duplicateDataFilter_none,
    mk_cf_duplicateDataFilter_mac,
    mk_cf_duplicateDataFilter_macAndDataType,
    mk_cf_duplicateDataFilter_macAndRawData
};

typedef NS_ENUM(NSInteger, mk_cf_reminderLedColor) {
    mk_cf_reminderLedColor_red,
    mk_cf_reminderLedColor_blue,
    mk_cf_reminderLedColor_green,
};

typedef NS_ENUM(NSInteger, mk_cf_sosTriggerType) {
    mk_cf_sosTriggerType_singleClick,
    mk_cf_sosTriggerType_doubleClick,
    mk_cf_sosTriggerType_tripleClick,
};


typedef NS_ENUM(NSInteger, mk_cf_threeAxisSampleRate) {
    mk_cf_threeAxisSampleRate1hz,           //1hz
    mk_cf_threeAxisSampleRate10hz,          //10hz
    mk_cf_threeAxisSampleRate25hz,          //25hz
    mk_cf_threeAxisSampleRate50hz,          //50hz
    mk_cf_threeAxisSampleRate100hz          //100hz
};

typedef NS_ENUM(NSInteger, mk_cf_threeAxisDataFullScale) {
    mk_cf_threeAxisDataFullScale0,               //±2g
    mk_cf_threeAxisDataFullScale1,               //±4g
    mk_cf_threeAxisDataFullScale2,               //±8g
    mk_cf_threeAxisDataFullScale3                //±16g
};

typedef NS_ENUM(NSInteger, mk_cf_advParamsType) {
    mk_cf_advParamsType_config,               //Config advertisement
    mk_cf_advParamsType_noraml,               //Normal advertisement
    mk_cf_advParamsType_trigger,              //Trigger advertisement
};

typedef NS_ENUM(NSInteger, mk_cf_txPower) {
    mk_cf_txPowerNeg40dBm,   //RadioTxPower:-40dBm
    mk_cf_txPowerNeg20dBm,   //-20dBm
    mk_cf_txPowerNeg16dBm,   //-16dBm
    mk_cf_txPowerNeg12dBm,   //-12dBm
    mk_cf_txPowerNeg8dBm,    //-8dBm
    mk_cf_txPowerNeg4dBm,    //-4dBm
    mk_cf_txPower0dBm,       //0dBm
    mk_cf_txPower3dBm,       //3dBm
    mk_cf_txPower4dBm,       //4dBm
};


typedef NS_ENUM(NSInteger, mk_cf_mqtt_networkType) {
    mk_cf_mqtt_networkType_ethernet,
    mk_cf_mqtt_networkType_wifi,
};


@protocol cf_indicatorLightStatusProtocol <NSObject>

@property (nonatomic, assign)BOOL ble_advertising;

@property (nonatomic, assign)BOOL ble_connected;

@property (nonatomic, assign)BOOL server_connecting;

@property (nonatomic, assign)BOOL server_connected;

@end



@protocol mk_cf_BLEFilterRawDataProtocol <NSObject>

/// The currently filtered data type, refer to the definition of different Bluetooth data types by the International Bluetooth Organization, 1 byte of hexadecimal data
@property (nonatomic, copy)NSString *dataType;

/// Data location to start filtering.if minIndex's value is 0,maxIndex must be 0;
@property (nonatomic, assign)NSInteger minIndex;

/// Data location to end filtering.if maxIndex's value is 0,minIndex must be 0;
@property (nonatomic, assign)NSInteger maxIndex;

/// The currently filtered content. The data length should be maxIndex-minIndex, if maxIndex=0&&minIndex==0, the item length is not checked whether it meets the requirements.MAX length:29 Bytes
@property (nonatomic, copy)NSString *rawData;

@end


@protocol mk_cf_BLEFilterBXPButtonProtocol <NSObject>

@property (nonatomic, assign)BOOL isOn;

@property (nonatomic, assign)BOOL singlePressIsOn;

@property (nonatomic, assign)BOOL doublePressIsOn;

@property (nonatomic, assign)BOOL longPressIsOn;

@property (nonatomic, assign)BOOL abnormalInactivityIsOn;

@end


@protocol mk_cf_BLEFilterPirProtocol <NSObject>

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

@protocol mk_cf_mqttModifyWifiProtocol <NSObject>

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

@protocol mk_cf_mqttModifyWifiEapCertProtocol <NSObject>

/// security为personal无此参数
@property (nonatomic, copy)NSString *caFilePath;

/// eapType为TLS有效
@property (nonatomic, copy)NSString *clientKeyPath;

/// eapType为TLS有效
@property (nonatomic, copy)NSString *clientCertPath;

@end



@protocol mk_cf_mqttModifyNetworkProtocol <NSObject>

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


@protocol mk_cf_modifyMqttServerProtocol <NSObject>

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


@protocol mk_cf_modifyMqttServerCertsProtocol <NSObject>

/// 0-256 Characters
@property (nonatomic, copy)NSString *caFilePath;

/// 0-256 Characters
@property (nonatomic, copy)NSString *clientKeyPath;

/// 0-256 Characters
@property (nonatomic, copy)NSString *clientCertPath;

@end


#pragma mark - 扫描数据上报内容选项protocol

@protocol cf_uploadDataOptionProtocol <NSObject>

@property (nonatomic, assign)BOOL timestamp;

@property (nonatomic, assign)BOOL rawData_advertising;

@property (nonatomic, assign)BOOL rawData_response;

@end
