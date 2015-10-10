//
//  OneDayWeatherData.m
//  OpenWeatherMap
//
//  Created by chencheng on 15/7/10.
//  Copyright (c) 2015年 chencheng. All rights reserved.
//

#import "ThreeHoursData.h"

@implementation ThreeHoursData
-(instancetype)init
{
    self = [super init];
    if (self) {
        _temperature = [[NSNumber alloc]init];
        _date = nil;
        _icon = nil;
        _condition = nil;
        _hour = nil;
        _tempHigh=[[NSNumber alloc]init];
        _tempLow=[[NSNumber alloc]init];
    }
    return self;
}
@end

