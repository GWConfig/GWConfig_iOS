//
//  MKCHSosTriggerCell.h
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/4/22.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCHSosTriggerCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, assign)BOOL selected;

@end

@protocol MKCHSosTriggerCellDelegate <NSObject>

- (void)ch_sosTriggerCellAction:(NSInteger)index;

@end

@interface MKCHSosTriggerCell : MKBaseCell

@property (nonatomic, weak)id <MKCHSosTriggerCellDelegate>delegate;

@property (nonatomic, strong)MKCHSosTriggerCellModel *dataModel;

+ (MKCHSosTriggerCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
