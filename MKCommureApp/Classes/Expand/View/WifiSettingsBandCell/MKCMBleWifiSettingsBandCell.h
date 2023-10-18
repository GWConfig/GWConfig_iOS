//
//  MKCMBleWifiSettingsBandCell.h
//  MKCommureApp_Example
//
//  Created by aa on 2023/6/15.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCMBleWifiSettingsBandCellModel : NSObject

@property (nonatomic, assign)NSInteger country;

@end

@protocol MKCMBleWifiSettingsBandCellDelegate <NSObject>

- (void)cm_bleWifiSettingsBandCell_countryChanged:(NSInteger)country;

@end

@interface MKCMBleWifiSettingsBandCell : MKBaseCell

@property (nonatomic, strong)MKCMBleWifiSettingsBandCellModel *dataModel;

@property (nonatomic, weak)id <MKCMBleWifiSettingsBandCellDelegate>delegate;

+ (MKCMBleWifiSettingsBandCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
