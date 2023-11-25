//
//  MKCGResetByButtonCell.h
//  CommureGateway_Example
//
//  Created by aa on 2023/2/13.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCGResetByButtonCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, assign)BOOL selected;

@end

@protocol MKCGResetByButtonCellDelegate <NSObject>

- (void)cg_resetByButtonCellAction:(NSInteger)index;

@end

@interface MKCGResetByButtonCell : MKBaseCell

@property (nonatomic, weak)id <MKCGResetByButtonCellDelegate>delegate;

@property (nonatomic, strong)MKCGResetByButtonCellModel *dataModel;

+ (MKCGResetByButtonCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
