//
//  MHMachineActivedViewController.m
//  waterever
//
//  Created by qyyue on 2017/8/23.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHMachineActivedViewController.h"
#import "MHMachineRepairViewController.h"
#import "MHMachineApartViewController.h"
#import "MHSelectBundleViewController.h"
#import "MHBundleUsageViewController.h"
#import "MHCommonHeader.h"
#import "MHMachineStatusModel.h"
#import "MHWaterUsageViewController.h"
#import "SCLAlertView.h"

@interface MHMachineActivedViewController ()
@property (weak, nonatomic) IBOutlet UILabel *identifyLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *batteryLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
- (IBAction)editBtnClicked;


- (IBAction)repairBtnClicked;
- (IBAction)apartBtnClicked;
- (IBAction)payBtnClicked;
- (IBAction)searchBtnClicked;

@property(nonatomic,strong) MHMachineStatusModel *machineStatusModel;
@end

@implementation MHMachineActivedViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getMachineStatus];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

-(void)initView{
    self.title = @"设备详情";
}

-(void)getMachineStatus{
    MHUserInfoTool *userInfo = [MHUserInfoTool sharedMHUserInfoTool];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:userInfo.deviceId forKey:@"device_id"];
    [parameters setObject:userInfo.personDeviceId forKey:@"person_device_id"];
    [MHNetWorkTool GETWITHHEADER:[WATEREVERHOST stringByAppendingFormat:@"device/2.0/%@/%@",userInfo.deviceId,userInfo.personDeviceId] parameters:parameters success:^(id responseObject) {
        int code = [responseObject[@"code"] intValue];
        if(code == 0){
            self.machineStatusModel = [MHMachineStatusModel mj_objectWithKeyValues:responseObject[@"data"]];
            dispatch_async(dispatch_get_main_queue(), ^{
               //刷新ui
                [self refreshMachineStatus];
            });
        }else if(code == -1){
            [SVProgressHUD showErrorWithStatus:@"未知错误"];
        }
    } failure:nil];
}

-(void)refreshMachineStatus{
    
    //剩余详情
    self.leftDayLabel.text = self.machineStatusModel.streamOrPeriod?self.machineStatusModel.streamOrPeriod:@"0";
    int salePackageType = [self.machineStatusModel.salePackageType intValue];
    if(salePackageType == 1){
        //周期套餐
        self.leftTypeLabel.text = @"剩余时间";
        self.unitLabel.text = @"天";
    }else if(salePackageType == 2){
        //流量套餐
        self.leftTypeLabel.text = @"剩余流量";
        self.unitLabel.text = @"L";
    }
    
    //设备编号
    self.identifyLabel.text = self.machineStatusModel.deviceName;
    
    //安装日期
    // 格式化时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self.machineStatusModel.dateCreated doubleValue]/ 1000.0];
    NSString *dateString = [formatter stringFromDate:date];
    self.dateLabel.text = dateString;
    
    //电池情况
//    if([self.machineStatusModel.batteryStatus isEqualToString:@"0"]){
//        self.batteryLabel.text = @"正常";
//    }else if([self.machineStatusModel.batteryStatus isEqualToString:@"1"]){
//        self.batteryLabel.text = @"警告";
//    }else{
//        self.batteryLabel.text = @"0%";
//    }
    
    //电池电量
    if(self.machineStatusModel.batterySOC){
        self.batteryLabel.text = [NSString stringWithFormat:@"%@%%",self.machineStatusModel.batterySOC];
    }else{
        self.batteryLabel.text = @"0%";
    }
    
    
}

- (IBAction)editBtnClicked {
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.customViewColor = MHUIColorFromHex(0x3e91ff);
    [alert setHorizontalButtons:YES];
    
    SCLTextView *textField = [alert addTextField:@"请输入要修改的名称"];
    alert.hideAnimationType = SCLAlertViewHideAnimationSimplyDisappear;
    [alert addButton:@"确定" actionBlock:^(void) {
        if([textField.text isEqualToString:@""]){
            [SVProgressHUD showErrorWithStatus:@"设备名称不能为空"];
        }else if(textField.text.length > 6){
            [SVProgressHUD showErrorWithStatus:@"设备名称不能超过6个字"];
        }else{
            self.identifyLabel.text = textField.text;
            [self editMachineNameWithMachineName:textField.text];
        }
    }];
    [alert showEdit:self title:nil subTitle:[NSString stringWithFormat:@"\n%@\n",self.identifyLabel.text] closeButtonTitle:@"取消" duration:0.0f];
}

-(void)editMachineNameWithMachineName:(NSString *)machineName{
    MHUserInfoTool *userInfo = [MHUserInfoTool sharedMHUserInfoTool];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:userInfo.personDeviceId forKey:@"person_device_id"];
    [parameters setObject:machineName forKey:@"device_name"];
    [MHNetWorkTool PATCHWITHHEADER:[NSString stringWithFormat:@"%@device/2.4/name/%@",WATEREVERHOST,userInfo.personDeviceId] parameters:parameters success:^(id responseObject) {
        long code = [responseObject[@"code"] longValue];
        if(code == 0){
            [SVProgressHUD showSuccessWithStatus:responseObject[@"msg"]];
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
        }
    } failure:nil];
    
}

- (IBAction)repairBtnClicked {
//    [SVProgressHUD showErrorWithStatus:@"请先激活设备"];
//    return;
    MHMachineRepairViewController *vc = [[MHMachineRepairViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)apartBtnClicked {
//    [SVProgressHUD showErrorWithStatus:@"请先激活设备"];
//    return;
    MHMachineApartViewController *vc = [[MHMachineApartViewController alloc]init];
    vc.deviceCode = self.machineStatusModel.deviceCode;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)payBtnClicked {
//    [SVProgressHUD showErrorWithStatus:@"请先激活设备"];
//    return;
    MHSelectBundleViewController *vc = [[MHSelectBundleViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)searchBtnClicked {
//    [SVProgressHUD showErrorWithStatus:@"请先激活设备"];
//    return;
    
    int salePackageType = [self.machineStatusModel.salePackageType intValue];
    if(salePackageType == 1){
        //周期套餐
        MHBundleUsageViewController *vc = [[MHBundleUsageViewController alloc]init];
        vc.machineStatusModel = self.machineStatusModel;
        [self.navigationController pushViewController:vc animated:YES];
    }else if(salePackageType == 2){
        //流量套餐
        MHWaterUsageViewController *vc = [[MHWaterUsageViewController alloc]init];
        vc.machineStatusModel = self.machineStatusModel;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [SVProgressHUD showErrorWithStatus:@"暂未购买套餐"];
    }
}
@end
