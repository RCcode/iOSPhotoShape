//
//  PHO_DataRequest.m
//  IOSShape
//
//  Created by wsq-wlq on 14-6-4.
//  Copyright (c) 2014年 wsq-wlq. All rights reserved.
//

#import "PHO_DataRequest.h"

#import "PHO_AppDelegate.h"

#import "Reachability.h"

@interface PHO_DataRequest ()

@end

@implementation PHO_DataRequest

- (id)initWithDelegate:(id<WebRequestDelegate,DownLoadTypeFaceDelegate>)request_Delegate
{
    self = [super init];
    
    self.delegate = request_Delegate;
    
    return self;
}

#pragma mark -
#pragma mark 公共请求 （Post）
- (void)requestServiceWithPost:(NSString *)url_Str jsonRequestSerializer:(AFJSONRequestSerializer *)requestSerializer isRegisterToken:(BOOL)token
{
    
    NSString *url = nil;
    if ([url_Str isEqualToString:@"getStickerInfos.do"])
    {
        url = [NSString stringWithFormat:@"%@%@",HTTP_BASEURL,url_Str];
        
    }
    else
    {
        url = [NSString stringWithFormat:@"%@",url_Str];
    }
    
    
    PHO_AppDelegate *appDelegate = (PHO_AppDelegate *)[UIApplication sharedApplication].delegate;
    
    appDelegate.manager.requestSerializer = requestSerializer;
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    appDelegate.manager.responseSerializer = responseSerializer;
    
    //    NSData *jsonData = [self.valuesDictionary JSONData];
    [appDelegate.manager POST:token? kPushURL:url parameters:self.valuesDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //解析数据
        NSDictionary *dic = responseObject;
        NSLog(@"%@",[dic objectForKey:@"message"]);
        [self.delegate didReceivedData:dic withTag:requestTag];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        hideMBProgressHUD();
        NSLog(@"error.......%@",error);
        [self.delegate requestFailed:requestTag];
    }];
}

#pragma mark -
#pragma mark 公共请求 （Get）
- (void)requestServiceWithGet:(NSString *)url_Str
{
    PHO_AppDelegate *appDelegate = (PHO_AppDelegate *)[UIApplication sharedApplication].delegate;
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    appDelegate.manager.requestSerializer = requestSerializer;
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    appDelegate.manager.responseSerializer = responseSerializer;
    
    [appDelegate.manager GET:url_Str parameters:nil
                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         //解析数据
                         NSDictionary *dic = (NSDictionary *)responseObject;
                         [self.delegate didReceivedData:dic withTag:requestTag];
                     }
                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         [self.delegate requestFailed:requestTag];
                     }];
}

#pragma mark -
#pragma mark 检测网络状态
- (BOOL)checkNetWorking
{
    
    BOOL connected = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable ? YES : NO;
    
    if (!connected) {
        //        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:LocalizedString(@"tips", @"")
        //                                                       message:LocalizedString(@"connection_exception", @"")
        //                                                      delegate:nil
        //                                             cancelButtonTitle:@"OK"
        //                                             otherButtonTitles:nil];
        //        [alert show];
    }
    
    return connected;
}

#pragma mark -
#pragma mark 更多应用
- (void)moreApp:(NSDictionary *)dictionary withTag:(NSInteger)tag
{
    if (![self checkNetWorking])
        return;
    requestTag = tag;
    self.valuesDictionary = dictionary;
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requestSerializer setTimeoutInterval:30];
    
    [self requestServiceWithPost:@"http://moreapp.rcplatformhk.net/pbweb/app/getIOSAppListNew.do" jsonRequestSerializer:requestSerializer  isRegisterToken:NO];
}


#pragma mark -
#pragma mark 注册设备
- (void)registerToken:(NSDictionary *)dictionary withTag:(NSInteger)tag
{
    if (![self checkNetWorking])
        return;
    requestTag = tag;
    self.valuesDictionary = dictionary;
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:30];
    [self requestServiceWithPost:nil jsonRequestSerializer:requestSerializer  isRegisterToken:YES];
}

#pragma mark -
#pragma mark 版本更新
- (void)updateVersion:(NSString *)url withTag:(NSInteger)tag
{
    if (![self checkNetWorking])
        return;
    requestTag = tag;
    [self requestServiceWithGet:url];
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
