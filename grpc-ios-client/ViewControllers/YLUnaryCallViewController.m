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

@interface YLUnaryCallViewController()<GRPCProtoResponseHandler, NSURLSessionDelegate>

@end

@implementation YLUnaryCallViewController {
    UITextView *_firstNameTextInput;
    UITextView *_lastNameTextInput;
    UIButton *_submitBtn;
    UILabel *_responseLabel;
}

- (instancetype)init {
    if (self = [super init]) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat startOffX = 30;
    CGFloat startOffY = 100;
    CGFloat maxWidth = self.view.frame.size.width - startOffX;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(startOffX, startOffY, maxWidth, 30)];
    titleLabel.text = @"Start an unary call:";
    [self.view addSubview:titleLabel];
    
    startOffY += titleLabel.frame.size.height + 10;
    UILabel *firstNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(startOffX, startOffY, 100, 30)];
    firstNameLabel.text = @"firstName:";
    [self.view addSubview:firstNameLabel];
    
    _firstNameTextInput = [[UITextView alloc] initWithFrame:CGRectMake(startOffX + firstNameLabel.frame.size.width + 10, startOffY, maxWidth - 100 - startOffX, 30)];
    _firstNameTextInput.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _firstNameTextInput.layer.borderWidth = 1;
    [self.view addSubview:_firstNameTextInput];
    
    startOffY += _firstNameTextInput.frame.size.height + 5;
    UILabel *lastNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(startOffX, startOffY, 100, 30)];
    lastNameLabel.text = @"lastName:";
    [self.view addSubview:lastNameLabel];
    
    _lastNameTextInput = [[UITextView alloc] initWithFrame:CGRectMake(startOffX + lastNameLabel.frame.size.width + 10, startOffY, maxWidth - 100 - startOffX, 30)];
    _lastNameTextInput.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _lastNameTextInput.layer.borderWidth = 1;
    [self.view addSubview:_lastNameTextInput];
    
    startOffY += _lastNameTextInput.frame.size.height + 20;
    _submitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_submitBtn addTarget:self action:@selector(startCall) forControlEvents:UIControlEventTouchUpInside];
    [_submitBtn setFrame:CGRectMake(startOffX, startOffY, maxWidth - startOffX, 30)];
    [_submitBtn setTitle:@"Make a unary request" forState:UIControlStateNormal];
    [self.view addSubview:_submitBtn];
    
    startOffY += _submitBtn.frame.size.height + 50;
    UILabel *resultTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(startOffX, startOffY, maxWidth - startOffX, 50)];
    resultTitleLable.text = @"Response:";
    [self.view addSubview:resultTitleLable];
    
    startOffY += resultTitleLable.frame.size.height;
    _responseLabel = [[UILabel alloc] initWithFrame:CGRectMake(startOffX, startOffY, maxWidth - startOffX, 100)];
    _responseLabel.numberOfLines = 0;
    _responseLabel.font = [UIFont systemFontOfSize:14];
    _responseLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _responseLabel.layer.borderWidth = 1;
    [self.view addSubview:_responseLabel];
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

- (void)startCall {
    GRPCMutableCallOptions *options = [[GRPCMutableCallOptions alloc] init];
    options.transport = GRPCDefaultTransportImplList.core_insecure;

    Greeting *greeting = [Greeting message];
    greeting.firstName = _firstNameTextInput.text;
    greeting.lastName = _lastNameTextInput.text;
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
    if ([message isKindOfClass:[GreetResponse class]]) {
        _responseLabel.text = ((GreetResponse *)message).result;
    }
}

@end
