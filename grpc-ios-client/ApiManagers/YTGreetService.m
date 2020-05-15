//
//  YTGreetService.m
//  grpc-ios-client
//
//  Created by 梁煜麟 on 5/15/20.
//  Copyright © 2020 Yulin Liang. All rights reserved.
//

#import "YLGreetService.h"

static NSString * const kHostAddress = @"localhost:50051";

@implementation YLGreetService {
    GreetingService *_clientStub;
}

+ (instancetype)sharedInstance {
    static YLGreetService *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[YLGreetService alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        _clientStub = [[GreetingService alloc] initWithHost:kHostAddress];
    }
    
    return self;
}

- (GreetingService *)getClientStub {
    return _clientStub;
}

@end
