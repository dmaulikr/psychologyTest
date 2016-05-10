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

@interface IKairHttpRequestHelper : NSObject
{

}


/**
 *  是否有网络连接
 *
 *  @return YES:有,NO:没有
 */
+(BOOL) HaveNet;

/**
 *  是否有WIFI
 *
 *  @return YES:有,NO:没有
 */
+(BOOL) HaveWIFI;

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
