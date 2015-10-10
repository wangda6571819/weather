//
//  ViewController.m
//  天气预报
//
//  Created by wangda on 15/7/10.
//  Copyright (c) 2015年 wang. All rights reserved.
//

#import "ViewController.h"
#import "LBBlurredImage/UIImageView+LBBlurredImage.h"
#import "Masonry.h"
#import "OpenWeatherMapInterface.h"
#import "TableViewCell.h"
#import "CBChartView.h"
#import "ThreeHoursData.h"
#import "BTGlassScrollView.h"

//#define _height self.view.bounds.size.height
//#define _width self.view.bounds.size.width



@interface ViewController ()<UIScrollViewAccessibilityDelegate>
@property (strong,nonatomic)UIImageView *blurredView;
@property (strong,nonatomic)UITableView *tableView;
@property (strong,nonatomic)UIScrollView *scrollView;
@property (strong,nonatomic)CurrentWeatherData * weatherCurrentData;
@property (strong,nonatomic)NSMutableArray *hoursTempreture;
@property (strong,nonatomic)NSMutableArray *daysTempreture;
@property (strong,nonatomic)NSString *intString;


@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,strong) UIPageControl *pageControl;

@property(nonatomic,strong) UIImageView *backGround;

@property (nonatomic,strong) UIScrollView * viewScroller;
@property (nonatomic,strong) NSArray * cityArr;
@property int pageNum;
@end

static NSString *Cell = @"TableViewCell";


@implementation ViewController

-(void)viewWillAppear:(BOOL)animated
{
    //整体布局
    UIImage * backgroundImage = [UIImage imageNamed:@"bg3"];
    // Do any additional setup after loading the view, typically from a nib.
    self.backGround =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _width,_height )];
    self.backGround.contentMode=UIViewContentModeScaleToFill;
    self.backGround.image = backgroundImage;
    [self.view addSubview:self.backGround];
    
    
    [self addTimer];
    self.pageNum   = 0;
    NSShadow *shadow = [[NSShadow alloc] init];
    [shadow setShadowOffset:CGSizeMake(1, 1)];
    [shadow setShadowColor:[UIColor blackColor]];
    [shadow setShadowBlurRadius:1];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor], NSShadowAttributeName: shadow};
    self.navigationController.navigationBarHidden = NO ;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.title = @"天气预报";
    
    [self addTimer];
    
    
    
    self.cityArr =[NSArray arrayWithObjects:@"南京",@"上海",@"北京",@"广州",@"深圳",nil];
    
    self.viewScroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width*[self.cityArr count], self.view.frame.size.height)];
    for (NSString * cityName in self.cityArr) {
        
        
        
        BTGlassScrollView *glassScrollView =[[BTGlassScrollView alloc]initWithFrame:self.view.frame];
        [glassScrollView setFrame:CGRectOffset(glassScrollView.bounds, self.pageNum*_width, 0)];
        
        [self getCityWithName:cityName withScrollView:glassScrollView];
        self.pageNum ++;
        [self.viewScroller addSubview:glassScrollView];
    }
    //    [self.viewScroller setContentOffset:CGPointMake([self.cityArr count] * self.viewScroller.frame.size.width, self.viewScroller.contentOffset.y)];
    //    [self.viewScroller setContentOffset:CGPointMake(-50, 0)];
    [self.view addSubview:self.viewScroller];
    
    self.pageNum   = 0;
    UISwipeGestureRecognizer* recognizerR;
    // handleSwipeFrom 是偵測到手势，所要呼叫的方法
    recognizerR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight)];
    // 不同的 Recognizer 有不同的实体变数
    // 例如 SwipeGesture 可以指定方向
    // 而 TapGesture 則可以指定次數
    recognizerR.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:recognizerR];
    
    
    UISwipeGestureRecognizer* recognizerL;
    // handleSwipeFrom 是偵測到手势，所要呼叫的方法
    recognizerL = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft)];
    // 不同的 Recognizer 有不同的实体变数
    // 例如 SwipeGesture 可以指定方向
    // 而 TapGesture 則可以指定次數
    recognizerL.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:recognizerL];
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    
    
}



-(void)handleSwipeRight
{
    self.pageNum--;
    if (self.pageNum == -1) {
        self.pageNum = 4;
    }
    [self changeThePageWithWay:@"right"];
}

-(void)handleSwipeLeft
{
    self.pageNum++;
    if (self.pageNum == [self.cityArr count]) {
        self.pageNum = 0;
    }
    [self changeThePageWithWay:@"left"];
}



-(void)changeThePageWithWay:(NSString *)way
{
    
    
    
    [ UIView beginAnimations : nil context : nil ];
    // 持续时间
    
    [ UIView setAnimationDuration : 1.0 ];
    
    // 在出动画的时候减缓速度
    [ UIView setAnimationCurve : UIViewAnimationCurveLinear ];
    // 添加动画开始及结束的代理
    [ UIView setAnimationDelegate : self ];
    [ UIView setAnimationWillStartSelector : @selector (begin)];
    
    [ UIView setAnimationDidStopSelector : @selector (stopAnimating)];
    
    // 动画效果
    if ([way isEqualToString: @"left"]) {
        [ UIView setAnimationTransition : UIViewAnimationTransitionNone forView : self . view cache : YES ];
    }
    else{
        [ UIView setAnimationTransition : UIViewAnimationTransitionNone forView : self . view cache : YES ];
    }
    
    //View 切换
//    int maxPage = (int)[self.cityArr count];
    [self.viewScroller setContentOffset:CGPointMake(self.pageNum*_width, 0)];
    
    [UIView commitAnimations ];
}


//获得城市列表
-(void)getCityWithName:(NSString  * )name withScrollView:(BTGlassScrollView *)view
{
    self.cityName = name;
    
    self.weatherCurrentData =[[CurrentWeatherData alloc]init];
    self.weatherCurrentData=[OpenWeatherMapInterface getCurrentDataWithCityName:self.cityName andCountryCode:nil];
    
    
    self.hoursTempreture=[OpenWeatherMapInterface getOneDayWwatherDataWithCityName:self.cityName andCountryCode:nil];
    
    self.daysTempreture = [OpenWeatherMapInterface getSevenDayWwatherDataWithCityName:self.cityName andCountryCode:nil];
    
    
    [self setAllLayOutWithView:view];
    
    UINib *nib = [UINib nibWithNibName:@"TableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:Cell];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}




#pragma mark - AllLayout 
    //设置整体布局
-(void)setAllLayOutWithView:(BTGlassScrollView *)view
{

    
    
    
    
    
    UIImage * backgroundImage = [UIImage imageNamed:@"bg3"];
        //模糊视图
    self.blurredView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _width,_height)];
    [self.blurredView setImageToBlur:backgroundImage blurRadius:10 completionBlock:nil];
    self.blurredView.alpha =0;
    [view addSubview:self.blurredView];
    
        //滚动图
    self.scrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, _width,_height)];
    self.scrollView.backgroundColor=[UIColor clearColor];
    self.scrollView.contentSize=CGSizeMake(_width, _height*3);
    self.scrollView.scrollEnabled=YES;
    self.scrollView.pagingEnabled=YES;
    self.scrollView.delegate=self;
    
    [view addSubview:self.scrollView];
    
    
    
    
     UIPageControl *pageControl = [[UIPageControl alloc] init];
     pageControl.center = CGPointMake(_width/2, 30); // 设置pageControl的位置
     pageControl.numberOfPages = [self.cityArr count];
     pageControl.currentPage = self.pageNum;
    
     [pageControl setBounds:CGRectMake(0,0,16*([self.cityArr count]-1)+16,16)]; //页面控件上的圆点间距基本在16左右。
     [pageControl.layer setCornerRadius:8]; // 圆角层
     [pageControl setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.2]];
     [view addSubview:pageControl];
    
    
        // 使用
//    CBChartView *chartView = [[CBChartView alloc]init];
//    chartView.shutDefaultAnimation = YES;
//    [self.scrollView addSubview:chartView];
//    NSRange rangeTime =NSMakeRange(11, 2);
//    NSMutableArray *xValueArr=[[NSMutableArray alloc]init];
//    NSMutableArray *yValueArr=[[NSMutableArray alloc]init];
//    float maxTem =-100;
//    float minTem =100;
//    for (ThreeHoursData * temp in self.hoursTempreture) {
//        [xValueArr addObject:[temp.date  substringWithRange:rangeTime]];
//        [yValueArr addObject:[temp.temperature stringValue]];
//        if (maxTem<[temp.temperature floatValue]) {
//            maxTem=[temp.temperature floatValue];
//        }
//        if (minTem>[temp.temperature floatValue]) {
//            minTem=[temp.temperature floatValue];
//        }
//    }
//    
//    
//    chartView.xValues = xValueArr;
//    chartView.yValues = yValueArr;
//    chartView.chartWidth = 2.0;
//    chartView.chartColor = [UIColor whiteColor];
//    
//
//    
//    [UIView animateWithDuration:1 animations:^{
//        chartView.frame = CGRectMake(10, 110, 310, 300);
//    }];
    
    
    
    
    
    //--------------------------------------------------
   /*
    CGFloat imageW = self.scrollView.frame.size.width;
    CGFloat imageH = self.scrollView.frame.size.height;
    CGFloat imageY = 0;
    NSInteger totalCount = 3;
    for (int i = 0; i<totalCount; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        
        CGFloat imageX = i*imageW;
        
        imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
        NSString *name = [NSString stringWithFormat:@"bg%d",i+1];
        imageView.image = [UIImage imageNamed:name];
        [self.scrollView addSubview:imageView];
    }
    
    self.pageControl = [[UIPageControl alloc]init];
    //[self.scrollView addSubview:self.pageControl];
    
    CGFloat scrollviewW =  self.scrollView.frame.size.width;
        CGFloat x = self.scrollView.contentOffset.x;
        int page = (x + scrollviewW / 2) /  scrollviewW;
        self.pageControl.currentPage = page;
    */
    //--------------------------------------------------
    
    
    
    
    
        //滚动图里的表格
    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, _height, _width,_height*2)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor colorWithWhite:1 alpha:0.0];
    self.tableView.pagingEnabled = YES;
    [self.scrollView  addSubview:self.tableView];
    
    
    
//    self.weatherCurrentData.tempLow=[NSNumber numberWithFloat:minTem];
//    self.weatherCurrentData.tempHigh=[NSNumber numberWithFloat:maxTem];
    
    
    [self setTheCurrentMessage:self.weatherCurrentData];
    
}


 
#pragma  mark - setImmediatelyInformation
-(void)setTheCurrentMessage:(CurrentWeatherData *)data
{
        //第一页中的即时信息
    UILabel *cityName =[[UILabel alloc]init];
    cityName.text=self.cityArr[self.pageNum];
    cityName.font=[UIFont fontWithName:nil size:50];
    cityName.textColor=[UIColor whiteColor];
    [self.scrollView addSubview:cityName];
    [cityName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scrollView.mas_centerX);
        make.top.equalTo(self.scrollView.mas_top).with.offset(60);
    }];
    
    
    
    UIButton * cityChoose =[[UIButton alloc]init];
    cityChoose.tintColor = [UIColor whiteColor];
    [cityChoose setTitle:@"手动选择城市" forState:UIControlStateNormal];
    [cityChoose.titleLabel setFont:[UIFont fontWithName:nil size:18]];
    cityChoose.titleLabel.tintColor = [UIColor whiteColor];
    cityChoose.backgroundColor = [UIColor clearColor];
    [cityChoose addTarget:self action:@selector(chooseTheCity) forControlEvents:UIControlEventTouchDown];
    [self.scrollView addSubview:cityChoose];
    [cityChoose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cityName.mas_centerY);
        make.right.equalTo(self.scrollView.mas_rightMargin).with.offset(-20);
    }];
    
    
    UIImageView *weatherImage =[[UIImageView alloc]initWithImage:[UIImage imageNamed:data.icon]];
    [self.scrollView addSubview:weatherImage];
    [weatherImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.mas_left).with.offset(20);
        make.bottom.equalTo(self.tableView.mas_top).with.offset(-220);
        make.height.equalTo(@30);
        make.width.equalTo(@30);
    }];
    
    UILabel *weatherLabel =[[UILabel alloc]init];
    weatherLabel.text=data.conditionDescription;
    weatherLabel.font=[UIFont fontWithName:nil size:25];
    weatherLabel.textColor=[UIColor whiteColor];
    [self.scrollView addSubview:weatherLabel];
    [weatherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weatherImage.mas_centerY);
        make.left.equalTo(weatherImage.mas_right).with.offset(30);
    }];
    
    UILabel *currentTempretureLabel =[[UILabel alloc]init];
    currentTempretureLabel.text=[NSString stringWithFormat:@"%.fº",[data.temperature floatValue]];
    currentTempretureLabel.font=[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:120];
    currentTempretureLabel.textColor=[UIColor whiteColor];
    [self.scrollView addSubview:currentTempretureLabel];
    [currentTempretureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weatherImage.mas_bottom).with.offset(5);
        make.left.equalTo(weatherImage.mas_right).with.offset(-10);
    }];
    
    
    UILabel *tempretureRangeLabel =[[UILabel alloc]init];
    tempretureRangeLabel.text=[NSString stringWithFormat:@"%.fº-%.fº",[data.tempLow floatValue],[data.tempHigh floatValue]];
    tempretureRangeLabel.font=[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:40];
    tempretureRangeLabel.textColor=[UIColor whiteColor];
    [self.scrollView addSubview:tempretureRangeLabel];
    [tempretureRangeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(currentTempretureLabel.mas_bottom).with.offset(10);
        make.left.equalTo(weatherImage.mas_left);
    }];
    
   
}

#pragma  mark - tableView delegate (delegate and dataSource)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.hoursTempreture.count+1;
    }else{
        return self.daysTempreture.count+1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Cell];
    if (! cell) {
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Cell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.conditionLabel.textColor = [UIColor whiteColor];
    cell.TimeLabel.textColor = [UIColor whiteColor];
    cell.tempLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.1];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.conditionLabel.text = nil;
            cell.TimeLabel.text = nil;
            cell.tempLabel.text = nil;
            NSString *dateStr = [OpenWeatherMapInterface getDay];
            [self configureHeaderCell:cell title:dateStr];
        }
        else {
            cell.imageView.image =[UIImage imageNamed:[self.hoursTempreture[indexPath.row-1] valueForKey:@"icon"]];
            cell.TimeLabel.text = [NSString stringWithFormat:@"%@ %@",  [[[self.hoursTempreture[indexPath.row-1] valueForKey:@"date"] substringFromIndex:11] substringToIndex:2],[self.hoursTempreture[indexPath.row-1] valueForKey:@"hour"]];
            NSLog(@"----------------------text is %@",cell.TimeLabel.text);
            cell.tempLabel.text =[NSString stringWithFormat:@"%d℃",[[self.hoursTempreture[indexPath.row-1] valueForKey:@"temperature"] intValue]];
            cell.conditionLabel.text = [self.hoursTempreture[indexPath.row-1] valueForKey:@"condition"];
        }
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.conditionLabel.text = nil;
            cell.TimeLabel.text = nil;
            cell.tempLabel.text = nil;
           [self configureHeaderCell:cell title:@"一周天气"];
        }
        else {
            
            int tempHigh = [[self.daysTempreture[indexPath.row-1] tempHigh] intValue];
            int tempLow = [[self.daysTempreture[indexPath.row-1] tempLow] intValue];
            NSString *icon1 = [self.daysTempreture[indexPath.row-1] icon];
            cell.imageView.image =[UIImage imageNamed:icon1];
            cell.tempLabel.text = [NSString stringWithFormat:@"%d/%d℃",tempHigh,tempLow];
            cell.TimeLabel.text = [self.daysTempreture[indexPath.row-1] valueForKey:@"weekDay"];
            cell.conditionLabel.text = [self.daysTempreture[indexPath.row-1] valueForKey:@"condition"];
        }
    }
    return cell;
    
    
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger cellCount = [self tableView:tableView numberOfRowsInSection:indexPath.section];
    return _height / ((CGFloat)cellCount);
}




- (void)configureHeaderCell:(UITableViewCell *)cell title:(NSString *)title {
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    cell.textLabel.text = title;
    cell.detailTextLabel.text = @"";
    cell.imageView.image = nil;
}



#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat height = scrollView.bounds.size.height;
    CGFloat position = MAX(scrollView.contentOffset.y, 0.0);
    CGFloat percent = MIN(position / height, 1.0);
    self.blurredView.alpha = percent;
}




-(void)request: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg  {
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, HttpArg];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [request addValue: @"ade0c46e82a50e4d21ba134779d94254" forHTTPHeaderField: @"apikey"];

    NSURLResponse *res = [[NSURLResponse alloc]init];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&res error:nil];
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    self.cityName =[dict[@"retData"] objectForKey:@"city"];

}
static int i = 0;


-(void)nextImage
{
    NSLog(@"in timer~~~~");
    
    UIImage *backgroundImage;
    if(i == 0)
    {
       backgroundImage  = [UIImage imageNamed:@"bg1"];
        NSLog(@"in i =0 ");
    }
    if (i==1) {
        backgroundImage = [UIImage imageNamed:@"bg2"];
        NSLog(@"in i =1 ");

    }
    if (i==2) {
       backgroundImage = [UIImage imageNamed:@"bg3"];
        i=-1;
        NSLog(@"in i =2 ");

    }
    i++;
    
    
    //--------------虽然实现了，但是对于一些参数的改变还是显得没有生效，没有那么顺手好用啊
    CATransition *animation = [CATransition animation];
    [animation setDuration:2.0f];
    //[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    //[animation setType:kCATransitionReveal];
    //[animation setType:kCAEmitterBehaviorDrag];
    [animation setType:kCAEmitterBehaviorColorOverLife];
    
    [animation setSubtype: kCATransitionFromBottom];
    self.backGround.image = backgroundImage;
    [self.view.layer addAnimation:animation forKey:@"Reveal"];
    // [self.view.layer addAnimation:animation forKey:@"cube"];
       // Do any additional setup after loading the view, typically from a nib.
   // UIImageView *backGround =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _width,_height )];
    /*[UIView animateWithDuration:1.2 animations:^{
        
     
       // self.backGround.alpha = 0.5;
        
      //  self.backGround.alpha = 1.0;
    }];*/
   
    [self.blurredView setImageToBlur:backgroundImage blurRadius:10 completionBlock:nil];
   /* int page = (int)self.pageControl.currentPage;
        if (page == 2) {
               page = 0;
          }else
              {
                      page++;
                   }
  
    //  滚动scrollview
      CGFloat x = page * self.scrollView.frame.size.width;
       self.scrollView.contentOffset = CGPointMake(x, 0);*/
}




#pragma  mark -the timer
//开启定时器
-(void)addTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
}

//关闭定时器
-(void)removeTimer{
    [self.timer invalidate];
}


#pragma  mark - choose the city
-(void)chooseTheCity
{
    
}



@end
