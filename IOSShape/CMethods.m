//
//  CMethods.m
//  TaxiTest
//
//  Created by Xiaohui Guo  on 13-3-13.
//  Copyright (c) 2013年 FJKJ. All rights reserved.
//

#import "CMethods.h"
#import <stdlib.h>
#import <time.h>
#import "PHO_AppDelegate.h"
#import "ME_AppInfo.h"

//用户当前的语言环境
#define CURR_LANG   ([[NSLocale preferredLanguages] objectAtIndex:0])

@implementation CMethods


//window 高度
CGFloat windowHeight(){
    return [UIScreen mainScreen].bounds.size.height;
}

//statusBar隐藏与否的高
CGFloat heightWithStatusBar(){
    return NO==[UIApplication sharedApplication].statusBarHidden ? windowHeight()-20 :windowHeight();
}

//view 高度
CGFloat viewHeight(UIViewController *viewController){
    if (nil==viewController) {
        return heightWithStatusBar();
    }
    return YES==viewController.navigationController.navigationBarHidden ? heightWithStatusBar():heightWithStatusBar()-44;
    
}

NSString *appVersion(){
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}


NSArray* getImagesArray(NSString *folderName, NSString *type)
{
    NSArray *returnArray = [[NSBundle mainBundle]pathsForResourcesOfType:type inDirectory:folderName];
    return returnArray;
}

UIImage* getImageFromDirectory(NSString *imageName, NSString *folderName)
{
    NSString *path = [[NSBundle mainBundle] pathForResource:[[imageName componentsSeparatedByString:@"@"] objectAtIndex:0] ofType:@"png" inDirectory:folderName];
    UIImage *returnImage = [UIImage imageWithContentsOfFile:path];
    return returnImage;
}

UIImage* pngImagePath(NSString *name)
{
    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@@2x",name] ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    return image;
}

UIImage* jpgImagePath(NSString *name)
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    return image;
}

NSString* stringForInteger(int value)
{
    NSString *str = [NSString stringWithFormat:@"%d",value];
    return str;
}

NSString *LocalizedString(NSString *translation_key, id none)
{
    
    NSString *language = @"en";
    
    //只适配这么些种语言，其余一律用en
    if([CURR_LANG isEqualToString:@"zh-Hans"] ||
       [CURR_LANG isEqualToString:@"zh-Hant"] ||
       [CURR_LANG isEqualToString:@"de"] ||
       [CURR_LANG isEqualToString:@"es"] ||
       [CURR_LANG isEqualToString:@"fr"] ||
       [CURR_LANG isEqualToString:@"it"] ||
       [CURR_LANG isEqualToString:@"js"] ||
       [CURR_LANG isEqualToString:@"ko"] ||
       [CURR_LANG isEqualToString:@"ja"] ||
       [CURR_LANG isEqualToString:@"pt"] ||
       [CURR_LANG isEqualToString:@"pt-PT"] ||
       [CURR_LANG isEqualToString:@"id"] ||
       [CURR_LANG isEqualToString:@"th"] ||
       [CURR_LANG isEqualToString:@"ru"] ){
        language = CURR_LANG;
    }
    NSString * path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj"];
    NSBundle * languageBundle = [NSBundle bundleWithPath:path];
    return [languageBundle localizedStringForKey:translation_key value:@"" table:nil];
}

//當前语言环境
NSString* currentLanguage()
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString *languangeType;
    NSString* preferredLang = [languages objectAtIndex:0];
    if ([preferredLang isEqualToString:@"zh-Hant"]){
        languangeType=@"ft";
    }else{
        languangeType=@"jt";
    }
    NSLog(@"Preferred Language:%@", preferredLang);
    return languangeType;
}

//BOOL iPhone5(){
//    if (568==windowHeight()) {
//        return YES;
//    }
//    return NO;
//}

BOOL IOS7_Or_Higher(){
    return [[UIDevice currentDevice].systemVersion floatValue] >= 7.0 ? YES : NO;
}

//数学意义上的随机数在计算机上已被证明不可能实现。通常的随机数是使用随机数发生器在一个有限大的线性空间里取一个数。“随机”甚至不能保证数字的出现是无规律的。使用系统时间作为随机数发生器是常见的选择
NSMutableArray* randrom(int count,int totalCount){
    int x;
    int i;
    NSMutableArray *array=[[NSMutableArray alloc]init];
    time_t t;
    srand((unsigned) time(&t));
    for(i=0; i<count; i++){
        x=rand() % totalCount;
        printf("%d ", x);
        [array addObject:[NSString stringWithFormat:@"%d",x]];
    }
    printf("\n");
    return array;
}

UIColor* colorWithHexString(NSString *stringToConvert)
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];//字符串处理
    //例子，stringToConvert #ffffff
    if ([cString length] < 6)
        return [UIColor whiteColor];//如果非十六进制，返回白色
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];//去掉头
    if ([cString length] != 6)//去头非十六进制，返回白色
        return [UIColor whiteColor];
    //分别取RGB的值
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    //NSScanner把扫描出的制定的字符串转换成Int类型
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    //转换为UIColor
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

NSData* toJSONData(id theData)
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if ([jsonData length] != 0 && error == nil){
        return jsonData;
    }else{
        return nil;
    }
}

NSString *doDevicePlatform()
{
    size_t size;
    int nR = sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size);
    nR = sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    NSDictionary *devModeMappingMap = @{
                                        @"x86_64"    :@"Simulator",
                                        @"iPod1,1"   :@"iPod Touch",      // (Original)
                                        @"iPod2,1"   :@"iPod Touch",      // (Second Generation)
                                        @"iPod3,1"   :@"iPod Touch",      // (Third Generation)
                                        @"iPod4,1"   :@"iPod Touch",      // (Fourth Generation)
                                        @"iPod5,1"   :@"iPod Touch",
                                        @"iPhone1,1" :@"iPhone",          // (Original)
                                        @"iPhone1,2" :@"iPhone",          // (3G)
                                        @"iPhone2,1" :@"iPhone",          // (3GS)
                                        @"iPhone3,1" :@"iPhone 4",        //
                                        @"iPhone4,1" :@"iPhone 4S",       //
                                        @"iPhone5,1" :@"iPhone 5",        // (model A1428, AT&T/Canada)
                                        @"iPhone5,2" :@"iPhone 5",        // (model A1429, everything else)
                                        @"iPhone5,3" :@"iPhone 5c",       // (model A1456, A1532 | GSM)
                                        @"iPhone5,4" :@"iPhone 5c",       // (model A1507, A1516, A1526 (China), A1529 | Global)
                                        @"iPhone6,1" :@"iPhone 5s",       // (model A1433, A1533 | GSM)
                                        @"iPhone6,2" :@"iPhone 5s",       // (model A1457, A1518, A1528 (China), A1530 | Global)
                                        @"iPad1,1"   :@"iPad",            // (Original)
                                        @"iPad2,1"   :@"iPad 2",          //
                                        @"iPad2,2"   :@"iPad 2",
                                        @"iPad2,3"   :@"iPad 2",
                                        @"iPad2,4"   :@"iPad 2",
                                        @"iPad2,5"   :@"iPad Mini",       // (Original)
                                        @"iPad2,6"   :@"iPad Mini",
                                        @"iPad2,7"   :@"iPad Mini",
                                        @"iPad3,1"   :@"iPad 3",          // (3rd Generation)
                                        @"iPad3,2"   :@"iPad 3",
                                        @"iPad3,3"   :@"iPad 3",
                                        @"iPad3,4"   :@"iPad 4",          // (4th Generation)
                                        @"iPad3,5"   :@"iPad 4",
                                        @"iPad3,6"   :@"iPad 4",
                                        @"iPad4,1"   :@"iPad Air",        // 5th Generation iPad (iPad Air) - Wifi
                                        @"iPad4,2"   :@"iPad Air",        // 5th Generation iPad (iPad Air) - Cellular
                                        @"iPad4,4"   :@"iPad Mini 2",     // (2nd Generation iPad Mini - Wifi)
                                        @"iPad4,5"   :@"iPad Mini 2"      // (2nd Generation iPad Mini - Cellular)
                                        };
    
    NSString *devModel = [devModeMappingMap valueForKeyPath:platform];
    return (devModel) ? devModel : platform;
}


MBProgressHUD *mb;
MBProgressHUD * showMBProgressHUD(NSString *content,BOOL showView)
{
    //显示LoadView
    if (mb==nil) {
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        mb = [[MBProgressHUD alloc] initWithView:window];
        mb.mode = showView?MBProgressHUDModeDeterminate:MBProgressHUDModeText;
        [window addSubview:mb];
        //如果设置此属性则当前的view置于后台
        //mb.dimBackground = YES;
        mb.labelText = content;
    }else{
        mb.mode = showView?MBProgressHUDModeDeterminate:MBProgressHUDModeText;
        mb.labelText = content;
    }
    [mb show:YES];
    return mb;
}

void hideMBProgressHUD()
{
    [mb hide:YES];
}

void cancleAllRequests()
{
    hideMBProgressHUD();
    PHO_AppDelegate *appDelegate = (PHO_AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.manager.operationQueue cancelAllOperations];
}


CGRect getTextLabelRectWithContentAndFont(NSString *content ,UIFont *font)
{
    CGSize size = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
    
    CGRect returnRect = [content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil];
    
    return returnRect;
}

CGSize sizeWithContentAndFont(NSString *content,CGSize size,float fontSize)
{
    
    UIFont *font = [UIFont boldSystemFontOfSize:fontSize];
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
    CGSize labelsize =[content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    
    return labelsize;
}


NSString *exchangeTime(NSString *time)
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSInteger timeValues = [time integerValue];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timeValues];
    NSString *dataStr = [formatter stringFromDate:confromTimesp];
    return dataStr;
}

NSMutableArray *changeMoreTurnArray(NSArray *array)
{
    NSMutableArray *tempArray = [[NSMutableArray alloc]initWithArray:array];
    for (ME_AppInfo *info in array)
    {
        if (info.openUrl)
        {
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:info.openUrl]])
            {
                [tempArray removeObject:info];
                [tempArray insertObject:info atIndex:tempArray.count];
            }
        }
    }
    return [NSMutableArray arrayWithArray:tempArray];
}

@end
