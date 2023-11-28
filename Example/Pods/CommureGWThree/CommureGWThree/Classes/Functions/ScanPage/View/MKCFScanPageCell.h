//
//  MKCFScanPageCell.h
//  CommureGWThree_Example
//
//  Created by aa on 2023/2/7.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@class MKCFScanPageModel;
@interface MKCFScanPageCell : MKBaseCell

@property (nonatomic, strong)MKCFScanPageModel *dataModel;

+ (MKCFScanPageCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
