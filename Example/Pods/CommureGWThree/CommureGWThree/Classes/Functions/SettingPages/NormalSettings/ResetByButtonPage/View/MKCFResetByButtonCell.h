//
//  MKCFResetByButtonCell.h
//  CommureGWThree_Example
//
//  Created by aa on 2023/2/13.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCFResetByButtonCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, assign)BOOL selected;

@end

@protocol MKCFResetByButtonCellDelegate <NSObject>

- (void)cf_resetByButtonCellAction:(NSInteger)index;

@end

@interface MKCFResetByButtonCell : MKBaseCell

@property (nonatomic, weak)id <MKCFResetByButtonCellDelegate>delegate;

@property (nonatomic, strong)MKCFResetByButtonCellModel *dataModel;

+ (MKCFResetByButtonCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
