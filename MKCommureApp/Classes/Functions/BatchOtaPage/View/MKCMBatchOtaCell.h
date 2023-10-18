//
//  MKCMBatchOtaCell.h
//  MKCommureApp_Example
//
//  Created by aa on 2023/7/7.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCMBatchOtaCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *macAddress;

@property (nonatomic, copy)NSString *status;

@end

@protocol MKCMBatchOtaCellDelegate <NSObject>

- (void)cm_batchOtaCell_delete:(NSInteger)index;

@end

@interface MKCMBatchOtaCell : MKBaseCell

@property (nonatomic, strong)MKCMBatchOtaCellModel *dataModel;

@property (nonatomic, weak)id <MKCMBatchOtaCellDelegate>delegate;

+ (MKCMBatchOtaCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
