//
//  OpenWeatherMapInterface.h
//  OpenWeatherMap
//
//  Created by chencheng on 15/7/10.
//  Copyright (c) 2015年 chencheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CurrentWeatherData.h"


#define LOGIN_URL  @"http://api.openweathermap.org/data/2.5/forecast/city?id=524901&APPID={1a419219b2a707cbec7161ba7942c0a9}"


@interface OpenWeatherMapInterface : NSObject
+(CurrentWeatherData *)getCurrentDataWithCityName:(NSString *)cityName andCountryCode:(NSString *)countryCode;
+(NSMutableArray *)getOneDayWwatherDataWithCityName:(NSString *)cityName andCountryCode:(NSString *)countryCode;
+(NSMutableArray *)getSevenDayWwatherDataWithCityName:(NSString *)cityName andCountryCode:(NSString *)countryCode;
-(NSString *)getTheTime;
+(NSString *)getDay;
+ (NSString *)deviceIPAdress;
+(void)login;
@end
