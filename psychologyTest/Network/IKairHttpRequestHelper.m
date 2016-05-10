//
//  IKairHttpRequestHelper.m
//  iKair
//
//  Created by xuwei on 13-9-2.
//  Copyright (c) 2013年 xuwei. All rights reserved.
//

#import "IKairHttpRequestHelper.h"
#import "Reachability.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPSessionManager.h"

#import "IKairConstant.h"
#import "IKairContext.h"

@implementation IKairHttpRequestHelper

// 是否有WIFI
+ (BOOL) HaveWIFI
{
    Reachability *wifi = [Reachability reachabilityForLocalWiFi];
    
    // 2.检测手机是否能上网络(WIFI\3G\2.5G)
    //Reachability *conn = [Reachability reachabilityForInternetConnection];
    
    // 3.判断网络状态
    if ([wifi currentReachabilityStatus] != NotReachable) { // 有wifi
        return YES;
    }
    
    return NO;
}

//是否有网络连接
+(BOOL) HaveNet
{
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&zeroAddress);
    if(reachability != NULL) {
        //NetworkStatus retVal = NotReachable;
        SCNetworkReachabilityFlags flags;
        if (SCNetworkReachabilityGetFlags(reachability, &flags)) {
            if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
            {
                // if target host is not reachable
                return NO;
            }
            
            if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
            {
                // if target host is reachable and no connection is required
                //  then we'll assume (for now) that your on Wi-Fi
                return YES;
            }
            
            
            if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
                 (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
            {
                // ... and the connection is on-demand (or on-traffic) if the
                //     calling application is using the CFSocketStream or higher APIs
                
                if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
                {
                    // ... and no [user] intervention is needed
                    return YES;
                }
            }
            
            if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
            {
                // ... but WWAN connections are OK if the calling application
                //     is using the CFNetwork (CFSocketStream?) APIs.
                return YES;
            }
        }
    }
    
    return NO;
}

/**
 *  POST数据
 *
 *  @param url            url
 *  @param Params         需要POST的参数
 *  @param didFinishBlock 回调
 */
-(void) PostRequestUrl:(NSString *)url
             SetParams:(NSDictionary *)parameters
             didFinish:(void(^)(id json,NSError *error))didFinishBlock
{
    [self PostRequestUrl:url SetParams:parameters contentTypes:nil didFinish:didFinishBlock];
}

/**
 *  POST数据
 *
 *  @param url            url
 *  @param Params         需要POST的参数
 *  @param didFinishBlock 回调
 */
-(void) PostRequestUrl:(NSString *)url
             SetParams:(NSDictionary *)parameters
          contentTypes:(NSSet *)acceptableContentTypes
             didFinish:(void(^)(id json,NSError *error))didFinishBlock
{
    NSString *appKey    = IKairAPPKey;
    NSString *token     = [IKairContext getCurrentToken];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    if(acceptableContentTypes)
        manager.responseSerializer.acceptableContentTypes = acceptableContentTypes;
    else
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer setValue:appKey forHTTPHeaderField:@"Appkey"];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Token"];
    
//    NSString *json = [parameters JSONString];
//    NSLog(@"token:%@,url:%@,json:%@",token,url,json);
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation,id responseObject)
    {
//        NSLog(@"url:%@,Success: %@",url, [responseObject JSONString]);
        didFinishBlock(responseObject,nil);
    }
    failure:^(AFHTTPRequestOperation *operation,NSError *error) {
             NSLog(@"Error: %@", error);
          didFinishBlock(nil,error);
        
    }];
}

/**
 *  Get数据
 *
 *  @param url              url
 *  @param didFinishBlock   回调
 */
-(void) GetRequestUrl:(NSString *)url
            didFinish:(void(^)(id json,NSError *error))didFinishBlock
{
    [self GetRequestUrl:url contentTypes:[NSSet setWithObject:@"application/json"] didFinish:didFinishBlock];
}

 //application/json
/**
 *  Get数据
 *
 *  @param url              url
 *  @param didFinishBlock   回调
 */
-(void) GetRequestUrl:(NSString *)url
         contentTypes:(NSSet *)acceptableContentTypes
            didFinish:(void(^)(id json,NSError *error))didFinishBlock
{
    NSString *appKey    = IKairAPPKey;
    NSString *token     = [IKairContext getCurrentToken];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = acceptableContentTypes;//[NSSet setWithObject:@"application/json"];
    [manager.requestSerializer setValue:appKey forHTTPHeaderField:@"appkey"];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    
    
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject)
     {
//         NSLog(@"url:%@,token:%@,Success: %@",url,token, [responseObject JSONString]);
         didFinishBlock(responseObject,nil);
     }
    failure:^(AFHTTPRequestOperation *operation,NSError *error) {
         NSLog(@"url:%@,token:%@,Error: %@",url,token, error);
        didFinishBlock(nil,error);
    }];
}

/**
 *  Post Json数据到服务器
 *
 *  @param url            url
 *  @param json           json串
 *  @param didFinishBlock 回调
 */
-(void) PostJSONDataToUrl:(NSString *)url
                     json:(NSString *)json
                didFinish:(void(^)(NSString *json,NSError *error))didFinishBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody: [json dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"URL:%@,JSON responseObject: %@ ",url,responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
    }];
    [op start];
}

/**
 *  长传图片文件
 *
 *  @param strUrl         url
 *  @param image          图片
 *  @param didFinishBlock 回调
 */
-(void) PostImageToUrl:(NSString *)url
                 image:(UIImage *)image
             didFinish:(void(^)(id json,NSError *error))didFinishBlock
{
    NSString *appKey    = IKairAPPKey;
    NSString *token     = [IKairContext getCurrentToken];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager.requestSerializer setValue:appKey forHTTPHeaderField:@"appkey"];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
   
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
        [formData appendPartWithFileData :imageData name:@"file" fileName:@"file.png" mimeType:@"image/jpeg"];
        
    } success:^(AFHTTPRequestOperation *operation,id responseObject) {
        
        didFinishBlock(responseObject,nil);
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        
        NSLog(@"Error: %@", error);
        didFinishBlock(nil,error);
    }];
}

// 下载图片
+(void) DownloadImageUrl:(NSString*)url
               didFinish:(void(^)(UIImage *image,NSError *error))didFinishBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [request setHTTPMethod:@"GET"];
    [request setValue: @"image/png" forHTTPHeaderField:@"Content-Type"];
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response: %@", responseObject);

        didFinishBlock(responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Image error: %@", error);
    }];
    [requestOperation start];
}
@end
