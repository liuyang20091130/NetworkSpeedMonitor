//
//  NetWorkSpeedMonitor.h
//  NetworkSpeedMonitor
//
//  Created by 刘洋 on 15/8/24.
//  Copyright (c) 2015年 刘洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

typedef struct LYNetWorkBytes {
    long long int inBytes;
    long long int outBytes;
}LYNetWorkBytes;

@interface LYNetWorkSpeedMonitor : NSObject

@property (assign,nonatomic,readonly) long long int bytesPerSecond;
@property (assign,nonatomic,readonly) LYNetWorkBytes networkBytesPerSecond;
@property (strong,nonatomic,readonly) NSString *speedStr;
@property (assign,nonatomic,readonly,getter=isMonitoring) BOOL monitoring;

@property (assign,nonatomic,readonly) NetworkStatus networkStatus;

+(LYNetWorkSpeedMonitor *)sharedMonitor;
- (void)startMonitor;
- (void)stopMonitor;
@end
