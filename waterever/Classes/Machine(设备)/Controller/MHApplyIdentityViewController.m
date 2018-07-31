//
//  MHApplyIdentityViewController.m
//  waterever
//
//  Created by qyyue on 2017/8/24.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHApplyIdentityViewController.h"
#import "MHCommonHeader.h"
#import "MHUserInfoTool.h"
#import "MHAddressSubmitViewController.h"

@interface MHApplyIdentityViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
- (IBAction)vertifyBtnClicked;
- (IBAction)frontBtnClicked;
- (IBAction)behindBtnClicked;

@property (weak, nonatomic) IBOutlet UIButton *frontBtn;
@property (weak, nonatomic) IBOutlet UIButton *behindBtn;


@property(nonatomic,strong) NSData *frontImageData;
@property(nonatomic,strong) NSData *behindImageData;
@property(nonatomic,assign) int flag;
@end

@implementation MHApplyIdentityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"上传身份证";
}

- (IBAction)vertifyBtnClicked {
    if(!self.frontBtn.enabled&&!self.behindBtn.enabled){
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:self.identifyCard forKey:@"idcard"];
        MHUserInfoTool *userInfo = [MHUserInfoTool sharedMHUserInfoTool];
        AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        [mgr.requestSerializer setValue:userInfo.token forHTTPHeaderField:@"Authorization"];
        [mgr POST:[WATEREVERHOST stringByAppendingString:@"tools/2.0/upload_idcard"] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFileData:self.frontImageData name:@"front_idcard" fileName:@"front_idcard.jpeg" mimeType:@"image/jpeg"];
            [formData appendPartWithFileData:self.behindImageData name:@"back_idcard" fileName:@"back_idcard.jpeg" mimeType:@"image/jpeg"];
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
            MHAddressSubmitViewController *vc = [[MHAddressSubmitViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
                vc.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithImage:@"h5_back_normal" HighlightedImage:@"h5_back_hightlight" Target:self Action:@selector(backToRoot)];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if(error){
                NSLog(@"%@",error);
            }
        }];

    }else{
        [SVProgressHUD showErrorWithStatus:@"请上传身份证照片"];
    }
}

-(void)backToRoot{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)frontBtnClicked {
    self.flag = 1;
    [self addCamera];
}

- (IBAction)behindBtnClicked {
    self.flag = 0;
    [self addCamera];
}

- (void)addCamera
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    //判断是否可以打开照相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"]) {
        
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        if(self.flag == 1){
            [self.frontBtn setBackgroundImage:image forState:UIControlStateNormal];
            self.frontImageData = UIImageJPEGRepresentation(image, 0.1);
            self.frontBtn.enabled = NO;
        }else{
            [self.behindBtn setBackgroundImage:image forState:UIControlStateNormal];
            self.behindImageData = UIImageJPEGRepresentation(image, 0.1);
            self.behindBtn.enabled = NO;
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
