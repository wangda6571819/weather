//
//  SevenDayData.m
//  OpenWeatherMap
//
//  Created by chencheng on 15/7/10.
//  Copyright (c) 2015年 chencheng. All rights reserved.
//

#import "SevenDayData.h"

@implementation SevenDayData
-(instancetype)init
{
    self = [super init];
    if (self) {
        _weekDay = nil;
        _icon = nil;
        _condition = nil;
        _tempHigh=[[NSNumber alloc]init];
        _tempLow=[[NSNumber alloc]init];
    }
    return self;
}
@end
