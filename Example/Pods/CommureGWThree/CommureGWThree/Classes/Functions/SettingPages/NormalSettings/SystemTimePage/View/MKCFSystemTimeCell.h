//
//  MKCFSystemTimeCell.h
//  CommureGWThree_Example
//
//  Created by aa on 2023/2/13.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCFSystemTimeCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, copy)NSString *buttonTitle;

@end

@protocol MKCFSystemTimeCellDelegate <NSObject>

- (void)cf_systemTimeButtonPressed:(NSInteger)index;

@end

@interface MKCFSystemTimeCell : MKBaseCell

@property (nonatomic, strong)MKCFSystemTimeCellModel *dataModel;

@property (nonatomic, weak)id <MKCFSystemTimeCellDelegate>delegate;

+ (MKCFSystemTimeCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
