//
//  MKCGSystemTimeCell.h
//  CommureGateway_Example
//
//  Created by aa on 2023/2/13.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCGSystemTimeCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, copy)NSString *buttonTitle;

@end

@protocol MKCGSystemTimeCellDelegate <NSObject>

- (void)cg_systemTimeButtonPressed:(NSInteger)index;

@end

@interface MKCGSystemTimeCell : MKBaseCell

@property (nonatomic, strong)MKCGSystemTimeCellModel *dataModel;

@property (nonatomic, weak)id <MKCGSystemTimeCellDelegate>delegate;

+ (MKCGSystemTimeCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
