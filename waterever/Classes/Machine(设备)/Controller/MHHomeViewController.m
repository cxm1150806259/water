//  MHHomeViewController.m
//  waterever
//
//  Created by qyyue on 2017/8/22.
//  Copyright © 2017年 qyyue. All rights reserved.
//

#import "MHHomeViewController.h"
#import "UIView+MHEXTENSION.h"
#import "MHApplyViewController.h"
#import "MHSetupProgressViewController.h"
#import "MHMachineActivedViewController.h"
#import "MHCommonHeader.h"
#import "MHUserInfoTool.h"
#import "MHApplyViewController.h"
#import "MHHomeStatusModel.h"
#import "MHAddressSubmitViewController.h"
#import "MHReachTool.h"
#import "UIButton+MHEXTENSION.h"
#import "MHCirclePerventView.h"
#import "MHAccountViewController.h"
#import "MHNavViewController.h"
#import "MHServeViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "MHCityInfoModel.h"
#import "SCLAlertView.h"
#import "JPUSHService.h"
#import "MHShareViewController.h"
#import "MHHomeTopView.h"
#import "MHMarginMoneyViewController.h"
#import "MHMessageCenterViewController.h"
#import "MHHomeActivityModel.h"
#import "ADAlertView.h"
#import "MHLoadActivityWebViewController.h"
#import "MHHomeLoadActivityWebViewController.h"
#import "MHPayCashViewController.h"

#define topViewMargin (SCREENBOUNDS.size.width - 200)*0.5

@interface MHHomeViewController ()<CLLocationManagerDelegate,UIScrollViewDelegate,MHHomeTopViewDelegate>

//app 3.0

@property(nonatomic,assign) BOOL firstComing;
@property (nonatomic, strong) CLLocationManager* locationManager;
@property (weak, nonatomic) IBOutlet UIButton *homeBtn;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property(nonatomic,strong ) UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *topScrollView;
@property(nonatomic,assign) NSInteger tempIndex;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityRankLabel;
@property (weak, nonatomic) IBOutlet UILabel *waterQualityLabel;
@property (weak, nonatomic) IBOutlet UILabel *machineStatusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *upImageView;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
@property (weak, nonatomic) IBOutlet UIButton *scrollLeftBtn;
@property (weak, nonatomic) IBOutlet UIButton *scrollRightBtn;
@property(nonatomic,strong)NSMutableArray *imgArr;

- (IBAction)scrollLeftBtnClicked;
- (IBAction)scrollRightBtnClicked;
- (IBAction)messageBtnClicked;
- (IBAction)homeBtnClicked;
- (IBAction)profileBtnClicked;
- (IBAction)serveBtnClicked;
- (IBAction)shareBtnClicked;

@property(nonatomic,strong)MHHomeStatusModel *tempModel;
@property(nonatomic,strong)NSMutableArray *modelArray;
@property(nonatomic,strong)NSMutableArray *activityModelArrayM;
@property(nonatomic,strong)NSString *tempMachineName;


@end

@implementation MHHomeViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id) self;
    [self checkMachineStatus];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.homeBtn setbuttonType:MHCategoryTypeBottom];
    [self addNotifier];
    [self getLocation];
    //每次启动请求一次
    [self loadPushMessage];
}

-(NSMutableArray *)activityModelArrayM{
    if (!_activityModelArrayM) {
        _activityModelArrayM = [NSMutableArray array];
    }
    return _activityModelArrayM;
}

-(void)loadPushMessage{
    [MHNetWorkTool GETWITHHEADER:[WATEREVERHOST stringByAppendingString:@"message/3.0/home_message"] parameters:nil success:^(id responseObject) {
        long code = [responseObject[@"code"] longValue];
        if(code == 0){
            self.activityModelArrayM = [MHHomeActivityModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            MHHomeActivityModel *model = [self.activityModelArrayM firstObject];
            NSLog(@"ads is %@",model.messageUrl);
            if (model.messageUrl == NULL) {
                NSLog(@"没有广告哦！！！");
            } else {
                [ADAlertView showInView:self.view theDelegate:self theADInfo:self.activityModelArrayM placeHolderImage:@"waterever_activity_normal"];
            }
            
        }
    } failure:nil];
}

-(void)clickAlertViewAtIndex:(NSInteger)index{
    MHHomeActivityModel *model = [self.activityModelArrayM objectAtIndex:index];
    MHHomeLoadActivityWebViewController *vc = [[MHHomeLoadActivityWebViewController alloc]init];
    vc.urlString = model.messageUrl;
    vc.title = model.title;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)getLocation{
    //检测定位功能是否开启
    if([CLLocationManager locationServicesEnabled]){
        if(!_locationManager){
            self.locationManager = [[CLLocationManager alloc] init];
            if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
                [self.locationManager requestWhenInUseAuthorization];
                [self.locationManager requestAlwaysAuthorization];
            }
            //设置代理
            [self.locationManager setDelegate:self];
            //设置定位精度
            [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
            //设置距离筛选
            [self.locationManager setDistanceFilter:100];
            //开始定位
            [self.locationManager startUpdatingLocation];
        }
    }else{
        //没有开启定位功能
    }
}

#pragma mark - CLLocationManangerDelegate
//定位成功以后调用
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    [self.locationManager stopUpdatingLocation];
    CLLocation* location = locations.lastObject;
    
    [self reverseGeocoder:location];
}

#pragma mark Geocoder
//反地理编码
- (void)reverseGeocoder:(CLLocation *)currentLocation {
    
    CLGeocoder* geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if(error || placemarks.count == 0){
            NSLog(@"error = %@",error);
        }else{
            CLPlacemark* placemark = placemarks.firstObject;
            NSString *cityString = [[placemark addressDictionary] objectForKey:@"City"];
            self.cityLabel.text = cityString;
            NSString *areaName = [[placemark addressDictionary] objectForKey:@"SubLocality"];
            if(areaName){
                //获取到地区之后再获取城市信息
                self.cityRankLabel.hidden = NO;
                self.upImageView.hidden = NO;
                [self getCityInfoWithAreaName:areaName];
            }
        }
    }];
}

-(void)addNotifier{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(withdrayMarginMoneyDone) name:@"MHMachineCountRefresh" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkDidReceiveMessage) name:kJPFNetworkDidReceiveMessageNotification object:nil];
}

-(void)withdrayMarginMoneyDone{
    //提取保证金后删除顶部滚动view字控件 重新创建
    for (MHHomeTopView *mhView in self.topScrollView.subviews) {
        [mhView removeFromSuperview];
    }
    self.pageControl.currentPage = 0;
    self.tempIndex = 0;
    self.firstComing = NO;
    [self.topScrollView setContentOffset:CGPointZero];
}

- (void)networkDidReceiveMessage{
    //收到了新消息
    [self.messageBtn setImage:[UIImage imageNamed:@"icon_message_new"] forState:UIControlStateNormal];
    [MHUserInfoTool sharedMHUserInfoTool].hasNewMsg = YES;
    [MHUserInfoTool saveUserInfo];
}

-(void)reachabilityChanged:(NSNotification *)noti{
    Reachability *currentReach = [noti object];
    NSParameterAssert([currentReach isKindOfClass:[Reachability class]]);
    
    if([currentReach currentReachabilityStatus] == NotReachable){
        self.homeBtn.userInteractionEnabled = NO;
    }else{
        //有网络
        self.homeBtn.userInteractionEnabled = YES;
        [self checkMachineStatus];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(UIPageControl *)pageControl{
    if(!_pageControl){
        _pageControl = [[UIPageControl alloc]init];
        _pageControl.centerX=self.topView.centerX;
        _pageControl.y=CGRectGetMaxY(self.topScrollView.frame) + 30;
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:1 alpha:0.5];
        [self.topView addSubview:_pageControl];
    }
    return _pageControl;
}

-(void)initScrollView{
    NSUInteger machineCount = self.modelArray.count + 1;
    self.topScrollView.contentSize=CGSizeMake(self.topScrollView.width*machineCount, 0);
    self.topScrollView.delegate=self;
    int totalSubviews = self.topScrollView.subviews.count;
    
    //如果有新设备 添加homeTopView，否则重新设置当前页的model
    if(totalSubviews < machineCount){
        for(int i=totalSubviews;i<machineCount;i++){
            MHHomeTopView *topView = [[MHHomeTopView alloc]init];
            topView.delegate=self;
            if(i == self.modelArray.count){
                NSLog(@"没有模型啦");
            }else{
                MHHomeStatusModel *model = [self.modelArray objectAtIndex:i];
                topView.homeStatusModel = model;
                //添加手势
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(withdrayMarginMoney)];
                tap.accessibilityLabel = model.deviceName;
                [topView addGestureRecognizer:tap];
            }
            topView.x = SCREENBOUNDS.size.width*i + topViewMargin;
            [self.topScrollView addSubview:topView];
        }
        
    }else{
        if(self.tempIndex == machineCount - 1 ){
            //一键申请 没有model
        }else{
            //获取当前的homeTopView
            MHHomeStatusModel *model = [self.modelArray objectAtIndex:self.tempIndex];
            MHHomeTopView *currentHomeTopView = [self.topScrollView.subviews objectAtIndex:self.tempIndex];
            currentHomeTopView.homeStatusModel = model;
            self.tempModel = model;
            self.tempMachineName = model.deviceName;
            [self setHomeBtnWithStatusModel:model];
        }
    }
    self.pageControl.numberOfPages=machineCount;
}

-(void)withdrayMarginMoney{
    MHMarginMoneyViewController *vc = [[MHMarginMoneyViewController alloc]init];
    [vc.view layoutIfNeeded];
    vc.machineNameTextField.text = self.tempMachineName;;
    [self.navigationController pushViewController:vc animated:YES];
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

#pragma mark - MHHomeTopViewDelegate
-(void)editMachineName:(UILabel *)nameLabel{
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
            nameLabel.text = textField.text;
            self.tempMachineName = textField.text;
            [self editMachineNameWithMachineName:textField.text];
        }
    }];
    [alert showEdit:self title:nil subTitle:[NSString stringWithFormat:@"\n%@\n",nameLabel.text] closeButtonTitle:@"取消" duration:0.0f];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    self.scrollRightBtn.enabled = YES;
    self.scrollLeftBtn.enabled = YES;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat contentOffX=scrollView.contentOffset.x;
    NSInteger page=(contentOffX*1.0/scrollView.width)+0.5;
    self.pageControl.currentPage=page;
    
    NSInteger index = contentOffX/SCREENBOUNDS.size.width;
    if(index != self.tempIndex){
        self.tempIndex = index;
        NSLog(@"%ld",self.tempIndex);
        //获取index后发送通知 切换按钮状态
        if(self.tempIndex == self.modelArray.count){
            //超出模型数组 默认一件申请
            self.tempModel = nil;
            [self setHomeBtnWithStatusModel:nil];
        }else{
            //获得对应的model
            MHHomeStatusModel *model = [self.modelArray objectAtIndex:self.tempIndex];
            self.tempModel = model;
            self.tempMachineName = model.deviceName;
            MHUserInfoTool *userInfo = [MHUserInfoTool sharedMHUserInfoTool];
            if([model.personDeviceId intValue]!=-1){
                userInfo.personDeviceId = model.personDeviceId;
            }
            //暂时每次都存下来
            userInfo.applyDeviceId=model.applyDeviceId;
            userInfo.deviceId =model.deviceId;
            userInfo.applyStatus = model.applyStatus;//之前都在放在保存后面
            [MHUserInfoTool saveUserInfo];
            [self setHomeBtnWithStatusModel:model];
            
        }
    }
}

-(void)checkMachineStatus{
    [SVProgressHUD showWithStatus:@"正在加载..."];
    MHUserInfoTool *userInfo = [MHUserInfoTool sharedMHUserInfoTool];
    [self.messageBtn setImage:[UIImage imageNamed:userInfo.hasNewMsg?@"icon_message_new":@"icon_message"] forState:UIControlStateNormal];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:userInfo.personId forKey:@"person_id"];
    
    AFHTTPSessionManager *mgr=[AFHTTPSessionManager manager];
    [mgr.requestSerializer setValue:userInfo.token forHTTPHeaderField:@"Authorization"];
    
    [MHNetWorkTool GETWITHHEADER:[WATEREVERHOST stringByAppendingFormat:@"device/2.4/home/%@",userInfo.personId] parameters:parameters success:^(id responseObject) {
        [SVProgressHUD dismiss];
        self.homeBtn.enabled = YES;
        long code = [responseObject[@"code"] longValue];
        if(code == 0){
            
            if([responseObject[@"msg"] isEqualToString:@"用户未申请设备"]){
                self.homeBtn.tag = 88;
                return;
            }
            self.homeBtn.tag = 0;
            NSMutableArray *modelArray = [MHHomeStatusModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            self.modelArray = modelArray;
            
            //第一次进来设置默认信息
            if(!self.firstComing){
                self.firstComing = YES;
                //设置水质信息
                MHHomeStatusModel *firstModel = nil;
                if(modelArray.count){
                   firstModel = [modelArray objectAtIndex:0];
                }
                
//                if(!userInfo.personDeviceId&&[firstModel.personDeviceId intValue]!=-1){
//                    userInfo.personDeviceId = firstModel.personDeviceId;
//                }
                self.tempMachineName = firstModel.deviceName;
                
                if([firstModel.personDeviceId intValue]!=-1){
                    userInfo.personDeviceId = firstModel.personDeviceId;
                }
                //暂时每次都存下来
                userInfo.applyDeviceId = firstModel.applyDeviceId;
                userInfo.deviceId =firstModel.deviceId;
                userInfo.applyStatus = firstModel.applyStatus;//之前都在放在保存后面
                [MHUserInfoTool saveUserInfo];
                //设置默认的homeBtn
                [self setHomeBtnWithStatusModel:firstModel];
                self.waterQualityLabel.text = firstModel.levelName?firstModel.levelName:@"— —";
                self.tempModel = firstModel;
            }
            
            //判断是否显示可滚动按钮
            if(!modelArray.count){
                //0
                self.scrollLeftBtn.hidden = YES;
                self.scrollRightBtn.hidden = YES;
                
                self.pageControl.hidden = YES;
            }else{
                //有设备
                self.scrollLeftBtn.hidden = NO;
                self.scrollRightBtn.hidden = NO;
                self.pageControl.hidden = NO;
            }
            
            if(self.modelArray.count){
                MHHomeStatusModel *model = [self.modelArray objectAtIndex:self.tempIndex];
                self.tempModel = model;
                [self setHomeBtnWithStatusModel:model];
            }
            
            //获取成功后再设置顶部scrollview
            [self initScrollView];
            
        }else if(code == -1){
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
        }

    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络超时"];
    }];
}

-(void)setHomeBtnWithStatusModel:(MHHomeStatusModel *)model{
    NSArray *statusArr1 = @[@"1",@"2",@"8"];
    NSArray *statusArr2 = @[@"4",@"5",@"6"];//一键申请
    NSArray *statusArr3 = @[@"10",@"11"];//继续申请 @"7",
    if(model){
        if([statusArr1 containsObject:model.applyStatus]){
            self.machineStatusLabel.text = @"— —";
            [self.homeBtn setTitle:@"申请进程" forState:UIControlStateNormal];
            [self.homeBtn setImage:[UIImage imageNamed:@"home_setupProgress"] forState:UIControlStateNormal];
        }else if([statusArr2 containsObject:model.applyStatus]||[statusArr3 containsObject:model.applyStatus]){
            //未申请
            self.machineStatusLabel.text = @"— —";
            
            if([statusArr3 containsObject:model.applyStatus]){
                [self.homeBtn setTitle:@"继续申请" forState:UIControlStateNormal];
            }else{
                [self.homeBtn setTitle:@"一键申请" forState:UIControlStateNormal];
            }
            
            [self.homeBtn setImage:[UIImage imageNamed:@"fingure"] forState:UIControlStateNormal];
        }else if([model.applyStatus isEqualToString:@"3"]){
            //设备已安装
            [self.homeBtn setTitle:@"设备详情" forState:UIControlStateNormal];
            [self.homeBtn setImage:[UIImage imageNamed:@"home_search"] forState:UIControlStateNormal];
            
            switch ([model.deviceStatus intValue]) {
                case 2:
                    self.machineStatusLabel.text = @"使用中";
                    break;
                case 3:
                    self.machineStatusLabel.text = @"已停机";
                    break;
                case 4:
                    self.machineStatusLabel.text = @"已冻结";
                    break;
                case 5:
                    self.machineStatusLabel.text = @"已拆机";
                    break;
                case 6:
                    self.machineStatusLabel.text = @"未开机";
                    break;
                    
                default:
                    break;
            }
        }else{
            //多余的状态出现的时候显示默认
            self.machineStatusLabel.text = @"— —";
            [self.homeBtn setTitle:@"一键申请" forState:UIControlStateNormal];
            [self.homeBtn setImage:[UIImage imageNamed:@"fingure"] forState:UIControlStateNormal];
        }
    }else{
        //如果model没获取到就显示默认
        self.machineStatusLabel.text = @"— —";
        [self.homeBtn setTitle:@"一键申请" forState:UIControlStateNormal];
        [self.homeBtn setImage:[UIImage imageNamed:@"fingure"] forState:UIControlStateNormal];
    }
}

-(void)getCityInfoWithAreaName:(NSString *)areaName{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:areaName forKey:@"areaname"];
    [MHNetWorkTool POST:[WATEREVERHOST stringByAppendingString:@"tools/get_water_qc"] parameters:parameters success:^(id responseObject) {
        NSString *jsonString = [NSString replaceUnicode:responseObject[@"data"]];
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        NSMutableArray *cityInfoModelArrM = [MHCityInfoModel mj_objectArrayWithKeyValuesArray:dic[@"data"]];
        MHCityInfoModel *model = [cityInfoModelArrM firstObject];
        self.cityRankLabel.text = model.citytop?model.citytop:@"— —";
    } failure:nil];
}

- (void)applyMachine{
    
    MHUserInfoTool *userInfo = [MHUserInfoTool sharedMHUserInfoTool];
    
    if([userInfo.personTypeId intValue] == 1){
        //没有申请权限
        [SVProgressHUD showErrorWithStatus:userInfo.personAccount];
        return;
    }
    
    if([self.tempModel.applyStatus isEqualToString:@"10"]||[self.tempModel.applyStatus isEqualToString:@"11"]){
        MHAddressSubmitViewController *vc = [[MHAddressSubmitViewController alloc]init];
        vc.applyStatus = self.tempModel.applyStatus;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
//    int applyStatus = [self.tempModel.applyStatus intValue];
//    if(applyStatus!=4&&applyStatus!=5){
//        if(self.tempModel.applyDeviceId){
//            MHAddressSubmitViewController *vc = [[MHAddressSubmitViewController alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];
//            return;
//        }
//    }
    
    MHApplyViewController *applyVc = [[MHApplyViewController alloc]init];
    [self.navigationController pushViewController:applyVc animated:YES];
}

- (void)searchSetupProgress{
    MHSetupProgressViewController *setupProgressVc = [[MHSetupProgressViewController alloc]init];
    setupProgressVc.model = self.tempModel;
    setupProgressVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:setupProgressVc animated:YES];
}

- (void)machineActived{
    MHMachineActivedViewController *vc = [[MHMachineActivedViewController alloc]init];
    [vc.view layoutIfNeeded];
    vc.machineStatusLabel.text = [NSString stringWithFormat:@"设备状态：%@",self.machineStatusLabel.text];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)scrollLeftBtnClicked {
    CGFloat currentX = self.topScrollView.contentOffset.x;
    CGFloat scrollX = currentX - SCREENBOUNDS.size.width;
    if(scrollX < 0) return;
    [self.topScrollView setContentOffset:CGPointMake(scrollX, 0) animated:YES];
    //要写在滚动之后
    self.scrollLeftBtn.enabled = NO;
}

- (IBAction)scrollRightBtnClicked {
    CGFloat currentX = self.topScrollView.contentOffset.x;
    CGFloat scrollX = currentX + SCREENBOUNDS.size.width;
    if(scrollX >= self.topScrollView.contentSize.width) return;
    [self.topScrollView setContentOffset:CGPointMake(scrollX, 0) animated:YES];
    self.scrollRightBtn.enabled = NO;
}

- (IBAction)messageBtnClicked {
    MHMessageCenterViewController *vc = [[MHMessageCenterViewController alloc]init];
    MHNavViewController *navVc = [[MHNavViewController alloc] initWithRootViewController:vc];
    [self presentViewController:navVc animated:YES completion:nil];
}

- (IBAction)homeBtnClicked {
    NSArray *statusArr1 = @[@"1",@"2",@"8"];
    NSArray *statusArr2 = @[@"4",@"5",@"6"];//一键申请
    NSArray *statusArr3 = @[@"10",@"11"];//继续申请 @"7",
    if(self.tempModel){
        if([statusArr1 containsObject:self.tempModel.applyStatus]){
            [self searchSetupProgress];
        }else if([statusArr2 containsObject:self.tempModel.applyStatus]||[statusArr3 containsObject:self.tempModel.applyStatus]){
            [self applyMachine];
        }else if([self.tempModel.applyStatus isEqualToString:@"3"]){
            [self machineActived];
        }else{
            //多余的状态
            [SVProgressHUD showErrorWithStatus:@"未知错误,请稍后重试"];
        }
    }else if(self.homeBtn.tag == 88){
        //用户未申请设备
        [self applyMachine];
    }else{
        [self applyMachine];
    }
}

- (IBAction)profileBtnClicked {
    MHAccountViewController *vc = [[MHAccountViewController alloc]init];
    MHNavViewController *navVc = [[MHNavViewController alloc] initWithRootViewController:vc];
    [self presentViewController:navVc animated:YES completion:nil];
}

//客服
- (IBAction)serveBtnClicked {
//    NSMutableString *str=[[NSMutableString alloc]initWithFormat:@"tel:400-1003-365",@"客服号码"];
//
//    UIWebView *callWebview = [[UIWebView alloc]init];
//
//    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
//
//    [self.view addSubview:callWebview];
    
    NSString *phone = @"400-1003-365";
    //拨打电话代码
    UIApplication *app = [UIApplication sharedApplication];
    NSMutableString * phoneStr=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phone];
    NSURL *phoneUrl = [NSURL URLWithString:phoneStr];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if ([app canOpenURL:phoneUrl]) {
            [app openURL:phoneUrl];
        }
    });
//    MHServeViewController *vc = [[MHServeViewController alloc]init];
//    vc.urlString = @"http://japi.waterever.cn/service/";
//    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)shareBtnClicked {
    MHShareViewController *vc = [[MHShareViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
