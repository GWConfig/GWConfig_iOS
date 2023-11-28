

typedef NS_ENUM(NSInteger, mk_cf_taskOperationID) {
    mk_cf_defaultTaskOperationID,
    
#pragma mark - Read
    mk_cf_taskReadDeviceModelOperation,        //读取产品型号
    mk_cf_taskReadFirmwareOperation,           //读取固件版本
    mk_cf_taskReadHardwareOperation,           //读取硬件类型
    mk_cf_taskReadSoftwareOperation,           //读取软件版本
    mk_cf_taskReadManufacturerOperation,       //读取厂商信息
    
#pragma mark - 自定义协议读取
    mk_cf_taskReadDeviceNameOperation,         //读取设备名称
    mk_cf_taskReadDeviceMacAddressOperation,    //读取MAC地址
    mk_cf_taskReadDeviceWifiSTAMacAddressOperation, //读取WIFI STA MAC地址
    mk_cf_taskReadNTPServerHostOperation,       //读取NTP服务器域名
    mk_cf_taskReadTimeZoneOperation,            //读取时区
    
#pragma mark - Wifi Params
    mk_cf_taskReadWIFISecurityOperation,        //读取设备当前wifi的加密模式
    mk_cf_taskReadWIFISSIDOperation,            //读取设备当前的wifi ssid
    mk_cf_taskReadWIFIPasswordOperation,        //读取设备当前的wifi密码
    mk_cf_taskReadWIFIEAPTypeOperation,         //读取设备当前的wifi EAP类型
    mk_cf_taskReadWIFIEAPUsernameOperation,     //读取设备当前的wifi EAP用户名
    mk_cf_taskReadWIFIEAPPasswordOperation,     //读取设备当前的wifi EAP密码
    mk_cf_taskReadWIFIEAPDomainIDOperation,     //读取设备当前的wifi EAP域名ID
    mk_cf_taskReadWIFIVerifyServerStatusOperation,  //读取是否校验服务器
    mk_cf_taskReadWIFIDHCPStatusOperation,              //读取Wifi DHCP开关
    mk_cf_taskReadWIFINetworkIpInfosOperation,          //读取Wifi IP信息
    mk_cf_taskReadNetworkTypeOperation,                 //读取网络类型
    mk_cf_taskReadEthernetDHCPStatusOperation,          //读取Ethernet DHCP开关
    mk_cf_taskReadEthernetNetworkIpInfosOperation,      //读取Ethernet IP信息
    
#pragma mark - MQTT Params
    mk_cf_taskReadServerHostOperation,          //读取MQTT服务器域名
    mk_cf_taskReadServerPortOperation,          //读取MQTT服务器端口
    mk_cf_taskReadClientIDOperation,            //读取Client ID
    mk_cf_taskReadServerUserNameOperation,      //读取服务器登录用户名
    mk_cf_taskReadServerPasswordOperation,      //读取服务器登录密码
    mk_cf_taskReadServerCleanSessionOperation,  //读取MQTT Clean Session
    mk_cf_taskReadServerKeepAliveOperation,     //读取MQTT KeepAlive
    mk_cf_taskReadServerQosOperation,           //读取MQTT Qos
    mk_cf_taskReadSubscibeTopicOperation,       //读取Subscribe topic
    mk_cf_taskReadPublishTopicOperation,        //读取Publish topic
    mk_cf_taskReadConnectModeOperation,         //读取MTQQ服务器通信加密方式
    
#pragma mark - 密码特征
    mk_cf_connectPasswordOperation,             //连接设备时候发送密码
    
#pragma mark - 配置
    mk_cf_taskEnterSTAModeOperation,                //设备重启进入STA模式
    mk_cf_taskConfigNTPServerHostOperation,         //配置NTP服务器域名
    mk_cf_taskConfigTimeZoneOperation,              //配置时区
    mk_cf_taskConfigDeviceTimeOperation,            //配置UTC时间戳
    
#pragma mark - Wifi Params
    
    mk_cf_taskConfigWIFISecurityOperation,      //配置wifi的加密模式
    mk_cf_taskConfigWIFISSIDOperation,          //配置wifi的ssid
    mk_cf_taskConfigWIFIPasswordOperation,      //配置wifi的密码
    mk_cf_taskConfigWIFIEAPTypeOperation,       //配置wifi的EAP类型
    mk_cf_taskConfigWIFIEAPUsernameOperation,   //配置wifi的EAP用户名
    mk_cf_taskConfigWIFIEAPPasswordOperation,   //配置wifi的EAP密码
    mk_cf_taskConfigWIFIEAPDomainIDOperation,   //配置wifi的EAP域名ID
    mk_cf_taskConfigWIFIVerifyServerStatusOperation,    //配置wifi是否校验服务器
    mk_cf_taskConfigWIFICAFileOperation,                //配置WIFI CA证书
    mk_cf_taskConfigWIFIClientCertOperation,            //配置WIFI设备证书
    mk_cf_taskConfigWIFIClientPrivateKeyOperation,      //配置WIFI私钥
    mk_cf_taskConfigWIFIDHCPStatusOperation,                //配置Wifi DHCP开关
    mk_cf_taskConfigWIFIIpInfoOperation,                    //配置Wifi IP地址相关信息
    mk_cf_taskConfigNetworkTypeOperation,                   //配置网络接口类型
    mk_cf_taskConfigEthernetDHCPStatusOperation,            //配置Ethernet DHCP开关
    mk_cf_taskConfigEthernetIpInfoOperation,                //配置Ethernet IP地址相关信息
    
#pragma mark - MQTT Params
    mk_cf_taskConfigServerHostOperation,        //配置MQTT服务器域名
    mk_cf_taskConfigServerPortOperation,        //配置MQTT服务器端口
    mk_cf_taskConfigClientIDOperation,              //配置ClientID
    mk_cf_taskConfigServerUserNameOperation,        //配置服务器的登录用户名
    mk_cf_taskConfigServerPasswordOperation,        //配置服务器的登录密码
    mk_cf_taskConfigServerCleanSessionOperation,    //配置MQTT Clean Session
    mk_cf_taskConfigServerKeepAliveOperation,       //配置MQTT KeepAlive
    mk_cf_taskConfigServerQosOperation,             //配置MQTT Qos
    mk_cf_taskConfigSubscibeTopicOperation,         //配置Subscribe topic
    mk_cf_taskConfigPublishTopicOperation,          //配置Publish topic
    mk_cf_taskConfigConnectModeOperation,           //配置MTQQ服务器通信加密方式
    mk_cf_taskConfigCAFileOperation,                //配置CA证书
    mk_cf_taskConfigClientCertOperation,            //配置设备证书
    mk_cf_taskConfigClientPrivateKeyOperation,      //配置私钥
};

