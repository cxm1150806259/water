//
//  MHNewFeatureViewController.m
//  waterever
//
//  Created by qyyue on 2017/9/8.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHNewFeatureViewController.h"
#import "MHCommonHeader.h"
#import "MHNavViewController.h"
#import "MHLoginViewController.h"
#import <MaterialControls/MaterialControls.h>
#import "UIWindow+MHEXTENSION.h"

#define FEATURECOUNT 3

@interface MHNewFeatureViewController ()<UIScrollViewDelegate>
//@property(nonatomic,weak)UIPageControl *pageControl;
@end

@implementation MHNewFeatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addImageViews];
}


-(void)addImageViews{
    UIScrollView *scrollerView=[[UIScrollView alloc]init];
    scrollerView.frame=SCREENBOUNDS;
    scrollerView.contentSize=CGSizeMake(scrollerView.width*FEATURECOUNT, 0);
    scrollerView.pagingEnabled=YES;
    scrollerView.bounces=NO;
    scrollerView.showsHorizontalScrollIndicator=NO;
    scrollerView.delegate=self;
    [self.view addSubview:scrollerView];
    
    for(int i=0;i<FEATURECOUNT;i++){
        UIImageView *featureImageView=[[UIImageView alloc]init];
        featureImageView.frame=scrollerView.frame;
        featureImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"newfeature_app2_%d",i+1]];
        featureImageView.x=scrollerView.width*i;
        [scrollerView addSubview:featureImageView];
        
        if(FEATURECOUNT-1==i){
            UIButton *enterBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            enterBtn.clipsToBounds = YES;
            enterBtn.layer.cornerRadius = 18;
            [enterBtn setBackgroundImage:[UIImage imageNamed:@"newfeature_btn_frame"] forState:UIControlStateNormal];
            enterBtn.size=CGSizeMake(250, 35);
            enterBtn.centerX=self.view.centerX;
            enterBtn.y=self.view.height - 74 - 35;
            [enterBtn setTitleColor:MHUIColorFromHex(0x3e91ff) forState:UIControlStateNormal];
            [enterBtn setTitle:@"立即体验" forState:UIControlStateNormal];
            [enterBtn addTarget:self action:@selector(enterWaterever) forControlEvents:UIControlEventTouchUpInside];
            
            [featureImageView addSubview:enterBtn];
            featureImageView.userInteractionEnabled=YES;
        }
    }
    
//    UIPageControl *pageControl=[[UIPageControl alloc]init];
//    pageControl.numberOfPages=FEATURECOUNT;
//    pageControl.centerX=self.view.centerX;
//    pageControl.y=self.view.height-60;
//    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
//    pageControl.pageIndicatorTintColor = MHCOLOR(128, 128, 128, 1);
//
//    [self.self.view addSubview:pageControl];
//
//    self.pageControl=pageControl;
}
//
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    CGFloat contentOffX=scrollView.contentOffset.x;
//    NSInteger page=(contentOffX/scrollView.width*1.0)+0.5;
//    self.pageControl.currentPage=page;
//    self.pageControl.hidden = page == 2?YES:NO;
//
//}

-(void)enterWaterever{
//    KEYWINDOW.rootViewController=[[MHNavViewController alloc]initWithRootViewController:[[MHLoginViewController alloc]init]];
    [KEYWINDOW switchRootController];
}


@end
