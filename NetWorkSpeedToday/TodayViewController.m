//
//  TodayViewController.m
//  NetWorkSpeedToday
//
//  Created by 刘洋 on 15/8/26.
//  Copyright (c) 2015年 刘洋. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "NetWorkSpeedMonitor.h"

#import "ViewController.h"

@interface TodayViewController () <NCWidgetProviding>

@property (strong, nonatomic) IBOutlet UILabel *speedLabel;

@property (strong,nonatomic) LYNetWorkSpeedMonitor *speedMonitor;
@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.speedMonitor = [LYNetWorkSpeedMonitor sharedMonitor];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.speedMonitor startMonitor];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.speedMonitor stopMonitor];
    self.speedMonitor = nil;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    
    

    completionHandler(NCUpdateResultNewData);
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
    return UIEdgeInsetsZero;
}

#pragma mark - Customer Accesser
- (void)setSpeedMonitor:(LYNetWorkSpeedMonitor *)speedMonitor {
    
    if (_speedMonitor) {
        [_speedMonitor removeObserver:self forKeyPath:@"bytesPerSecond"];
    }
    _speedMonitor = speedMonitor;
    if (_speedMonitor) {
        [_speedMonitor addObserver:self forKeyPath:@"bytesPerSecond" options:NSKeyValueObservingOptionNew context:nil];
    }
}
#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString: @"bytesPerSecond"]) {
        self.speedLabel.text = self.speedMonitor.speedStr;
        self.speedLabel.text = [NSString stringWithFormat:@" 下载：%15s \n 上传：%15s \n 总计：%15s",[self.speedMonitor.downloadStr UTF8String],[self.speedMonitor.uploadStr UTF8String],[self.speedMonitor.speedStr UTF8String]];
    }
}

@end
