//
//  MKCMFilterCell.h
//  MKCommureApp_Example
//
//  Created by aa on 2023/2/6.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCMFilterCellModel : NSObject

/// cell标识符
@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, assign)NSInteger dataListIndex;

@property (nonatomic, strong)NSArray <NSString *>*dataList;

@end

@protocol MKCMFilterCellDelegate <NSObject>

- (void)cm_filterValueChanged:(NSInteger)dataListIndex index:(NSInteger)index;

@end

@interface MKCMFilterCell : MKBaseCell

@property (nonatomic, strong)MKCMFilterCellModel *dataModel;

@property (nonatomic, weak)id <MKCMFilterCellDelegate>delegate;

+ (MKCMFilterCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
