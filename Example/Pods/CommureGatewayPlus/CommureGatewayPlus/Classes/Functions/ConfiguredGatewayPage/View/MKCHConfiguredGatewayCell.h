//
//  MKCHConfiguredGatewayCell.h
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/10/18.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCHConfiguredGatewayCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *macAddress;

@property (nonatomic, assign)BOOL added;

@end

@interface MKCHConfiguredGatewayCell : MKBaseCell

@property (nonatomic, strong)MKCHConfiguredGatewayCellModel *dataModel;

+ (MKCHConfiguredGatewayCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
