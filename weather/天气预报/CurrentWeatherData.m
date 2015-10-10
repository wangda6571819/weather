//
//  CurrentWeatherData.m
//  OpenWeatherMap
//
//  Created by chencheng on 15/7/10.
//  Copyright (c) 2015年 chencheng. All rights reserved.
//

#import "CurrentWeatherData.h"

@implementation CurrentWeatherData
-(instancetype)init
{
    self = [super init];
    if (self) {
        _date = [[NSDate alloc]init];
        _humidity = [[NSNumber alloc]init];
        _temperature = [[NSNumber alloc]init];
        _tempHigh = [[NSNumber alloc]init];
        _tempLow = [[NSNumber alloc]init];
        _locationName = nil;
        _sunRise = [[NSDate alloc]init];
        _sunSet = [[NSDate alloc]init];
        _conditionDescription = nil;
        _condition = nil;
        _windBearing = [[NSNumber alloc]init];
        _windSpeed = [[NSNumber alloc]init];
        _icon = nil;
    }
    return  self;
}
@end
