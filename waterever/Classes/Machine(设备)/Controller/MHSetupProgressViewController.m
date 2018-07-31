//
//  MHSetupProgressViewController.m
//  waterever
//
//  Created by qyyue on 2017/8/23.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHSetupProgressViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "MHQRScanActivateDeviceViewController.h"
#import "MHCommonHeader.h"
#import "MHApplySuccessViewController.h"
#import "MHOrderServeViewController.h"
#import "MHOrderServeModel.h"

//物流信息头文件
#import "MHLogisticsStatusModel.h"
#import "DWQLogisticModel.h"
#import "DWQLogisticsView.h"
#import "DWQConfigFile.h"

@interface MHSetupProgressViewController ()
@property(nonatomic,strong)NSMutableArray<DWQLogisticModel *> *dataArray;
@property(nonatomic,strong)MHLogisticsStatusModel *logisticsStatusModel;
@property(nonatomic,strong)MHOrderServeModel *orderServeModel;

@property (weak, nonatomic) IBOutlet UILabel *contactLabel;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
@property (weak, nonatomic) IBOutlet UITextView *setupAddressLabel;
@property (weak, nonatomic) IBOutlet UIView *logisticsInformationView;
@property (weak, nonatomic) IBOutlet UIView *unsendView;

@property (weak, nonatomic) IBOutlet UILabel *applyTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *logisticsStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *logisticsNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *sendtimeLabel;
- (IBAction)searchLogisticsInfo;

@property (weak, nonatomic) IBOutlet UIButton *orderServeBtn;
- (IBAction)orderServeBtnClicked;

@property (weak, nonatomic) IBOutlet UIImageView *lineImageView1;

@property (weak, nonatomic) IBOutlet UIImageView *lineImageView2;

@property (weak, nonatomic) IBOutlet UIImageView *waterImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *waterImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *waterImageView3;
@property (weak, nonatomic) IBOutlet UIImageView *lineImageView4;
@property (weak, nonatomic) IBOutlet UIImageView *lineImageView5;

@property (weak, nonatomic) IBOutlet UIImageView *carImageView;
@property (weak, nonatomic) IBOutlet UIImageView *fingerImageView;


- (IBAction)qrcodeBtnClicked;

@end

@implementation MHSetupProgressViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupUi];
    [self getLogisticsInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNotifier];
    self.title = @"申请进程";
}

-(void)addNotifier{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
}

-(void)reachabilityChanged:(NSNotification *)noti{
    Reachability *currentReach = [noti object];
    NSParameterAssert([currentReach isKindOfClass:[Reachability class]]);
    
    if([currentReach currentReachabilityStatus] != NotReachable){
        [self getLogisticsInfo];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)setupUi{
    // 格式化时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    if(self.model){
        self.contactLabel.text = self.model.contactName;
        self.telLabel.text = self.model.contactPhone;
        self.setupAddressLabel.text = self.model.address;
        self.applyTimeLabel.text = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[self.model.applyDate doubleValue]/ 1000.0]];
    }else{
        return;
    }
    switch ([self.model.applyStatus intValue]) {
        case 1:{
//        已申请
        }
            break;
        case 2:{
//            已发货
            [self setupStatusTwo];
        }
            break;
        case 3:{
//            已安装
        }
            break;
        case 4:{
//            发货前取消
        }
            break;
        case 5:{
//         发货后取消   
        }
            break;
        case 8:{
            //已预约上门安装 已交钱
            [self.orderServeBtn setTitle:@"修改预约安装信息" forState:UIControlStateNormal];
            [self.orderServeBtn setTitleColor:MHUIColorFromHex(0x6699cc) forState:UIControlStateNormal];
            [self getOrderServeInfo];
            if(self.model.expressCompanyCode){
                [self setupStatusTwo];
            }
        }
            break;
        default:
            break;
    }
}

-(void)setupStatusTwo{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
//    已发货
    self.lineImageView4.image = [UIImage imageNamed:@"blue_xvxian"];
    self.lineImageView5.image = [UIImage imageNamed:@"blue_xvxian"];
    self.carImageView.image = [UIImage imageNamed:@"APP-48"];
    self.waterImageView2.image = [UIImage imageNamed:@"APP-43"];
    self.unsendView.hidden = YES;
    self.logisticsInformationView.hidden = NO;
    self.companyLabel.text = [NSString stringWithFormat:@"公司名称:%@",self.model.expressOffice];
    self.logisticsNumberLabel.text = [NSString stringWithFormat:@"快递单号:%@",self.model.expressCode];
    
    self.sendtimeLabel.text = [NSString stringWithFormat:@"发货时间:%@",[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[self.model.expressDate doubleValue]/ 1000.0]]];
}

- (IBAction)qrcodeBtnClicked {
    
    
    //  获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        MHQRScanActivateDeviceViewController *vc = [[MHQRScanActivateDeviceViewController alloc] init];
                        [self.navigationController pushViewController:vc animated:YES];
                    });
                    // 用户第一次同意了访问相机权限
                    
                } else {
                    // 用户第一次拒绝了访问相机权限
                }
            }];
        } else if (status == AVAuthorizationStatusAuthorized) { // 用户允许当前应用访问相机
            MHQRScanActivateDeviceViewController *vc = [[MHQRScanActivateDeviceViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (status == AVAuthorizationStatusDenied) { // 用户拒绝当前应用访问相机
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请去-> [设置 - 隐私 - 相机] 打开开关" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertC addAction:alertA];
            [self presentViewController:alertC animated:YES completion:nil];
            
        } else if (status == AVAuthorizationStatusRestricted) {
            [SVProgressHUD showErrorWithStatus:@"因为系统原因, 无法访问相册"];
        }
    } else {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertC addAction:alertA];
        [self presentViewController:alertC animated:YES completion:nil];
    }
}

- (IBAction)searchLogisticsInfo {
    
    if (!self.dataArray.count) {
        [SVProgressHUD showErrorWithStatus:@"暂未查到物流信息,请稍后重试"];
        return;
    }
    
    UIViewController *vc = [[UIViewController alloc]init];
    vc.title = @"物流查询";
    vc.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    DWQLogisticsView *logis = [[DWQLogisticsView alloc]initWithDatas:self.dataArray];
    logis.model = self.logisticsStatusModel;
    
    logis.frame = CGRectMake(0, 5, DWQScreenWidth, DWQScreenHeight);
    
    [vc.view addSubview:logis];
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(NSMutableArray<DWQLogisticModel *> *)dataArray{
    if(!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(void)getOrderServeInfo{
    MHUserInfoTool *userInfo = [MHUserInfoTool sharedMHUserInfoTool];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:userInfo.applyDeviceId forKey:@"apply_device_id"];
    [MHNetWorkTool GETWITHHEADER:[WATEREVERHOST stringByAppendingString:@"after_sale/get_device_install"] parameters:parameters success:^(id responseObject) {
        long code = [responseObject[@"code"] longValue];
        if(code == 0){
            self.orderServeModel = [MHOrderServeModel mj_objectWithKeyValues:responseObject[@"data"]];
        }else{
//            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
        }
    } failure:nil];

}

-(void)getLogisticsInfo{
    if(!self.model.expressCode) return;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:self.model.expressCompanyCode forKey:@"express_company_ode"];
    [parameters setObject:self.model.expressCode forKey:@"express_code"];
    
    [MHNetWorkTool GETWITHHEADER:[WATEREVERHOST stringByAppendingString:@"express/search"] parameters:parameters success:^(id responseObject) {
        int code = [responseObject[@"code"] intValue];
        if(code == 0){
            NSString *replacedResultString = [responseObject[@"data"] stringByReplacingOccurrencesOfString:@"\\" withString:@""];
            NSData *jsonData = [replacedResultString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            self.dataArray = [DWQLogisticModel mj_objectArrayWithKeyValuesArray:jsonDic[@"Traces"]];
            self.logisticsStatusModel = [MHLogisticsStatusModel mj_objectWithKeyValues:jsonDic];
            [self setupUi];
        }else if(code == -1){

        }

    } failure:nil];
}

- (IBAction)orderServeBtnClicked {
    if([self.model.applyStatus intValue] == 8){
        MHOrderServeViewController *vc = [[MHOrderServeViewController alloc]init];
        vc.orderServeModel = self.orderServeModel;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        MHApplySuccessViewController *vc = [[MHApplySuccessViewController alloc]init];
        vc.flag = 1;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}
@end
