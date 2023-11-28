//
//  MKCFFilterBeaconCell.h
//  CommureGWThree_Example
//
//  Created by aa on 2023/2/7..
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCFFilterBeaconCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, copy)NSString *minValue;

@property (nonatomic, copy)NSString *maxValue;

@end

@protocol MKCFFilterBeaconCellDelegate <NSObject>

- (void)mk_cf_beaconMinValueChanged:(NSString *)value index:(NSInteger)index;

- (void)mk_cf_beaconMaxValueChanged:(NSString *)value index:(NSInteger)index;

@end

@interface MKCFFilterBeaconCell : MKBaseCell

@property (nonatomic, strong)MKCFFilterBeaconCellModel *dataModel;

@property (nonatomic, weak)id <MKCFFilterBeaconCellDelegate>delegate;

+ (MKCFFilterBeaconCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
