#
# Be sure to run `pod lib lint MKCommureApp.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MKCommureApp'
  s.version          = '0.0.2'
  s.summary          = 'A short description of MKCommureApp.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/aadyx2007@163.com/MKCommureApp'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'aadyx2007@163.com' => 'aadyx2007@163.com' }
  s.source           = { :git => 'https://github.com/aadyx2007@163.com/MKCommureApp.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.0'
  
   s.resource_bundles = {
     'MKCommureApp' => ['MKCommureApp/Assets/*.png']
   }

   s.subspec 'Target' do |ss|
       
       ss.source_files = 'MKCommureApp/Classes/Target/**'
       
       ss.dependency 'MKBaseModuleLibrary'
       ss.dependency 'MKCommureApp/Functions'
     
     end
     
     s.subspec 'CTMediator' do |ss|
       
       ss.source_files = 'MKCommureApp/Classes/CTMediator/**'
       
       ss.dependency 'CTMediator'
       ss.dependency 'MKBaseModuleLibrary'
     
     end
     
     s.subspec 'DeviceModel' do |ss|
       
       ss.source_files = 'MKCommureApp/Classes/DeviceModel/**'

       ss.dependency 'MKBaseModuleLibrary'
       ss.dependency 'MKCommureApp/SDK/MQTT'
     
     end
     
     s.subspec 'Expand' do |ss|
       
       ss.subspec 'BleBaseController' do |sss|
         
         sss.source_files = 'MKCommureApp/Classes/Expand/BleBaseController/**'
       
       
         sss.dependency 'MKCommureApp/SDK/BLE'
       end
     
       ss.subspec 'BaseController' do |sss|
         
         sss.source_files = 'MKCommureApp/Classes/Expand/BaseController/**'
       
       
         sss.dependency 'MKCommureApp/SDK/MQTT'
         sss.dependency 'MKCommureApp/DeviceModel'
       end
       
       ss.subspec 'DatabaseManager' do |sss|
         
         sss.source_files = 'MKCommureApp/Classes/Expand/DatabaseManager/**'
       
       
         sss.dependency 'FMDB'
         sss.dependency 'MKCommureApp/DeviceModel'
       end
       
       ss.subspec 'ExcelManager' do |sss|
         
         sss.source_files = 'MKCommureApp/Classes/Expand/ExcelManager/**'
       
       
         sss.dependency 'libxlsxwriter'
         sss.dependency 'SSZipArchive'
       end
       
       ss.subspec 'View' do |sss|
         sss.subspec 'AlertView' do |ssss|
           ssss.source_files = 'MKCommureApp/Classes/Expand/View/AlertView/**'
         end
         
         sss.subspec 'BatchUpdateCell' do |ssss|
           ssss.source_files = 'MKCommureApp/Classes/Expand/View/BatchUpdateCell/**'
         end
         
         sss.subspec 'BleWifiSettingsCell' do |ssss|
           ssss.source_files = 'MKCommureApp/Classes/Expand/View/BleWifiSettingsCell/**'
         end
         
         sss.subspec 'FilterCell' do |ssss|
           
           ssss.subspec 'FilterBeaconCell' do |sssss|
             sssss.source_files = 'MKCommureApp/Classes/Expand/View/FilterCell/FilterBeaconCell/**'
           end
           
           ssss.subspec 'FilterByRawDataCell' do |sssss|
             sssss.source_files = 'MKCommureApp/Classes/Expand/View/FilterCell/FilterByRawDataCell/**'
           end
           
           ssss.subspec 'FilterEditSectionHeaderView' do |sssss|
             sssss.source_files = 'MKCommureApp/Classes/Expand/View/FilterCell/FilterEditSectionHeaderView/**'
           end
           
           ssss.subspec 'FilterNormalTextFieldCell' do |sssss|
             sssss.source_files = 'MKCommureApp/Classes/Expand/View/FilterCell/FilterNormalTextFieldCell/**'
           end
         
         end
         
         sss.subspec 'UserCredentialsView' do |ssss|
           
           ssss.source_files = 'MKCommureApp/Classes/Expand/View/UserCredentialsView/**'
           
         end
         
         sss.subspec 'WifiSettingsBandCell' do |ssss|
           ssss.source_files = 'MKCommureApp/Classes/Expand/View/WifiSettingsBandCell/**'
         end
           
       end
       
       ss.subspec 'ImportServerPage' do |sss|
         sss.subspec 'Controller' do |ssss|
           ssss.source_files = 'MKCommureApp/Classes/Expand/ImportServerPage/Controller/**'
         end
       end
       
       ss.dependency 'MKBaseModuleLibrary'
       ss.dependency 'MKCustomUIModule'
     
     end
     
     s.subspec 'SDK' do |ss|
         
       ss.subspec 'BLE' do |sss|
         sss.source_files = 'MKCommureApp/Classes/SDK/BLE/**'
         
         sss.dependency 'MKBaseBleModule'
       end
       
       ss.subspec 'MQTT' do |sss|
           sss.subspec 'Manager' do |ssss|
               ssss.source_files = 'MKCommureApp/Classes/SDK/MQTT/Manager/**'
               
               ssss.dependency 'MKBaseModuleLibrary'
               ssss.dependency 'MKBaseMQTTModule'
           end
           
           sss.subspec 'SDK' do |ssss|
               ssss.source_files = 'MKCommureApp/Classes/SDK/MQTT/SDK/**'
               
               ssss.dependency 'MKBaseModuleLibrary'
               ssss.dependency 'MKCommureApp/SDK/MQTT/Manager'
           end
       end
       
     end
     
     s.subspec 'Functions' do |ss|
       
       ss.subspec 'AboutPage' do |sss|
           sss.subspec 'Controller' do |ssss|
             ssss.source_files = 'MKCommureApp/Classes/Functions/AboutPage/Controller/**'
             
             ssss.dependency 'MKCommureApp/Functions/LogPage'
           end
       end
       
       ss.subspec 'BatchOtaPage' do |sss|
           sss.subspec 'Controller' do |ssss|
             ssss.source_files = 'MKCommureApp/Classes/Functions/BatchOtaPage/Controller/**'
             
             ssss.dependency 'MKCommureApp/Functions/BatchOtaPage/Model'
             ssss.dependency 'MKCommureApp/Functions/BatchOtaPage/View'
             
             ssss.dependency 'MKCommureApp/Functions/QRCodePage/Controller'
           end
           sss.subspec 'Model' do |ssss|
             ssss.source_files = 'MKCommureApp/Classes/Functions/BatchOtaPage/Model/**'
             
           end
           sss.subspec 'View' do |ssss|
             ssss.source_files = 'MKCommureApp/Classes/Functions/BatchOtaPage/View/**'
             
           end
       end
       
       ss.subspec 'ConfiguredGatewayPage' do |sss|
         sss.subspec 'Controller' do |ssss|
           ssss.source_files = 'MKCommureApp/Classes/Functions/ConfiguredGatewayPage/Controller/**'

           ssss.dependency 'MKCommureApp/Functions/ConfiguredGatewayPage/Model'
           ssss.dependency 'MKCommureApp/Functions/ConfiguredGatewayPage/View'

           ssss.dependency 'MKCommureApp/Functions/QRCodePage/Controller'
         end

         sss.subspec 'Model' do |ssss|
           ssss.source_files = 'MKCommureApp/Classes/Functions/ConfiguredGatewayPage/Model/**'

         end
         sss.subspec 'View' do |ssss|
           ssss.source_files = 'MKCommureApp/Classes/Functions/ConfiguredGatewayPage/View/**'

         end

       end
       
       ss.subspec 'LogPage' do |sss|
           sss.subspec 'Controller' do |ssss|
             ssss.source_files = 'MKCommureApp/Classes/Functions/LogPage/Controller/**'
           end
       end
       
       ss.subspec 'AddDeviceModules' do |sss|
           sss.subspec 'ParamsModel'  do |ssss|
               ssss.source_files = 'MKCommureApp/Classes/Functions/AddDeviceModules/ParamsModel/**'
           end
           sss.subspec 'Pages' do |ssss|
               ssss.subspec 'BleDeviceInfoPage' do |sssss|
                   sssss.subspec 'Controller' do |ssssss|
                     ssssss.source_files = 'MKCommureApp/Classes/Functions/AddDeviceModules/Pages/BleDeviceInfoPage/Controller/**'
                     
                     ssssss.dependency 'MKCommureApp/Functions/AddDeviceModules/Pages/BleDeviceInfoPage/Model'
                   end
                   
                   sssss.subspec 'Model' do |ssssss|
                     ssssss.source_files = 'MKCommureApp/Classes/Functions/AddDeviceModules/Pages/BleDeviceInfoPage/Model/**'
                   end
               end
               
               ssss.subspec 'BleDeviceParamsForGWT' do |sssss|
                 sssss.subspec 'Controller' do |ssssss|
                   ssssss.source_files = 'MKCommureApp/Classes/Functions/AddDeviceModules/Pages/BleDeviceParamsForGWT/Controller/**'
                 
                   ssssss.dependency 'MKCommureApp/Functions/AddDeviceModules/Pages/BleDeviceInfoPage'
                   ssssss.dependency 'MKCommureApp/Functions/AddDeviceModules/Pages/BleNetworkForGWT'
                   ssssss.dependency 'MKCommureApp/Functions/AddDeviceModules/Pages/ConnectSuccessPage'
                   ssssss.dependency 'MKCommureApp/Functions/AddDeviceModules/Pages/NTPTimezonePage'
                   ssssss.dependency 'MKCommureApp/Functions/AddDeviceModules/Pages/ServerForDevice'
                 end
               end
               
               ssss.subspec 'BleNetworkForGWT' do |sssss|
                   sssss.subspec 'Controller' do |ssssss|
                     ssssss.source_files = 'MKCommureApp/Classes/Functions/AddDeviceModules/Pages/BleNetworkForGWT/Controller/**'
                     
                     ssssss.dependency 'MKCommureApp/Functions/AddDeviceModules/Pages/BleNetworkForGWT/Model'
                   end
                   
                   sssss.subspec 'Model' do |ssssss|
                     ssssss.source_files = 'MKCommureApp/Classes/Functions/AddDeviceModules/Pages/BleNetworkForGWT/Model/**'
                   end
               end
               
               ssss.subspec 'BleNetworkSettingsPage' do |sssss|
                   sssss.subspec 'Controller' do |ssssss|
                     ssssss.source_files = 'MKCommureApp/Classes/Functions/AddDeviceModules/Pages/BleNetworkSettingsPage/Controller/**'
                     
                     ssssss.dependency 'MKCommureApp/Functions/AddDeviceModules/Pages/BleNetworkSettingsPage/Model'
                   end
                   
                   sssss.subspec 'Model' do |ssssss|
                     ssssss.source_files = 'MKCommureApp/Classes/Functions/AddDeviceModules/Pages/BleNetworkSettingsPage/Model/**'
                   end
               end
               
               ssss.subspec 'BleWifiSettingsPage' do |sssss|
                   sssss.subspec 'Controller' do |ssssss|
                     ssssss.source_files = 'MKCommureApp/Classes/Functions/AddDeviceModules/Pages/BleWifiSettingsPage/Controller/**'
                     
                     ssssss.dependency 'MKCommureApp/Functions/AddDeviceModules/Pages/BleWifiSettingsPage/Model'
                   end
                   
                   sssss.subspec 'Model' do |ssssss|
                     ssssss.source_files = 'MKCommureApp/Classes/Functions/AddDeviceModules/Pages/BleWifiSettingsPage/Model/**'
                   end
               end
               
               ssss.subspec 'ConnectSuccessPage' do |sssss|
                   sssss.subspec 'Controller' do |ssssss|
                     ssssss.source_files = 'MKCommureApp/Classes/Functions/AddDeviceModules/Pages/ConnectSuccessPage/Controller/**'
                   end
               end
               
               ssss.subspec 'DeviceParamsListPage' do |sssss|
                 sssss.subspec 'Controller' do |ssssss|
                   ssssss.source_files = 'MKCommureApp/Classes/Functions/AddDeviceModules/Pages/DeviceParamsListPage/Controller/**'
                 
                   ssssss.dependency 'MKCommureApp/Functions/AddDeviceModules/Pages/BleDeviceInfoPage'
                   ssssss.dependency 'MKCommureApp/Functions/AddDeviceModules/Pages/BleNetworkSettingsPage'
                   ssssss.dependency 'MKCommureApp/Functions/AddDeviceModules/Pages/BleWifiSettingsPage'
                   ssssss.dependency 'MKCommureApp/Functions/AddDeviceModules/Pages/ConnectSuccessPage'
                   ssssss.dependency 'MKCommureApp/Functions/AddDeviceModules/Pages/NTPTimezonePage'
                   ssssss.dependency 'MKCommureApp/Functions/AddDeviceModules/Pages/ServerForDevice'
                 end
               end
               
               ssss.subspec 'NTPTimezonePage' do |sssss|
                 sssss.subspec 'Controller' do |ssssss|
                   ssssss.source_files = 'MKCommureApp/Classes/Functions/AddDeviceModules/Pages/NTPTimezonePage/Controller/**'
                   
                   ssssss.dependency 'MKCommureApp/Functions/AddDeviceModules/Pages/NTPTimezonePage/Model'
                 end
                 
                 sssss.subspec 'Model' do |ssssss|
                   ssssss.source_files = 'MKCommureApp/Classes/Functions/AddDeviceModules/Pages/NTPTimezonePage/Model/**'
                 end
               end
               
               ssss.subspec 'ServerForDevice' do |sssss|
                   sssss.subspec 'Controller' do |ssssss|
                     ssssss.source_files = 'MKCommureApp/Classes/Functions/AddDeviceModules/Pages/ServerForDevice/Controller/**'
                     
                     ssssss.dependency 'MKCommureApp/Functions/AddDeviceModules/Pages/ServerForDevice/Model'
                     ssssss.dependency 'MKCommureApp/Functions/AddDeviceModules/Pages/ServerForDevice/View'
                   end
                   
                   sssss.subspec 'Model' do |ssssss|
                     ssssss.source_files = 'MKCommureApp/Classes/Functions/AddDeviceModules/Pages/ServerForDevice/Model/**'
                   end
                   
                   sssss.subspec 'View' do |ssssss|
                     ssssss.source_files = 'MKCommureApp/Classes/Functions/AddDeviceModules/Pages/ServerForDevice/View/**'
                   end
               end
               
               ssss.dependency 'MKCommureApp/Functions/AddDeviceModules/ParamsModel'
               
           end
           
       end
       
       ss.subspec 'DeviceDataPage' do |sss|
           sss.subspec 'Controller' do |ssss|
             ssss.source_files = 'MKCommureApp/Classes/Functions/DeviceDataPage/Controller/**'
             
             ssss.dependency 'MKCommureApp/Functions/DeviceDataPage/View'
             
             ssss.dependency 'MKCommureApp/Functions/SettingPages'
             ssss.dependency 'MKCommureApp/Functions/FilterPages/UploadOptionPage'
             ssss.dependency 'MKCommureApp/Functions/ManageBleModules'
           end
           
           sss.subspec 'View' do |ssss|
             ssss.source_files = 'MKCommureApp/Classes/Functions/DeviceDataPage/View/**'
           end
       end
       
       ss.subspec 'DeviceListPage' do |sss|
           sss.subspec 'Controller' do |ssss|
             ssss.source_files = 'MKCommureApp/Classes/Functions/DeviceListPage/Controller/**'
             
             ssss.dependency 'MKCommureApp/Functions/DeviceListPage/View'
             ssss.dependency 'MKCommureApp/Functions/DeviceListPage/Model'
             
             ssss.dependency 'MKCommureApp/Functions/ServerForApp'
             ssss.dependency 'MKCommureApp/Functions/ScanPage'
             ssss.dependency 'MKCommureApp/Functions/DeviceDataPage'
             ssss.dependency 'MKCommureApp/Functions/AboutPage'
             ssss.dependency 'MKCommureApp/Functions/BatchOtaPage'
             
           end
           
           sss.subspec 'Model' do |ssss|
             ssss.source_files = 'MKCommureApp/Classes/Functions/DeviceListPage/Model/**'
           end
           
           sss.subspec 'View' do |ssss|
             ssss.source_files = 'MKCommureApp/Classes/Functions/DeviceListPage/View/**'
             
             ssss.dependency 'MKCommureApp/Functions/DeviceListPage/Model'
           end
       end
       
       ss.subspec 'FilterPages' do |sss|
         
         sss.subspec 'FilterByMacPage' do |ssss|
           ssss.subspec 'Controller' do |sssss|
             sssss.source_files = 'MKCommureApp/Classes/Functions/FilterPages/FilterByMacPage/Controller/**'
           
             sssss.dependency 'MKCommureApp/Functions/FilterPages/FilterByMacPage/Model'
             
           end
         
           ssss.subspec 'Model' do |sssss|
             sssss.source_files = 'MKCommureApp/Classes/Functions/FilterPages/FilterByMacPage/Model/**'
           end
         end
         
         sss.subspec 'FilterByTag' do |ssss|
           ssss.subspec 'Controller' do |sssss|
             sssss.source_files = 'MKCommureApp/Classes/Functions/FilterPages/FilterByTag/Controller/**'
           
             sssss.dependency 'MKCommureApp/Functions/FilterPages/FilterByTag/Model'
             
           end
         
           ssss.subspec 'Model' do |sssss|
             sssss.source_files = 'MKCommureApp/Classes/Functions/FilterPages/FilterByTag/Model/**'
           end
         end
         
         sss.subspec 'TimeOffsetPage' do |ssss|
           ssss.subspec 'Controller' do |sssss|
             sssss.source_files = 'MKCommureApp/Classes/Functions/FilterPages/TimeOffsetPage/Controller/**'
           
             sssss.dependency 'MKCommureApp/Functions/FilterPages/TimeOffsetPage/Model'
             
           end
         
           ssss.subspec 'Model' do |sssss|
             sssss.source_files = 'MKCommureApp/Classes/Functions/FilterPages/TimeOffsetPage/Model/**'
           end
         end
         
         sss.subspec 'DecryptionKeyPage' do |ssss|
           ssss.subspec 'Controller' do |sssss|
             sssss.source_files = 'MKCommureApp/Classes/Functions/FilterPages/DecryptionKeyPage/Controller/**'
           
             sssss.dependency 'MKCommureApp/Functions/FilterPages/DecryptionKeyPage/Model'
             
           end
         
           ssss.subspec 'Model' do |sssss|
             sssss.source_files = 'MKCommureApp/Classes/Functions/FilterPages/DecryptionKeyPage/Model/**'
           end
         end
         
         sss.subspec 'UploadOptionPage' do |ssss|
           ssss.subspec 'Controller' do |sssss|
             sssss.source_files = 'MKCommureApp/Classes/Functions/FilterPages/UploadOptionPage/Controller/**'
           
             sssss.dependency 'MKCommureApp/Functions/FilterPages/UploadOptionPage/Model'
             sssss.dependency 'MKCommureApp/Functions/FilterPages/UploadOptionPage/View'
             
             sssss.dependency 'MKCommureApp/Functions/FilterPages/FilterByMacPage'
             sssss.dependency 'MKCommureApp/Functions/FilterPages/FilterByTag'
             sssss.dependency 'MKCommureApp/Functions/FilterPages/TimeOffsetPage'
             sssss.dependency 'MKCommureApp/Functions/FilterPages/DecryptionKeyPage'
             
           end
         
           ssss.subspec 'Model' do |sssss|
             sssss.source_files = 'MKCommureApp/Classes/Functions/FilterPages/UploadOptionPage/Model/**'
           end
           
           ssss.subspec 'View' do |sssss|
             sssss.source_files = 'MKCommureApp/Classes/Functions/FilterPages/UploadOptionPage/View/**'
           end
           
         end
         
       end
       
       ss.subspec 'ManageBleModules' do |sss|
         
         sss.subspec 'AccelerometerPage' do |ssss|
             ssss.subspec 'Controller' do |sssss|
                 sssss.source_files = 'MKCommureApp/Classes/Functions/ManageBleModules/AccelerometerPage/Controller/**'
                 
                 sssss.dependency 'MKCommureApp/Functions/ManageBleModules/AccelerometerPage/Model'
                 
             end
             
             ssss.subspec 'Model' do |sssss|
                 sssss.source_files = 'MKCommureApp/Classes/Functions/ManageBleModules/AccelerometerPage/Model/**'
             end
             
         end
         
         sss.subspec 'AdvParamsConfigPage' do |ssss|
             ssss.subspec 'Controller' do |sssss|
                 sssss.source_files = 'MKCommureApp/Classes/Functions/ManageBleModules/AdvParamsConfigPage/Controller/**'
                 
                 sssss.dependency 'MKCommureApp/Functions/ManageBleModules/AdvParamsConfigPage/Model'
                 
             end
             
             ssss.subspec 'Model' do |sssss|
                 sssss.source_files = 'MKCommureApp/Classes/Functions/ManageBleModules/AdvParamsConfigPage/Model/**'
             end
             
         end
         
         sss.subspec 'BatteryTestPage' do |ssss|
             ssss.subspec 'Controller' do |sssss|
                 sssss.source_files = 'MKCommureApp/Classes/Functions/ManageBleModules/BatteryTestPage/Controller/**'
                 
                 sssss.dependency 'MKCommureApp/Functions/ManageBleModules/BatteryTestPage/Model'
                 
             end
             
             ssss.subspec 'Model' do |sssss|
                 sssss.source_files = 'MKCommureApp/Classes/Functions/ManageBleModules/BatteryTestPage/Model/**'
             end
             
         end
         
         sss.subspec 'BeaconOTAPage' do |ssss|
             ssss.subspec 'Controller' do |sssss|
                 sssss.source_files = 'MKCommureApp/Classes/Functions/ManageBleModules/BeaconOTAPage/Controller/**'
                 
                 sssss.dependency 'MKCommureApp/Functions/ManageBleModules/BeaconOTAPage/Model'
                 
             end
             
             ssss.subspec 'Model' do |sssss|
                 sssss.source_files = 'MKCommureApp/Classes/Functions/ManageBleModules/BeaconOTAPage/Model/**'
             end
             
         end
         
         sss.subspec 'ButtonLogPage' do |ssss|
             ssss.subspec 'Controller' do |sssss|
                 sssss.source_files = 'MKCommureApp/Classes/Functions/ManageBleModules/ButtonLogPage/Controller/**'
                 
                 sssss.dependency 'MKCommureApp/Functions/ManageBleModules/ButtonLogPage/View'
                 
             end
             
             ssss.subspec 'View' do |sssss|
                 sssss.source_files = 'MKCommureApp/Classes/Functions/ManageBleModules/ButtonLogPage/View/**'
             end
             
         end
         
         sss.subspec 'ConnectedPage' do |ssss|
             ssss.subspec 'Controller' do |sssss|
                 sssss.source_files = 'MKCommureApp/Classes/Functions/ManageBleModules/ConnectedPage/Controller/**'
                 
                 sssss.dependency 'MKCommureApp/Functions/ManageBleModules/ConnectedPage/View'
                 sssss.dependency 'MKCommureApp/Functions/ManageBleModules/ConnectedPage/Model'
                 
                 sssss.dependency 'MKCommureApp/Functions/ManageBleModules/BeaconOTAPage'
                 sssss.dependency 'MKCommureApp/Functions/ManageBleModules/SelfTestTriggerPage'
                 sssss.dependency 'MKCommureApp/Functions/ManageBleModules/SosTriggerPage'
                 sssss.dependency 'MKCommureApp/Functions/ManageBleModules/BatteryTestPage'
                 sssss.dependency 'MKCommureApp/Functions/ManageBleModules/AccelerometerPage'
                 sssss.dependency 'MKCommureApp/Functions/ManageBleModules/SleepModePage'
                 sssss.dependency 'MKCommureApp/Functions/ManageBleModules/AdvParamsConfigPage'
                 sssss.dependency 'MKCommureApp/Functions/ManageBleModules/ButtonLogPage'
                 
             end
             
             ssss.subspec 'Model' do |sssss|
                 sssss.source_files = 'MKCommureApp/Classes/Functions/ManageBleModules/ConnectedPage/Model/**'
             end
             
             ssss.subspec 'View' do |sssss|
                 sssss.source_files = 'MKCommureApp/Classes/Functions/ManageBleModules/ConnectedPage/View/**'
             end
         end
         
         sss.subspec 'ManageBleDevicesPage' do |ssss|
             ssss.subspec 'Controller' do |sssss|
                 sssss.source_files = 'MKCommureApp/Classes/Functions/ManageBleModules/ManageBleDevicesPage/Controller/**'
                 
                 sssss.dependency 'MKCommureApp/Functions/ManageBleModules/ManageBleDevicesPage/View'
                 
                 sssss.dependency 'MKCommureApp/Functions/ManageBleModules/ConnectedPage'
                 
             end
             
             ssss.subspec 'View' do |sssss|
                 sssss.source_files = 'MKCommureApp/Classes/Functions/ManageBleModules/ManageBleDevicesPage/View/**'
             end
         end
         
         sss.subspec 'SelfTestTriggerPage' do |ssss|
             ssss.subspec 'Controller' do |sssss|
                 sssss.source_files = 'MKCommureApp/Classes/Functions/ManageBleModules/SelfTestTriggerPage/Controller/**'
             end
         end
         
         sss.subspec 'SleepModePage' do |ssss|
             ssss.subspec 'Controller' do |sssss|
                 sssss.source_files = 'MKCommureApp/Classes/Functions/ManageBleModules/SleepModePage/Controller/**'
             end
         end
         
         sss.subspec 'SosTriggerPage' do |ssss|
             ssss.subspec 'Controller' do |sssss|
                 sssss.source_files = 'MKCommureApp/Classes/Functions/ManageBleModules/SosTriggerPage/Controller/**'
                 
                 sssss.dependency 'MKCommureApp/Functions/ManageBleModules/SosTriggerPage/View'
             end
             
             ssss.subspec 'View' do |sssss|
                 sssss.source_files = 'MKCommureApp/Classes/Functions/ManageBleModules/SosTriggerPage/View/**'
             end
         end
         
       end
       
       ss.subspec 'ScanPage' do |sss|
           sss.subspec 'Controller' do |ssss|
             ssss.source_files = 'MKCommureApp/Classes/Functions/ScanPage/Controller/**'
             
             ssss.dependency 'MKCommureApp/Functions/ScanPage/Model'
             ssss.dependency 'MKCommureApp/Functions/ScanPage/View'
             
             ssss.dependency 'MKCommureApp/Functions/AddDeviceModules'
             ssss.dependency 'MKCommureApp/Functions/ConfiguredGatewayPage/Controller'
           end
           
           sss.subspec 'Model' do |ssss|
             ssss.source_files = 'MKCommureApp/Classes/Functions/ScanPage/Model/**'
           end
           
           sss.subspec 'View' do |ssss|
             ssss.source_files = 'MKCommureApp/Classes/Functions/ScanPage/View/**'
             
             ssss.dependency 'MKCommureApp/Functions/ScanPage/Model'
           end
       end
       
       ss.subspec 'QRCodePage' do |sss|
           sss.subspec 'Controller' do |ssss|
             ssss.source_files = 'MKCommureApp/Classes/Functions/QRCodePage/Controller/**'
             
             ssss.dependency 'MKCommureApp/Functions/QRCodePage/View'
           end
           
           sss.subspec 'View' do |ssss|
             ssss.source_files = 'MKCommureApp/Classes/Functions/QRCodePage/View/**'
           end
       end
       
       ss.subspec 'ServerForApp' do |sss|
           sss.subspec 'Controller' do |ssss|
             ssss.source_files = 'MKCommureApp/Classes/Functions/ServerForApp/Controller/**'
             
             ssss.dependency 'MKCommureApp/Functions/ServerForApp/Model'
             ssss.dependency 'MKCommureApp/Functions/ServerForApp/View'
           end
           
           sss.subspec 'Model' do |ssss|
             ssss.source_files = 'MKCommureApp/Classes/Functions/ServerForApp/Model/**'
           end
           
           sss.subspec 'View' do |ssss|
             ssss.source_files = 'MKCommureApp/Classes/Functions/ServerForApp/View/**'
           end
       end
       
       ss.subspec 'SettingPages' do |sss|
         
         sss.subspec 'BatchDfuBeaconPage' do |ssss|
             ssss.subspec 'Controller' do |sssss|
                 sssss.source_files = 'MKCommureApp/Classes/Functions/SettingPages/BatchDfuBeaconPage/Controller/**'
                 sssss.dependency 'MKCommureApp/Functions/SettingPages/BatchDfuBeaconPage/Model'
                 sssss.dependency 'MKCommureApp/Functions/SettingPages/BatchDfuBeaconPage/View'
             end
             ssss.subspec 'View' do |sssss|
                 sssss.source_files = 'MKCommureApp/Classes/Functions/SettingPages/BatchDfuBeaconPage/View/**'
             end
             ssss.subspec 'Model' do |sssss|
                 sssss.source_files = 'MKCommureApp/Classes/Functions/SettingPages/BatchDfuBeaconPage/Model/**'
             end
         end
         
         sss.subspec 'BatchUpdateKeyPage' do |ssss|
             ssss.subspec 'Controller' do |sssss|
                 sssss.source_files = 'MKCommureApp/Classes/Functions/SettingPages/BatchUpdateKeyPage/Controller/**'
                 sssss.dependency 'MKCommureApp/Functions/SettingPages/BatchUpdateKeyPage/Model'
                 sssss.dependency 'MKCommureApp/Functions/SettingPages/BatchUpdateKeyPage/View'
             end
             ssss.subspec 'View' do |sssss|
                 sssss.source_files = 'MKCommureApp/Classes/Functions/SettingPages/BatchUpdateKeyPage/View/**'
             end
             ssss.subspec 'Model' do |sssss|
                 sssss.source_files = 'MKCommureApp/Classes/Functions/SettingPages/BatchUpdateKeyPage/Model/**'
             end
         end
         
           sss.subspec 'DeviceInfoPage' do |ssss|
               ssss.subspec 'Controller' do |sssss|
                   sssss.source_files = 'MKCommureApp/Classes/Functions/SettingPages/DeviceInfoPage/Controller/**'
                   sssss.dependency 'MKCommureApp/Functions/SettingPages/DeviceInfoPage/Model'
               end
               ssss.subspec 'Model' do |sssss|
                   sssss.source_files = 'MKCommureApp/Classes/Functions/SettingPages/DeviceInfoPage/Model/**'
               end
           end
           
           sss.subspec 'ModifyNetworkPages' do |ssss|
             
             ssss.subspec 'MqttNetworkSettingForGWT' do |sssss|
                 sssss.subspec 'Controller' do |ssssss|
                   ssssss.source_files = 'MKCommureApp/Classes/Functions/SettingPages/ModifyNetworkPages/MqttNetworkSettingForGWT/Controller/**'
                   
                   ssssss.dependency 'MKCommureApp/Functions/SettingPages/ModifyNetworkPages/MqttNetworkSettingForGWT/Model'
                 end
                 sssss.subspec 'Model' do |ssssss|
                   ssssss.source_files = 'MKCommureApp/Classes/Functions/SettingPages/ModifyNetworkPages/MqttNetworkSettingForGWT/Model/**'
                 end
             end
             
               ssss.subspec 'MqttNetworkSettingsPage' do |sssss|
                   sssss.subspec 'Controller' do |ssssss|
                     ssssss.source_files = 'MKCommureApp/Classes/Functions/SettingPages/ModifyNetworkPages/MqttNetworkSettingsPage/Controller/**'
                     
                     ssssss.dependency 'MKCommureApp/Functions/SettingPages/ModifyNetworkPages/MqttNetworkSettingsPage/Model'
                   end
                   sssss.subspec 'Model' do |ssssss|
                     ssssss.source_files = 'MKCommureApp/Classes/Functions/SettingPages/ModifyNetworkPages/MqttNetworkSettingsPage/Model/**'
                   end
               end
               
               ssss.subspec 'MqttParamsForGWT' do |sssss|
                   sssss.subspec 'Controller' do |ssssss|
                     ssssss.source_files = 'MKCommureApp/Classes/Functions/SettingPages/ModifyNetworkPages/MqttParamsForGWT/Controller/**'
                     
                     ssssss.dependency 'MKCommureApp/Functions/SettingPages/ModifyNetworkPages/MqttParamsForGWT/Model'
                   end
                   sssss.subspec 'Model' do |ssssss|
                     ssssss.source_files = 'MKCommureApp/Classes/Functions/SettingPages/ModifyNetworkPages/MqttParamsForGWT/Model/**'
                   end
               end
               
               ssss.subspec 'MqttParamsListPage' do |sssss|
                   sssss.subspec 'Controller' do |ssssss|
                     ssssss.source_files = 'MKCommureApp/Classes/Functions/SettingPages/ModifyNetworkPages/MqttParamsListPage/Controller/**'
                     
                     ssssss.dependency 'MKCommureApp/Functions/SettingPages/ModifyNetworkPages/MqttParamsListPage/Model'
                     
                     ssssss.dependency 'MKCommureApp/Functions/SettingPages/ModifyNetworkPages/MqttNetworkSettingsPage'
                     ssssss.dependency 'MKCommureApp/Functions/SettingPages/ModifyNetworkPages/MqttServerPage'
                     ssssss.dependency 'MKCommureApp/Functions/SettingPages/ModifyNetworkPages/MqttWifiSettingsPage'
                   end
                   
                   sssss.subspec 'Model' do |ssssss|
                     ssssss.source_files = 'MKCommureApp/Classes/Functions/SettingPages/ModifyNetworkPages/MqttParamsListPage/Model/**'
                   end
               end
               
               ssss.subspec 'MqttServerPage' do |sssss|
                   sssss.subspec 'Controller' do |ssssss|
                     ssssss.source_files = 'MKCommureApp/Classes/Functions/SettingPages/ModifyNetworkPages/MqttServerPage/Controller/**'
                     
                     ssssss.dependency 'MKCommureApp/Functions/SettingPages/ModifyNetworkPages/MqttServerPage/Model'
                     ssssss.dependency 'MKCommureApp/Functions/SettingPages/ModifyNetworkPages/MqttServerPage/View'
                   end
                   sssss.subspec 'Model' do |ssssss|
                     ssssss.source_files = 'MKCommureApp/Classes/Functions/SettingPages/ModifyNetworkPages/MqttServerPage/Model/**'
                   end
                   sssss.subspec 'View' do |ssssss|
                     ssssss.source_files = 'MKCommureApp/Classes/Functions/SettingPages/ModifyNetworkPages/MqttServerPage/View/**'
                   end
               end
               
               ssss.subspec 'MqttWifiSettingsPage' do |sssss|
                   sssss.subspec 'Controller' do |ssssss|
                     ssssss.source_files = 'MKCommureApp/Classes/Functions/SettingPages/ModifyNetworkPages/MqttWifiSettingsPage/Controller/**'
                     
                     ssssss.dependency 'MKCommureApp/Functions/SettingPages/ModifyNetworkPages/MqttWifiSettingsPage/Model'
                   end
                   sssss.subspec 'Model' do |ssssss|
                     ssssss.source_files = 'MKCommureApp/Classes/Functions/SettingPages/ModifyNetworkPages/MqttWifiSettingsPage/Model/**'
                   end
               end
               
           end
           
           sss.subspec 'NormalSettings' do |ssss|
             
               ssss.subspec 'CommunicatePage' do |sssss|
                   sssss.subspec 'Controller'  do |ssssss|
                     ssssss.source_files = 'MKCommureApp/Classes/Functions/SettingPages/NormalSettings/CommunicatePage/Controller/**'
                     
                     ssssss.dependency 'MKCommureApp/Functions/SettingPages/NormalSettings/CommunicatePage/Model'
                   end
                   sssss.subspec 'Model'  do |ssssss|
                     ssssss.source_files = 'MKCommureApp/Classes/Functions/SettingPages/NormalSettings/CommunicatePage/Model/**'
                   end
               end
               
               ssss.subspec 'ConnectBeaconTimeout' do |sssss|
                   sssss.subspec 'Controller'  do |ssssss|
                     ssssss.source_files = 'MKCommureApp/Classes/Functions/SettingPages/NormalSettings/ConnectBeaconTimeout/Controller/**'
                     
                     ssssss.dependency 'MKCommureApp/Functions/SettingPages/NormalSettings/ConnectBeaconTimeout/Model'
                   end
                   sssss.subspec 'Model'  do |ssssss|
                     ssssss.source_files = 'MKCommureApp/Classes/Functions/SettingPages/NormalSettings/ConnectBeaconTimeout/Model/**'
                   end
               end
               
               ssss.subspec 'DataReportPage' do |sssss|
                   sssss.subspec 'Controller'  do |ssssss|
                     ssssss.source_files = 'MKCommureApp/Classes/Functions/SettingPages/NormalSettings/DataReportPage/Controller/**'
                     
                     ssssss.dependency 'MKCommureApp/Functions/SettingPages/NormalSettings/DataReportPage/Model'
                   end
                   sssss.subspec 'Model'  do |ssssss|
                     ssssss.source_files = 'MKCommureApp/Classes/Functions/SettingPages/NormalSettings/DataReportPage/Model/**'
                   end
               end
               
               ssss.subspec 'NetworkStatusPage' do |sssss|
                   sssss.subspec 'Controller'  do |ssssss|
                     ssssss.source_files = 'MKCommureApp/Classes/Functions/SettingPages/NormalSettings/NetworkStatusPage/Controller/**'
                     
                     ssssss.dependency 'MKCommureApp/Functions/SettingPages/NormalSettings/NetworkStatusPage/Model'
                   end
                   sssss.subspec 'Model'  do |ssssss|
                     ssssss.source_files = 'MKCommureApp/Classes/Functions/SettingPages/NormalSettings/NetworkStatusPage/Model/**'
                   end
               end
               
               ssss.subspec 'NTPServerPage' do |sssss|
                   sssss.subspec 'Controller'  do |ssssss|
                     ssssss.source_files = 'MKCommureApp/Classes/Functions/SettingPages/NormalSettings/NTPServerPage/Controller/**'
                     
                     ssssss.dependency 'MKCommureApp/Functions/SettingPages/NormalSettings/NTPServerPage/Model'
                   end
                   sssss.subspec 'Model'  do |ssssss|
                     ssssss.source_files = 'MKCommureApp/Classes/Functions/SettingPages/NormalSettings/NTPServerPage/Model/**'
                   end
               end
               
               ssss.subspec 'ResetByButtonPage' do |sssss|
                   sssss.subspec 'Controller'  do |ssssss|
                     ssssss.source_files = 'MKCommureApp/Classes/Functions/SettingPages/NormalSettings/ResetByButtonPage/Controller/**'
                     
                     ssssss.dependency 'MKCommureApp/Functions/SettingPages/NormalSettings/ResetByButtonPage/View'
                   end
                   sssss.subspec 'View'  do |ssssss|
                     ssssss.source_files = 'MKCommureApp/Classes/Functions/SettingPages/NormalSettings/ResetByButtonPage/View/**'
                   end
               end
               
               ssss.subspec 'SystemTimePage' do |sssss|
                   sssss.subspec 'Controller'  do |ssssss|
                     ssssss.source_files = 'MKCommureApp/Classes/Functions/SettingPages/NormalSettings/SystemTimePage/Controller/**'
                     
                     ssssss.dependency 'MKCommureApp/Functions/SettingPages/NormalSettings/SystemTimePage/View'
                     
                     ssssss.dependency 'MKCommureApp/Functions/SettingPages/NormalSettings/NTPServerPage'
                   end
                   sssss.subspec 'View'  do |ssssss|
                     ssssss.source_files = 'MKCommureApp/Classes/Functions/SettingPages/NormalSettings/SystemTimePage/View/**'
                   end
               end
               
           end
           
           sss.subspec 'OTAPage' do |ssss|
               ssss.subspec 'Controller' do |sssss|
                 sssss.source_files = 'MKCommureApp/Classes/Functions/SettingPages/OTAPage/Controller/**'
                 
                 sssss.dependency 'MKCommureApp/Functions/SettingPages/OTAPage/Model'
               end
               ssss.subspec 'Model' do |sssss|
                 sssss.source_files = 'MKCommureApp/Classes/Functions/SettingPages/OTAPage/Model/**'
               end
           end
           
           sss.subspec 'SettingPage' do |ssss|
               ssss.subspec 'Controller' do |sssss|
                 sssss.source_files = 'MKCommureApp/Classes/Functions/SettingPages/SettingPage/Controller/**'
                 
                 sssss.dependency 'MKCommureApp/Functions/SettingPages/SettingPage/Model'
                 
                 sssss.dependency 'MKCommureApp/Functions/SettingPages/DeviceInfoPage'
                 sssss.dependency 'MKCommureApp/Functions/SettingPages/ModifyNetworkPages'
                 sssss.dependency 'MKCommureApp/Functions/SettingPages/NormalSettings'
                 sssss.dependency 'MKCommureApp/Functions/SettingPages/OTAPage'
                 sssss.dependency 'MKCommureApp/Functions/SettingPages/BatchDfuBeaconPage'
                 sssss.dependency 'MKCommureApp/Functions/SettingPages/BatchUpdateKeyPage'
                 
               end
               ssss.subspec 'Model' do |sssss|
                 sssss.source_files = 'MKCommureApp/Classes/Functions/SettingPages/SettingPage/Model/**'
               end
           end
           
       end
       
       ss.dependency 'MKCommureApp/SDK'
       ss.dependency 'MKCommureApp/Expand'
       ss.dependency 'MKCommureApp/CTMediator'
       ss.dependency 'MKCommureApp/DeviceModel'
       ss.dependency 'MKCommureApp/CTMediator'
     
       ss.dependency 'MKBaseModuleLibrary'
       ss.dependency 'MKCustomUIModule'
       
       ss.dependency 'MLInputDodger'
       ss.dependency 'SGQRCode'
     end
   
end
