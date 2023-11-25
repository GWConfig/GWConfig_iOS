//
//  MKCGDeviceListCell.h
//  CommureGateway_Example
//
//  Created by aa on 2023/2/7.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKCGDeviceListCellDelegate <NSObject>

/**
 删除
 
 @param index 所在index
 */
- (void)cg_cellDeleteButtonPressed:(NSInteger)index;

@end

@class MKCGDeviceListModel;
@interface MKCGDeviceListCell : MKBaseCell

@property (nonatomic, weak)id <MKCGDeviceListCellDelegate>delegate;

@property (nonatomic, strong)MKCGDeviceListModel *dataModel;

+ (MKCGDeviceListCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
