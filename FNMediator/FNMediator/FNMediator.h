//
//  FNMediator.h
//  FNMediator
//
//  Created by Adward on 2018/7/23.
//  Copyright © 2018年 FN. All rights reserved.
//

#import <UIKit/UIKit.h>

#define __mediator [FNMediator sharedInstance]

/*********************push pop************************/

/**
 Using the macro definition quickly push a VC, traverse the navigation stack find current controller, use the push method of navigation controller, dictionaries can pass parameters, implementation principle is KVC dynamic assignment, and return to push the VC object (default animation)
 
 使用宏定义快速push一个VC，原理是遍历当前控制器的导航栈，使用导航控制器push方法，dict字典里面可以传参数，实现原理是KVC动态赋值，并返回push产生的VC对象（默认有动画）
 
 例如：//_mediator_openVC(@"OtherVC", @{@"titleStr":@"other"});
 
 @param className VC类名
 @param dict      VC所需的参数
 @return 返回VC对象
 */
#define _mediator_openVC(className, dict)               [__mediator pushVCWithClassName:className params:(dict) animated:YES];

#define _mediator_openVC2(className, dict)              [__mediator pushVCWithClassName:className params:(dict) animated:NO];


/**
 popToLastVCWithAnimated Animated
 返回到上一个VC（默认有动画）
 
 @return vc object
 */
#define _mediator_pop                   [__mediator popToLastVCWithAnimated:YES];
#define _mediator_pop2                  [__mediator popToLastVCWithAnimated:NO];

/*********************present dismiss************************/

/**
 Using the macro definition quickly present a VC, get current controller by traversing, dictionaries can pass parameters, implementation principle is KVC dynamic assignment, and return the VC object
 
 使用宏定义快速present一个VC，原理是遍历得到当前控制器，present 一个新的VC，dict字典里面可以传参数，实现原理是KVC动态赋值（默认有动画）
 
 例如：//SP_PRESENT_VC_BY_CLASSNAME(@"OtherVC", @{@"titleStr":@"other"});
 
 @param className VC类名
 @param dict      VC所需的参数
 
 @return 返回VC对象
 */
#define _mediator_presentVC(className, dict)               [__mediator presentVC:className params:(dict) animated:YES];

#define _mediator_presentVC2(className, dict)              [__mediator presentVC:className params:(dict) animated:NO];

/**
 dismissViewController Animated
 收回弹出的VC（默认有动画）
 
 @return vc object
 */
#define _mediator_dismiss              [__mediator dismissVCAnimated:YES completion:nil];

#define _mediator_dismiss2             [__mediator dismissVCAnimated:NO completion:nil];


/*********************Create VC Object************************/

/**
 创建一个VC，并使用KVC赋值
 
 @param className vc类名
 @param params 赋值参数
 @return 返回VC对象
 */
#define _mediator_createVC(className, dict)               [__mediator createVC:className withParams:(dict)];


@interface FNMediator : NSObject

+ (instancetype) sharedInstance;

#pragma mark - push & pop

/**
 创建VC并push到VC
 
 @param vcClassName 要创建VC的类名称
 @param params    传给VC的参数
 @param animated  是否动画
 @return VC对象
 */
- (UIViewController *)pushVCWithClassName:(NSString *)vcClassName params:(NSDictionary *)params animated:(BOOL)animated;

/**
 导航控制器push一个vc对象
 
 @param vc 实例化的vc对象
 @param animated  是否动画
 */
- (void)pushVC:(UIViewController *)vc animated:(BOOL)animated;

/**
 返回上一个VC
 */
- (void)popToLastVCWithAnimated:(BOOL)animated;

/**
 返回到导航器根视图控制器
 
 @param animated 是否动画
 */
- (void)popToRootVCWithAnimated:(BOOL)animated;

/**
 导航栈内返回指定位置的方法
 
 @param index    导航栈元素索引
 @param animated 有无动画
 */
- (void)popToVCAtIndex:(NSInteger)index animated:(BOOL)animated;

/**
 导航栈返回到指定输入的类名（带动画），如果一个导航栈里面有多个相同类的VC对象在里面则返回离根部最近的那个VC（导航栈里有相同类的实例对象通常不符合逻辑）
 
 @param className 类名
 @param animated  是否需要动画
 */
-(void)popToVCWithClassName:(NSString*)className animated:(BOOL)animated;

#pragma mark - present & dismiss

/**
 创建一个VC，并使用KVC赋值，然后弹出
 
 @param vcClassName vc类名
 @param params 赋值参数
 @param animated 是否动画
 @return 返回弹出的VC对象
 */
-(UIViewController *)presentVC:(NSString *)vcClassName params:(NSDictionary *)params animated:(BOOL)animated;

/**
 弹出一个VC对象
 
 @param vc ViewController对象
 @param animated 是否动画
 */
-(void)presentVC:(UIViewController *)vc animated:(BOOL)animated completion:(void (^)(void))completion;

/**
 从window.rootViewController弹出一个VC对象
 
 @param vc ViewController对象
 @param animated 是否动画
 */
-(void)rootVCpresentVC:(UIViewController *)vc animated:(BOOL)animated completion:(void (^)(void))completion;

/**
 收回弹出的VC
 */
- (void)dismissVCAnimated:(BOOL)animated completion:(void (^)(void))completion;

#pragma mark - create VC object

/**
 创建一个VC，并使用KVC赋值
 
 @param className vc类名
 @param params 赋值参数
 @return 返回VC对象
 */
- (UIViewController *)createVC:(NSString *)className withParams:(NSDictionary *)params;

/**
 创建一个VC，并使用KVC赋值
 
 @param className vc类名
 @param params 赋值参数
 @param shouldCacheTarget 是否需要缓存
 @return 返回VC对象
 */
- (UIViewController *)createVC:(NSString *)className withParams:(NSDictionary *)params shouldCache:(BOOL)shouldCacheTarget;

/**
 清空缓存里的对象

 @param targetName 对象名字
 */
- (void)releaseCachedTargetWithTargetName:(NSString *)targetName;


#pragma mark - get VC

/**
 Get the current navigation controller by  traversing
 遍历获得当前VC的导航控制器
 
 @return 导航控制器对象
 */
-(UINavigationController *)getCurrentNavC;

/**
 Get the current PresentingViewController by  traversing
 遍历获得弹出当前VC的父VC
 
 @return 导航控制器对象
 */
-(UIViewController *)getPresentingVC;


/**
 Get the current display controller object
 获得当前显示的控制器对象
 
 @return vc object
 */
- (UIViewController *)topVC;

/**
 获取根部的tabBarController
 
 @return tabBarController
 */
- (UITabBarController *)getCurrentTabVC;


/**
 Get rootViewController
 获取APP根视图控制器
 
 @return rootViewController
 */
- (UIViewController *)rootVC;

/**
 Get window
 获取APP主窗口
 
 @return 主窗口
 */
- (UIWindow*)mainWindow;

#pragma mark - TabBarViewController

/**
 设置根部tabBarController的selectIndex
 
 @param selectIndex 位置
 @return 设置是否成功
 */
- (BOOL)currentTabVCSetToSelectIndex:(NSUInteger)selectIndex;


@end
