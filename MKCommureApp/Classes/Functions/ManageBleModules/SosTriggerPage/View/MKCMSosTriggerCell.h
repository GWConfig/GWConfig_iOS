//
//  MKCMSosTriggerCell.h
//  MKCommureApp_Example
//
//  Created by aa on 2023/4/22.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCMSosTriggerCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, assign)BOOL selected;

@end

@protocol MKCMSosTriggerCellDelegate <NSObject>

- (void)cm_sosTriggerCellAction:(NSInteger)index;

@end

@interface MKCMSosTriggerCell : MKBaseCell

@property (nonatomic, weak)id <MKCMSosTriggerCellDelegate>delegate;

@property (nonatomic, strong)MKCMSosTriggerCellModel *dataModel;

+ (MKCMSosTriggerCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
