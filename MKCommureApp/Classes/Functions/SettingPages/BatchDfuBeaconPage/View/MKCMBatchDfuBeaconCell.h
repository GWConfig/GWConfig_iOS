//
//  MKCMBatchDfuBeaconCell.h
//  MKCommureApp_Example
//
//  Created by aa on 2023/4/21.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCMBatchDfuBeaconCellModel : NSObject

@property (nonatomic, copy)NSString *macAddress;

@property (nonatomic, copy)NSString *password;

@end

@interface MKCMBatchDfuBeaconCell : MKBaseCell

@property (nonatomic, strong)MKCMBatchDfuBeaconCellModel *dataModel;

+ (MKCMBatchDfuBeaconCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
