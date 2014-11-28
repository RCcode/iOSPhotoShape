//
//  PHO_AboutUsViewController.m
//  IOSShape
//
//  Created by wsq-wlq on 14-5-29.
//  Copyright (c) 2014年 wsq-wlq. All rights reserved.
//

#import "PHO_AboutUsViewController.h"
#import "PHO_AboutUsTableViewCell.h"
#import "MBProgressHUD.h"
#import <MessageUI/MFMailComposeViewController.h>

#import "PHO_DataRequest.h"

#import "PHO_AppDelegate.h"


@interface PHO_AboutUsViewController ()<UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>
{
    NSArray *_imageNames;
    NSArray *_titles;
}

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PHO_AboutUsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    _imageNames = @[@"about-us_update",@"about-us_marking",@"about-us_feedback",@"about-us_share",@"about-us_love-me"];
    
//    _titles = @[LocalizedString(@"update", nil),
//                LocalizedString(@"score", nil),
//                LocalizedString(@"feedback", nil),
//                LocalizedString(@"share", nil),
//                LocalizedString(@"follow_us", nil)];
    
    _titles = @[LocalizedString(@"aboutView_update", @""),
                LocalizedString(@"aboutView_score", @""),
                LocalizedString(@"aboutView_feedback", @""),
                LocalizedString(@"aboutView_shareApp", @""),
                LocalizedString(@"aboutView_followUs", @""),];
 
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 16, 46, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = LocalizedString(@"shareView_share", @"");
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:22];
    self.navigationItem.titleView = titleLabel;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, 30, 30)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"share_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //title
    _versionLabel.text = [NSString stringWithFormat:@"version: %@", appVersion()];
    
    
    //tabelView
    _tableView.alwaysBounceHorizontal = NO;
    _tableView.alwaysBounceVertical = NO;
}

- (void)backButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UITableVeiwDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _imageNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PHO_AboutUsTableViewCell *cell = [PHO_AboutUsTableViewCell moreTabelViewCellWithTableView:tableView IndexPath:indexPath];
    
    //设置数据
    NSUInteger index = indexPath.row;
    [cell setImageName:_imageNames[index] AndTitle:_titles[index]];
    
    return cell;
}


//- (void)evaluate
//{
//    SKStoreProductViewController *storeProductViewContorller = [[SKStoreProductViewController alloc] init];
//    storeProductViewContorller.delegate = self;
//    [storeProductViewContorller loadProductWithParameters: @{SKStoreProductParameterITunesItemIdentifier : appleID} completionBlock:^(BOOL result, NSError *error)
//    {
//        if(error)
//        {
//            NSLog(@"error %@ with userInfo %@",error,[error userInfo]);
//        }
//        else
//        {
//            [self presentViewController:storeProductViewContorller animated:YES completion:^{ }];
//        }
//    }];
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //隐藏moreTable
    [self touchesBegan:nil withEvent:nil];
    
    switch (indexPath.row) {
        case 0://更新
        {
            [self sendMessage:@"home_menu_update" and:@"home"];
            NSString *upDateString = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", appleID];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:upDateString]];
        }
            
            break;
        case 1://评分
        {
//            if ([[UIDevice currentDevice].systemVersion intValue] >= 6.0 ){ [self evaluate];}
            [self sendMessage:@"home_menu_tateus" and:@"home"];
            NSString *evaluateString = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", appleID];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:evaluateString]];
        }
            break;
        case 2://反馈
        {
            
            [self sendMessage:@"home_menu_feedback" and:@"home"];
            
            // app名称 版本
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
            NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
            
            //设备型号 系统版本
            NSString *deviceName = doDevicePlatform();
            NSString *deviceSystemName = [[UIDevice currentDevice] systemName];
            NSString *deviceSystemVer = [[UIDevice currentDevice] systemVersion];
            
            //设备分辨率
            CGFloat scale = [UIScreen mainScreen].scale;
            CGFloat resolutionW = [UIScreen mainScreen].bounds.size.width * scale;
            CGFloat resolutionH = [UIScreen mainScreen].bounds.size.height * scale;
            NSString *resolution = [NSString stringWithFormat:@"%.f * %.f", resolutionW, resolutionH];
            
            //本地语言
            NSString *language = [[NSLocale preferredLanguages] firstObject];
            
            //            NSString *diveceInfo = @"app版本号 手机型号 手机系统版本 分辨率 语言";
            NSString *diveceInfo = [NSString stringWithFormat:@"%@ %@, %@, %@ %@, %@, %@", app_Name, app_Version, deviceName, deviceSystemName, deviceSystemVer,  resolution, language];
            
            //直接发邮件
            MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
            if(!picker) break;
            picker.mailComposeDelegate =self;
            NSString *subject = [NSString stringWithFormat:@"%@ %@ (iOS)",LocalizedString(@"app_name", nil), LocalizedString(@"feedback", nil)];
            [picker setSubject:subject];
            [picker setToRecipients:@[kFeedbackEmail]];
            [picker setMessageBody:diveceInfo isHTML:NO];
            [self presentViewController:picker animated:YES completion:nil];
        }
            break;
        case 3://分享应用
        {
            
            [self sendMessage:@"home_menu_share" and:@"home"];
            
            
            //需要分享的内容
            NSString *shareContent = [NSString stringWithFormat:@"%@ http://bit.ly/1zBFbL7",LocalizedString(@"aboutView_content", @"")];
            NSArray *activityItems = @[shareContent];
            
            UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
            __weak UIActivityViewController *blockActivityVC = activityVC;
            
            activityVC.completionHandler = ^(NSString *activityType,BOOL completed){
                if(completed){
                    MBProgressHUD *hud = showMBProgressHUD(LocalizedString(@"shareSuccess", @""), NO);
                    [hud performSelector:@selector(hide:) withObject:nil afterDelay:1.5];
                }
                [blockActivityVC dismissViewControllerAnimated:YES completion:nil];
            };
            [self presentViewController:activityVC animated:YES completion:nil];
        }
            
            break;
        case 4://关注我
            [MobClick event:@"home_menu_followus" label:@"Home"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kFollwUsURL]];
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark 版本检测
- (void)checkVersion
{
    NSString *urlStr = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",appleID];
    PHO_DataRequest *request = [[PHO_DataRequest alloc] initWithDelegate:self];
    [request updateVersion:urlStr withTag:10];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 123)
    {
        if(buttonIndex==0)
        {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/qun-xiang-dao/id%@?ls=1&mt=8",appleID ]];
            [[UIApplication sharedApplication]openURL:url];
        }
    }
    
}


#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [controller dismissViewControllerAnimated:YES completion:^{
        if(MFMailComposeResultSent == result){
            MBProgressHUD *hud = showMBProgressHUD(@"success", NO);
            [hud performSelector:@selector(hide:) withObject:nil afterDelay:1.5];
        }
    }];
}

#pragma mark 发送统计

- (void)sendMessage:(NSString *)label and:(NSString *)event
{
    //友盟统计
    [MobClick event:event label:nil];
    
    //flurryAnalytics
    [Flurry logEvent:event];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
