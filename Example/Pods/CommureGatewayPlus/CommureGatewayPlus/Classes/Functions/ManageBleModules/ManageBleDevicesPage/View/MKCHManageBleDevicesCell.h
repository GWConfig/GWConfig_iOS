//
//  MKCHManageBleDevicesCell.h
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/2/8.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCHManageBleDevicesCellModel : NSObject

@property (nonatomic, copy)NSString *macAddress;

@property (nonatomic, copy)NSString *deviceName;

@property (nonatomic, assign)BOOL connectable;

@property (nonatomic, assign)NSInteger rssi;

/*
 0：ibeacon
 1：eddystone-uid
 2：eddystone-url
 3：eddystone-tlm
 4：bxp-devinfo
 5：bxp-acc
 6：bxp-th
 7：bxp-button
 8：bxp-tag
 9：pir
 10：other
 */
@property (nonatomic, assign)NSInteger typeCode;

@end

@protocol MKCHManageBleDevicesCellDelegate <NSObject>

/// 用户点击了链接按钮
/// @param macAddress 目标设备的mac地址
/// @param typeCode 目标设备的设备类型
/*
 typeCode:
 0：ibeacon
 1：eddystone-uid
 2：eddystone-url
 3：eddystone-tlm
 4：bxp-devinfo
 5：bxp-acc
 6：bxp-th
 7：bxp-button
 8：bxp-tag
 9：pir
 10：other
 */
- (void)ch_manageBleDevicesCellConnectButtonPressed:(NSString *)macAddress typeCode:(NSInteger)typeCode;

@end

@interface MKCHManageBleDevicesCell : MKBaseCell

@property (nonatomic, strong)MKCHManageBleDevicesCellModel *dataModel;

@property (nonatomic, weak)id <MKCHManageBleDevicesCellDelegate>delegate;

+ (MKCHManageBleDevicesCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
