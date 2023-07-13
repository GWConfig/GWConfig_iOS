//
//  MKCMBatchDfuBeaconCell.h
//  MKCommureApp_Example
//
//  Created by aa on 2023/4/21.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, mk_cm_batchDfuBeaconStatus) {
    mk_cm_batchDfuBeaconStatus_normal,
    mk_cm_batchDfuBeaconStatus_upgrading,
    mk_cm_batchDfuBeaconStatus_success,
    mk_cm_batchDfuBeaconStatus_failed,
};

@interface MKCMBatchDfuBeaconCellModel : NSObject

@property (nonatomic, copy)NSString *macAddress;

@property (nonatomic, copy)NSString *password;

@property (nonatomic, assign)mk_cm_batchDfuBeaconStatus status;

@end

@interface MKCMBatchDfuBeaconCell : MKBaseCell

@property (nonatomic, strong)MKCMBatchDfuBeaconCellModel *dataModel;

+ (MKCMBatchDfuBeaconCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
