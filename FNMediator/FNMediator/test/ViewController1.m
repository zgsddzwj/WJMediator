//
//  ViewController1.m
//  FNMediator
//
//  Created by Adward on 2018/7/23.
//  Copyright © 2018年 FN. All rights reserved.
//

#import "ViewController1.h"
#import "FNMediator.h"

@interface ViewController1 ()

@end

@implementation ViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor greenColor];
    NSLog(@"%@\nparams = %@",NSStringFromClass([self class]),self.params);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"jump" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(jump) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor blackColor];
    btn.frame = CGRectMake(100, 100, 50, 50);
}

- (void)jump
{
    _mediator_openVC(@"ViewController2", (@{@"vcTitle":@"t2",
                                            @"params":@{@"t2":@"this is vc2"}
                                            }));
    
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
