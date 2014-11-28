//
//  PHO_HomeViewController.m
//  photoprocessing
//
//  Created by wsq-wlq on 14-5-21.
//  Copyright (c) 2014年 wsq-wlq. All rights reserved.
//

#import "PHO_HomeViewController.h"

#import "PHO_MainViewController.h"

#import "PHO_AboutUsViewController.h"

#import "MBProgressHUD+Add.h"

#import <AssetsLibrary/AssetsLibrary.h>

#import "PHO_AppDelegate.h"

#import "ME_MoreAppViewController.h"

@interface PHO_HomeViewController ()

@end

@implementation PHO_HomeViewController

@synthesize imagePicker;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
        
        // Custom initialization
    }
    return self;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(haveNewApp) name:@"addMoreImage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noNewApp) name:@"removeMoreImage" object:nil];
    
    
//    self.view.backgroundColor = [UIColor colorWithPatternImage:pngImagePath(@"wallbase")];
    if (iPhone5)
    {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Default-568h"]];
    }
    else
    {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Default"]];
    }
//    UIView *customNavgationView = [[UIView alloc]initWithFrame:CGRectMake(0, TOPORIGIN_Y, 320, 44)];
//    NSLog(@"%d",TOPORIGIN_Y);
//    customNavgationView.backgroundColor = [UIColor redColor];
//    [self.view addSubview:customNavgationView];
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [infoButton setFrame:CGRectMake(274, TOPORIGIN_Y + 12, 40, 40)];
    [infoButton addTarget:self action:@selector(infoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [infoButton setBackgroundImage:[UIImage imageNamed:@"InfoButtonImage.png"] forState:UIControlStateNormal];
    [self.view addSubview:infoButton];
    
//    UIImageView *nameImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 254, 30)];
//    nameImageView.image = [UIImage imageNamed:@"Shape.png"];
//    nameImageView.center = CGPointMake(self.view.center.x, 170);
//    [self.view addSubview:nameImageView];
//

    UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreen_Height, 320, 140)];
    if (iPhone5)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.6];
        [UIView setAnimationDelay:0.8];
        buttonView.frame = CGRectMake(0, kScreen_Height-217, 320, 140);
        [UIView commitAnimations];
    }
    else
    {
//        nameImageView.center = CGPointMake(self.view.center.x, 150);

        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.6];
        [UIView setAnimationDelay:0.8];
        buttonView.frame = CGRectMake(0, kScreen_Height-190, 320, 140);
        [UIView commitAnimations];
    }
    buttonView.backgroundColor = colorWithHexString(@"#ffffff");
//    buttonView.layer.borderColor = colorWithHexString(@"dcdcdc").CGColor;
//    buttonView.layer.borderWidth = 1;
    buttonView.alpha = 0.8;
    [self.view addSubview:buttonView];
    
    UIButton *openlibrary = [UIButton buttonWithType:UIButtonTypeCustom];
    [openlibrary setBackgroundImage:[UIImage imageNamed:@"gallery.png"] forState:UIControlStateNormal];
    [openlibrary setFrame:CGRectMake(19, 38, 65, 65)];
//    openlibrary.center = CGPointMake(openlibrary.frame.origin.x, buttonView.center.y);
    openlibrary.tag = 100;
    [openlibrary addTarget:self action:@selector(choosePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:openlibrary];
    
    UIButton *openCamera = [UIButton buttonWithType:UIButtonTypeCustom];
    [openCamera setBackgroundImage:[UIImage imageNamed:@"Camera.png"] forState:UIControlStateNormal];
    [openCamera setFrame:CGRectMake(130, 38, 65, 65)];
//    openCamera.center = CGPointMake(openCamera.frame.origin.x, buttonView.center.y);
    openCamera.tag = 101;
    [openCamera addTarget:self action:@selector(choosePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:openCamera];
    
    openMoreAppButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [openMoreAppButton setBackgroundImage:[UIImage imageNamed:@"more.png"] forState:UIControlStateNormal];
    [openMoreAppButton setFrame:CGRectMake(241, 38, 65, 65)];
//    openNoCropButton.center = CGPointMake(openNoCropButton.frame.origin.x, buttonView.center.y);
    [openMoreAppButton addTarget:self action:@selector(openMoreAppButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:openMoreAppButton];
    
    self.imagePicker = [[UIImagePickerController alloc]init];
    self.imagePicker.delegate = self;
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"MoreAPP"] isEqualToString:@"1"])
    {
        [self haveNewApp];
    }

    // Do any additional setup after loading the view.
}


#pragma 弹出菜单按扭方法

- (void)infoButtonPressed:(id)sender
{
    [self sendMessage:@"home_menu" and:@"home"];
    if (aboutUs == nil)
    {
        aboutUs = [[PHO_AboutUsViewController alloc]init];
    }
    UINavigationController *aboutNav = [[UINavigationController alloc]initWithRootViewController:aboutUs];
    [aboutNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"titlebar.png"] forBarMetrics:UIBarMetricsDefault];
    [self presentViewController:aboutNav animated:YES completion:nil];
}


/**********************************************************
 函数名称：-(void)choosePhoto:(id)sender
 函数描述：打开相册或相机
 输入参数：(id)sender：用户点击事件
 输出参数：无
 返回值：  无
 **********************************************************/

- (void)choosePhoto:(id)sender
{
    UIButton *tembtn = (UIButton *)sender;
    NSInteger tag = tembtn.tag;
    if (tag == 100)
    {
        //打开相册
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:LocalizedString(@"user_library_step", @"")
                                                           delegate:self
                                                  cancelButtonTitle:LocalizedString(@"backTipConfirm", @"")
                                                  otherButtonTitles:nil];
            [alert show];
        }        
        [self sendMessage:@"home_gallery" and:@"home"];
        
    }
    else if (tag == 101)
    {
        //打开相机
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        NSLog(@"%d",authStatus);
        if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:LocalizedString(@"user_camera_step", @"")
                                                           delegate:self
                                                  cancelButtonTitle:LocalizedString(@"backTipConfirm", @"")
                                                  otherButtonTitles:nil];
            [alert show];
        }
        [self sendMessage:@"home_camera" and:@"home"];
        
        
    }
    
    
    [self presentViewController:imagePicker animated:YES
                     completion:nil];
    
    PHO_AppDelegate *app = (PHO_AppDelegate *)[UIApplication sharedApplication].delegate;
    UIView *adBanner = (UIView *)app.adBanner;
    adBanner.hidden = YES;

}
/**********************************************************
 函数名称：-(void)imagePickerController:(UIImagePickerController *)picker
 didFinishPickingMediaWithInfo:(NSDictionary *)info
 函数描述：获得用户使用相机或相册所选中的照片
 输入参数：(UIImagePickerController *)picker：相机，相册控制器
 (NSDictoinary *)info:用户所选相片数据信息
 输出参数：(UIImage *)img :用户所选图片
 返回值：  无
 **********************************************************/
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
//    chooseImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary)
    {
        chooseImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
    }
    /*改变图片旋转90度问题*/
    UIImage *cameraPic = [info objectForKey:UIImagePickerControllerOriginalImage];
    //    NSLog(@"cameraPic.imageOrientation == %ld",cameraPic.imageOrientation);
    
    if (cameraPic.imageOrientation != UIImageOrientationUp)
    {
        
        int mi = cameraPic.imageOrientation;
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        CGAffineTransform transform = CGAffineTransformIdentity;
        
        switch (mi)
        {
            case UIImageOrientationDown:
            case UIImageOrientationDownMirrored:
                transform = CGAffineTransformTranslate(transform, cameraPic.size.width, cameraPic.size.height);
                transform = CGAffineTransformRotate(transform, M_PI);
                break;
                
            case UIImageOrientationLeft:
            case UIImageOrientationLeftMirrored:
                transform = CGAffineTransformTranslate(transform, cameraPic.size.width, 0);
                transform = CGAffineTransformRotate(transform, M_PI_2);
                break;
                
            case UIImageOrientationRight:
            case UIImageOrientationRightMirrored:
                transform = CGAffineTransformTranslate(transform, 0, cameraPic.size.height);
                transform = CGAffineTransformRotate(transform, -M_PI_2);
                break;
        }
        
        switch (mi)
        {
            case UIImageOrientationUpMirrored:
            case UIImageOrientationDownMirrored:
                transform = CGAffineTransformTranslate(transform, cameraPic.size.width, 0);
                transform = CGAffineTransformScale(transform, -1, 1);
                break;
                
            case UIImageOrientationLeftMirrored:
            case UIImageOrientationRightMirrored:
                transform = CGAffineTransformTranslate(transform, cameraPic.size.height, 0);
                transform = CGAffineTransformScale(transform, -1, 1);
                break;
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        CGContextRef ctx = CGBitmapContextCreate(NULL, cameraPic.size.width, cameraPic.size.height,
                                                 CGImageGetBitsPerComponent(cameraPic.CGImage), 0,
                                                 CGImageGetColorSpace(cameraPic.CGImage),
                                                 CGImageGetBitmapInfo(cameraPic.CGImage));
        CGContextConcatCTM(ctx, transform);
        switch (mi)
        {
            case UIImageOrientationLeft:
            case UIImageOrientationLeftMirrored:
            case UIImageOrientationRight:
            case UIImageOrientationRightMirrored:
                // Grr...
                CGContextDrawImage(ctx, CGRectMake(0,0,cameraPic.size.height,cameraPic.size.width), cameraPic.CGImage);
                break;
                
            default:
                CGContextDrawImage(ctx, CGRectMake(0,0,cameraPic.size.width,cameraPic.size.height), cameraPic.CGImage);
                break;
        }
        
        // And now we just create a new UIImage from the drawing context
        CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
        chooseImage = [UIImage imageWithCGImage:cgimg];
        CGContextRelease(ctx);
        CGImageRelease(cgimg);
    }

    if (chooseImage)
    {
        [self dismissPicker];
    }
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
    
    PHO_AppDelegate *app = (PHO_AppDelegate *)[UIApplication sharedApplication].delegate;
    UIView *adBanner = (UIView *)app.adBanner;
    adBanner.hidden = NO;

}
/**********************************************************
 函数名称：-(void)dismissPicker
 函数描述：退出相册或相机
 输入参数：无
 输出参数：无
 返回值：  无
 **********************************************************/

- (void)dismissPicker
{
    
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
    
    PHO_MainViewController *mainViewController = [[PHO_MainViewController alloc]init];
    [mainViewController setImage:chooseImage];
    [self.navigationController pushViewController:mainViewController animated:YES];
    
    PHO_AppDelegate *app = (PHO_AppDelegate *)[UIApplication sharedApplication].delegate;
    UIView *adBanner = (UIView *)app.adBanner;
    adBanner.hidden = NO;
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
}


- (void)openMoreAppButtonPressed:(id)sender
{
    [self sendMessage:@"home_moreapps" and:@"home"];
    ME_MoreAppViewController *moreApp = [[ME_MoreAppViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:moreApp];
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"titlebar.png"] forBarMetrics:UIBarMetricsDefault];
    nav.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    nav.navigationBar.backgroundColor = [UIColor clearColor];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)haveNewApp
{
//    [openMoreAppButton setBackgroundImage:[UIImage imageNamed:@"more-tip.png"] forState:UIControlStateNormal];
    UIImageView *redImageView = [[UIImageView alloc]initWithFrame:CGRectMake(50, 0, 12, 12)];
    redImageView.image = [UIImage imageNamed:@"spot.png"];
    redImageView.tag = 11;
    [openMoreAppButton addSubview:redImageView];
}

- (void)noNewApp
{
//    [openMoreAppButton setBackgroundImage:[UIImage imageNamed:@"more.png"] forState:UIControlStateNormal];
    UIView *imageView = [openMoreAppButton viewWithTag:11];
    [imageView removeFromSuperview];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

#pragma mark 发送统计

- (void)sendMessage:(NSString *)lable and:(NSString *)event
{
    //友盟统计
    [MobClick event:event label:lable];
    
    //flurryAnalytics
    [Flurry logEvent:event];
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
