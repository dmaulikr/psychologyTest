//
//  IKairHttpRequestHelper.m
//  iKair
//
//  Created by xuwei on 13-9-2.
//  Copyright (c) 2013年 xuwei. All rights reserved.
//

#import "HttpRequestHelper.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPSessionManager.h"


@implementation HttpRequestHelper


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
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    if(acceptableContentTypes)
        manager.responseSerializer.acceptableContentTypes = acceptableContentTypes;
    else
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation,id responseObject)
    {
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
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = acceptableContentTypes;
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject)
     {
         didFinishBlock(responseObject,nil);
     }
    failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        didFinishBlock(nil,error);
    }];
}


/**
 *  Get数据
 *
 *  @param urlString        url
 *  @param didFinishBlock   回调
 *  @param timeoutInterval  超时时间间隔
 */
- (void) GetRequestUrl:(NSString *)urlString
       timeoutInterval:(double)timeoutInterval
             didFinish:(void (^)(id, NSError *))didFinishBlock
{
    
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setTimeoutInterval:timeoutInterval];
    
    [request setHTTPMethod:@"GET"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError * error){
        NSLog(@"data: %@", data);
        if (data != nil) {
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *jsonData = [self jsonParse:str];
             didFinishBlock(jsonData, nil);
        } else if (data == nil && error != nil)
        {
            didFinishBlock(nil, error);
        } else {
            didFinishBlock(nil, error);
        }
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

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

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


- (NSDictionary*)jsonParse:(NSString *)jsonString
{
    NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    return dic;
}


@end
