//
//  MHLoadActivityWebViewController.m
//  waterever
//
//  Created by qyyue on 2017/11/30.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHLoadActivityWebViewController.h"
#import "MHWebView.h"
#import "UIImage+MHEXTENSION.h"
#import "UIBarButtonItem+MHEXTENSION.h"

@interface MHLoadActivityWebViewController ()<MHWebViewDelegate>
@property (nonatomic , strong) MHWebView *webView;
@end

@implementation MHLoadActivityWebViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id) self;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"news_btn_back_black" HighlightedImage:nil Target:self Action:@selector(back)];
    self.navigationItem.rightBarButtonItem = nil;
    NSDictionary *titleAttribute=@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:18]};
    [self.navigationController.navigationBar setTitleTextAttributes:titleAttribute];
    [self setupWebView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupWebView];
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

- (void)setupWebView {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
    [self.webView loadRequest:request];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
