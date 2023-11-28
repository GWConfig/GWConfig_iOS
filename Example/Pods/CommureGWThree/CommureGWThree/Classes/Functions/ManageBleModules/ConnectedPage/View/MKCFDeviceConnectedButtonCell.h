//
//  MKCFDeviceConnectedButtonCell.h
//  CommureGWThree_Example
//
//  Created by aa on 2023/4/21.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCFDeviceConnectedButtonCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, copy)NSString *valueMsg;

@property (nonatomic, assign)BOOL showButton;

@property (nonatomic, copy)NSString *buttonTitle;

@end

@protocol MKCFDeviceConnectedButtonCellDelegate <NSObject>

- (void)cf_deviceConnectedButtonCell_buttonPressed:(NSInteger)index;

@end

@interface MKCFDeviceConnectedButtonCell : MKBaseCell

@property (nonatomic, weak)id <MKCFDeviceConnectedButtonCellDelegate>delegate;

@property (nonatomic, strong)MKCFDeviceConnectedButtonCellModel *dataModel;

+ (MKCFDeviceConnectedButtonCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
