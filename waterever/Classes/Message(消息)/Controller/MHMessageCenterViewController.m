//
//  MHMessageCenterViewController.m
//  waterever
//
//  Created by qyyue on 2017/11/27.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHMessageCenterViewController.h"
#import "MHShareViewController.h"
#import "MHExchangeCouponsViewController.h"
#import "MHMessageCenterTableViewCell.h"
#import "MHMessageViewController.h"
#import "MHFandomViewController.h"
#import "MHActivityTableViewController.h"

//轮播
#import "NewPagedFlowView.h"
#import "MHNetWorkTool.h"
#import "MHCommonHeader.h"

#import "MHMessageCenterModel.h"
#import "MHMessageModel.h"
#import "MHMessageTool.h"

#import <SDWebImage/SDWebImageManager.h>
#import "MHLoadActivityWebViewController.h"

#import "JPUSHService.h"

#define Width [UIScreen mainScreen].bounds.size.width
#define MHUIColorFromHex(s) [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s & 0xFF00) >> 8))/255.0 blue:((s & 0xFF))/255.0  alpha:1.0]


@interface MHMessageCenterViewController ()<NewPagedFlowViewDelegate, NewPagedFlowViewDataSource, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *inviteFriendView;
@property (weak, nonatomic) IBOutlet UIView *exchangeCouponsView;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIView *topScrollView;
@property (nonatomic, strong) NSMutableArray *imageArray;//图片数组
@property (nonatomic, strong) NewPagedFlowView *pageFlowView;//轮播图
@property(nonatomic,strong) MHMessageCenterModel *messageCenterModel;
@property(nonatomic,strong) NSMutableArray<MHMessageModel *> *msgArray;
@end

@implementation MHMessageCenterViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"news_btn_back_black" HighlightedImage:nil Target:self Action:@selector(dismiss)];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    NSDictionary *titleAttribute=@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:18]};
    [self.navigationController.navigationBar setTitleTextAttributes:titleAttribute];
    
    [self loadData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
//    NSDictionary *titleAttribute=@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]};
//    [self.navigationController.navigationBar setTitleTextAttributes:titleAttribute];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:MHUIColorFromHex(0x3e91ff)] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

-(NSMutableArray<MHMessageModel *> *)msgArray{
    if(!_msgArray){
        _msgArray = [MHMessageTool getMessageArry];
    }
    return _msgArray;
}

-(void)initView{
    self.title = @"消息中心";
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self addGes];
}

-(NSString *)dateStringWithTimestamp:(NSString *)timestamp{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM月dd日"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]/ 1000.0];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

- (void)setupUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //设置消息
    MHMessageCenterTableViewCell *msgCell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    MHMessageModel *msgModel = [self.msgArray firstObject];
//    msgCell.titleLabel.text = msgModel.extras.title;
    msgCell.contentLabel.text = msgModel.content?msgModel.content:@"暂无消息";
    msgCell.timeLabel.text = msgModel.extras.date?msgModel.extras.date:@"";
    
    //设置活动
    MHMessageCenterTableViewCell *activityCell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
//    activityCell.titleLabel.text = self.messageCenterModel.activityLatest.title;
    activityCell.contentLabel.text = self.messageCenterModel.activityLatest.smallTitle?self.messageCenterModel.activityLatest.smallTitle:@"暂无活动";
    activityCell.timeLabel.text = self.messageCenterModel.activityLatest.dateCreated?[self dateStringWithTimestamp:self.messageCenterModel.activityLatest.dateCreated]:@"";
    
    //水粉圈
    MHMessageCenterTableViewCell *fandomCell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
//    fandomCell.titleLabel.text = self.messageCenterModel.articleLatest.title;
    fandomCell.contentLabel.text = self.messageCenterModel.articleLatest.smallTitle?self.messageCenterModel.articleLatest.smallTitle:@"暂无内容";
    fandomCell.timeLabel.text = self.messageCenterModel.articleLatest.dateCreated?[self dateStringWithTimestamp:self.messageCenterModel.articleLatest.dateCreated]:@"";
    
    for (int i=self.imageArray.count; i<self.messageCenterModel.activityPageList.count; i++) {
        MHActivityModel *model = [self.messageCenterModel.activityPageList objectAtIndex:i];
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:model.activityImageUrl] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            [self.imageArray addObject:image];
            if(self.imageArray.count == self.messageCenterModel.activityPageList.count){
                [self initTopScrollView];
            }
        }];
    }
    
    [self.tableview reloadData];
}

-(void)initTopScrollView{
    NewPagedFlowView *pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, 0, Width, 131)];
    pageFlowView.backgroundColor = [UIColor clearColor];
    pageFlowView.delegate = self;
    pageFlowView.dataSource = self;
    pageFlowView.autoTime = 3;
    pageFlowView.minimumPageAlpha = 0.4;
    pageFlowView.isCarousel = YES;
    pageFlowView.orientation = NewPagedFlowViewOrientationHorizontal;
    pageFlowView.isOpenAutoScroll = YES;
    pageFlowView.orginPageCount = self.imageArray.count;
    
//    //初始化pageControl
//    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, pageFlowView.frame.size.height - 24, Width, 8)];
//    pageFlowView.pageControl = pageControl;
//    [pageFlowView addSubview:pageControl];
    
    [pageFlowView reloadData];
    [self.topScrollView addSubview:pageFlowView];
    
    self.pageFlowView = pageFlowView;
}

-(void)loadData{
    [MHNetWorkTool GETWITHHEADER:[WATEREVERHOST stringByAppendingString:@"message/3.0"] parameters:nil success:^(id responseObject) {
        long code = [responseObject[@"code"] longValue];
        if(code == 0){
            self.messageCenterModel = [MHMessageCenterModel mj_objectWithKeyValues:responseObject[@"data"]];
            //设置ui内容
            [self setupUI];
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
        }
    } failure:nil];
}

#pragma mark --NewPagedFlowView Delegate
- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    MHActivityModel *model = [self.messageCenterModel.activityPageList objectAtIndex:subIndex];
    MHLoadActivityWebViewController *vc = [[MHLoadActivityWebViewController alloc]init];
    vc.urlString = model.activityUrl;
    vc.title = model.title;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
//    return CGSizeMake(Width - 50, (Width - 50) * 9 / 16);
    return CGSizeMake(Width - 50, self.topScrollView.size.height);
}

#pragma mark --NewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    return self.imageArray.count;
}

- (PGIndexBannerSubiew *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    
    PGIndexBannerSubiew *bannerView = [flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[PGIndexBannerSubiew alloc] init];
        bannerView.tag = index;
        bannerView.layer.cornerRadius = 10;
        bannerView.clipsToBounds = YES;
    }
    
    bannerView.mainImageView.image = [self.imageArray  objectAtIndex:index];
    return bannerView;
}


#pragma mark --懒加载
- (NSMutableArray *)imageArray {
    if (_imageArray == nil) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

#pragma mark --UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MHMessageCenterTableViewCell *cell = [MHMessageCenterTableViewCell cellWithTableView:tableView];
    switch (indexPath.row) {
        case 0:{
            cell.iconImageView.image = [UIImage imageNamed:@"news_notice"];
            cell.titleLabel.text = @"最新消息";
        }
            break;
        case 1:{
            cell.iconImageView.image = [UIImage imageNamed:@"news_allactivities"];
            cell.titleLabel.text = @"所有活动";
        }
            break;
        case 2:{
            cell.iconImageView.image = [UIImage imageNamed:@"news_circle"];
            cell.titleLabel.text = @"水粉圈";
        }
            break;
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:{
            //消息
            MHMessageViewController *vc = [[MHMessageViewController alloc]init];
            vc.pushType = 1;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:{
            //所有活动
            MHActivityTableViewController *vc = [[MHActivityTableViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:{
            //水粉圈
            MHFandomViewController *vc = [[MHFandomViewController alloc]init];
            vc.pushType = 1;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)dealloc {
    [self.pageFlowView stopTimer];
}

-(void)addGes{
    UITapGestureRecognizer *inviteFriendTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(inviteFriendViewClicked)];
    [self.inviteFriendView addGestureRecognizer:inviteFriendTap];
    
    UITapGestureRecognizer *exchangeCouponsTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(exchangeCouponsViewClicked)];
    [self.exchangeCouponsView addGestureRecognizer:exchangeCouponsTap];
}

-(void)inviteFriendViewClicked{
    MHShareViewController *vc = [[MHShareViewController alloc]init];
    vc.pushType = 1;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)exchangeCouponsViewClicked{
    MHExchangeCouponsViewController *vc = [[MHExchangeCouponsViewController alloc]init];
    vc.pushType = 1;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
