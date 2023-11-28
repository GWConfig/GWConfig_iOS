//
//  CTMediator+MKCommureAdd.m
//  MKCommureApp
//
//  Created by aa on 2023/11/24.
//

#import "CTMediator+MKCommureAdd.h"

#import "MKCommureMediatorKey.h"

@implementation CTMediator (MKCommureAdd)

- (UIViewController *)CTMediator_Commure_CG_DeviceListPage {
    return [self Action_Commure_ViewControllerWithTarget:kTarget_commure_CG_module
                                                  action:kAction_commure_CG_deviceListPage
                                                  params:@{}];
}

- (UIViewController *)CTMediator_Commure_GW3_DeviceListPage {
    return [self Action_Commure_ViewControllerWithTarget:kTarget_commure_GW3_module
                                                  action:kAction_commure_GW3_deviceListPage
                                                  params:@{}];
}

#pragma mark - private method
- (UIViewController *)Action_Commure_ViewControllerWithTarget:(NSString *)targetName
                                                       action:(NSString *)actionName
                                                       params:(NSDictionary *)params{
    UIViewController *viewController = [self performTarget:targetName
                                                    action:actionName
                                                    params:params
                                         shouldCacheTarget:NO];
    if ([viewController isKindOfClass:[UIViewController class]]) {
        // view controller 交付出去之后，可以由外界选择是push还是present
        return viewController;
    } else {
        // 这里处理异常场景，具体如何处理取决于产品
        return [[UIViewController alloc] init];
    }
}

@end
