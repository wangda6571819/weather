//
//  TableViewCell.h
//  天气预报
//
//  Created by 陈铖 on 15/7/10.
//  Copyright (c) 2015年 wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *TimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *conditionLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;

@end
