//
//  MKCMBatchUpdateKeyCell.h
//  MKCommureApp_Example
//
//  Created by aa on 2023/4/21.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCMBatchUpdateKeyCellModel : NSObject

@property (nonatomic, copy)NSString *macAddress;

@property (nonatomic, copy)NSString *password;

@end

@interface MKCMBatchUpdateKeyCell : MKBaseCell

@property (nonatomic, strong)MKCMBatchUpdateKeyCellModel *dataModel;

+ (MKCMBatchUpdateKeyCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
