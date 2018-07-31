//
//  MHMachineApartAppliedViewController.m
//  waterever
//
//  Created by qyyue on 2017/8/23.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHMachineApartAppliedViewController.h"

@interface MHMachineApartAppliedViewController ()
- (IBAction)sunmitBtnClicked;
@property (weak, nonatomic) IBOutlet UITextView *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation MHMachineApartAppliedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

-(void)initView{
    self.title = @"拆机成功";
    self.addressLabel.text = self.model.address;
    self.telLabel.text = [NSString stringWithFormat:@"联系电话：%@",self.model.contactPhone];
    self.nameLabel.text = [NSString stringWithFormat:@"收件人：%@",self.model.contactName];
}

- (IBAction)sunmitBtnClicked {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
