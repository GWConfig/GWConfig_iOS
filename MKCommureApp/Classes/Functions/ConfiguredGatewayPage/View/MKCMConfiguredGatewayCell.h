//
//  MKCMConfiguredGatewayCell.h
//  MKCommureApp_Example
//
//  Created by aa on 2023/7/7.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCMConfiguredGatewayCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *macAddress;

@property (nonatomic, copy)NSString *status;

@end

@protocol MKCMConfiguredGatewayCellDelegate <NSObject>

- (void)cm_ConfiguredGatewayCell_delete:(NSInteger)index;

@end

@interface MKCMConfiguredGatewayCell : MKBaseCell

@property (nonatomic, strong)MKCMConfiguredGatewayCellModel *dataModel;

@property (nonatomic, weak)id <MKCMConfiguredGatewayCellDelegate>delegate;

+ (MKCMConfiguredGatewayCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
