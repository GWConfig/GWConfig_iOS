
typedef NS_ENUM(NSInteger, mk_ch_serverOperationID) {
    mk_ch_defaultServerOperationID,
    
#pragma mark - Config
    mk_ch_server_taskRebootDeviceOperation,             //重启设备
    mk_ch_server_taskKeyResetTypeOperation,             //配置按键恢复出厂设置类型
    mk_ch_server_taskConfigNetworkStatusReportIntervalOperation,    //配置网络状态上报间隔
    mk_ch_server_taskConfigReconnectTimeoutOperation,           //配置网络重连超时时间
    mk_ch_server_taskConfigOTAHostOperation,                    //OTA
    mk_ch_server_taskConfigNTPServerOperation,                  //配置NTP服务器信息
    mk_ch_server_taskConfigDeviceTimeZoneOperation,             //配置设备的UTC时间
    mk_ch_server_taskConfigIndicatorLightStatusOperation,       //配置指示灯开关
    mk_ch_server_taskResetDeviceOperation,              //恢复出厂设置
    mk_ch_server_taskConfigBleAdvStatusOperation,       //配置蓝牙广播状态
    mk_ch_server_taskConfigPowerSwitchStatusOperation,  //配置开关状态
    mk_ch_server_taskConfigNpcOTAHostOperation,         //配置NCP固件升级
    mk_ch_server_taskModifyWifiInfosOperation,          //配置wifi网络
    mk_ch_server_taskModifyWifiCertsOperation,          //配置EAP证书
    mk_ch_server_taskModifyWifiNetworkInfoOperation,        //配置Wifi网络参数
    mk_ch_server_taskModifyMqttInfoOperation,           //配置MQTT参数
    mk_ch_server_taskModifyMqttCertsOperation,          //配置MQTT证书
    mk_ch_server_taskConfigScanSwitchStatusOperation,   //配置扫描开关状态
    mk_ch_server_taskConfigFilterRelationshipsOperation,  //配置过滤逻辑
    mk_ch_server_taskConfigFilterByRSSIOperation,         //配置过滤RSSI
    mk_ch_server_taskConfigFilterByMacAddressOperation,     //配置过滤mac
    mk_ch_server_taskConfigFilterByTagOperation,            //配置过滤Tag
    mk_ch_server_taskConfigDataReportTimeoutOperation,      //配置数据包上报超时时间
    mk_ch_server_taskConfigBXBDecryptTimeOffsetOperation,   //配置BXP-B解析时间偏移
    mk_ch_server_taskConfigBXBDecryptKeyOperation,          //配置BXP-B秘钥
    mk_ch_server_taskConfigCommunicationTimeoutOperation,       //配置通信超时时间
    mk_ch_server_taskConfigConnectBeaconTimeoutOperation,       //配置BXP-B连接扫描等待超时时间
    
    mk_ch_server_taskConnectBXPButtonWithMacOperation,      //连接指定mac地址的BXP-Button设备
    
    mk_ch_server_taskConfigDeviceLedReminderOperation,      //LED提醒
    mk_ch_server_taskConfigDeviceBuzzerReminderOperation,   //Buzzer提醒
    mk_ch_server_taskConfigDeviceTimestampOperation,        //同步时间戳
    mk_ch_server_taskPowerOffConnectedDeviceOperation,      //关机
    mk_ch_server_taskResetConnectedDeviceOperation,         //复位
    
    mk_ch_server_taskConfigTagIDOperation,              //设置Tag ID
    mk_ch_server_taskConfigSosTriggerTypeOperation,     //设置SOS出发方式
    mk_ch_server_taskConfigSelfTestTriggeredByButtonOperation,  //设置按键自检时长
    
    mk_ch_server_taskBatchDfuBeaconWithMacOperation, //批量升级
    mk_ch_server_taskBatchUpdateKeyWithMacOperation,    //批量更新秘钥
    
    mk_ch_server_taskStartBXPButtonDfuWithMacOperation,         //指定BXP-Button设备DFU升级
    
    mk_ch_server_taskConnectNormalBleDeviceWithMacOperation,    //网关连接指定mac地址的蓝牙设备
    
#pragma mark - Read
    mk_ch_server_taskReadKeyResetTypeOperation,         //读取按键恢复出厂设置类型
    mk_ch_server_taskReadDeviceInfoOperation,           //读取设备信息
    mk_ch_server_taskReadNetworkStatusReportIntervalOperation,  //读取网络状态上报间隔
    mk_ch_server_taskReadNetworkReconnectTimeoutOperation,      //读取网络重连超时时间
    mk_ch_server_taskReadNTPServerOperation,                    //读取NTP服务器信息
    mk_ch_server_taskReadDeviceUTCTimeOperation,                //读取当前UTC时间
    mk_ch_server_taskReadIndicatorLightStatusOperation,         //读取指示灯开关
    mk_ch_server_taskReadOtaStatusOperation,                    //读取当前设备OTA状态
    mk_ch_server_taskReadBleAdvStatusOperation,                 //读取蓝牙广播状态
    mk_ch_server_taskReadPowerSwitchStatusOperation,            //读取开关状态
    mk_ch_server_taskReadWifiInfosOperation,                    //读取设备当前连接的wifi信息
    mk_ch_server_taskReadWifiNetworkInfosOperation,                 //读取Wifi网络参数
    mk_ch_server_taskReadNetworkTypeOperation,                  //读取网络接口选择
    mk_ch_server_taskReadMQTTParamsOperation,                   //读取MQTT服务器信息
    mk_ch_server_taskReadScanSwitchStatusOperation,    //读取扫描开关状态
    mk_ch_server_taskReadFilterRelationshipsOperation,  //读取过滤逻辑
    mk_ch_server_taskReadFilterByRSSIOperation,         //读取过滤RSSI
    mk_ch_server_taskReadFilterByMacOperation,          //读取过滤MAC
    mk_ch_server_taskReadFilterBXPTagOperation,         //读取过滤Tag
    mk_ch_server_taskReadDataReportTimeoutOperation,    //读取数据上报超时时间
    mk_ch_server_taskReadBXBDecryptTimeOffsetOperation, //读取BXP-B解析时间偏移
    mk_ch_server_taskReadBXBDecryptKeyOperation,        //读取BXP-B秘钥
    mk_ch_server_taskReadCommunicateTimeoutOperation,           //读取通信超时时间
    mk_ch_server_taskReadConnectBeaconTimeoutOperation,         //读取BXP-B连接扫描等待超时时间
    
    mk_ch_server_taskReadBXPButtonConnectedDeviceInfoOperation, //读取已连接BXP-Button设备信息
    mk_ch_server_taskDisconnectBleDeviceOperation,          //断开连接
    mk_ch_server_taskDismissAlarmStatusOperation,               //BXP-Button消警
    
    mk_ch_server_taskReadGatewayBleConnectStatusOperation,      //读取网关蓝牙连接的状态
    
    mk_ch_server_taskReadDeviceBatteryVoltageOperation,         //读取已连接设备的电池电压
    mk_ch_server_taskReadTagIDOperation,                //读取已连接设备的Tag ID
    mk_ch_server_taskReadSosTriggerTypeOperation,       //读取SOS触发方式
    mk_ch_server_taskReadSelfTestTriggeredByButtonOperation,    //读取按键自检时长
    mk_ch_server_taskReadAlarmStatusOperation,          //读取报警状态
    
    mk_ch_server_taskReadBatterySelfTestOperation,  //读取电量自检参数
    mk_ch_server_taskConfigBatterySelfTestOperation,    //设置电量自检参数
    mk_ch_server_taskReadBatterySelfTestLedParamsOperation, //读取电量自检LED参数
    mk_ch_server_taskConfigBatterySelfTestLedParamsOperation,   //设置电量自检LED参数
    mk_ch_server_taskReadAccelerometerParamsOperation,      //读取三轴参数
    mk_ch_server_taskConfigAccelerometerParamsOperation,    //设置三轴参数
    mk_ch_server_taskReadSleepModeParametersOperation,      //读取省电等待时间
    mk_ch_server_taskConfigSleepModeParametersOperation,    //配置省电等待时间
    mk_ch_server_taskReadAdvParamsOperation,                //读取广播参数
    mk_ch_server_taskConfigAdvParamsOperation,              //设置广播参数
    mk_ch_server_taskConfigPasswordVerificationOperation,   //设置连接密码
    mk_ch_server_taskReadPasswordVerificationStatusOperation,     //读取密码校验开关状态
    mk_ch_server_taskConfigPasswordVerificationStatusOperation,     //设置密码校验开关状态
    
    
    mk_ch_server_taskReadButtonLogOperation,                //获取按键log
    mk_ch_server_taskClearButtonLogOperation,               //清除按键log
    
    
    mk_ch_server_taskReadSosAlarmNotiOperation,             //读取Sos报警Led与Buzzer参数
    mk_ch_server_taskConfigSosAlarmNotiOperation,           //配置Sos报警Led与Buzzer参数
    
    
    mk_ch_server_taskReadHardwareSelfTestOperation,         //读取硬件自检Led与Buzzer参数
    mk_ch_server_taskConfigHardwareSelfTestOperation,       //配置硬件自检Led与Buzzer参数
    
    mk_ch_server_taskReadDismissSosAlarmNotiOperation,             //读取消除Sos报警Led与Buzzer参数
    mk_ch_server_taskConfigDismissSosAlarmNotiOperation,           //配置消除Sos报警Led与Buzzer参数
    
    mk_ch_server_taskReadButtonPressEffectiveIntervalOperation,     //读取按键有效间隔参数
    mk_ch_server_taskConfigButtonPressEffectiveIntervalOperation,   //配置按键有效间隔参数
};
