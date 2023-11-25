//
//  MKCGFilterCell.h
//  CommureGateway_Example
//
//  Created by aa on 2023/2/6.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCGFilterCellModel : NSObject

/// cell标识符
@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, assign)NSInteger dataListIndex;

@property (nonatomic, strong)NSArray <NSString *>*dataList;

@end

@protocol MKCGFilterCellDelegate <NSObject>

- (void)cg_filterValueChanged:(NSInteger)dataListIndex index:(NSInteger)index;

@end

@interface MKCGFilterCell : MKBaseCell

@property (nonatomic, strong)MKCGFilterCellModel *dataModel;

@property (nonatomic, weak)id <MKCGFilterCellDelegate>delegate;

+ (MKCGFilterCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
