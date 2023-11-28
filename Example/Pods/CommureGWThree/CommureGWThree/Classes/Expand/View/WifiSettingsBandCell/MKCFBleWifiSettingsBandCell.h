//
//  MKCFBleWifiSettingsBandCell.h
//  CommureGWThree_Example
//
//  Created by aa on 2023/6/15.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCFBleWifiSettingsBandCellModel : NSObject

@property (nonatomic, assign)NSInteger country;

@end

@protocol MKCFBleWifiSettingsBandCellDelegate <NSObject>

- (void)cf_bleWifiSettingsBandCell_countryChanged:(NSInteger)country;

@end

@interface MKCFBleWifiSettingsBandCell : MKBaseCell

@property (nonatomic, strong)MKCFBleWifiSettingsBandCellModel *dataModel;

@property (nonatomic, weak)id <MKCFBleWifiSettingsBandCellDelegate>delegate;

+ (MKCFBleWifiSettingsBandCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
