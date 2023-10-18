

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
    mk_cm_taskReadWIFIDHCPStatusOperation,              //读取Wifi DHCP开关
    mk_cm_taskReadWIFINetworkIpInfosOperation,          //读取Wifi IP信息
    mk_cm_taskReadNetworkTypeOperation,                 //读取网络类型
    mk_cm_taskReadEthernetDHCPStatusOperation,          //读取Ethernet DHCP开关
    mk_cm_taskReadEthernetNetworkIpInfosOperation,      //读取Ethernet IP信息
    mk_cm_taskReadCountryBandOperation,             //读取国家地区参数
    
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
    
#pragma mark - 密码特征
    mk_cm_connectPasswordOperation,             //连接设备时候发送密码
    
#pragma mark - 配置
    mk_cm_taskEnterSTAModeOperation,                //设备重启进入STA模式
    mk_cm_taskConfigNTPServerHostOperation,         //配置NTP服务器域名
    mk_cm_taskConfigTimeZoneOperation,              //配置时区
    mk_cm_taskConfigDeviceTimeOperation,            //配置UTC时间戳
    
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
    mk_cm_taskConfigWIFIDHCPStatusOperation,                //配置Wifi DHCP开关
    mk_cm_taskConfigWIFIIpInfoOperation,                    //配置Wifi IP地址相关信息
    mk_cm_taskConfigNetworkTypeOperation,                   //配置网络接口类型
    mk_cm_taskConfigEthernetDHCPStatusOperation,            //配置Ethernet DHCP开关
    mk_cm_taskConfigEthernetIpInfoOperation,                //配置Ethernet IP地址相关信息
    mk_cm_taskConfigCountryBandOperation,                   //配置国家地区参数
    
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
};

