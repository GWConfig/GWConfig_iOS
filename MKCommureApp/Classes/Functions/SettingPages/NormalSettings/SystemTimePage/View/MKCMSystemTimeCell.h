//
//  MKCMSystemTimeCell.h
//  MKCommureApp_Example
//
//  Created by aa on 2023/2/13.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCMSystemTimeCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, copy)NSString *buttonTitle;

@end

@protocol MKCMSystemTimeCellDelegate <NSObject>

- (void)cm_systemTimeButtonPressed:(NSInteger)index;

@end

@interface MKCMSystemTimeCell : MKBaseCell

@property (nonatomic, strong)MKCMSystemTimeCellModel *dataModel;

@property (nonatomic, weak)id <MKCMSystemTimeCellDelegate>delegate;

+ (MKCMSystemTimeCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
