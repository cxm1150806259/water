//
//  MHSeeProtocolViewController.m
//  1
//
//  Created by qyyue on 2017/9/9.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHSeeProtocolViewController.h"
#import "MHWebView.h"

@interface MHSeeProtocolViewController ()<MHWebViewDelegate>
@property (nonatomic , strong) MHWebView *webView;

@end

@implementation MHSeeProtocolViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id) self;
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


@end
