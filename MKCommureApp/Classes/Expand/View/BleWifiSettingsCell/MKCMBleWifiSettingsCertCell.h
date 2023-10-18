//
//  MKCMBleWifiSettingsCertCell.h
//  MKCommureApp_Example
//
//  Created by aa on 2023/1/30.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCMBleWifiSettingsCertCellModel : NSObject

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *fileName;

@end

@protocol MKCMBleWifiSettingsCertCellDelegate <NSObject>

- (void)cm_bleWifiSettingsCertPressed:(NSInteger)index;

@end

@interface MKCMBleWifiSettingsCertCell : MKBaseCell

@property (nonatomic, strong)MKCMBleWifiSettingsCertCellModel *dataModel;

@property (nonatomic, weak)id <MKCMBleWifiSettingsCertCellDelegate>delegate;

+ (MKCMBleWifiSettingsCertCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
