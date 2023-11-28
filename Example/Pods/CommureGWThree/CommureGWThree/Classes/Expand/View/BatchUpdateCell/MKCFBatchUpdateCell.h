//
//  MKCFBatchUpdateCell.h
//  CommureGWThree_Example
//
//  Created by aa on 2023/10/19.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, mk_cf_batchUpdateStatus) {
    mk_cf_batchUpdateStatus_normal,
    mk_cf_batchUpdateStatus_upgrading,
    mk_cf_batchUpdateStatus_timeout,
    mk_cf_batchUpdateStatus_success,
    mk_cf_batchUpdateStatus_failed,
};

@interface MKCFBatchUpdateCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *macAddress;

@property (nonatomic, assign)mk_cf_batchUpdateStatus status;

@end

@protocol MKCFBatchUpdateCellDelegate <NSObject>

- (void)cf_batchUpdateCell_delete:(NSInteger)index;

- (void)cf_batchUpdateCell_retry:(NSInteger)index;

@end

@interface MKCFBatchUpdateCell : MKBaseCell

@property (nonatomic, strong)MKCFBatchUpdateCellModel *dataModel;

@property (nonatomic, weak)id <MKCFBatchUpdateCellDelegate>delegate;

+ (MKCFBatchUpdateCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
