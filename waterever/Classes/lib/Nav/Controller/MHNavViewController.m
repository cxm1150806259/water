//
//  MHNavViewController.m
//  SinaWeibo
//
//  Created by qyyue on 2016/12/7.
//  Copyright © 2016年 qyyue. All rights reserved.
//

#import "MHNavViewController.h"
#import "UIBarButtonItem+MHEXTENSION.h"
#import "UIImage+MHEXTENSION.h"


#define MHUIColorFromHex(s) [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s & 0xFF00) >> 8))/255.0 blue:((s & 0xFF))/255.0  alpha:1.0]
@interface MHNavViewController ()

@end

@implementation MHNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

+(void)initialize{
    //设置item属性
    UIBarButtonItem *item=[UIBarButtonItem appearance];
    
    //normal
    NSDictionary *itemAttribute=@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:13]};
    [item setTitleTextAttributes:itemAttribute forState:UIControlStateNormal];
    
    //highlighted
    NSDictionary *itemAttribute2=@{NSForegroundColorAttributeName:[UIColor orangeColor],NSFontAttributeName:[UIFont systemFontOfSize:13]};
    [item setTitleTextAttributes:itemAttribute2 forState:UIControlStateHighlighted];

    //disabled
    NSDictionary *itemAttribute3=@{NSForegroundColorAttributeName:[UIColor grayColor],NSFontAttributeName:[UIFont systemFontOfSize:13]};
    [item setTitleTextAttributes:itemAttribute3 forState:UIControlStateDisabled];
    
    //设置标题属性
    UINavigationBar *navBar = [UINavigationBar appearance];
    NSDictionary *titleAttribute=@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]};
    [navBar setTitleTextAttributes:titleAttribute];
    [navBar setBarTintColor:[UIColor whiteColor]];
    [navBar setBackgroundImage:[UIImage imageWithColor:MHUIColorFromHex(0x3e91ff)] forBarMetrics:UIBarMetricsDefault];
    [navBar setShadowImage:[[UIImage alloc] init]];
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [super pushViewController:viewController animated:animated];
    
//    NSLog(@"%@",self.navigationController.navigationBar.translucent?@"YES":@"NO");
    
    if (self.viewControllers.count>2){
        viewController.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithImage:@"h5_back_normal" HighlightedImage:@"h5_back_hightlight" Target:self Action:@selector(backView)];
        viewController.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"退出" style:UIBarButtonItemStylePlain target:self action:@selector(backToRoot)];
        [viewController.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    }else if(self.viewControllers.count>1){
        viewController.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithImage:@"h5_back_normal" HighlightedImage:@"h5_back_hightlight" Target:self Action:@selector(backView)];
    }
    
}

-(void)backView{
    [self popViewControllerAnimated:YES];
}

-(void)backToRoot{
    [self popToRootViewControllerAnimated:YES];
}
@end
