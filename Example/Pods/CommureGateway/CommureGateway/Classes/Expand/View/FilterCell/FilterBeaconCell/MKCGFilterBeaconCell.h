//
//  MKCGFilterBeaconCell.h
//  CommureGateway_Example
//
//  Created by aa on 2023/2/7..
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCGFilterBeaconCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, copy)NSString *minValue;

@property (nonatomic, copy)NSString *maxValue;

@end

@protocol MKCGFilterBeaconCellDelegate <NSObject>

- (void)mk_cg_beaconMinValueChanged:(NSString *)value index:(NSInteger)index;

- (void)mk_cg_beaconMaxValueChanged:(NSString *)value index:(NSInteger)index;

@end

@interface MKCGFilterBeaconCell : MKBaseCell

@property (nonatomic, strong)MKCGFilterBeaconCellModel *dataModel;

@property (nonatomic, weak)id <MKCGFilterBeaconCellDelegate>delegate;

+ (MKCGFilterBeaconCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
