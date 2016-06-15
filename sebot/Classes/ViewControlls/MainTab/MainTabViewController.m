//
//  MainTabViewController.m
//  sebot
//
//  Created by yulei on 16/6/15.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "MainTabViewController.h"
#import "AppDelegate.h"
#import "MydeviceViewcontroller.h"
#import "PersonCenterViewcontroller.h"
#import "FamilySpaceViewcontroller.h"

@interface MainTabViewController()
{
    
    AppDelegate * app;
    
}

@property (nonatomic, strong) UINavigationController* navFamilyVC;
//家庭圈
@property (nonatomic, strong) UINavigationController* navMyDeviceVC;
//我的设备
@property (strong, nonatomic) UINavigationController  *navPersonCenterVC;
//个人中心
@end

@implementation MainTabViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    app= (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [self setupSubviews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
}

- (void)setupSubviews
{
    
    self.tabBar.backgroundColor=[UIColor whiteColor];
    
    self.viewControllers = @[
                             self.navSquareVC,
                             self.navNearVC,
                             self.navEggVC
                             ];
    
    self.tabBar.layer.shadowColor = [UIColor blackColor].CGColor;
    self.tabBar.layer.shadowOffset = CGSizeMake(0, -1);
    self.tabBar.layer.shadowOpacity = 0.4;
    self.tabBar.layer.shadowRadius = 2;
    
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:GREEN_COLOR, UITextAttributeTextColor,
                                                       nil] forState:UIControlStateNormal];
    UIColor *titleHighlightedColor = [UIColor colorWithRed:237/255.0 green:92/255.0 blue:73/255.0 alpha:1];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       titleHighlightedColor, UITextAttributeTextColor,
                                                       nil] forState:UIControlStateSelected];
}

//家庭圈
- (UINavigationController *)navSquareVC{
    if (!_navFamilyVC) {
        
        FamilySpaceViewcontroller* vc = [[FamilySpaceViewcontroller alloc] init];
        

        vc.tabBarItem =
        [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"tabFamily", nil)
                                      image:[[UIImage imageNamed:@"tab_square_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                              selectedImage:[[UIImage imageNamed:@"tab_square_press"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        _navFamilyVC = [[UINavigationController alloc]initWithRootViewController:vc];
    }
    
    return _navFamilyVC;
}

//我的设备
- (UINavigationController *)navNearVC{
    if (!_navMyDeviceVC) {
        
        MydeviceViewcontroller* vc = [[MydeviceViewcontroller alloc] init];
        vc.tabBarItem =
        [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"tabDevice", nil)
                                      image:[[UIImage imageNamed:@"tab_near_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                              selectedImage:[[UIImage imageNamed:@"tab_near_press"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        _navMyDeviceVC = [[UINavigationController alloc]initWithRootViewController:vc];
    }
    
    return _navMyDeviceVC;
}

//个人中心
- (UINavigationController *)navEggVC{
    if (!_navPersonCenterVC) {
        
        PersonCenterViewcontroller* vc = [[PersonCenterViewcontroller alloc] init];
        
        vc.tabBarItem =
        [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"tabPerson", nil)
                                      image:[[UIImage imageNamed:@"tab_egg_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                              selectedImage:[[UIImage imageNamed:@"tab_egg_press"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        _navPersonCenterVC = [[UINavigationController alloc]initWithRootViewController:vc];
    }
    
    return _navPersonCenterVC;
}


- (void)pushViewController:(UIViewController*)viewController {
    
    if ([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
        
        viewController.hidesBottomBarWhenPushed = YES;
        
        [((UINavigationController*)self.selectedViewController) pushViewController:viewController animated:YES];
        
    }
    
}

@end
