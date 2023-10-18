//
//  MKCMBatchUpdateKeyCell.h
//  MKCommureApp_Example
//
//  Created by aa on 2023/4/21.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, mk_cm_batchUpdateKeyStatus) {
    mk_cm_batchUpdateKeyStatus_normal,
    mk_cm_batchUpdateKeyStatus_upgrading,
    mk_cm_batchUpdateKeyStatus_success,
    mk_cm_batchUpdateKeyStatus_failed,
};

@interface MKCMBatchUpdateKeyCellModel : NSObject

@property (nonatomic, copy)NSString *macAddress;

@property (nonatomic, copy)NSString *password;

@property (nonatomic, assign)mk_cm_batchUpdateKeyStatus status;

@end

@interface MKCMBatchUpdateKeyCell : MKBaseCell

@property (nonatomic, strong)MKCMBatchUpdateKeyCellModel *dataModel;

+ (MKCMBatchUpdateKeyCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
