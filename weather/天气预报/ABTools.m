//
//  ABTools.m
//  AirBox
//
//  Created by wangda on 15-3-17.
//  Copyright (c) 2015年 wangda. All rights reserved.
//

#import "ABTools.h"
#import "AFNetworkActivityLogger.h"
//#import "AMPopTip.h"


#ifndef DEBUG_FLAG
#define DEBUG_AFNET 1
#endif
@implementation ABTools

+ (AFHTTPRequestOperationManager*)managerwithURL:(NSString *)url
{
    static AFHTTPRequestOperationManager* instance ;
    static dispatch_once_t onceToken;
    //如果ABTools是在并发情况下调用的方法，方法不会引发线程安全问题
    dispatch_once(&onceToken, ^{
        //创建单个实例
        instance = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:url]];
        //可以设置超时的时间
        instance.requestSerializer.timeoutInterval=30.0f;
        //设定提交的默认请求处理类为JSON格式提交
        instance.requestSerializer = [AFJSONRequestSerializer serializer];
        instance.responseSerializer = [AFJSONResponseSerializer serializer];
        //正常情况，服务器如果返回json，其头信息中会给出content-type，一般为text/json或者application/json
        //而当前服务器返回的头类型是text/html
        NSMutableSet *acceptTypes =  instance.responseSerializer.acceptableContentTypes.mutableCopy;
        

        [acceptTypes addObject:@"plain/text"];
        [acceptTypes addObject:@"json/application"];
        
        instance.responseSerializer.acceptableContentTypes = acceptTypes.copy;
        //增加请求响应的数据包调试
        if (DEBUG_AFNET) {
            [[AFNetworkActivityLogger sharedLogger]startLogging];
            [[AFNetworkActivityLogger sharedLogger]setLevel:AFLoggerLevelDebug];
        }
    });
    return instance;
}



+ (AFHTTPRequestOperationManager*)managerDevWithURL:(NSString *)url
{
    static AFHTTPRequestOperationManager* instance ;
    static dispatch_once_t onceToken;
    //如果ABTools是在并发情况下调用的方法，方法不会引发线程安全问题
    dispatch_once(&onceToken, ^{
        //创建单个实例
        instance = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:url]];
        //可以设置超时的时间
        instance.requestSerializer.timeoutInterval=30.0f;
        //设定提交的默认请求处理类为JSON格式提交
//        instance.requestSerializer = [AFJSONRequestSerializer serializer];
//        instance.responseSerializer = [AFJSONResponseSerializer serializer];
        //正常情况，服务器如果返回json，其头信息中会给出content-type，一般为text/json或者application/json
        //而当前服务器返回的头类型是text/html
        NSMutableSet *acceptTypes =  instance.responseSerializer.acceptableContentTypes.mutableCopy;
        
        
        [acceptTypes addObject:@"application/x-www-form-urlencoded"];
        
        instance.responseSerializer.acceptableContentTypes = acceptTypes.copy;
        //增加请求响应的数据包调试
        if (DEBUG_AFNET) {
            [[AFNetworkActivityLogger sharedLogger]startLogging];
            [[AFNetworkActivityLogger sharedLogger]setLevel:AFLoggerLevelDebug];
        }
    });
    return instance;
}









+(NSString*) getText:(NSString *)msgkey
{
    //NSLo
    return nil;
}

+(NSDictionary*)fetchSSIDInfo {
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
     id info = nil;
    for (NSString *item in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge_retained CFStringRef)item);
        if (info&&[info count]) {
            break;
        }
    }
    return [info copy];
}
//
//+(NSString*)getCurrentSSID {
//    
//    NSDictionary * ssidDict = [self fetchSSIDInfo];
//    if (ssidDict) {
//        
//        
//        return [ssidDict objectForKey:(__bridge_transfer NSString*)kCNNetworkInfoKeySSID];
//    }
//	return @"未连接";
//}
//
//+(UIView*) showTips:(NSString *)message atView:(UIView*)view {
//    #if (defined(__IPHONE_OS_VERSION_MIN_REQUIRED) && __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0)
//    
//    AMPopTip *pop =[AMPopTip popTip];
//    pop.popoverColor = [UIColor colorWithRed:214.0/255 green:31.0/255 blue:42.0/255 alpha:1];
//    pop.textColor = [UIColor whiteColor];
////    pop.shouldDismissOnTapOutside = YES;
////    pop.shouldDismissOnTap = YES;
//    
//    [pop showText:message direction:AMPopTipDirectionDown maxWidth:view.superview.frame.size.width-10 inView:view.superview fromFrame:view.frame];
//    return pop;
//    
//    #else
//    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//    [alert show];
//    return alert;
//    #endif
//	
//}
//
//+(void) hideTip:(UIView*)tip {
//    
//#if (defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0)
//    if ([tip respondsToSelector:@selector(hide)]) {
//        [tip performSelector:@selector(hide)];
//    }
//#endif
//}





@end
