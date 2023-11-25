//
//  MKCGDeviceConnectedButtonCell.h
//  CommureGateway_Example
//
//  Created by aa on 2023/4/21.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCGDeviceConnectedButtonCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, copy)NSString *valueMsg;

@property (nonatomic, assign)BOOL showButton;

@property (nonatomic, copy)NSString *buttonTitle;

@end

@protocol MKCGDeviceConnectedButtonCellDelegate <NSObject>

- (void)cg_deviceConnectedButtonCell_buttonPressed:(NSInteger)index;

@end

@interface MKCGDeviceConnectedButtonCell : MKBaseCell

@property (nonatomic, weak)id <MKCGDeviceConnectedButtonCellDelegate>delegate;

@property (nonatomic, strong)MKCGDeviceConnectedButtonCellModel *dataModel;

+ (MKCGDeviceConnectedButtonCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
