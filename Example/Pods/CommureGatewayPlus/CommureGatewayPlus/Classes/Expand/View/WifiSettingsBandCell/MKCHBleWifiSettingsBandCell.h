//
//  MKCHBleWifiSettingsBandCell.h
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/6/15.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCHBleWifiSettingsBandCellModel : NSObject

@property (nonatomic, assign)NSInteger country;

@end

@protocol MKCHBleWifiSettingsBandCellDelegate <NSObject>

- (void)ch_bleWifiSettingsBandCell_countryChanged:(NSInteger)country;

@end

@interface MKCHBleWifiSettingsBandCell : MKBaseCell

@property (nonatomic, strong)MKCHBleWifiSettingsBandCellModel *dataModel;

@property (nonatomic, weak)id <MKCHBleWifiSettingsBandCellDelegate>delegate;

+ (MKCHBleWifiSettingsBandCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
