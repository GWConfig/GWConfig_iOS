

typedef NS_ENUM(NSInteger, mk_ch_taskOperationID) {
    mk_ch_defaultTaskOperationID,
    
#pragma mark - Read
    mk_ch_taskReadDeviceModelOperation,        //读取产品型号
    mk_ch_taskReadFirmwareOperation,           //读取固件版本
    mk_ch_taskReadHardwareOperation,           //读取硬件类型
    mk_ch_taskReadSoftwareOperation,           //读取软件版本
    mk_ch_taskReadManufacturerOperation,       //读取厂商信息
    
#pragma mark - 自定义协议读取
    mk_ch_taskReadDeviceNameOperation,         //读取设备名称
    mk_ch_taskReadDeviceMacAddressOperation,    //读取MAC地址
    mk_ch_taskReadDeviceWifiSTAMacAddressOperation, //读取WIFI STA MAC地址
    mk_ch_taskReadNTPServerHostOperation,       //读取NTP服务器域名
    mk_ch_taskReadTimeZoneOperation,            //读取时区
    mk_ch_taskReadBleFirmwareOperation,         //读取蓝牙模块固件版本
    
#pragma mark - Wifi Params
    mk_ch_taskReadWIFISecurityOperation,        //读取设备当前wifi的加密模式
    mk_ch_taskReadWIFISSIDOperation,            //读取设备当前的wifi ssid
    mk_ch_taskReadWIFIPasswordOperation,        //读取设备当前的wifi密码
    mk_ch_taskReadWIFIEAPTypeOperation,         //读取设备当前的wifi EAP类型
    mk_ch_taskReadWIFIEAPUsernameOperation,     //读取设备当前的wifi EAP用户名
    mk_ch_taskReadWIFIEAPPasswordOperation,     //读取设备当前的wifi EAP密码
    mk_ch_taskReadWIFIEAPDomainIDOperation,     //读取设备当前的wifi EAP域名ID
    mk_ch_taskReadWIFIVerifyServerStatusOperation,  //读取是否校验服务器
    mk_ch_taskReadWIFIDHCPStatusOperation,              //读取Wifi DHCP开关
    mk_ch_taskReadWIFINetworkIpInfosOperation,          //读取Wifi IP信息
    mk_ch_taskReadCountryBandOperation,                 //读取国家地区参数
    
#pragma mark - MQTT Params
    mk_ch_taskReadServerHostOperation,          //读取MQTT服务器域名
    mk_ch_taskReadServerPortOperation,          //读取MQTT服务器端口
    mk_ch_taskReadClientIDOperation,            //读取Client ID
    mk_ch_taskReadServerUserNameOperation,      //读取服务器登录用户名
    mk_ch_taskReadServerPasswordOperation,      //读取服务器登录密码
    mk_ch_taskReadServerCleanSessionOperation,  //读取MQTT Clean Session
    mk_ch_taskReadServerKeepAliveOperation,     //读取MQTT KeepAlive
    mk_ch_taskReadServerQosOperation,           //读取MQTT Qos
    mk_ch_taskReadSubscibeTopicOperation,       //读取Subscribe topic
    mk_ch_taskReadPublishTopicOperation,        //读取Publish topic
    mk_ch_taskReadConnectModeOperation,         //读取MTQQ服务器通信加密方式
    
#pragma mark - 密码特征
    mk_ch_connectPasswordOperation,             //连接设备时候发送密码
    
#pragma mark - 配置
    mk_ch_taskEnterSTAModeOperation,                //设备重启进入STA模式
    mk_ch_taskConfigNTPServerHostOperation,         //配置NTP服务器域名
    mk_ch_taskConfigTimeZoneOperation,              //配置时区
    
#pragma mark - Wifi Params
    
    mk_ch_taskConfigWIFISecurityOperation,      //配置wifi的加密模式
    mk_ch_taskConfigWIFISSIDOperation,          //配置wifi的ssid
    mk_ch_taskConfigWIFIPasswordOperation,      //配置wifi的密码
    mk_ch_taskConfigWIFIEAPTypeOperation,       //配置wifi的EAP类型
    mk_ch_taskConfigWIFIEAPUsernameOperation,   //配置wifi的EAP用户名
    mk_ch_taskConfigWIFIEAPPasswordOperation,   //配置wifi的EAP密码
    mk_ch_taskConfigWIFIEAPDomainIDOperation,   //配置wifi的EAP域名ID
    mk_ch_taskConfigWIFIVerifyServerStatusOperation,    //配置wifi是否校验服务器
    mk_ch_taskConfigWIFICAFileOperation,                //配置WIFI CA证书
    mk_ch_taskConfigWIFIClientCertOperation,            //配置WIFI设备证书
    mk_ch_taskConfigWIFIClientPrivateKeyOperation,      //配置WIFI私钥
    mk_ch_taskConfigWIFIDHCPStatusOperation,                //配置Wifi DHCP开关
    mk_ch_taskConfigWIFIIpInfoOperation,                    //配置Wifi IP地址相关信息
    mk_ch_taskConfigCountryBandOperation,                   //配置国家地区参数
    
#pragma mark - MQTT Params
    mk_ch_taskConfigServerHostOperation,        //配置MQTT服务器域名
    mk_ch_taskConfigServerPortOperation,        //配置MQTT服务器端口
    mk_ch_taskConfigClientIDOperation,              //配置ClientID
    mk_ch_taskConfigServerUserNameOperation,        //配置服务器的登录用户名
    mk_ch_taskConfigServerPasswordOperation,        //配置服务器的登录密码
    mk_ch_taskConfigServerCleanSessionOperation,    //配置MQTT Clean Session
    mk_ch_taskConfigServerKeepAliveOperation,       //配置MQTT KeepAlive
    mk_ch_taskConfigServerQosOperation,             //配置MQTT Qos
    mk_ch_taskConfigSubscibeTopicOperation,         //配置Subscribe topic
    mk_ch_taskConfigPublishTopicOperation,          //配置Publish topic
    mk_ch_taskConfigConnectModeOperation,           //配置MTQQ服务器通信加密方式
    mk_ch_taskConfigCAFileOperation,                //配置CA证书
    mk_ch_taskConfigClientCertOperation,            //配置设备证书
    mk_ch_taskConfigClientPrivateKeyOperation,      //配置私钥
};

