//
//  MKCommureAboutCell.h
//  MKCommureApp
//
//  Created by aa on 2023/11/24.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCommureAboutCellModel : NSObject

@property (nonatomic, copy)NSString *typeMessage;

@property (nonatomic, copy)NSString *value;

@property (nonatomic, copy)NSString *iconName;

@property (nonatomic, assign)BOOL canAdit;

@end

@interface MKCommureAboutCell : MKBaseCell

@property (nonatomic, strong)MKCommureAboutCellModel *dataModel;

+ (MKCommureAboutCell *)initCellWithTableView:(UITableView *)table;

@end

NS_ASSUME_NONNULL_END
