//
//  MHServeViewController.m
//  waterever
//
//  Created by qyyue on 2017/10/20.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHServeViewController.h"
#import "MHWebView.h"

@interface MHServeViewController ()<MHWebViewDelegate>
@property (nonatomic , strong) MHWebView *webView;
@end

@implementation MHServeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"人工客服";
    [self setupWebView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}

-(MHWebView *)webView{
    if(!_webView){
        CGFloat webViewX = 0;
        CGFloat webViewY = 0;
        CGFloat webViewW = [UIScreen mainScreen].bounds.size.width;
        CGFloat webViewH = [UIScreen mainScreen].bounds.size.height - 64;
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


-(void)keyboardWillShow{
    [self.webView.wkWebView evaluateJavaScript:@"document.body.scrollTop = document.body.scrollHeight;" completionHandler:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
