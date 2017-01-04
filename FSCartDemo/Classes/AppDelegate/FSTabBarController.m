//
//  FSTabBarController.m
//  FSCartDemo
//
//  Created by 如果思念是自己的 on 17/1/4.
//  Copyright © 2017年 如果思念是自己的. All rights reserved.
//

#import "FSTabBarController.h"
#import "FSHomeVC.h"
#import "FSFindVC.h"
#import "FSCartVC.h"
#import "FSMeVC.h"

#import "UIImage+ImageContentWithColor.h"

@interface FSTabBarController ()

@end

@implementation FSTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //创建4个视图控制器
    [self creatChildViewControllers];
    
    //设置tabbarItemTextAttributes中的颜色
    [self setTabBarItemTextAttributes];
    
    
    //设置tabbar背景图片
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"barBgImg"]];
    //navigationBar背景图片
    [[UINavigationBar appearance]setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:(UIBarMetricsDefault)];
    
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    
    //设置自定义tabbar
    //[self setCustomTabbar];
    // Do any additional setup after loading the view.
}


/**
 *  设置tabbarItem文本标题颜色
 */
- (void)setTabBarItemTextAttributes
{
    //设置普通状态下文本的颜色
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:44/255.0 green:44/255.0 blue:44/255.0 alpha:1];
    
    //设置选中状态下的文本颜色
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:20/255.0 green:107/255.0 blue:147/255.0 alpha:1];
    
    //配置文本属性（将上述设置的颜色添加上去）
    UITabBarItem *tabbarItem = [UITabBarItem appearance];
    [tabbarItem setTitleTextAttributes:normalAttrs forState:(UIControlStateNormal)];
    [tabbarItem setTitleTextAttributes:selectedAttrs forState:(UIControlStateSelected)];
}



/**
 *  添加子控制器，添加了4个视图控制器
 */
- (void)creatChildViewControllers
{
    // 首页
    [self addOneChildViewController:[[UINavigationController alloc] initWithRootViewController:[FSHomeVC new]] title:@"首页" normalImage:@"homeBarInselect" selectedImage:@"homeBarSelect"];
    // 发现
    [self addOneChildViewController:[[UINavigationController alloc] initWithRootViewController:[FSFindVC new]] title:@"发现" normalImage:@"findBarInselect" selectedImage:@"findBarSelect"];
    // 购物车
    [self addOneChildViewController:[[UINavigationController alloc] initWithRootViewController:[FSCartVC new]] title:@"购物车" normalImage:@"shopcatrBarInselect" selectedImage:@"shopcatrBarSelect"];
    // 我的
    [self addOneChildViewController:[[UINavigationController alloc] initWithRootViewController:[FSMeVC new]] title:@"我的" normalImage:@"meBarInselect" selectedImage:@"meBarSelect"];
}



/**
 *  给tabbarController添加一个子视图控制器
 *
 *  @param viewController 子控制器
 *  @param title          标题
 *  @param normalImage    正常状态下的图片
 *  @param selectedImage  选中状态下的图片
 */
- (void)addOneChildViewController:(UIViewController *)viewController title:(NSString *)title normalImage:(NSString *)normalImage selectedImage:(NSString *)selectedImage
{
    // tab标题
    viewController.tabBarItem.title = title;
    
    // tab未选中图片
    viewController.tabBarItem.image = [UIImage imageNamed:normalImage];
    
    // tab选中图片
    UIImage *image = [UIImage imageNamed:selectedImage];
    image = [image imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    viewController.tabBarItem.selectedImage = image;
    
    // 添加子控制器
    [self addChildViewController:viewController];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
