//
//  SevenDayData.h
//  OpenWeatherMap
//
//  Created by chencheng on 15/7/10.
//  Copyright (c) 2015年 chencheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SevenDayData : NSObject
@property (strong,nonatomic) NSNumber *tempHigh;
@property (strong,nonatomic) NSNumber *tempLow;
@property (strong,nonatomic) NSString *weekDay;
@property (strong,nonatomic) NSString *icon;
@property (strong,nonatomic) NSString *condition;
@end
