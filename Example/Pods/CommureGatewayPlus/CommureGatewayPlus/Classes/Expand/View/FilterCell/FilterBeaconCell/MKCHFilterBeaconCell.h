//
//  MKCHFilterBeaconCell.h
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/2/7..
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCHFilterBeaconCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, copy)NSString *minValue;

@property (nonatomic, copy)NSString *maxValue;

@end

@protocol MKCHFilterBeaconCellDelegate <NSObject>

- (void)mk_ch_beaconMinValueChanged:(NSString *)value index:(NSInteger)index;

- (void)mk_ch_beaconMaxValueChanged:(NSString *)value index:(NSInteger)index;

@end

@interface MKCHFilterBeaconCell : MKBaseCell

@property (nonatomic, strong)MKCHFilterBeaconCellModel *dataModel;

@property (nonatomic, weak)id <MKCHFilterBeaconCellDelegate>delegate;

+ (MKCHFilterBeaconCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
