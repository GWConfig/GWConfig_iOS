//
//  MKCMResetByButtonCell.h
//  MKCommureApp_Example
//
//  Created by aa on 2023/2/13.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCMResetByButtonCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, assign)BOOL selected;

@end

@protocol MKCMResetByButtonCellDelegate <NSObject>

- (void)cm_resetByButtonCellAction:(NSInteger)index;

@end

@interface MKCMResetByButtonCell : MKBaseCell

@property (nonatomic, weak)id <MKCMResetByButtonCellDelegate>delegate;

@property (nonatomic, strong)MKCMResetByButtonCellModel *dataModel;

+ (MKCMResetByButtonCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
