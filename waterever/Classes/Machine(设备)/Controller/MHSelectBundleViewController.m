//
//  MHSelectBundleViewController.h
//  waterever
//
//  Created by qyyue on 2017/8/23.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHSelectBundleViewController.h"
#import "MHPayBundleTableViewCell.h"
#import "MHPayBundleViewController.h"
#import "MHCommonHeader.h"
#import "MHSaleBundleModel.h"


@interface MHSelectBundleViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong) NSArray *saleBundleArray;

@end

@implementation MHSelectBundleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购买套餐";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self getSaleBundle];
}

-(void)getSaleBundle{
    [MHNetWorkTool GETWITHHEADER:[WATEREVERHOST stringByAppendingString:@"finance/2.0/sale_package"] parameters:nil success:^(id responseObject) {
        int code = [responseObject[@"code"] intValue];
        if(code == 0){
            dispatch_async(dispatch_get_main_queue(), ^{
               self.saleBundleArray = [MHSaleBundleModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                [self.tableView reloadData];
            });
        }else if(code == -1){
            [SVProgressHUD showErrorWithStatus:@"获取套餐失败，请稍后重试"];
        }
    } failure:nil];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.saleBundleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (MHPayBundleTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MHPayBundleTableViewCell *cell = [MHPayBundleTableViewCell cellWithTableView:tableView];
    MHSaleBundleModel *saleBundleModel = [self.saleBundleArray objectAtIndex:indexPath.section];
    cell.saleBundleModel = saleBundleModel;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MHPayBundleViewController *vc = [[MHPayBundleViewController alloc]init];
    MHSaleBundleModel *model = [self.saleBundleArray objectAtIndex:indexPath.section];
    vc.saleBundleModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}
@end
