//
//  MHMessagePreViewController.m
//  waterever
//
//  Created by qyyue on 2017/9/5.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHMessagePreViewController.h"
#import "MHPopTool.h"

@interface MHMessagePreViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextVIew;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
- (IBAction)closeBtnClicked;

@end

@implementation MHMessagePreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)setModel:(MHMessageModel *)model{
    _model = model;
    self.contentTextVIew.text = model.content;
    self.dateLabel.text = model.extras.date;
    self.titleLabel.text = model.extras.title;
    self.iconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"msg_icon%@",model.extras.type]];
}

-(NSArray<id<UIPreviewActionItem>> *)previewActionItems{
    UIPreviewAction *calcelAction = [UIPreviewAction actionWithTitle:@"取消" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {

    }];
    return  @[calcelAction];
}

- (IBAction)closeBtnClicked {
    [[MHPopTool sharedInstance]close];
}
@end
