//
//  MKCHBatchUpdateCell.h
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/10/19.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, mk_ch_batchUpdateStatus) {
    mk_ch_batchUpdateStatus_normal,
    mk_ch_batchUpdateStatus_upgrading,
    mk_ch_batchUpdateStatus_timeout,
    mk_ch_batchUpdateStatus_success,
    mk_ch_batchUpdateStatus_failed,
};

@interface MKCHBatchUpdateCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *macAddress;

@property (nonatomic, assign)mk_ch_batchUpdateStatus status;

@end

@protocol MKCHBatchUpdateCellDelegate <NSObject>

- (void)ch_batchUpdateCell_delete:(NSInteger)index;

- (void)ch_batchUpdateCell_retry:(NSInteger)index;

@end

@interface MKCHBatchUpdateCell : MKBaseCell

@property (nonatomic, strong)MKCHBatchUpdateCellModel *dataModel;

@property (nonatomic, weak)id <MKCHBatchUpdateCellDelegate>delegate;

+ (MKCHBatchUpdateCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
