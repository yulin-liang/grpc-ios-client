//
//  YLClientStreamingCallViewController.m
//  grpc-ios-client
//
//  Created by 梁煜麟 on 5/15/20.
//  Copyright © 2020 Yulin Liang. All rights reserved.
//

#import "YLClientStreamingCallViewController.h"

#import <GRPCClient/GRPCCall.h>
#import <ProtoRPC/ProtoRPC.h>
#import <GRPCCLient/GRPCTransport.h>
#import "YLGreetService.h"

@interface YLClientStreamingCallViewController()<GRPCProtoResponseHandler>

@end

@implementation YLClientStreamingCallViewController

- (instancetype)init {
    if (self = [super init]) {
        self.view.backgroundColor = [UIColor blueColor];
        [self startClientStreamingCall];
    }
    
    return self;
}

- (void)startClientStreamingCall {
    GRPCMutableCallOptions *options = [[GRPCMutableCallOptions alloc] init];
    options.transport = GRPCDefaultTransportImplList.core_insecure;
    
    GRPCStreamingProtoCall *clientStreamingCall = [[[YLGreetService sharedInstance] getClientStub] greetClientStreamWithResponseHandler:self callOptions:options];
    [clientStreamingCall start];
    for (int i = 0; i < 10; i++) {
        Greeting *greetRequest = [Greeting message];
        greetRequest.firstName = [NSString stringWithFormat:@"%d - Yulin", i];
        greetRequest.lastName = @"Liang";
        [clientStreamingCall writeMessage:greetRequest];
    }
    [clientStreamingCall finish];
}

#pragma mark GRPCProtoResponseHandler

- (dispatch_queue_t)dispatchQueue {
    return dispatch_get_main_queue();
}

- (void)didReceiveProtoMessage:(GPBMessage *)message {
    NSLog(@"%@", message);
}

@end

