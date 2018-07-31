//
//  MHLoadWebViewController.m
//  waterever
//
//  Created by qyyue on 2017/9/7.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHLoadWebViewController.h"
#import "MHWebView.h"
#import "MHNavViewController.h"
#import "UIBarButtonItem+MHEXTENSION.h"
#import "UIImage+MHEXTENSION.h"

@interface MHLoadWebViewController ()<MHWebViewDelegate>
@property (nonatomic , strong) MHWebView *webView;
@end

@implementation MHLoadWebViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id) self;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"news_btn_back_black" HighlightedImage:nil Target:self Action:@selector(back)];
    [self setupWebView];
}


- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)setModel:(MHFandomInfoModel *)model{
    _model = model;
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

// 添加webView，加载扫描过来的内容
- (void)setupWebView {
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.model.articleUrl]]];
}

-(NSArray<id<UIPreviewActionItem>> *)previewActionItems{
    UIPreviewAction *calcelAction = [UIPreviewAction actionWithTitle:@"取消" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {

    }];
    return  @[calcelAction];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
