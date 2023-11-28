//
//  MKCFDeviceListCell.h
//  CommureGWThree_Example
//
//  Created by aa on 2023/2/7.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKCFDeviceListCellDelegate <NSObject>

/**
 删除
 
 @param index 所在index
 */
- (void)cf_cellDeleteButtonPressed:(NSInteger)index;

@end

@class MKCFDeviceListModel;
@interface MKCFDeviceListCell : MKBaseCell

@property (nonatomic, weak)id <MKCFDeviceListCellDelegate>delegate;

@property (nonatomic, strong)MKCFDeviceListModel *dataModel;

+ (MKCFDeviceListCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
