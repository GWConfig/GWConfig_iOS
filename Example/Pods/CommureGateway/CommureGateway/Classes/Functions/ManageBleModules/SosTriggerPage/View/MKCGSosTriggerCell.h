//
//  MKCGSosTriggerCell.h
//  CommureGateway_Example
//
//  Created by aa on 2023/4/22.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCGSosTriggerCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, assign)BOOL selected;

@end

@protocol MKCGSosTriggerCellDelegate <NSObject>

- (void)cg_sosTriggerCellAction:(NSInteger)index;

@end

@interface MKCGSosTriggerCell : MKBaseCell

@property (nonatomic, weak)id <MKCGSosTriggerCellDelegate>delegate;

@property (nonatomic, strong)MKCGSosTriggerCellModel *dataModel;

+ (MKCGSosTriggerCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
