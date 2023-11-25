//
//  MKCGBleWifiSettingsBandCell.h
//  CommureGateway_Example
//
//  Created by aa on 2023/6/15.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCGBleWifiSettingsBandCellModel : NSObject

@property (nonatomic, assign)NSInteger country;

@end

@protocol MKCGBleWifiSettingsBandCellDelegate <NSObject>

- (void)cg_bleWifiSettingsBandCell_countryChanged:(NSInteger)country;

@end

@interface MKCGBleWifiSettingsBandCell : MKBaseCell

@property (nonatomic, strong)MKCGBleWifiSettingsBandCellModel *dataModel;

@property (nonatomic, weak)id <MKCGBleWifiSettingsBandCellDelegate>delegate;

+ (MKCGBleWifiSettingsBandCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
