

typedef NS_ENUM(NSInteger, mk_cg_taskOperationID) {
    mk_cg_defaultTaskOperationID,
    
#pragma mark - Read
    mk_cg_taskReadDeviceModelOperation,        //读取产品型号
    mk_cg_taskReadFirmwareOperation,           //读取固件版本
    mk_cg_taskReadHardwareOperation,           //读取硬件类型
    mk_cg_taskReadSoftwareOperation,           //读取软件版本
    mk_cg_taskReadManufacturerOperation,       //读取厂商信息
    
#pragma mark - 自定义协议读取
    mk_cg_taskReadDeviceNameOperation,         //读取设备名称
    mk_cg_taskReadDeviceMacAddressOperation,    //读取MAC地址
    mk_cg_taskReadDeviceWifiSTAMacAddressOperation, //读取WIFI STA MAC地址
    mk_cg_taskReadNTPServerHostOperation,       //读取NTP服务器域名
    mk_cg_taskReadTimeZoneOperation,            //读取时区
    
#pragma mark - Wifi Params
    mk_cg_taskReadWIFISecurityOperation,        //读取设备当前wifi的加密模式
    mk_cg_taskReadWIFISSIDOperation,            //读取设备当前的wifi ssid
    mk_cg_taskReadWIFIPasswordOperation,        //读取设备当前的wifi密码
    mk_cg_taskReadWIFIEAPTypeOperation,         //读取设备当前的wifi EAP类型
    mk_cg_taskReadWIFIEAPUsernameOperation,     //读取设备当前的wifi EAP用户名
    mk_cg_taskReadWIFIEAPPasswordOperation,     //读取设备当前的wifi EAP密码
    mk_cg_taskReadWIFIEAPDomainIDOperation,     //读取设备当前的wifi EAP域名ID
    mk_cg_taskReadWIFIVerifyServerStatusOperation,  //读取是否校验服务器
    mk_cg_taskReadWIFIDHCPStatusOperation,              //读取Wifi DHCP开关
    mk_cg_taskReadWIFINetworkIpInfosOperation,          //读取Wifi IP信息
    mk_cg_taskReadNetworkTypeOperation,                 //读取网络类型
    mk_cg_taskReadEthernetDHCPStatusOperation,          //读取Ethernet DHCP开关
    mk_cg_taskReadEthernetNetworkIpInfosOperation,      //读取Ethernet IP信息
    
#pragma mark - MQTT Params
    mk_cg_taskReadServerHostOperation,          //读取MQTT服务器域名
    mk_cg_taskReadServerPortOperation,          //读取MQTT服务器端口
    mk_cg_taskReadClientIDOperation,            //读取Client ID
    mk_cg_taskReadServerUserNameOperation,      //读取服务器登录用户名
    mk_cg_taskReadServerPasswordOperation,      //读取服务器登录密码
    mk_cg_taskReadServerCleanSessionOperation,  //读取MQTT Clean Session
    mk_cg_taskReadServerKeepAliveOperation,     //读取MQTT KeepAlive
    mk_cg_taskReadServerQosOperation,           //读取MQTT Qos
    mk_cg_taskReadSubscibeTopicOperation,       //读取Subscribe topic
    mk_cg_taskReadPublishTopicOperation,        //读取Publish topic
    mk_cg_taskReadConnectModeOperation,         //读取MTQQ服务器通信加密方式
    
#pragma mark - 密码特征
    mk_cg_connectPasswordOperation,             //连接设备时候发送密码
    
#pragma mark - 配置
    mk_cg_taskEnterSTAModeOperation,                //设备重启进入STA模式
    mk_cg_taskConfigNTPServerHostOperation,         //配置NTP服务器域名
    mk_cg_taskConfigTimeZoneOperation,              //配置时区
    
#pragma mark - Wifi Params
    
    mk_cg_taskConfigWIFISecurityOperation,      //配置wifi的加密模式
    mk_cg_taskConfigWIFISSIDOperation,          //配置wifi的ssid
    mk_cg_taskConfigWIFIPasswordOperation,      //配置wifi的密码
    mk_cg_taskConfigWIFIEAPTypeOperation,       //配置wifi的EAP类型
    mk_cg_taskConfigWIFIEAPUsernameOperation,   //配置wifi的EAP用户名
    mk_cg_taskConfigWIFIEAPPasswordOperation,   //配置wifi的EAP密码
    mk_cg_taskConfigWIFIEAPDomainIDOperation,   //配置wifi的EAP域名ID
    mk_cg_taskConfigWIFIVerifyServerStatusOperation,    //配置wifi是否校验服务器
    mk_cg_taskConfigWIFICAFileOperation,                //配置WIFI CA证书
    mk_cg_taskConfigWIFIClientCertOperation,            //配置WIFI设备证书
    mk_cg_taskConfigWIFIClientPrivateKeyOperation,      //配置WIFI私钥
    mk_cg_taskConfigWIFIDHCPStatusOperation,                //配置Wifi DHCP开关
    mk_cg_taskConfigWIFIIpInfoOperation,                    //配置Wifi IP地址相关信息
    mk_cg_taskConfigNetworkTypeOperation,                   //配置网络接口类型
    mk_cg_taskConfigEthernetDHCPStatusOperation,            //配置Ethernet DHCP开关
    mk_cg_taskConfigEthernetIpInfoOperation,                //配置Ethernet IP地址相关信息
    
#pragma mark - MQTT Params
    mk_cg_taskConfigServerHostOperation,        //配置MQTT服务器域名
    mk_cg_taskConfigServerPortOperation,        //配置MQTT服务器端口
    mk_cg_taskConfigClientIDOperation,              //配置ClientID
    mk_cg_taskConfigServerUserNameOperation,        //配置服务器的登录用户名
    mk_cg_taskConfigServerPasswordOperation,        //配置服务器的登录密码
    mk_cg_taskConfigServerCleanSessionOperation,    //配置MQTT Clean Session
    mk_cg_taskConfigServerKeepAliveOperation,       //配置MQTT KeepAlive
    mk_cg_taskConfigServerQosOperation,             //配置MQTT Qos
    mk_cg_taskConfigSubscibeTopicOperation,         //配置Subscribe topic
    mk_cg_taskConfigPublishTopicOperation,          //配置Publish topic
    mk_cg_taskConfigConnectModeOperation,           //配置MTQQ服务器通信加密方式
    mk_cg_taskConfigCAFileOperation,                //配置CA证书
    mk_cg_taskConfigClientCertOperation,            //配置设备证书
    mk_cg_taskConfigClientPrivateKeyOperation,      //配置私钥
};

