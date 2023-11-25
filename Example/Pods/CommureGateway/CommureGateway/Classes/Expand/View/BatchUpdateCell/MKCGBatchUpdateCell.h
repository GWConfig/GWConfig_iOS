//
//  MKCGBatchUpdateCell.h
//  CommureGateway_Example
//
//  Created by aa on 2023/10/19.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, mk_cg_batchUpdateStatus) {
    mk_cg_batchUpdateStatus_normal,
    mk_cg_batchUpdateStatus_upgrading,
    mk_cg_batchUpdateStatus_timeout,
    mk_cg_batchUpdateStatus_success,
    mk_cg_batchUpdateStatus_failed,
};

@interface MKCGBatchUpdateCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *macAddress;

@property (nonatomic, assign)mk_cg_batchUpdateStatus status;

@end

@protocol MKCGBatchUpdateCellDelegate <NSObject>

- (void)cg_batchUpdateCell_delete:(NSInteger)index;

- (void)cg_batchUpdateCell_retry:(NSInteger)index;

@end

@interface MKCGBatchUpdateCell : MKBaseCell

@property (nonatomic, strong)MKCGBatchUpdateCellModel *dataModel;

@property (nonatomic, weak)id <MKCGBatchUpdateCellDelegate>delegate;

+ (MKCGBatchUpdateCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
