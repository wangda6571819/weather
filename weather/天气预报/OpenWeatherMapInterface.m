//
//  OpenWeatherMapInterface.m
//  OpenWeatherMap
//
//  Created by chencheng on 15/7/10.
//  Copyright (c) 2015年 chencheng. All rights reserved.
//

#import "OpenWeatherMapInterface.h"
#import "ThreeHoursData.h"
#import "SevenDayData.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#import "ABTools.h"

@implementation OpenWeatherMapInterface


+(void)login
{
    __block AFHTTPRequestOperationManager *manager = [ABTools managerwithURL:LOGIN_URL];
    [manager GET:LOGIN_URL parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    
    
}

+(CurrentWeatherData *)getCurrentDataWithCityName:(NSString *)cityName andCountryCode:(NSString *)countryCode
{
    CurrentWeatherData *currentWeather = [[CurrentWeatherData alloc]init];
    NSString *strURL = nil;
    if (countryCode == nil) {
        strURL = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?q=%@&lang=Zh_cn",cityName];
    }else{
        strURL = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?q=%@,%@&lang=Zh_cn",cityName,countryCode];
    }
    
    NSURL * url = [NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy: NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:5.0];
    
    NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary * resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    
    
   
    currentWeather.humidity = [[resDict objectForKey:@"main"] objectForKey:@"humidity"];
    currentWeather.temperature =  [self changeTemperature:[[resDict objectForKey:@"main"] objectForKey:@"temp"]];
    currentWeather.tempHigh =   [self changeTemperature:[[resDict objectForKey:@"main"] objectForKey:@"temp_max"]];
    currentWeather.tempLow =  [self changeTemperature:[[resDict objectForKey:@"main"] objectForKey:@"temp_min"]];
    currentWeather.locationName = [resDict objectForKey:@"name"];
    currentWeather.sunRise = [[resDict objectForKey:@"sys"] objectForKey:@"sunrise"];
    currentWeather.sunSet = [[resDict objectForKey:@"sys"] objectForKey:@"sunset"];
    currentWeather.conditionDescription = [[resDict objectForKey:@"weather"][0] objectForKey:@"description"];
    currentWeather.condition = [[resDict objectForKey:@"weather"][0] objectForKey:@"main"];
    currentWeather.windBearing = [[resDict objectForKey:@"wind"] objectForKey:@"deg"];
    currentWeather.windSpeed = [[resDict objectForKey:@"wind"] objectForKey:@"speed"];
    NSDictionary *iconDict =[[NSDictionary   alloc]init];
    iconDict=@{
        @"01d" : @"weather-clear",
        @"02d" : @"weather-few",
        @"03d" : @"weather-few",
        @"04d" : @"weather-broken",
        @"09d" : @"weather-shower",
        @"10d" : @"weather-rain",
        @"11d" : @"weather-tstorm",
        @"13d" : @"weather-snow",
        @"50d" : @"weather-mist",
        @"01n" : @"weather-moon",
        @"02n" : @"weather-few-night",
        @"03n" : @"weather-few-night",
        @"04n" : @"weather-broken",
        @"09n" : @"weather-shower",
        @"10n" : @"weather-rain-night",
        @"11n" : @"weather-tstorm",
        @"13n" : @"weather-snow",
        @"50n" : @"weather-mist"
    };
    
    NSString *iconName =[[resDict objectForKey:@"weather"][0] objectForKey:@"icon"];
    currentWeather.icon =[iconDict objectForKey:iconName];
  //  NSString *s =[NSString stringWithFormat:@"%@",[[resDict objectForKey:@"sys"] objectForKey:@"sunrise"]]; //对应21:00
   // NSDate *d = [NSDate dateWithTimeIntervalSince1970:[s doubleValue]/1000];
      return currentWeather;
}

+(NSNumber *)changeTemperature:(NSNumber *)temp
{
    return [NSNumber numberWithDouble:([temp doubleValue]-273.16)];
}







+(NSMutableArray *)getOneDayWwatherDataWithCityName:(NSString *)cityName andCountryCode:(NSString *)countryCode
{
    NSMutableArray *arr1 = [NSMutableArray array];
    NSString *strURL = nil;
    if (countryCode == nil) {
        strURL = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast?q=%@,cn&mode=json&lang=Zh_cn",cityName];
    }else{
            //strURL = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?q=%@,%@",cityName,countryCode];
    }
    NSURL * url = [NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy: NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:5.0];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary * resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *arr = [resDict objectForKey:@"list"];
    
    NSDictionary *iconDict =[[NSDictionary   alloc]init];
    iconDict=@{
               @"01d" : @"weather-clear",
               @"02d" : @"weather-few",
               @"03d" : @"weather-few",
               @"04d" : @"weather-broken",
               @"09d" : @"weather-shower",
               @"10d" : @"weather-rain",
               @"11d" : @"weather-tstorm",
               @"13d" : @"weather-snow",
               @"50d" : @"weather-mist",
               @"01n" : @"weather-moon",
               @"02n" : @"weather-few-night",
               @"03n" : @"weather-few-night",
               @"04n" : @"weather-broken",
               @"09n" : @"weather-shower",
               @"10n" : @"weather-rain-night",
               @"11n" : @"weather-tstorm",
               @"13n" : @"weather-snow",
               @"50n" : @"weather-mist"
               };
    
    
    
    NSDate *currentDate = [[NSDate alloc]init];
    
    
    
    
    
    
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate: currentDate];
    
    NSDate *localeDate = [currentDate  dateByAddingTimeInterval: interval];
    
    NSLog(@"1111111---%@", localeDate);
    
    NSString *currentTime =[NSString stringWithFormat:@"%@",localeDate];

    
    NSLog(@"---date  %@",currentDate);
    NSLog(@"-----------%@",currentTime);
    NSRange rangeTime =NSMakeRange(11, 2);
    NSString *time =[currentTime substringWithRange:rangeTime];
    NSLog(@"time is %@",time);
    int n =[time intValue]/3*3;
    NSLog(@"n is %d",n );

    /*
    
    NSLog(@"---date  %@",currentDate);
    NSLog(@"-----------%@",currentTime);
    NSRange rangeTime =NSMakeRange(11, 2);
    NSString *time =[currentTime substringWithRange:rangeTime];
    NSLog(@"time is %@",time);
    int n =[time intValue]/3*3;
    NSLog(@"n is %d",n );
    
   */
    
   
    
    
    
    
    NSString *timeTheResult =[NSString stringWithFormat:@"%d",n];
    
    NSLog(@"------is----%@",timeTheResult);
    
    NSLog(@"%@",[[arr[0] objectForKey:@"weather"][0] objectForKey:@"icon"]);
    int count =-1;
    for (int i = 0; i < arr.count; i++) {
        ThreeHoursData *threeHoursData = [[ThreeHoursData alloc]init];
        threeHoursData.temperature = [self changeTemperature:[[arr[i] objectForKey:@"main"] objectForKey:@"temp"]];
        
        threeHoursData.date = [arr[i] objectForKey:@"dt_txt"];
        threeHoursData.icon =[iconDict objectForKey:[[arr[i] objectForKey:@"weather"][0] objectForKey:@"icon"]];
        threeHoursData.hour = [self amOrpm:threeHoursData.date];
        threeHoursData.condition = [[arr[i] objectForKey:@"weather"][0] objectForKey:@"description"];
        
        NSString *currentComTime =[NSString stringWithFormat:@"%d",[[threeHoursData.date substringWithRange:rangeTime] intValue]];
        NSLog(@"-------------isis--%@",currentComTime);
        if ([timeTheResult isEqualToString:currentComTime]) {
            count =8;
        }
        if (count >0) {
        
            [arr1 addObject:threeHoursData];
            count--;
        }
        if (count ==0) {
            break;
        }
    }
    NSLog(@"----count is %lu",(unsigned long)arr.count);
    return arr1;
}
+(NSMutableArray *)getSevenDayWwatherDataWithCityName:(NSString *)cityName andCountryCode:(NSString *)countryCode
{
    NSMutableArray *arr1 = [NSMutableArray array];
    NSString *strURL = nil;
    if (countryCode == nil) {
        strURL = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?q=%@&mode=json&units=metric&cnt=7&lang=Zh_cn",cityName];
    }else{
        //strURL = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?q=%@,%@",cityName,countryCode];
    }
    NSURL * url = [NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy: NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:5.0];
    NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary * resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *arr = [resDict objectForKey:@"list"];
    NSDictionary *iconDict =[[NSDictionary   alloc]init];
    iconDict=@{
               @"01d" : @"weather-clear",
               @"02d" : @"weather-few",
               @"03d" : @"weather-few",
               @"04d" : @"weather-broken",
               @"09d" : @"weather-shower",
               @"10d" : @"weather-rain",
               @"11d" : @"weather-tstorm",
               @"13d" : @"weather-snow",
               @"50d" : @"weather-mist",
               @"01n" : @"weather-moon",
               @"02n" : @"weather-few-night",
               @"03n" : @"weather-few-night",
               @"04n" : @"weather-broken",
               @"09n" : @"weather-shower",
               @"10n" : @"weather-rain-night",
               @"11n" : @"weather-tstorm",
               @"13n" : @"weather-snow",
               @"50n" : @"weather-mist"
               };
    for (int i = 0; i < arr.count; i++) {
        SevenDayData *sevenDayData = [[SevenDayData alloc]init];
        sevenDayData.icon = [iconDict objectForKey:[[arr[i] objectForKey:@"weather"][0] objectForKey:@"icon"]];
        sevenDayData.tempHigh = [[arr[i] objectForKey:@"temp"] objectForKey:@"max"];
        sevenDayData.tempLow = [[arr[i] objectForKey:@"temp"] objectForKey:@"min"];
        sevenDayData.weekDay = [self weekDayStr:[arr[i] objectForKey:@"dt"]];
        sevenDayData.condition = [[arr[i] objectForKey:@"weather"][0] objectForKey:@"description"];
        [arr1 addObject:sevenDayData];
    }
    NSLog(@"aaaaaaaaaaaaaaaaaais %d",arr1.count);
    return arr1;
}

+(NSString *)getDay
{
    NSDate *date = [[NSDate alloc]init];
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    format.dateFormat = @"MM-dd";
    NSString *dateStr = [format stringFromDate:date];
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    
   return  [NSString stringWithFormat:@"%@ %@",dateStr, [self weekDayStr:[NSNumber numberWithDouble:timeInterval]]];
}
-(NSString *)getTheTime
{
    NSDate *currentDate = [[NSDate alloc]init];
    NSString *currentTime =[NSString stringWithFormat:@"%@",currentDate];
    NSRange rangeTime =NSMakeRange(11, 2);
    NSString *time =[currentTime substringWithRange:rangeTime];
    int n =[time intValue]/3*8;
    return [NSString stringWithFormat:@"%d",n];
}
+(NSString *)weekDayStr:(NSNumber *)format
{
    NSTimeInterval a = [format doubleValue];
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:a];
    NSCalendar*calendar = [NSCalendar currentCalendar];
    NSDateComponents*comps;
    comps =[calendar components:(NSCalendarUnitWeekday | NSCalendarUnitWeekday |NSCalendarUnitWeekdayOrdinal)
                      fromDate:date1];
    NSInteger weekday = [comps weekday]; // 星期几（注意，周日是“1”，周一是“2”。。。。）
    NSString *weekday1;
    switch (weekday) {
        case 1:
            weekday1 = @"星期日";
            break;
        case 2:
            weekday1 = @"星期一";
            break;
        case 3:
            weekday1 = @"星期二";
            break;
        case 4:
            weekday1 = @"星期三";
            break;
        case 5:
            weekday1 = @"星期四";
            break;
        case 6:
            weekday1 = @"星期五";
            break;
        case 7:
            weekday1 = @"星期六";
            break;
        default:
            break;
    }
    return weekday1;
}

+(NSString *)amOrpm:(NSString *)date
{
    int a = [[date substringWithRange:NSMakeRange(11, 2)] intValue];
    if (a < 12 || a == 0 ) {
        return @"AM";
    }else
    {
        return @"PM";
    }
}



+ (NSString *)deviceIPAdress {
    NSString *address = @"an error occurred when obtaining ip address";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    
    if (success == 0) { // 0 表示获取成功
        
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                    // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                        // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);  
    
    
    return address;  
}

@end
