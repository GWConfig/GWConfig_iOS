//
//  MKCFBleWifiSettingsCertCell.h
//  CommureGWThree_Example
//
//  Created by aa on 2023/1/30.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCFBleWifiSettingsCertCellModel : NSObject

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *fileName;

@end

@protocol MKCFBleWifiSettingsCertCellDelegate <NSObject>

- (void)cf_bleWifiSettingsCertPressed:(NSInteger)index;

@end

@interface MKCFBleWifiSettingsCertCell : MKBaseCell

@property (nonatomic, strong)MKCFBleWifiSettingsCertCellModel *dataModel;

@property (nonatomic, weak)id <MKCFBleWifiSettingsCertCellDelegate>delegate;

+ (MKCFBleWifiSettingsCertCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
