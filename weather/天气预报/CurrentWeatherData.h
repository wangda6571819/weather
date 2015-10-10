//
//  CurrentWeatherData.h
//  OpenWeatherMap
//
//  Created by chencheng on 15/7/10.
//  Copyright (c) 2015年 chencheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrentWeatherData : NSObject
@property (strong,nonatomic) NSDate *date;
@property (strong,nonatomic) NSNumber *humidity;
@property (strong,nonatomic) NSNumber *temperature;
@property (strong,nonatomic) NSNumber *tempHigh;
@property (strong,nonatomic) NSNumber *tempLow;
@property (strong,nonatomic) NSString *locationName;
@property (strong,nonatomic) NSDate *sunRise;
@property (strong,nonatomic) NSDate *sunSet;
@property (strong,nonatomic) NSString *conditionDescription;
@property (strong,nonatomic) NSString *condition;
@property (strong,nonatomic) NSNumber *windBearing;
@property (strong,nonatomic) NSNumber *windSpeed;
@property (strong,nonatomic) NSString *icon;
@end
