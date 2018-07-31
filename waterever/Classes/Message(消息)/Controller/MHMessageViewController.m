//
//  MHMessageViewController.m
//  waterever
//
//  Created by qyyue on 2017/8/24.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHMessageViewController.h"
#import "MHMessageTableViewCell.h"
#import "MHMessageTool.h"
#import "MHFeedbackViewController.h"
#import "MHMessagePreViewController.h"
#import "MHPopTool.h"
#import "UIView+MHEXTENSION.h"
#import "MHUserInfoTool.h"
#import "UIBarButtonItem+MHEXTENSION.h"
#import "MHMessageHeaderView.h"

@interface MHMessageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) NSMutableArray<MHMessageModel *> *msgArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIView *mhPopView;
@property(nonatomic,strong) MHMessagePreViewController *preVc;
@property (weak, nonatomic) IBOutlet UIView *nullView;
@property(nonatomic,strong)UIView *tempView;
- (IBAction)feedBackBtnClicked;
- (IBAction)contactUsBtnClicked;
@end

@implementation MHMessageViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id) self;
    if(self.pushType == 1){
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"news_btn_back_black" HighlightedImage:nil Target:self Action:@selector(back)];
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        
        NSDictionary *titleAttribute=@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:18]};
        [self.navigationController.navigationBar setTitleTextAttributes:titleAttribute];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MHUserInfoTool sharedMHUserInfoTool].hasNewMsg = NO;
    [MHUserInfoTool saveUserInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息中心";
    
    //添加推送监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNewPusher) name:@"MHNewNotification" object:nil];
}

//-(void)dismiss{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

-(UIView *)tempView{
    if(!_tempView){
        _tempView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 10)];
        _tempView.backgroundColor = [UIColor clearColor];
    }
    return _tempView;
}

-(NSMutableArray<MHMessageModel *> *)msgArray{
    if(!_msgArray){
        _msgArray = [MHMessageTool getMessageArry];
    }
    return _msgArray;
}

-(UIView *)mhPopView{
    if(!_mhPopView){
        _mhPopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 350)];
        _mhPopView.backgroundColor = [UIColor clearColor];
        _mhPopView.userInteractionEnabled=YES;
    }
    return _mhPopView;
}

-(MHMessagePreViewController *)preVc{
    if(!_preVc){
        _preVc = [[MHMessagePreViewController alloc]init];
        [_preVc.view layoutIfNeeded];
    }
    return _preVc;
}

-(void)getNewPusher{
    self.msgArray = [MHMessageTool getMessageArry];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    self.nullView.hidden = self.msgArray.count?YES:NO;
    return self.msgArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MHMessageTableViewCell *cell = [MHMessageTableViewCell cellWithTableView:tableView];
    MHMessageModel *model = [self.msgArray objectAtIndex:indexPath.section];
    cell.model = model;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //消息进入页未设计 暂时取消
    return;
    
    MHMessageModel *model = [self.msgArray objectAtIndex:indexPath.section];
    self.preVc.model = model;
    self.preVc.view.size = self.mhPopView.size;
    self.preVc.view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    [self.mhPopView addSubview:self.preVc.view];
    [MHPopTool sharedInstance].shadeBackgroundType = ShadeBackgroundTypeSolid;
    [MHPopTool sharedInstance].closeButtonType = ButtonPositionTypeRight;
    [[MHPopTool sharedInstance] showWithPresentView:self.mhPopView animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MHMessageModel *model = [self.msgArray objectAtIndex:indexPath.section];
    return model.cellHeight;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //先从数组拿到model再从数组删除
        MHMessageModel *model = [self.msgArray objectAtIndex:indexPath.section];
        [MHMessageTool deleteWithMsgId:model.msgId];
        [self.msgArray removeObjectAtIndex:indexPath.section];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return self.tempView;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MHMessageHeaderView *headerView = [[[NSBundle mainBundle]loadNibNamed:@"MHMessageHeaderView" owner:self options:nil]lastObject];
    MHMessageModel *model = [self.msgArray objectAtIndex:section];
    headerView.timeLabel.text = model.extras.date;
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (IBAction)feedBackBtnClicked {
    MHFeedbackViewController *vc = [[MHFeedbackViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)contactUsBtnClicked {
    UIWebView *webView = [[UIWebView alloc]init];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",[MHUserInfoTool sharedMHUserInfoTool].telePhone]]]];
    [self.view addSubview:webView];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
