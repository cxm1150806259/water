//
//  MHAddressSubmitViewController.m
//  waterever
//
//  Created by qyyue on 2017/8/23.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHAddressSubmitViewController.h"
#import "MHPayCashViewController.h"
#import "MHCommonHeader.h"
#import "MHUserInfoTool.h"
#import "STPickerArea.h"
#import "MHApplyAddressModel.h"

@interface MHAddressSubmitViewController ()<STPickerAreaDelegate>
@property(nonatomic,strong) STPickerArea *pickerArea;
@property (weak, nonatomic) IBOutlet MHTextField *nameTextField;
@property (weak, nonatomic) IBOutlet MHTextField *telTextField;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet MHTextView *detailAddressTextField;

@property(nonatomic,strong) MHApplyAddressModel *applyAddressModel;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
- (IBAction)submitBtnClicked;
- (IBAction)checkBtnClicked;

@end

@implementation MHAddressSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

-(void)initView{
    self.title = @"地址填写";
    self.telTextField.mhMaxTextCount = 11;
    [self.detailAddressTextField addObserver];
    
    UITapGestureRecognizer *areaTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectArea)];
    [self.areaLabel addGestureRecognizer:areaTap];
    
    [self getAddressInfo];
}

-(void)getAddressInfo{
    if([self.applyStatus isEqualToString:@"11"]){
        //地址已填写 填充一下
        MHUserInfoTool *userInfo = [MHUserInfoTool sharedMHUserInfoTool];
        [MHNetWorkTool GETWITHHEADER:[WATEREVERHOST stringByAppendingFormat:@"apply/2.0/apply_device/%@",userInfo.applyDeviceId] parameters:@{@"apply_device_id":userInfo.applyDeviceId} success:^(id responseObject) {
            long code = [responseObject[@"code"] longValue];
            if(code == 0){
                self.applyAddressModel = [MHApplyAddressModel mj_objectWithKeyValues:[responseObject objectForKey:@"data"]];
                [self setupAddressInfo];
            }else{
                [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            }
        } failure:nil];
    }
}

-(void)setupAddressInfo{
    self.nameTextField.text = self.applyAddressModel.contactName;
    self.telTextField.text = self.applyAddressModel.contactPhone;
    self.areaLabel.text = self.applyAddressModel.installArea;
    self.detailAddressTextField.text = self.applyAddressModel.postAddress;
    self.detailAddressTextField.placeholder = nil;
    self.checkBtn.tag = [self.applyAddressModel.isInstall intValue];
    [self.checkBtn setImage:[UIImage imageNamed:self.checkBtn.tag?@"check_selected":@"check_normal"] forState:UIControlStateNormal];
    [self.checkBtn setTitle:self.checkBtn.tag?@" 已选择上门安装":@" 是否上门安装" forState:UIControlStateNormal];
}

-(STPickerArea *)pickerArea{
    if(!_pickerArea){
        _pickerArea = [[STPickerArea alloc]init];
        [_pickerArea setDelegate:self];
        [_pickerArea setSaveHistory:YES];
        [_pickerArea setContentMode:STPickerContentModeCenter];
    }
    return _pickerArea;
}

- (IBAction)submitBtnClicked {
    if([self.nameTextField.text isEqualToString:@""]){
        [SVProgressHUD showErrorWithStatus:@"请输入姓名"];
        return;
    }
    if(self.telTextField.text.length != 11){
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
        return;
    }
    
    if([self.areaLabel.text isEqualToString:@"请选择收货地址"]){
        [SVProgressHUD showErrorWithStatus:@"请选择收货区域"];
        return;
    }
    
    if(self.detailAddressTextField.text.length < 5){
        [SVProgressHUD showErrorWithStatus:@"请输入详细收货地址,不少于5个字"];
        return;
    }
    
    MHUserInfoTool *userInfo = [MHUserInfoTool sharedMHUserInfoTool];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    [parameters setObject:userInfo.personId forKey:@"person_id"];
    [parameters setObject:userInfo.applyDeviceId forKey:@"apply_device_id"];
    [parameters setObject:self.nameTextField.text forKey:@"contact_name"];
    [parameters setObject:userInfo.phone forKey:@"contact_phone"];
    [parameters setObject:self.areaLabel.text forKey:@"post_area"];
    [parameters setObject:self.detailAddressTextField.text forKey:@"post_address"];
    [parameters setObject:@(self.checkBtn.tag) forKey:@"install"];
    
    [MHNetWorkTool PATCHWITHHEADER:[WATEREVERHOST stringByAppendingFormat:@"apply/3.0/apply_device/%@",userInfo.applyDeviceId] parameters:parameters success:^(id responseObject) {
        if([responseObject[@"msg"] isEqualToString:@"成功"]){
            MHPayCashViewController *vc = [[MHPayCashViewController alloc]init];
            vc.setupFlag = self.checkBtn.tag;
            [self.navigationController pushViewController: vc animated:YES];
            //进入支付保证金页面不能返回继续填写地址
            vc.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithImage:@"h5_back_normal" HighlightedImage:@"h5_back_hightlight" Target:self Action:@selector(backToRoot)];
            vc.navigationItem.rightBarButtonItem=nil;
            
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
        }
    } failure:nil];
    
}

- (IBAction)checkBtnClicked {
    self.checkBtn.tag = self.checkBtn.tag?0:1;
    [self.checkBtn setImage:[UIImage imageNamed:self.checkBtn.tag?@"check_selected":@"check_normal"] forState:UIControlStateNormal];
    [self.checkBtn setTitle:self.checkBtn.tag?@" 已选择上门安装":@" 是否上门安装" forState:UIControlStateNormal];
}


#pragma mark STPickerAreaDelegate
- (void)pickerArea:(STPickerArea *)pickerArea province:(NSString *)province city:(NSString *)city area:(NSString *)area
{
    self.areaLabel.text = [NSString stringWithFormat:@"%@ %@ %@", province, city, area];
}

-(void)backToRoot{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)selectArea{
    [self.view endEditing:YES];
    [self.pickerArea show];
}
@end
