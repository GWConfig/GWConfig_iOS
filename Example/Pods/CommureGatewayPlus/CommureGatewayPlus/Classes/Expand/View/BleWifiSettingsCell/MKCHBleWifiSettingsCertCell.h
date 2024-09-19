//
//  MKCHBleWifiSettingsCertCell.h
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/1/30.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCHBleWifiSettingsCertCellModel : NSObject

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *fileName;

@end

@protocol MKCHBleWifiSettingsCertCellDelegate <NSObject>

- (void)ch_bleWifiSettingsCertPressed:(NSInteger)index;

@end

@interface MKCHBleWifiSettingsCertCell : MKBaseCell

@property (nonatomic, strong)MKCHBleWifiSettingsCertCellModel *dataModel;

@property (nonatomic, weak)id <MKCHBleWifiSettingsCertCellDelegate>delegate;

+ (MKCHBleWifiSettingsCertCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
