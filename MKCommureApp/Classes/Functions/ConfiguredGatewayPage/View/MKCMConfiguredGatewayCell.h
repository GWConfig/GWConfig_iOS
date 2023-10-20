//
//  MKCMConfiguredGatewayCell.h
//  MKCommureApp_Example
//
//  Created by aa on 2023/10/18.
//  Copyright © 2023 lovexiaoxia. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCMConfiguredGatewayCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *macAddress;

@property (nonatomic, assign)BOOL added;

@end

@interface MKCMConfiguredGatewayCell : MKBaseCell

@property (nonatomic, strong)MKCMConfiguredGatewayCellModel *dataModel;

+ (MKCMConfiguredGatewayCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
