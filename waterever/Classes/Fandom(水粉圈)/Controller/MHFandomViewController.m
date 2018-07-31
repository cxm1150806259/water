//
//  MHFandomViewController.m
//  waterever
//
//  Created by qyyue on 2017/8/24.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHFandomViewController.h"
#import "MHFandomTableViewCell.h"
#import "MHCommonHeader.h"
#import "MHLoadWebViewController.h"
#import "MHFandomInfoModel.h"

@interface MHFandomViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIView *tempView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *nullView;
@property(nonatomic,assign) unsigned long oldDataArrayCount;

@property(nonatomic,strong) UILabel *tempTipLabel;
@end

@implementation MHFandomViewController

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

-(void)viewWillDisappear:(BOOL)animate{
    [super viewWillDisappear:animate];
    [self.tempTipLabel removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNotifier];
    [self initView];
    [self.tableView.mj_header beginRefreshing];
}

-(void)addNotifier{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
}

-(void)reachabilityChanged:(NSNotification *)noti{
    Reachability *currentReach = [noti object];
    NSParameterAssert([currentReach isKindOfClass:[Reachability class]]);
    
    if([currentReach currentReachabilityStatus] == NotReachable){
        [self.tableView.mj_header endRefreshing];
    }else{
        //有网络
        [self.tableView.mj_header beginRefreshing];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)initView{
    self.title = @"水粉圈";
    self.tableView.estimatedRowHeight = 400;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    //去除预留的空白
    self.automaticallyAdjustsScrollViewInsets = false;
    [self addHeaderRefreshControl];
    //暂时不添加上拉加载
//    [self addFooterRefreshControl];
}

-(void)addHeaderRefreshControl{
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getFandomInfo)];
}

-(void)addFooterRefreshControl{
}

-(NSMutableArray *)dataArray{
    if(!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(UIView *)tempView{
    if(!_tempView){
        _tempView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 10)];
        _tempView.backgroundColor = [UIColor clearColor];
    }
    return _tempView;
}

-(void)getFandomInfo{
    [self.tempTipLabel removeFromSuperview];
    [MHNetWorkTool GETWITHHEADER:[WATEREVERHOST stringByAppendingString:@"message/3.0/circle"] parameters:nil success:^(id responseObject) {
        int code = [responseObject[@"code"] intValue];
        if(code == 0){
            self.dataArray = [MHFandomInfoModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            
            [self.tableView reloadData];
            
             [self addNewStatusNoti:self.dataArray.count];
            
            self.oldDataArrayCount = self.dataArray.count;
            
        }else if(code == -1){

        }
        
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
        [self.tableView.mj_header endRefreshing];
    }];
}

//加载成功后添加提示消息
-(void)addNewStatusNoti:(unsigned long)newStatusCount{
    UILabel *label=[[UILabel alloc]init];
    self.tempTipLabel = label;
    label.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_new_status_background"]];
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=[UIColor whiteColor];
    label.width=SCREENBOUNDS.size.width;
    label.height=33;
    label.x=0;
    label.y=64-label.height;
    
    if(self.oldDataArrayCount == 0 ){
        if(newStatusCount){
            label.text=[NSString stringWithFormat:@"加载到%ld篇文章",newStatusCount];
        }else{
            label.text=@"没有新的内容";
        }
    }else{
        unsigned long newCount = newStatusCount - self.oldDataArrayCount;
        if(newCount != 0){
            label.text=[NSString stringWithFormat:@"加载到%ld篇新的文章",newCount];
        }else{
            label.text=@"没有新的内容";
        }
    }
    
    [UIView animateWithDuration:1 animations:^{
        label.y=64;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionCurveLinear animations:^{
            label.y=64-label.height;
            label.alpha=0.5;
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
    [self.navigationController.view insertSubview:label belowSubview:self.navigationController.navigationBar];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    self.nullView.hidden = self.dataArray.count?YES:NO;
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MHFandomTableViewCell *cell = [MHFandomTableViewCell cellWithTableView:tableView];
    MHFandomInfoModel *model = [self.dataArray objectAtIndex:indexPath.section];
    cell.model = model;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MHFandomInfoModel *model = [self.dataArray objectAtIndex:indexPath.section];
    return model.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MHFandomInfoModel *model = [self.dataArray objectAtIndex:indexPath.section];
    MHLoadWebViewController *vc = [[MHLoadWebViewController alloc]init];
    vc.model = model;
    vc.title = model.title;
    [self.navigationController pushViewController:vc animated:YES];
    vc.navigationItem.rightBarButtonItem = nil;
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return self.tempView;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.tempView;
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
