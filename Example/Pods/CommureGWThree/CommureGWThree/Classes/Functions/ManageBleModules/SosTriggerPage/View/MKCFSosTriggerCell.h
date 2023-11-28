//
//  MKCFSosTriggerCell.h
//  CommureGWThree_Example
//
//  Created by aa on 2023/4/22.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCFSosTriggerCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, assign)BOOL selected;

@end

@protocol MKCFSosTriggerCellDelegate <NSObject>

- (void)cf_sosTriggerCellAction:(NSInteger)index;

@end

@interface MKCFSosTriggerCell : MKBaseCell

@property (nonatomic, weak)id <MKCFSosTriggerCellDelegate>delegate;

@property (nonatomic, strong)MKCFSosTriggerCellModel *dataModel;

+ (MKCFSosTriggerCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
