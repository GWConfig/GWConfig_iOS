//
//  MKCFConfiguredGatewayCell.h
//  CommureGWThree_Example
//
//  Created by aa on 2023/10/18.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCFConfiguredGatewayCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *macAddress;

@property (nonatomic, assign)BOOL added;

@end

@interface MKCFConfiguredGatewayCell : MKBaseCell

@property (nonatomic, strong)MKCFConfiguredGatewayCellModel *dataModel;

+ (MKCFConfiguredGatewayCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
