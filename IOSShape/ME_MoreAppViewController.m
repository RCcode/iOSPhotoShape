//
//  ME_MoreAppViewController.m
//  IOSMirror
//
//  Created by gaoluyangrc on 14-7-14.
//  Copyright (c) 2014年 rcplatformhk. All rights reserved.
//

#import "ME_MoreAppViewController.h"
#import "PHO_DataRequest.h"
#import "CMethods.h"
#import "Me_MoreTableViewCell.h"
#import "ME_AppInfo.h"
#import "UIImageView+WebCache.h"
#import <StoreKit/StoreKit.h>
#import "FONT_SQLMassager.h"
#import "PHO_AppDelegate.h"

@interface ME_MoreAppViewController () <UITableViewDataSource,UITableViewDelegate,SKStoreProductViewControllerDelegate>
{
    UITableView *appInfoTableView;
    NSTimer *_timer;
}
@end

@implementation ME_MoreAppViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    appInfoTableView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"More Apps";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *leftItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftItemButton.frame = CGRectMake(0, 0, 30, 30);
    [leftItemButton setBackgroundImage:[UIImage imageNamed:@"share_back"] forState:UIControlStateNormal];
    [leftItemButton addTarget:self action:@selector(leftItemButtonPressed:) forControlEvents:UIControlEventTouchUpInside];//    navBackItem.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, itemWH * 0.65);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemButton];
    
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:@selector(rightItemClick)];
//    self.navigationItem.rightBarButtonItem = rightItem;
    
    //判断是否已下载完数据
    PHO_AppDelegate *app = (PHO_AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (app.appsArray.count == 0)
    {
        MBProgressHUD *hud = showMBProgressHUD(nil, YES);
        hud.userInteractionEnabled = NO;
        hud.color = [UIColor blackColor];
        
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
        hideMBProgressHUD();
    }
    
    appInfoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height - 44 - 50) style:UITableViewStylePlain];
    if (!iPhone5)
    {
        appInfoTableView.frame = CGRectMake(0, 0, 320, self.view.bounds.size.height - 44);
    }
    [appInfoTableView registerNib:[UINib nibWithNibName:@"Me_MoreTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    appInfoTableView.backgroundColor = [UIColor clearColor];
    appInfoTableView.backgroundView = nil;
    appInfoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    appInfoTableView.delegate = self;
    appInfoTableView.dataSource = self;
    [self.view addSubview:appInfoTableView];
        
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(updateState) userInfo:nil repeats:YES];
    [_timer fire];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [_timer invalidate];
    _timer = nil;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)updateState{
    [appInfoTableView reloadData];
}

- (void)leftItemButtonPressed:(id)sender
{
    cancleAllRequests();
    hideMBProgressHUD();
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"MoreAPP"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeMoreImage" object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightItemClick
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [[(PHO_AppDelegate *)[[UIApplication sharedApplication] delegate] appsArray] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Me_MoreTableViewCell *cell = (Me_MoreTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.delegate = self;
    
    ME_AppInfo *appInfo = [[(PHO_AppDelegate *)[[UIApplication sharedApplication] delegate] appsArray] objectAtIndex:indexPath.row];
    
    CGSize appNameSize = getTextLabelRectWithContentAndFont(appInfo.appName, [UIFont fontWithName:FONTNAMESTRING size:14]).size;
    if (appNameSize.height < 20.f)
    {
        [cell.titleLabel setFrame:CGRectMake(cell.typeLabel.frame.origin.x, cell.typeLabel.frame.origin.y - appNameSize.height - 6, appNameSize.width, appNameSize.height)];
    }
    else
    {
        [cell.titleLabel setFrame:CGRectMake(cell.titleLabel.frame.origin.x, cell.titleLabel.frame.origin.y - 6, appNameSize.width, appNameSize.height)];
    }
    cell.titleLabel.text = appInfo.appName;
    cell.typeLabel.text = appInfo.appCate;
//    [cell.logoImageView sd_setImageWithURL:[NSURL URLWithString:appInfo.iconUrl] placeholderImage:nil];

    [cell.logoImageView sd_setImageWithURL:[NSURL URLWithString:appInfo.iconUrl] placeholderImage:nil options:SDWebImageRetryFailed | SDWebImageLowPriority];
    
    cell.commentLabel.text = [NSString stringWithFormat:@"(%d)",appInfo.appComment];
    NSString *title = @"";
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:appInfo.openUrl]])
    {
        title = LocalizedString(@"open", @"");
    }
    else
    {
        if ([appInfo.price isEqualToString:@"0"])
        {
            title = LocalizedString(@"free", @"");
        }
        else
        {
            title = appInfo.price;
        }
    }
    
    CGSize size = getTextLabelRectWithContentAndFont(title, [UIFont fontWithName:FONTNAMESTRING size:18]).size;
    [cell.installBtn setFrame:CGRectMake(320 - size.width - 20, cell.installBtn.frame.origin.y, size.width, 26)];
    [cell.installBtn setTitle:title forState:UIControlStateNormal];
    
    cell.appInfo = appInfo;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ME_AppInfo *appInfo = [[(PHO_AppDelegate *)[[UIApplication sharedApplication] delegate] appsArray] objectAtIndex:indexPath.row];
    
    [self event:[NSString stringWithFormat:@"homeMoreApp_%d",appInfo.appId] label:@"home"];
    
    if (appInfo.isHave)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appInfo.openUrl]];
    }
    else
    {
        [self jumpAppStore:appInfo.downUrl];
    }
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)jumpAppStore:(NSString *)appid
{
    NSString *evaluateString = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",appid];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:evaluateString]];
}

#pragma mark -
#pragma mark WebRequestDelegate
- (void)didReceivedData:(NSDictionary *)dic withTag:(NSInteger)tag
{
    PHO_AppDelegate *app = (PHO_AppDelegate *)[[UIApplication sharedApplication] delegate];
    
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
    [appInfoTableView reloadData];
    hideMBProgressHUD();
}

- (void)requestFailed:(NSInteger)tag
{
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 事件统计
- (void)event:(NSString *)eventID label:(NSString *)label;
{
    //友盟
    [MobClick event:eventID label:label];
}

@end
