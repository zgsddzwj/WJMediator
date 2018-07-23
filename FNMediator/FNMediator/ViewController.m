//
//  ViewController.m
//  FNMediator
//
//  Created by Adward on 2018/7/23.
//  Copyright © 2018年 FN. All rights reserved.
//

#import "ViewController.h"
#import "FNMediator.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"jump" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(jump) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor blackColor];
    btn.frame = CGRectMake(100, 100, 50, 50);
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setTitle:@"jump2new" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(jump2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    btn2.backgroundColor = [UIColor blackColor];
    btn2.frame = CGRectMake(100, 300, 150, 50);
}

- (void)jump
{
    _mediator_openVC(@"ViewController1", (@{@"vcTitle":@"t1",
                                            @"params":@{@"t1":@"this is vc1"}
                                            }));
    
    
}

- (void)jump2
{
    UIViewController *vc = [__mediator createVC:@"ViewController1" withParams:(@{@"vcTitle":@"t1",
                                                                                 @"params":@{@"t1":@"this is new vc1"}
                                                                                 })shouldCache:YES];
    
    [__mediator pushVC:vc animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
