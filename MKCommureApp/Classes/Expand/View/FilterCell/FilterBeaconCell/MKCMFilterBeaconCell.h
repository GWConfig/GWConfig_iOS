//
//  MKCMFilterBeaconCell.h
//  MKCommureApp_Example
//
//  Created by aa on 2023/2/7..
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCMFilterBeaconCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, copy)NSString *minValue;

@property (nonatomic, copy)NSString *maxValue;

@end

@protocol MKCMFilterBeaconCellDelegate <NSObject>

- (void)mk_cm_beaconMinValueChanged:(NSString *)value index:(NSInteger)index;

- (void)mk_cm_beaconMaxValueChanged:(NSString *)value index:(NSInteger)index;

@end

@interface MKCMFilterBeaconCell : MKBaseCell

@property (nonatomic, strong)MKCMFilterBeaconCellModel *dataModel;

@property (nonatomic, weak)id <MKCMFilterBeaconCellDelegate>delegate;

+ (MKCMFilterBeaconCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
