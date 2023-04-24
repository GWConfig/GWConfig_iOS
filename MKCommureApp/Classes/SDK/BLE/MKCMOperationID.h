

typedef NS_ENUM(NSInteger, mk_cm_taskOperationID) {
    mk_cm_defaultTaskOperationID,
    
#pragma mark - Read
    mk_cm_taskReadDeviceModelOperation,        //读取产品型号
    mk_cm_taskReadFirmwareOperation,           //读取固件版本
    mk_cm_taskReadHardwareOperation,           //读取硬件类型
    mk_cm_taskReadSoftwareOperation,           //读取软件版本
    mk_cm_taskReadManufacturerOperation,       //读取厂商信息
    
#pragma mark - 自定义协议读取
    mk_cm_taskReadDeviceNameOperation,         //读取设备名称
    mk_cm_taskReadDeviceMacAddressOperation,    //读取MAC地址
    mk_cm_taskReadDeviceWifiSTAMacAddressOperation, //读取WIFI STA MAC地址
    mk_cm_taskReadNTPServerHostOperation,       //读取NTP服务器域名
    mk_cm_taskReadTimeZoneOperation,            //读取时区
    
#pragma mark - Wifi Params
    mk_cm_taskReadWIFISecurityOperation,        //读取设备当前wifi的加密模式
    mk_cm_taskReadWIFISSIDOperation,            //读取设备当前的wifi ssid
    mk_cm_taskReadWIFIPasswordOperation,        //读取设备当前的wifi密码
    mk_cm_taskReadWIFIEAPTypeOperation,         //读取设备当前的wifi EAP类型
    mk_cm_taskReadWIFIEAPUsernameOperation,     //读取设备当前的wifi EAP用户名
    mk_cm_taskReadWIFIEAPPasswordOperation,     //读取设备当前的wifi EAP密码
    mk_cm_taskReadWIFIEAPDomainIDOperation,     //读取设备当前的wifi EAP域名ID
    mk_cm_taskReadWIFIVerifyServerStatusOperation,  //读取是否校验服务器
    mk_cm_taskReadDHCPStatusOperation,              //读取DHCP开关
    mk_cm_taskReadNetworkIpInfosOperation,          //读取IP信息
    
#pragma mark - MQTT Params
    mk_cm_taskReadServerHostOperation,          //读取MQTT服务器域名
    mk_cm_taskReadServerPortOperation,          //读取MQTT服务器端口
    mk_cm_taskReadClientIDOperation,            //读取Client ID
    mk_cm_taskReadServerUserNameOperation,      //读取服务器登录用户名
    mk_cm_taskReadServerPasswordOperation,      //读取服务器登录密码
    mk_cm_taskReadServerCleanSessionOperation,  //读取MQTT Clean Session
    mk_cm_taskReadServerKeepAliveOperation,     //读取MQTT KeepAlive
    mk_cm_taskReadServerQosOperation,           //读取MQTT Qos
    mk_cm_taskReadSubscibeTopicOperation,       //读取Subscribe topic
    mk_cm_taskReadPublishTopicOperation,        //读取Publish topic
    mk_cm_taskReadConnectModeOperation,         //读取MTQQ服务器通信加密方式
    
#pragma mark - Filter Params
    mk_cm_taskReadRssiFilterValueOperation,             //读取扫描RSSI过滤
    mk_cm_taskReadFilterRelationshipOperation,          //读取扫描过滤逻辑
    mk_cm_taskReadFilterMACAddressListOperation,        //读取MAC过滤列表
    mk_cm_taskReadFilterAdvNameListOperation,           //读取ADV Name过滤列表
    
    
#pragma mark - 密码特征
    mk_cm_connectPasswordOperation,             //连接设备时候发送密码
    
#pragma mark - 配置
    mk_cm_taskEnterSTAModeOperation,                //设备重启进入STA模式
    mk_cm_taskConfigNTPServerHostOperation,         //配置NTP服务器域名
    mk_cm_taskConfigTimeZoneOperation,              //配置时区
    
#pragma mark - Wifi Params
    
    mk_cm_taskConfigWIFISecurityOperation,      //配置wifi的加密模式
    mk_cm_taskConfigWIFISSIDOperation,          //配置wifi的ssid
    mk_cm_taskConfigWIFIPasswordOperation,      //配置wifi的密码
    mk_cm_taskConfigWIFIEAPTypeOperation,       //配置wifi的EAP类型
    mk_cm_taskConfigWIFIEAPUsernameOperation,   //配置wifi的EAP用户名
    mk_cm_taskConfigWIFIEAPPasswordOperation,   //配置wifi的EAP密码
    mk_cm_taskConfigWIFIEAPDomainIDOperation,   //配置wifi的EAP域名ID
    mk_cm_taskConfigWIFIVerifyServerStatusOperation,    //配置wifi是否校验服务器
    mk_cm_taskConfigWIFICAFileOperation,                //配置WIFI CA证书
    mk_cm_taskConfigWIFIClientCertOperation,            //配置WIFI设备证书
    mk_cm_taskConfigWIFIClientPrivateKeyOperation,      //配置WIFI私钥
    mk_cm_taskConfigDHCPStatusOperation,                //配置DHCP开关
    mk_cm_taskConfigIpInfoOperation,                    //配置IP地址相关信息
    
#pragma mark - MQTT Params
    mk_cm_taskConfigServerHostOperation,        //配置MQTT服务器域名
    mk_cm_taskConfigServerPortOperation,        //配置MQTT服务器端口
    mk_cm_taskConfigClientIDOperation,              //配置ClientID
    mk_cm_taskConfigServerUserNameOperation,        //配置服务器的登录用户名
    mk_cm_taskConfigServerPasswordOperation,        //配置服务器的登录密码
    mk_cm_taskConfigServerCleanSessionOperation,    //配置MQTT Clean Session
    mk_cm_taskConfigServerKeepAliveOperation,       //配置MQTT KeepAlive
    mk_cm_taskConfigServerQosOperation,             //配置MQTT Qos
    mk_cm_taskConfigSubscibeTopicOperation,         //配置Subscribe topic
    mk_cm_taskConfigPublishTopicOperation,          //配置Publish topic
    mk_cm_taskConfigConnectModeOperation,           //配置MTQQ服务器通信加密方式
    mk_cm_taskConfigCAFileOperation,                //配置CA证书
    mk_cm_taskConfigClientCertOperation,            //配置设备证书
    mk_cm_taskConfigClientPrivateKeyOperation,      //配置私钥
        
#pragma mark - 过滤参数
    mk_cm_taskConfigRssiFilterValueOperation,                   //配置扫描RSSI过滤
    mk_cm_taskConfigFilterRelationshipOperation,                //配置扫描过滤逻辑
    mk_cm_taskConfigFilterMACAddressListOperation,           //配置MAC过滤规则
    mk_cm_taskConfigFilterAdvNameListOperation,             //配置Adv Name过滤规则
};

