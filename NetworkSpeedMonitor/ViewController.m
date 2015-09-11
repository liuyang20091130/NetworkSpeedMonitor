//
//  ViewController.m
//  NetworkSpeedMonitor
//
//  Created by 刘洋 on 15/8/24.
//  Copyright (c) 2015年 刘洋. All rights reserved.
//

#import "ViewController.h"

#import "NetWorkSpeedMonitor.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UILabel *speedLabel;
@property (strong, nonatomic) IBOutlet UIButton *startBtn;
@property (strong, nonatomic) IBOutlet UIButton *stopBtn;

@property (strong,nonatomic) LYNetWorkSpeedMonitor *speedMonitor;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.speedMonitor = [LYNetWorkSpeedMonitor sharedMonitor];
    [self.speedMonitor startMonitor];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self.speedMonitor stopMonitor];
    self.speedMonitor = nil;
}

#pragma mark - Customer Accesser
- (void)setSpeedMonitor:(LYNetWorkSpeedMonitor *)speedMonitor {
    
    if (_speedMonitor) {
        [_speedMonitor removeObserver:self forKeyPath:@"bytesPerSecond"];
        [_speedMonitor removeObserver:self forKeyPath:@"monitoring"];
    }
    
    _speedMonitor = speedMonitor;
    
    if (_speedMonitor) {
        [_speedMonitor addObserver:self forKeyPath:@"bytesPerSecond" options:NSKeyValueObservingOptionNew context:nil];
        [_speedMonitor addObserver:self forKeyPath:@"monitoring" options:NSKeyValueObservingOptionNew context:nil];
    }
}

#pragma mark - IBActions
- (IBAction)start:(id)sender {
    [self.speedMonitor startMonitor];
}
- (IBAction)stop:(id)sender {
    [self.speedMonitor stopMonitor];
}


#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString: @"bytesPerSecond"]) {
        self.speedLabel.text = [NSString stringWithFormat:@" 下载：%15s \n 上传：%15s \n 总计：%15s",[self.speedMonitor.downloadStr UTF8String],[self.speedMonitor.uploadStr UTF8String],[self.speedMonitor.speedStr UTF8String]];
    } else if ([keyPath isEqualToString: @"monitoring"]) {
        if (!self.speedMonitor.isMonitoring) {
            self.speedLabel.text = @"未监测";
        }
        self.startBtn.enabled = !self.speedMonitor.isMonitoring;
        self.stopBtn.enabled = !self.startBtn.enabled;
    }
}

@end
