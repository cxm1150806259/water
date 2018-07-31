//
//  DWQTableHeaderView.m
//  DWQLogisticsInformation
//
//  Created by 杜文全 on 16/7/9.
//  Copyright © 2016年 com.iOSDeveloper.duwenquan. All rights reserved.
//

#import "DWQTableHeaderView.h"

#import "DWQConfigFile.h"

@interface DWQTableHeaderView ()


@end
@implementation DWQTableHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self=[super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setPhone:(NSString *)phone {
    
    self.phoneLabel.text = phone;
}

- (void)setNumber:(NSString *)number {
    
    self.numLabel.text = number;
}

- (void)setCompany:(NSString *)company {
    
    self.comLabel.text = company;
}

- (void)setupUI {
    self.backgroundColor=[UIColor whiteColor];
    
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    
    self.goodsPic.frame=CGRectMake(Gap, Gap, 8*Gap, 6*Gap);
    self.goodsPic.image=[UIImage imageNamed:@"logistics"];
    [bgView addSubview:self.goodsPic];
    
    UILabel *label0=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.goodsPic.frame)+Gap/3,Gap, 7*Gap, 2*Gap)];
    label0.font = [UIFont systemFontOfSize:15];
    label0.textColor = [UIColor grayColor];
    label0.text = @"物流状态:";
    [bgView addSubview:label0];
    
    self.type.frame=CGRectMake(CGRectGetMaxX(label0.frame)+Gap/2, label0.frame.origin.y, DWQScreenWidth/2, label0.frame.size.height);
    self.type.font=[UIFont systemFontOfSize:15];
    self.type.textColor=[UIColor grayColor];
    self.type.textAlignment=NSTextAlignmentLeft;
    [bgView addSubview:self.type];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(label0.frame.origin.x ,CGRectGetMaxY(label0.frame), 7*Gap, 2*Gap)];
    label1.font = [UIFont systemFontOfSize:15];
    label1.textColor = [UIColor grayColor];
    label1.text = @"运单编号:";
    [bgView addSubview:label1];
    
    self.numLabel.frame=CGRectMake(CGRectGetMaxX(label1.frame)+Gap/2, label1.frame.origin.y, DWQScreenWidth/2, label1.frame.size.height);
    self.numLabel.font=[UIFont systemFontOfSize:15];
    self.numLabel.textColor=[UIColor grayColor];
    self.numLabel.textAlignment=NSTextAlignmentLeft;
    [bgView addSubview:self.numLabel];
    
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(label1.frame.origin.x ,CGRectGetMaxY(label1.frame), 7*Gap, 2*Gap)];
    label2.font = [UIFont systemFontOfSize:15];
    label2.textColor = [UIColor grayColor];
    label2.text = @"承运公司:";
    [bgView addSubview:label2];
    
    
    self.comLabel.frame=CGRectMake(CGRectGetMaxX(label2.frame)+Gap/2, label2.frame.origin.y, DWQScreenWidth/2, label1.frame.size.height);
    self.comLabel.font=[UIFont systemFontOfSize:15];
    self.comLabel.textColor=[UIColor grayColor];
    self.comLabel.textAlignment=NSTextAlignmentLeft;
    [bgView addSubview:self.comLabel];
    
    UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.comLabel.frame)+Gap, DWQScreenWidth, 5)];
    line.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [bgView addSubview:line];
}
-(void)BoHao{

}
#pragma mark 懒加载
-(UIImageView *)goodsPic{
    
    if(!_goodsPic) {
        
        _goodsPic =[[UIImageView alloc]init];
        
    }
    
    return _goodsPic;
    
}
-(UILabel *)type{
    
    if(!_type) {
        
        _type =[[UILabel alloc]init];
        
    }
    
    return _type;
    
}
-(UILabel *)numLabel{
    
    if(!_numLabel) {
        
        _numLabel =[[UILabel alloc]init];
        
    }
    
    return _numLabel;
    
}
-(UILabel *)comLabel{
    
    if(!_comLabel) {
        
        _comLabel =[[UILabel alloc]init];
        
    }
    
    return _comLabel;
    
}
-(UILabel *)phoneLabel{
    
    if(!_phoneLabel) {
        
        _phoneLabel =[[UILabel alloc]init];
        
    }
    
    return _phoneLabel;
    
}
-(UIImageView *)psHeaderPic{
    
    if(!_psHeaderPic) {
        
        _psHeaderPic =[[UIImageView alloc]init];
        
    }
    
    return _psHeaderPic;
    
}
-(UILabel *)psName{
    
    if(!_psName) {
        
        _psName =[[UILabel alloc]init];
        
    }
    
    return _psName;
    
}
-(UIButton *)psPhone{
    
    if(!_psPhone) {
        
        _psPhone =[[UIButton alloc]init];
        
    }
    
    return _psPhone;
    
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


@end
