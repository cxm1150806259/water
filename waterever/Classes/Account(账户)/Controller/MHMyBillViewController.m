//
//  MHMyBillViewController.m
//  waterever
//
//  Created by qyyue on 2017/8/24.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHMyBillViewController.h"
#import "MHMyBillTableViewCell.h"
#import "MHCommonHeader.h"

@interface MHMyBillViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *nullView;

@end

@implementation MHMyBillViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.payDetailDataArrayM.count){
        self.nullView.hidden = YES;
    }else{
        self.nullView.hidden = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的账单";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.payDetailDataArrayM.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MHPayDetailModel *model = [self.payDetailDataArrayM objectAtIndex:indexPath.row];
    
    MHMyBillTableViewCell *cell = [MHMyBillTableViewCell cellWithTableView:tableView];
    cell.model = model;
//    if(indexPath.row%2){
//        cell.contentView.backgroundColor = MHCOLOR(238, 203, 204, 1);
//    }else{
//        cell.contentView.backgroundColor = MHCOLOR(249, 237, 238, 1);
//    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
