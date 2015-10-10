//
//  OneDayWeatherData.h
//  OpenWeatherMap
//
//  Created by chencheng on 15/7/10.
//  Copyright (c) 2015年 chencheng. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ThreeHoursData : NSObject
@property (strong,nonatomic) NSNumber *temperature; //Kelvin:(K)开氏度(摄氏度+273.16)
@property (strong,nonatomic) NSString *date;
@property (strong,nonatomic) NSString *icon;
@property (strong,nonatomic) NSString *condition;
@property (strong,nonatomic) NSString *hour;
@property (strong,nonatomic) NSNumber *tempHigh;
@property (strong,nonatomic) NSNumber *tempLow;
@end

