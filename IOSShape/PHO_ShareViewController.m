//
//  PHO_ShareViewController.m
//  IOSShape
//
//  Created by wsq-wlq on 14-5-22.
//  Copyright (c) 2014年 wsq-wlq. All rights reserved.
//

#import "PHO_ShareViewController.h"

#import "MBProgressHUD+Add.h"

#import <Social/Social.h>
#import <Accounts/Accounts.h>

#import "PHO_AppDelegate.h"
#import "FONT_SQLMassager.h"
#import "PHO_DataRequest.h"
#import "UIImage+processing.h"
#import "ME_AppInfo.h"
#import "UIImageView+WebCache.h"


#define kTheBestImagePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"shareImage.igo"]
#define kToMorePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"shareImage.jpg"]


@interface PHO_ShareViewController ()
@end

@implementation PHO_ShareViewController
@synthesize isSaved;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 16, 46, 44)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = LocalizedString(@"shareView_share", @"");
        titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:22];
        self.navigationItem.titleView = titleLabel;
        
        // Custom initialization
    }
    return self;
}

- (void)getImage:(UIImage *)image
{
    theBestImage = image;
    
    PHO_AppDelegate *app = (PHO_AppDelegate *)[UIApplication sharedApplication].delegate;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    if (app.isOn)
    {
        [userDefault setObject:[NSNumber numberWithBool:YES] forKey:@"waterMark"];
        saveImage = [UIImage addwaterMarkOrnotWithImage:theBestImage];
    }
    else
    {
        saveImage = theBestImage;
        [userDefault setObject:[NSNumber numberWithBool:NO] forKey:@"waterMark"];
    }
    
    [userDefault synchronize];

    isSaved = NO;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //导航
//    UIView *customNavgationView = [[UIView alloc]initWithFrame:CGRectMake(0, TOPORIGIN_Y, 320, 44)];
//    NSLog(@"%d",TOPORIGIN_Y);
//    customNavgationView.backgroundColor = [UIColor redColor];
//    [self.view addSubview:customNavgationView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    isSwitchPressed = YES;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, 30, 30)];
//    [backButton setBackgroundImage:[UIImage imageNamed:@"share_back"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"share_back"] forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    backButton.contentMode = UIViewContentModeCenter;
//    backButton.i
    [backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *popToHomeViewButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [popToHomeViewButton setFrame:CGRectMake(0, 0, 30, 30)];
    [popToHomeViewButton addTarget:self action:@selector(popToHomeViewButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [popToHomeViewButton setBackgroundImage:[UIImage imageNamed:@"edit_home.png"] forState:UIControlStateNormal];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:popToHomeViewButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    NSArray *shareToArray = [NSArray arrayWithObjects:@"相册.png", @"share-to-insta.png", @"fb.png", @"更多.png",nil];
//    NSArray *shareToNameArray = [NSArray arrayWithObjects:@"save", @"instagram", @"faceBook", @"more", nil];
    NSArray *shareToNameArray = @[LocalizedString(@"shareView_save", @""),
                                  @"Instagram",@"Facebook",
                                  LocalizedString(@"shareView_more", @"")];
    
    for (int i = 0; i < 4; i ++)
    {
        @autoreleasepool
        {
            UIButton *shareToButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [shareToButton setBackgroundImage:[UIImage imageNamed:[shareToArray objectAtIndex:i]] forState:UIControlStateNormal];
            shareToButton.frame = CGRectMake(10+25*i+56*i, 20, 56, 56);
            shareToButton.tag = i + 10;
            [shareToButton setTitle:[shareToNameArray objectAtIndex:i] forState:UIControlStateNormal];
            [shareToButton setTitleColor:colorWithHexString(@"#7e7e7e") forState:UIControlStateNormal];
            [shareToButton setTitleEdgeInsets:UIEdgeInsetsMake(80, 0, 0, 0)];
            shareToButton.titleLabel.textAlignment = NSTextAlignmentCenter;
            shareToButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
            [shareToButton addTarget:self action:@selector(shareToButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:shareToButton];
        }
    }
    
    PHO_AppDelegate *app = (PHO_AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UILabel *markLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 105, 240, 40)];
    markLabel.text = LocalizedString(@"showwatermark", nil);
    markLabel.textColor = [UIColor blackColor];
    markLabel.font = [UIFont systemFontOfSize:14.f];
    [self.view addSubview:markLabel];
    
    UISwitch *switchBtn = [[UISwitch alloc]initWithFrame:CGRectMake(250, 110, 80, 40)];
    switchBtn.onTintColor = colorWithHexString(@"fe8c3f");
    if (app.isOn)
    {
        [switchBtn setOn:YES];
    }
    else
    {
        [switchBtn setOn:NO];
    }
    [switchBtn addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:switchBtn];
    
    //判断是否已下载完数据
    if (app.appsArray.count == 0)
    {
        //查看数据库中是否存在
        if ([[FONT_SQLMassager shareStance] getAllData].count == 0)
        {
            //Bundle Id
            NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
            NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
            NSString *currentVersion = [infoDict objectForKey:@"CFBundleVersion"];
            NSString *language = [[NSLocale preferredLanguages] firstObject];
            if ([language isEqualToString:@"zh-Hans"])
            {
                language = @"zh";
            }
            else if ([language isEqualToString:@"zh-Hant"])
            {
                language = @"zh_TW";
            }
            NSDictionary *dic = @{@"appId":[NSNumber numberWithInt:moreAppID],@"packageName":bundleIdentifier,@"language":language,@"version":currentVersion,@"platform":[NSNumber numberWithInt:0]};
            PHO_DataRequest *request = [[PHO_DataRequest alloc] initWithDelegate:self];
            [request moreApp:dic withTag:11];
        }
        else
        {
            app.appsArray = [[FONT_SQLMassager shareStance] getAllData];
        }
    }
    
    appMoretableView = [[UITableView alloc]initWithFrame:CGRectZero];
    
    if (iPhone5)
    {
        appMoretableView.frame = CGRectMake(0, 165, 320, kScreen_Height-210-50);
    }
    else
    {
        appMoretableView.frame = CGRectMake(0, 165, 320, kScreen_Height-210);
    }
    
    [appMoretableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    appMoretableView.delegate = self;
    appMoretableView.dataSource = self;
    appMoretableView.backgroundColor = [UIColor clearColor];
    appMoretableView.backgroundView = nil;
    appMoretableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:appMoretableView];
    
    
    // Do any additional setup after loading the view.
}

- (void)switchChanged:(UISwitch *)switchBtn
{
    PHO_AppDelegate *app = (PHO_AppDelegate *)[UIApplication sharedApplication].delegate;
    
    app.isOn = switchBtn.isOn;
    
    isSwitchPressed = YES;
    
    if (app.isOn)
    {
        [self sendMessage:@"share_showwatermark" and:@"share"];
        saveImage = [UIImage addwaterMarkOrnotWithImage:theBestImage];
    }
    else
    {
        [self sendMessage:@"share_hidewatermark" and:@"share"];
        saveImage = theBestImage;
    }
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:[NSNumber numberWithBool:YES] forKey:@"waterMark"];
    [userDefault synchronize];

}

#pragma mark 导航按扭方法

//返回上一层
- (void)backButtonPressed:(id)sender
{
//    if (isSaved)
//    {
        [self.navigationController popViewControllerAnimated:YES];
//    }
//    else
//    {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:LocalizedString(@"backTipMessage", @"") delegate:self cancelButtonTitle:LocalizedString(@"backTipCancel", @"") otherButtonTitles:LocalizedString(@"backTipConfirm", @""), nil];
//        alert.tag = 100;
//        [alert show];
//    }
}

//返回到主页
- (void)popToHomeViewButtonPressed:(id)sender
{
    if (isSaved)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:LocalizedString(@"backTipMessage", @"") delegate:self cancelButtonTitle:LocalizedString(@"backTipCancel", @"") otherButtonTitles:LocalizedString(@"backTipConfirm", @""), nil];
        alert.tag = 100;
        [alert show];
    }
    
}

#pragma mark 分享按扭方法

- (void)shareToButtonPressed:(id)sender
{
    
    UIButton *tempButton = (UIButton *)sender;
    NSInteger tag = tempButton.tag - 10;
    switch (tag)
    {
        case 0:
            //保存到相册
            {
                if (isSaved && isSwitchPressed == NO)
                {
                    [MBProgressHUD showSuccess:LocalizedString(@"shareView_saveSuccess", @"")
                                        toView:[UIApplication sharedApplication].keyWindow];
                    return;
                }
                else
                {
                    [self sendMessage:@"share_save" and:@"share"];
                    UIImageWriteToSavedPhotosAlbum(saveImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                    
                }
                
            }
            break;
        case 1:
            //分享到instagram
            {
                [self sendMessage:@"share_instagram" and:@"share"];
                if([[NSFileManager defaultManager] fileExistsAtPath:kTheBestImagePath]){
                    [[NSFileManager defaultManager] removeItemAtPath:kTheBestImagePath error:nil];
                }
                
                NSData *imageData = UIImageJPEGRepresentation(saveImage, 0.8);
                [imageData writeToFile:kTheBestImagePath atomically:YES];
                
                //分享
                NSURL *fileURL = [NSURL fileURLWithPath:kTheBestImagePath];
                _documetnInteractionController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
                _documetnInteractionController.delegate = self;
                _documetnInteractionController.UTI = @"com.instagram.photo";
                //    _documetnInteractionController.UTI = @"public.png";
                _documetnInteractionController.annotation = @{@"InstagramCaption":kShareHotTags};
                BOOL canOpne = [_documetnInteractionController presentOpenInMenuFromRect:CGRectMake(0, 0, 0, 0) inView:self.view animated:YES];
                if (canOpne == NO)
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:LocalizedString(@"shareView_NoInstagram", @"") delegate:self cancelButtonTitle:LocalizedString(@"backTipConfirm", @"") otherButtonTitles:nil, nil];
                    [alert show];
                }
            }
            break;
        case 2:
            //分享到faceBook
            {
                if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
                {
                    slComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
//                    [slComposerSheet setInitialText:self.sharingText];
                    if([[NSFileManager defaultManager] fileExistsAtPath:kTheBestImagePath]){
                        [[NSFileManager defaultManager] removeItemAtPath:kTheBestImagePath error:nil];
                    }
                    
                    NSData *imageData = UIImageJPEGRepresentation(saveImage, 0.8);
                    [imageData writeToFile:kTheBestImagePath atomically:YES];
                    UIImage *image = [UIImage imageWithContentsOfFile:kTheBestImagePath];
                    
                    [slComposerSheet addImage:image];
                    [self presentViewController:slComposerSheet animated:YES completion:nil];
                }
                else
                {
                    [MBProgressHUD showError:LocalizedString(@"shareView_shareFaile", @"")
                                        toView:[UIApplication sharedApplication].keyWindow];
                    return;
                }
                __block PHO_ShareViewController *controller = self;
                __block UIImage *blockImage = theBestImage;
                [slComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result)
                {
                    
                    NSLog(@"start completion block");
                    NSString *output;
                    switch (result) {
                        case SLComposeViewControllerResultCancelled:
                            output = @"Action Cancelled";
                            break;
                        case SLComposeViewControllerResultDone:
                            
                            output = @"Post Successfull";
                            break;
                        default:
                            break;
                    }
                    if (result != SLComposeViewControllerResultCancelled)
                    {
                        [MBProgressHUD showSuccess:LocalizedString(@"shareView_shareSuccess", @"")
                                            toView:[UIApplication sharedApplication].keyWindow];
                        UIImageWriteToSavedPhotosAlbum(blockImage, controller, nil, nil);
                    }
                }];

            }
            break;
        case 3:
            //更多
            {
                [self sendMessage:@"share_more" and:@"share"];
                //保存本地 如果已存在，则删除
                if([[NSFileManager defaultManager] fileExistsAtPath:kToMorePath]){
                    [[NSFileManager defaultManager] removeItemAtPath:kToMorePath error:nil];
                }
                
                NSData *imageData = UIImageJPEGRepresentation(saveImage, 0.8);
                [imageData writeToFile:kToMorePath atomically:YES];
                
                NSURL *fileURL = [NSURL fileURLWithPath:kToMorePath];
                _documetnInteractionController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
                _documetnInteractionController.delegate = self;
                _documetnInteractionController.UTI = @"com.instagram.photo";
//                _documetnInteractionController.annotation = @{@"InstagramCaption":@"来自NoCrop"};
                [_documetnInteractionController presentOpenInMenuFromRect:CGRectMake(0, 0, 0, 0) inView:self.view animated:YES];
            }
            break;
        default:
            break;
    }
}
#pragma mark 保存至本地相册 结果反馈
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if(error == nil)
    {
        [MBProgressHUD showSuccess:LocalizedString(@"shareView_saveSuccess", @"")
                            toView:[UIApplication sharedApplication].keyWindow];
        self.isSaved = YES;
        isSwitchPressed = NO;
    }
    else
    {
        [MBProgressHUD showError:LocalizedString(@"shareView_saveFaile", @"")
                          toView:[UIApplication sharedApplication].keyWindow];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100)
    {
        if (buttonIndex == 0)
        {
            return;
        }
        else if (buttonIndex == 1)
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
    }
}

#pragma mark -
#pragma mark UITableViewDelegate And UITableDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 228.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [(PHO_AppDelegate *)[[UIApplication sharedApplication] delegate] appsArray].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    for (UIView *subView in [cell.contentView subviews])
    {
        [subView removeFromSuperview];
    }
    
    ME_AppInfo *appInfo = [[(PHO_AppDelegate *)[[UIApplication sharedApplication] delegate] appsArray] objectAtIndex:indexPath.row];
    
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    titleLabel.numberOfLines = 0;
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    CGSize labelsize = sizeWithContentAndFont(appInfo.appDesc, CGSizeMake(300, 100), 12);
    
    [titleLabel setFrame:CGRectMake(20, 0, labelsize.width, labelsize.height)];
    titleLabel.text = appInfo.appDesc;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:12.f];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [cell.contentView addSubview:titleLabel];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, labelsize.height + 10, 290, 178)];
//    [imageView sd_setImageWithURL:[NSURL URLWithString:appInfo.bannerUrl] placeholderImage:nil];
    [imageView sd_setImageWithURL:[NSURL URLWithString:appInfo.bannerUrl] placeholderImage:nil options:SDWebImageRetryFailed | SDWebImageLowPriority];
    [cell.contentView addSubview:imageView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PHO_AppDelegate *app = (PHO_AppDelegate *)[UIApplication sharedApplication].delegate;
    
    ME_AppInfo *appInfo = [app.appsArray objectAtIndex:indexPath.row];
        
    [self sendMessage:[NSString stringWithFormat:@"shareMoreApp_%d",appInfo.appId] and:@"home"];
    
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:appInfo.openUrl]])
    {
        NSString *evaluateString = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",appInfo.downUrl];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:evaluateString]];
    }
    else
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appInfo.openUrl]];
    }
}

#pragma mark -
#pragma mark WebRequestDelegate
- (void)didReceivedData:(NSDictionary *)dic withTag:(NSInteger)tag
{
    PHO_AppDelegate *app = (PHO_AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSArray *infoArray = [dic objectForKey:@"list"];
    NSMutableArray *isDownArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *noDownArray = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *infoDic in infoArray)
    {
        ME_AppInfo *appInfo = [[ME_AppInfo alloc]initWithDictionary:infoDic];
        if (appInfo.isHave)
        {
            [isDownArray addObject:appInfo];
        }
        else
        {
            [noDownArray addObject:appInfo];
        }
    }
    NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:0];
    [dataArray addObjectsFromArray:noDownArray];
    [dataArray addObjectsFromArray:isDownArray];
    app.appsArray = dataArray;
    
    //判断是否有新应用
    if (app.appsArray.count > 0)
    {
        NSMutableArray *dataArray = [[FONT_SQLMassager shareStance] getAllData];
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        
        for (ME_AppInfo *app in [(PHO_AppDelegate *)[[UIApplication sharedApplication] delegate] appsArray])
        {
            BOOL isHave = NO;
            for (ME_AppInfo *appInfo in dataArray)
            {
                if (app.appId == appInfo.appId)
                {
                    isHave = YES;
                }
            }
            if (!isHave) {
                [array addObject:app];
            }
        }
        
        //插入新数据
        if (array.count > 0)
        {
            [[FONT_SQLMassager shareStance] insertAppInfo:array];
        }
    }
    [appMoretableView reloadData];
}

- (void)requestFailed:(NSInteger)tag
{
    
}

#pragma mark 发送统计

- (void)sendMessage:(NSString *)label and:(NSString *)event
{
    //友盟统计
    [MobClick event:event label:label];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
