//
//  MKCMBatchUpdateCell.h
//  MKCommureApp_Example
//
//  Created by aa on 2023/10/19.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, mk_cm_batchUpdateStatus) {
    mk_cm_batchUpdateStatus_normal,
    mk_cm_batchUpdateStatus_upgrading,
    mk_cm_batchUpdateStatus_timeout,
    mk_cm_batchUpdateStatus_success,
    mk_cm_batchUpdateStatus_failed,
};

@interface MKCMBatchUpdateCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *macAddress;

@property (nonatomic, assign)mk_cm_batchUpdateStatus status;

@end

@protocol MKCMBatchUpdateCellDelegate <NSObject>

- (void)cm_batchUpdateCell_delete:(NSInteger)index;

- (void)cm_batchUpdateCell_retry:(NSInteger)index;

@end

@interface MKCMBatchUpdateCell : MKBaseCell

@property (nonatomic, strong)MKCMBatchUpdateCellModel *dataModel;

@property (nonatomic, weak)id <MKCMBatchUpdateCellDelegate>delegate;

+ (MKCMBatchUpdateCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
