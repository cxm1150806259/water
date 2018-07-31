//
//  MHActivityTableViewController.m
//  waterever
//
//  Created by qyyue on 2017/11/30.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHActivityTableViewController.h"
#import "MHActivityTableViewCell.h"
#import "MHCommonHeader.h"
#import "MHNetWorkTool.h"
#import "MHActivityModel.h"
#import "MHLoadActivityWebViewController.h"

@interface MHActivityTableViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UIView *tempView;
@end

@implementation MHActivityTableViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"news_btn_back_black" HighlightedImage:nil Target:self Action:@selector(back)];
    NSDictionary *titleAttribute=@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:18]};
    [self.navigationController.navigationBar setTitleTextAttributes:titleAttribute];
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = false;
    self.title = @"所有活动";
}

-(UIView *)tempView{
    if(!_tempView){
        _tempView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 10)];
        _tempView.backgroundColor = [UIColor clearColor];
    }
    return _tempView;
}

-(NSMutableArray *)dataArray{
    if(!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(void)loadData{
    [MHNetWorkTool GETWITHHEADER:[WATEREVERHOST stringByAppendingString:@"message/3.0/activity"] parameters:nil success:^(id responseObject) {
        int code = [responseObject[@"code"] intValue];
        if(code == 0){
            self.dataArray = [MHActivityModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [self.tableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
        }
    } failure:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return section == self.dataArray.count - 1 ? 30 : 8;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.tempView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return section == self.dataArray.count - 1 ? [[[NSBundle mainBundle]loadNibNamed:@"MHActivityFooterView" owner:self options:nil]lastObject] : self.tempView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MHActivityTableViewCell *cell = [MHActivityTableViewCell cellWithTableView:tableView];
    MHActivityModel *model = [self.dataArray objectAtIndex:indexPath.section];
    cell.model = model;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MHActivityModel *model = [self.dataArray objectAtIndex:indexPath.section];
    return model.cellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MHActivityModel *model = [self.dataArray objectAtIndex:indexPath.section];
    MHLoadActivityWebViewController *vc = [[MHLoadActivityWebViewController alloc]init];
    vc.urlString = model.activityUrl;
    vc.title = model.title;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
@end

