//
//  MKCHResetByButtonCell.h
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/2/13.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCHResetByButtonCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, assign)BOOL selected;

@end

@protocol MKCHResetByButtonCellDelegate <NSObject>

- (void)ch_resetByButtonCellAction:(NSInteger)index;

@end

@interface MKCHResetByButtonCell : MKBaseCell

@property (nonatomic, weak)id <MKCHResetByButtonCellDelegate>delegate;

@property (nonatomic, strong)MKCHResetByButtonCellModel *dataModel;

+ (MKCHResetByButtonCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
