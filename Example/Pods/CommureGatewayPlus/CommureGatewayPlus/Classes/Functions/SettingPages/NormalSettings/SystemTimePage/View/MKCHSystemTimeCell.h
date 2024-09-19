//
//  MKCHSystemTimeCell.h
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/2/13.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCHSystemTimeCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, copy)NSString *buttonTitle;

@end

@protocol MKCHSystemTimeCellDelegate <NSObject>

- (void)ch_systemTimeButtonPressed:(NSInteger)index;

@end

@interface MKCHSystemTimeCell : MKBaseCell

@property (nonatomic, strong)MKCHSystemTimeCellModel *dataModel;

@property (nonatomic, weak)id <MKCHSystemTimeCellDelegate>delegate;

+ (MKCHSystemTimeCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
