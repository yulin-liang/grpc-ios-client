//
//  ViewController.m
//  grpc-ios-client
//
//  Created by 梁煜麟 on 5/11/20.
//  Copyright © 2020 梁煜麟. All rights reserved.
//

#import "ViewController.h"
#import "google/protobuf/Greet.pbrpc.h"
#import <GRPCClient/GRPCCall.h>
#import <ProtoRPC/ProtoRPC.h>
#import <GRPCCLient/GRPCTransport.h>

static NSString * const kHostAddress = @"localhost:50051";

@interface ViewController ()

@end

@interface TestResponseHandler : NSObject<GRPCProtoResponseHandler>

@end

@implementation TestResponseHandler

- (dispatch_queue_t)dispatchQueue {
    return dispatch_get_main_queue();
}

- (void)didReceiveProtoMessage:(GPBMessage *)message {
    NSLog(@"%@", message);
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GreetingService *client = [[GreetingService alloc] initWithHost:kHostAddress];
    
    GRPCMutableCallOptions *options = [[GRPCMutableCallOptions alloc] init];
    options.transport = GRPCDefaultTransportImplList.core_insecure;
    
    Greeting *greeting = [Greeting message];
    greeting.firstName = @"Yulin";
    greeting.lastName = @"Liang";
    GreetRequest *request = [GreetRequest message];
    request.greeting = greeting;
    
    GRPCUnaryProtoCall *call = [client greetWithMessage:request
                                        responseHandler:[[TestResponseHandler alloc] init]
                                            callOptions:options];
    [call start];
    
    
    GRPCStreamingProtoCall *clientStreamingCall = [client greetClientStreamWithResponseHandler:[[TestResponseHandler alloc] init] callOptions:options];
    [clientStreamingCall start];
    for (int i = 0; i < 10; i++) {
        Greeting *greetRequest = [Greeting message];
        greetRequest.firstName = [NSString stringWithFormat:@"%d", i];
        greetRequest.lastName = @"Liang";
        [clientStreamingCall writeMessage:greetRequest];
    }
    [clientStreamingCall finish];
}


@end
