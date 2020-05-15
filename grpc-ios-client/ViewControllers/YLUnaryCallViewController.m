//
//  YLUnaryCallViewController.m
//  grpc-ios-client
//
//  Created by 梁煜麟 on 5/15/20.
//  Copyright © 2020 Yulin Liang. All rights reserved.
//

#import "YLUnaryCallViewController.h"
#import <GRPCClient/GRPCCall.h>
#import <ProtoRPC/ProtoRPC.h>
#import <GRPCCLient/GRPCTransport.h>
#import "YLGreetService.h"

@interface YLUnaryCallViewController()<GRPCProtoResponseHandler>

@end

@implementation YLUnaryCallViewController

- (instancetype)init {
    if (self = [super init]) {
        self.view.backgroundColor = [UIColor blueColor];
        [self startUnaryCall];
    }
    
    return self;
}

- (void)startUnaryCall {
    GRPCMutableCallOptions *options = [[GRPCMutableCallOptions alloc] init];
    options.transport = GRPCDefaultTransportImplList.core_insecure;
    
    Greeting *greeting = [Greeting message];
    greeting.firstName = @"Yulin";
    greeting.lastName = @"Liang";
    GreetRequest *request = [GreetRequest message];
    request.greeting = greeting;
    
    GRPCUnaryProtoCall *call = [[[YLGreetService sharedInstance] getClientStub] greetWithMessage:request responseHandler:self callOptions:options];
    [call start];
}

#pragma mark GRPCProtoResponseHandler

- (dispatch_queue_t)dispatchQueue {
    return dispatch_get_main_queue();
}

- (void)didReceiveProtoMessage:(GPBMessage *)message {
    NSLog(@"%@", message);
}

@end
