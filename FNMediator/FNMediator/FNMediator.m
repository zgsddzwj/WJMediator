//
//  FNMediator.m
//  FNMediator
//
//  Created by Adward on 2018/7/23.
//  Copyright © 2018年 FN. All rights reserved.
//

#import "FNMediator.h"

@interface FNMediator()

//TODO:add to cache
@property (nonatomic, strong) NSMutableDictionary *cachedTarget;

@end

@implementation FNMediator

+ (instancetype)sharedInstance
{
    static FNMediator *mediator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mediator = [FNMediator new];
    });
    return mediator;
}

#pragma mark - push & pop

-(UIViewController *)pushVCWithClassName:(NSString *)vcClassName params:(NSDictionary *)params animated:(BOOL)animated
{
    //创建当前类并加入属性
    UIViewController *ret = [self createVC:vcClassName withParams:params];
    
    [self pushVC:ret animated:animated];
    
    return (ret);
}

- (void)pushVC:(UIViewController *)vc animated:(BOOL)animated
{
    NSAssert([vc isKindOfClass:[UIViewController class]], @"vc is not VC");
    
    if ([vc isKindOfClass:[UIViewController class]])
    {
        //find NavigationController
        UINavigationController *navc = [self getCurrentNavC];
        
        if (navc)
        {
            if (navc.viewControllers.count)
            {
                vc.hidesBottomBarWhenPushed = YES;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [navc pushViewController:vc animated:animated];
            });
        }
    }
}

- (void)popToLastVCWithAnimated:(BOOL)animated
{
    UINavigationController *navc = [self getCurrentNavC];
    if (navc && navc.viewControllers.count>1)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [navc popViewControllerAnimated:animated];
        });
    }
}

- (void)popToRootVCWithAnimated:(BOOL)animated
{
    UINavigationController *navc = [self getCurrentNavC];
    if (navc && navc.viewControllers.count>1)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [navc popToRootViewControllerAnimated:animated];
        });
    }
}

- (void)popToVCAtIndex:(NSInteger)index animated:(BOOL)animated
{
    UINavigationController *navc = [self getCurrentNavC];
    
    NSAssert(navc && index>=0 && navc.viewControllers.count>1 && navc.viewControllers.count-1>index, @"can not pop!!!");
    
    //导航栈内一定要超过1个vc，否则不能pop
    //从导航栈顶跳到栈顶不成立，所以navc.viewControllers.count-1>index
    if (navc && index>=0 && navc.viewControllers.count>1 && navc.viewControllers.count-1>index)
    {
        UIViewController *obj = [navc.viewControllers objectAtIndex:index];
        
        NSAssert([obj isKindOfClass:[UIViewController class]], @"obj is not VC");
        
        if (obj)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [navc popToViewController:obj animated:animated];
            });
        }
    }
}

- (void)popToVCWithClassName:(NSString *)className animated:(BOOL)animated
{
    NSAssert([className isKindOfClass:[NSString class]] && className.length>0, @"className string error!");
    
    if ([className isKindOfClass:[NSString class]] && className.length>0)
    {
        NSString *name = [className stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        Class cls = NSClassFromString(name);
        
        if (cls && [cls isSubclassOfClass:[UIViewController class]])
        {
            UINavigationController *navc = [self getCurrentNavC];
            
            //导航栈内一定要超过1个vc，否则不能pop
            if (navc && navc.viewControllers.count>1)
            {
                NSArray *vcArr = navc.viewControllers;
                
                for (UIViewController *vcobj in vcArr) {
                    
                    if ([vcobj isMemberOfClass:[cls class]])
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [navc popToViewController:vcobj animated:animated];
                        });
                        return;
                    }
                }
            }
        }
    }
    
}

#pragma mark - present & dismiss

-(UIViewController *)presentVC:(NSString *)vcClassName params:(NSDictionary *)params animated:(BOOL)animated
{
    //创建当前类并加入属性
    UIViewController *ret = [self createVC:vcClassName withParams:params];
    
    [self presentVC:ret animated:animated completion:nil];
    
    return  ret;
}

-(void)presentVC:(UIViewController *)vc animated:(BOOL)animated completion:(void (^)(void))completion
{
    NSAssert([vc isKindOfClass:[UIViewController class]], @"vc is not VC");
    
    if ([vc isKindOfClass:[UIViewController class]]) {
        
        UIViewController *topVC = [self topVC];
        
        if (topVC) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [topVC presentViewController:vc animated:animated completion:completion];
            });
        }
    }
}

-(void)rootVCpresentVC:(UIViewController *)vc animated:(BOOL)animated completion:(void (^)(void))completion
{
    NSAssert([vc isKindOfClass:[UIViewController class]], @"vc is not VC");
    
    if ([vc isKindOfClass:[UIViewController class]]) {
        
        UIViewController *rootVC = [self rootVC];
        
        if (rootVC) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [rootVC presentViewController:vc animated:animated completion:completion];
            });
        }
    }
}

- (void)dismissVCAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    UIViewController *vc = [self getPresentingVC];
    if (vc)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [vc dismissViewControllerAnimated:animated completion:completion];
        });
    }
}

#pragma mark - create VC object

- (UIViewController *)createVC:(NSString *)className withParams:(NSDictionary *)params
{
    UIViewController *ret = nil;
    
    NSAssert(([className isKindOfClass:[NSString class]] && className.length>0), @"className string error!");
    
    if ([className isKindOfClass:[NSString class]] && className.length>0)
    {
        NSString *name = [className stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        Class cls = NSClassFromString(name);
        
        NSAssert((cls && [cls isSubclassOfClass:[UIViewController class]]), @"class is not ViewController");
        
        if (cls && [cls isSubclassOfClass:[UIViewController class]]) {
            
            // create viewController
            UIViewController *vc = [[cls alloc] init];
            
            // kvc set params;
            ret = [self object:vc kvc_setParams:params];
        }
    }
    return (ret);
}

- (UIViewController *)createVC:(NSString *)className withParams:(NSDictionary *)params shouldCache:(BOOL)shouldCacheTarget
{
    UIViewController *ret = nil;
    
    NSAssert(([className isKindOfClass:[NSString class]] && className.length>0), @"className string error!");
    
    if ([className isKindOfClass:[NSString class]] && className.length>0)
    {
        NSString *name = [className stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        id target = self.cachedTarget[name];
        
        if (target == nil) {
            Class cls = NSClassFromString(name);
            
            NSAssert((cls && [cls isSubclassOfClass:[UIViewController class]]), @"class is not ViewController");
            
            if (cls && [cls isSubclassOfClass:[UIViewController class]]) {
                
                // create viewController
                UIViewController *vc = [[cls alloc] init];
                if (shouldCacheTarget) {
                    [self.cachedTarget setObject:vc forKey:name];
                }
                // kvc set params;
                ret = [self object:vc kvc_setParams:params];
            }
        }else {
            return target;
        }
    }
    return (ret);
}

- (id)object:(id)object kvc_setParams:(NSDictionary *)params;
{
    if ([params isKindOfClass:[NSDictionary class]] && (params.count>0))
    {
        @try {
            [object setValuesForKeysWithDictionary:params];
        } @catch (NSException *exception) {
            NSAssert(nil, exception.description);
        } @finally {
        }
    }
    
    return object;
}

- (void)releaseCachedTargetWithTargetName:(NSString *)targetName
{
    NSString *name = [targetName stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *targetClassString = [NSString stringWithFormat:@"%@", name];
    [self.cachedTarget removeObjectForKey:targetClassString];
}

#pragma mark - get VC
-(UINavigationController *)getCurrentNavC
{
    UINavigationController *navc = [self topVC].navigationController;
    
    NSAssert([navc isKindOfClass:[UINavigationController class]], @"navc is not UINavigationController");
    
    return ([navc isKindOfClass:[UINavigationController class]] ? navc : nil);
}

-(UIViewController *)getPresentingVC
{
    UIViewController *ret = nil;
    UIViewController *topVC = [self topVC];
    if (topVC.presentingViewController) {
        ret = topVC.presentingViewController;
    }
    
    if (!ret) {
        
        if (topVC.navigationController) {
            UIViewController *tempVC  =  topVC.navigationController.presentingViewController;
            
            if (tempVC) {
                ret = tempVC;
            }
        }
    }
    
    NSAssert([ret isKindOfClass:[UINavigationController class]],nil);
    
    return ret;
}

- (UIViewController *)topVC
{
    UIViewController *ret = nil;
    UIViewController *vc = [self rootVC];
    while (vc) {
        ret = vc;
        if ([ret isKindOfClass:[UINavigationController class]])
        {
            vc = [(UINavigationController *)vc visibleViewController];
        } else if ([ret isKindOfClass:[UITabBarController class]])
        {
            vc = [(UITabBarController *)vc selectedViewController];
        } else
        {
            vc = [vc presentedViewController];
        }
    }
    
    NSAssert([ret isKindOfClass:[UIViewController class]],nil);
    
    return ([ret isKindOfClass:[UIViewController class]] ? ret : nil);
}

- (UIViewController *)rootVC
{
    UIViewController  *vc = [self mainWindow].rootViewController;
    
    NSAssert([vc isKindOfClass:[UIViewController class]],nil);
    
    return (vc);
}

- (UIWindow*)mainWindow
{
    UIWindow *window = nil;
    
    UIApplication *app  = [UIApplication sharedApplication];
    
    if ([app.delegate respondsToSelector:@selector(window)]) {
        window = [app.delegate window];
    }
    
    if (!window) {
        if ([app windows].count>0)
        {
            window = [[app windows] objectAtIndex:0];
        }
    }
    
    if (!window) {
        window = [UIApplication sharedApplication].keyWindow;
    }
    
    return window;
}

- (UITabBarController *)getCurrentTabVC
{
    UITabBarController *tab = (UITabBarController *)[self rootVC];
    
    NSAssert([tab isKindOfClass:[UITabBarController class]],nil);
    
    return ([tab isKindOfClass:[UITabBarController class]] ? tab : nil);
}

- (BOOL)currentTabVCSetToSelectIndex:(NSUInteger)selectIndex
{
    UITabBarController *tab = [self getCurrentTabVC];
    
    if (tab && tab.viewControllers.count>selectIndex)
    {
        tab.selectedIndex = selectIndex;
        return YES;
    }
    return NO;
}

#pragma mark - getters && setters

- (NSMutableDictionary *)cachedTarget
{
    if (!_cachedTarget) {
        _cachedTarget = [NSMutableDictionary new];
    }
    return _cachedTarget;
}

@end
