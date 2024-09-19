//
//  MKCHDeviceListCell.h
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/2/7.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKCHDeviceListCellDelegate <NSObject>

/**
 删除
 
 @param index 所在index
 */
- (void)ch_cellDeleteButtonPressed:(NSInteger)index;

@end

@class MKCHDeviceListModel;
@interface MKCHDeviceListCell : MKBaseCell

@property (nonatomic, weak)id <MKCHDeviceListCellDelegate>delegate;

@property (nonatomic, strong)MKCHDeviceListModel *dataModel;

+ (MKCHDeviceListCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
