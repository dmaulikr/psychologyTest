//
//  HttpRequestHelper.h
//  iKair
//
//  Created by xuwei on 13-9-2.
//  Copyright (c) 2013年 xuwei. All rights reserved.
//

/**
 *  HTTP基本操作功能类
 */
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HttpRequestHelper : NSObject
{

}


/**
 *  请求数据
 *
 *  @param url            url
 *  @param Params         需要POST的参数
 *  @param didFinishBlock 回调
 */
-(void) PostRequestUrl:(NSString *)url
             SetParams:(NSDictionary *)Params
             didFinish:(void(^)(id json,NSError *error))didFinishBlock;

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
             didFinish:(void(^)(id json,NSError *error))didFinishBlock;



/**
 *  Post Json数据到服务器
 *
 *  @param url            url
 *  @param json           json串
 *  @param didFinishBlock 回调
 */
-(void) PostJSONDataToUrl:(NSString *)url
                     json:(NSString *)json
                didFinish:(void(^)(NSString *json,NSError *error))didFinishBlock;


/**
 *  Get数据
 *
 *  @param url              url
 *  @param didFinishBlock   回调
 */
-(void) GetRequestUrl:(NSString *)url
            didFinish:(void(^)(id json,NSError *error))didFinishBlock;

/**
 *  Get数据
 *
 *  @param url              url
 *  @param didFinishBlock   回调
 */
-(void) GetRequestUrl:(NSString *)url
         contentTypes:(NSSet *)acceptableContentTypes
            didFinish:(void(^)(id json,NSError *error))didFinishBlock;


/**
 *  Get数据
 *
 *  @param url              url
 *  @param timeoutInterval  超时设置
 *  @param didFinishBlock   回调
 */
- (void) GetRequestUrl:(NSString *)urlString
       timeoutInterval:(double)timeoutInterval
             didFinish:(void (^)(id, NSError *))didFinishBlock;


/**
 *  长传图片文件
 *
 *  @param strUrl         url
 *  @param image          图片
 *  @param didFinishBlock 回调
 */
-(void) PostImageToUrl:(NSString *)url
                 image:(UIImage *)image
             didFinish:(void(^)(id json,NSError *error))didFinishBlock;



// 下载图片
+(void) DownloadImageUrl:(NSString*)url
               didFinish:(void(^)(UIImage *image,NSError *error))didFinishBlock;


@end
