//
//  MKCFFilterEditSectionHeaderView.h
//  CommureGWThree_Example
//
//  Created by aa on 2023/2/6..
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCFFilterEditSectionHeaderViewModel : NSObject

/// sectionHeader所在index
@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, strong)UIColor *contentColor;

@end

@protocol MKCFFilterEditSectionHeaderViewDelegate <NSObject>

/// 加号点击事件
/// @param index 所在index
- (void)mk_cf_filterEditSectionHeaderView_addButtonPressed:(NSInteger)index;

/// 减号点击事件
/// @param index 所在index
- (void)mk_cf_filterEditSectionHeaderView_subButtonPressed:(NSInteger)index;

@end

@interface MKCFFilterEditSectionHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong)MKCFFilterEditSectionHeaderViewModel *dataModel;

@property (nonatomic, weak)id <MKCFFilterEditSectionHeaderViewDelegate>delegate;

+ (MKCFFilterEditSectionHeaderView *)initHeaderViewWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
