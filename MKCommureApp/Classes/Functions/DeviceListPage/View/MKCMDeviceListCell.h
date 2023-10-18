//
//  MKCMDeviceListCell.h
//  MKCommureApp_Example
//
//  Created by aa on 2023/2/7.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKCMDeviceListCellDelegate <NSObject>

/**
 删除
 
 @param index 所在index
 */
- (void)cm_cellDeleteButtonPressed:(NSInteger)index;

@end

@class MKCMDeviceListModel;
@interface MKCMDeviceListCell : MKBaseCell

@property (nonatomic, weak)id <MKCMDeviceListCellDelegate>delegate;

@property (nonatomic, strong)MKCMDeviceListModel *dataModel;

+ (MKCMDeviceListCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
