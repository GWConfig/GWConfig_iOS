//
//  MKCMDeviceConnectedButtonCell.h
//  MKCommureApp_Example
//
//  Created by aa on 2023/4/21.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCMDeviceConnectedButtonCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, copy)NSString *valueMsg;

@property (nonatomic, assign)BOOL showButton;

@property (nonatomic, copy)NSString *buttonTitle;

@end

@protocol MKCMDeviceConnectedButtonCellDelegate <NSObject>

- (void)cm_deviceConnectedButtonCell_buttonPressed:(NSInteger)index;

@end

@interface MKCMDeviceConnectedButtonCell : MKBaseCell

@property (nonatomic, weak)id <MKCMDeviceConnectedButtonCellDelegate>delegate;

@property (nonatomic, strong)MKCMDeviceConnectedButtonCellModel *dataModel;

+ (MKCMDeviceConnectedButtonCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
