//
//  MHGuidanceViewController.m
//  waterever
//
//  Created by qyyue on 2017/10/11.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHGuidanceViewController.h"
#import "MHWebView.h"
#import "UIBarButtonItem+MHEXTENSION.h"

@interface MHGuidanceViewController ()<MHWebViewDelegate>
@property (nonatomic , strong) MHWebView *webView;
@end
@implementation MHGuidanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

-(MHWebView *)webView{
    if(!_webView){
        CGFloat webViewX = 0;
        CGFloat webViewY = 0;
        CGFloat webViewW = [UIScreen mainScreen].bounds.size.width;
        CGFloat webViewH = [UIScreen mainScreen].bounds.size.height;
        self.webView = [MHWebView webViewWithFrame:CGRectMake(webViewX, webViewY, webViewW, webViewH)];
        _webView.progressViewColor = [UIColor redColor];
        _webView.MHQRCodeDelegate = self;
        [self.view addSubview:_webView];
    }
    return _webView;
}

- (void)setupUI {
    self.title = @"用户指南";
    
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithImage:@"h5_back_normal" HighlightedImage:@"h5_back_hightlight" Target:self Action:@selector(backView)];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://japi.waterever.cn/waterever/"]];
    [self.webView loadRequest:request];
}

-(void)backView{
    if(self.webView.wkWebView.canGoBack){
        [self.webView.wkWebView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}




@end
