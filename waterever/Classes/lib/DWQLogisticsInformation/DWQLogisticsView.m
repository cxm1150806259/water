//
//  DWQLogisticsView.m
//  DWQLogisticsInformation
//
//  Created by 杜文全 on 16/7/9.
//  Copyright © 2016年 com.iOSDeveloper.duwenquan. All rights reserved.
//

#import "DWQLogisticsView.h"
#import "DWQConfigFile.h"
#import "DWQLogisticCell.h"


@interface DWQLogisticsView () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic)NSMutableArray *dataArray;
@property (strong, nonatomic)UITableView *table;
@end

@implementation DWQLogisticsView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        [self setupUI];
    }
    
    return self;
}

- (instancetype)initWithDatas:(NSArray*)array {
    self = [super init];
    if (self) {
        
//        [self.dataArray addObjectsFromArray:array]; 正常添加
//        [self setupUI];
        
        for(int i = array.count-1;i>=0;i--){
//            倒着添加
            [self.dataArray addObject:[array objectAtIndex:i]];
        }
    }
    
    return self;
}

- (void)setDatas:(NSArray *)datas {
    if (_datas == datas) {
        
        _datas = datas;
    }
    
    [self.table reloadData];
}

- (void)reloadDataWithDatas:(NSArray *)array {
    
    [self.dataArray addObjectsFromArray:array];
    [self.table reloadData];
}
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

-(void)setModel:(MHLogisticsStatusModel *)model{
    _model = model;
    
    switch ([self.model.State intValue]) {
        case 2:
            self.header.type.text=@"途中";
            break;
        case 3:
            self.header.type.text=@"已签收";
            break;
        case 4:
            self.header.type.text=@"问题件";
            break;
        default:
            break;
    }
    
    self.header.numLabel.text = self.model.LogisticCode;
    self.header.comLabel.text = self.model.ShipperCode;

}

- (void)setupUI {
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:table];
    [table setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.table = table;
    
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    self.header=[[DWQTableHeaderView alloc]initWithFrame:CGRectMake(0, 0, DWQScreenWidth, 100)];;
    
    self.header.userInteractionEnabled=YES;
    
    self.table.tableHeaderView=self.header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DWQLogisticCell *cell = [tableView dequeueReusableCellWithIdentifier:@"logisticsCellIdentifier"];
    if (cell == nil) {
        
        cell = [[DWQLogisticCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"logisticsCellIdentifier"];
    }
    
    if (indexPath.row == 0) {
        cell.hasUpLine = NO;
        cell.currented = YES;
    } else {
        cell.hasUpLine = YES;
        cell.currented = NO;
        //        cell.currentTextColor = nil;
    }
    
    if (indexPath.row == self.dataArray.count - 1) {
        cell.hasDownLine = NO;
    } else {
        cell.hasDownLine = YES;
    }
    
    DWQLogisticModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    [cell reloadDataWithModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DWQLogisticModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    return model.height;
}

#pragma mark 拨打电话
-(void)BoHao{
 
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 1;
}


@end
