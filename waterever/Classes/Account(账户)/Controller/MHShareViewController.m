//
//  MHShareViewController.m
//  waterever
//
//  Created by qyyue on 2017/8/24.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHShareViewController.h"
#import "MHCommonHeader.h"
#import <UMSocialCore/UMSocialCore.h>
#import "MHShareModel.h"
#import "MHSeeShareRuleViewController.h"
#import "SGQRCode.h"

@interface MHShareViewController ()
@property(nonatomic,strong) MHShareModel *shareModel;
@property (weak, nonatomic) IBOutlet UIImageView *myQRCodeImageView;
@property (weak, nonatomic) IBOutlet UILabel *rewardLabel;

- (IBAction)wechatShareBtnClicked;
- (IBAction)friendSquareShareBtnClicked;
- (IBAction)sinaShareBtnClicked;
- (IBAction)qqShareBtnClicked;
- (IBAction)seeRuleBtnClicked;

@end

@implementation MHShareViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.pushType == 1){
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"news_btn_back_black" HighlightedImage:nil Target:self Action:@selector(back)];
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.translucent = NO;
        
        NSDictionary *titleAttribute=@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:18]};
        [self.navigationController.navigationBar setTitleTextAttributes:titleAttribute];
    }
}

//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    if(self.pushType == 1){
//        self.navigationController.navigationBar.translucent = YES;
//    }
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的分享";
    self.myQRCodeImageView.image = [SGQRCodeGenerateManager SG_generateWithDefaultQRCodeData:[NSString stringWithFormat:@"https://api.waterever.cn/share.html?version=2.0&userId=%@",[MHUserInfoTool sharedMHUserInfoTool].personId] imageViewWidth:60];
    [self getShareModel];
}

-(void)getShareModel{
    MHUserInfoTool *userInfo = [MHUserInfoTool sharedMHUserInfoTool];
    [MHNetWorkTool GETWITHHEADER:[WATEREVERHOST stringByAppendingFormat:@"god/2.0/share/%@",userInfo.personId] parameters:@{@"person_id":userInfo.personId} success:^(id responseObject) {
        int code = [responseObject[@"code"] intValue];
        if(code == 0 ){
            self.shareModel = [MHShareModel mj_objectWithKeyValues:responseObject[@"data"]];
            userInfo.shareRuleUrlString = self.shareModel.shareRuleUrl;
            NSString *reward = self.shareModel.reward;
            NSString *reward_behind = @"元分享红包";
            self.rewardLabel.text =[@"赢" stringByAppendingFormat:@"%@%@",reward,reward_behind] ;
        }
    } failure:nil];
}

- (IBAction)wechatShareBtnClicked {
    [self shareWithPlatformType:UMSocialPlatformType_WechatSession];
}

- (IBAction)friendSquareShareBtnClicked {
    [self shareWithPlatformType:UMSocialPlatformType_WechatTimeLine];
}

- (IBAction)sinaShareBtnClicked {
    [self shareWithPlatformType:UMSocialPlatformType_Sina];
}

- (IBAction)qqShareBtnClicked {
    [self shareWithPlatformType:UMSocialPlatformType_QQ];
}

- (IBAction)seeRuleBtnClicked {
    MHUserInfoTool *userInfo = [MHUserInfoTool sharedMHUserInfoTool];
    if(!userInfo.shareRuleUrlString){
        [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
        return;
    }
    [MHUserInfoTool saveUserInfo];
    MHSeeShareRuleViewController *vc = [[MHSeeShareRuleViewController alloc]init];
    vc.pushType = self.pushType;
    vc.urlString = userInfo.shareRuleUrlString;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)shareWithPlatformType:(UMSocialPlatformType)platformType
{
    if(self.shareModel){
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
//        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.shareModel.title descr:self.shareModel.text thumImage:self.shareModel.imageUrl];
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.shareModel.title descr:self.shareModel.text thumImage:[UIImage imageNamed:@"share-logo"]];

       
        //设置网页地址
        shareObject.webpageUrl = self.shareModel.titleUrl;
        
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            if (error) {
                UMSocialLogInfo(@"************Share fail with error %@*********",error);
            }else{
                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                    UMSocialShareResponse *resp = data;
                    //分享结果消息
                    UMSocialLogInfo(@"response message is %@",resp.message);
                    //第三方原始返回的数据
                    UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                    
                }else{
                    UMSocialLogInfo(@"response data is %@",data);
                }
            }
        }];
    }else{
        [self getShareModel];
    }
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
