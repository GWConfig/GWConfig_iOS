//
//  MKCGBleWifiSettingsCertCell.h
//  CommureGateway_Example
//
//  Created by aa on 2023/1/30.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCGBleWifiSettingsCertCellModel : NSObject

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *fileName;

@end

@protocol MKCGBleWifiSettingsCertCellDelegate <NSObject>

- (void)cg_bleWifiSettingsCertPressed:(NSInteger)index;

@end

@interface MKCGBleWifiSettingsCertCell : MKBaseCell

@property (nonatomic, strong)MKCGBleWifiSettingsCertCellModel *dataModel;

@property (nonatomic, weak)id <MKCGBleWifiSettingsCertCellDelegate>delegate;

+ (MKCGBleWifiSettingsCertCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
