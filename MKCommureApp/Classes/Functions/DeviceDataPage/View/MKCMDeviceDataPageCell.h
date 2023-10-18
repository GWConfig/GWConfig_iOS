//
//  MKCMDeviceDataPageCell.h
//  MKCommureApp_Example
//
//  Created by aa on 2023/2/4.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCMDeviceDataPageCellModel : NSObject

@property (nonatomic, copy)NSString *msg;

- (CGFloat)fetchCellHeight;

@end

@interface MKCMDeviceDataPageCell : MKBaseCell

+ (MKCMDeviceDataPageCell *)initCellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong)MKCMDeviceDataPageCellModel *dataModel;

@end

NS_ASSUME_NONNULL_END
