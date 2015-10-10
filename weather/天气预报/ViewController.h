//
//  ViewController.h
//  天气预报
//
//  Created by wangda on 15/7/10.
//  Copyright (c) 2015年 wang. All rights reserved.
//




#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)NSString *cityName;

@end

