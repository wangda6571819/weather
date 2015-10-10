//
//  ABTools.h
//  AirBox
//
//  Created by wangda on 15-3-17.
//  Copyright (c) 2015年 wangda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <MobileCoreServices/MobileCoreServices.h>




@interface ABTools : NSObject
//返回处理过的单例类
+ (AFHTTPRequestOperationManager*)managerwithURL:(NSString *)url;
+ (AFHTTPRequestOperationManager*)managerDevWithURL:(NSString *)url;
+(NSString *)getText:(NSString *) msgkey;

+(NSDictionary*)fetchSSIDInfo;

//+(NSString*)getCurrentSSID;
//+(UIView*) showTips:(NSString *)message atView:(UIView*)view;
//+(void) hideTip:(UIView*)tip;
@end
