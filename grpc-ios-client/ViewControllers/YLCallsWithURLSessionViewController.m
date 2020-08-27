//
//  YLCallsWithURLSessionViewController.m
//  grpc-ios-client
//
//  Created by 梁煜麟 on 8/27/20.
//  Copyright © 2020 Yulin Liang. All rights reserved.
//

#import "YLCallsWithURLSessionViewController.h"
#import <GRPCClient/GRPCCall.h>
#import <ProtoRPC/ProtoRPC.h>
#import <GRPCCLient/GRPCTransport.h>
#import "YLGreetService.h"

@interface YLCallsWithURLSessionViewController()<GRPCProtoResponseHandler, NSURLSessionDelegate>

@end

@implementation YLCallsWithURLSessionViewController {
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
//    GRPCMutableCallOptions *options = [[GRPCMutableCallOptions alloc] init];
//    options.transport = GRPCDefaultTransportImplList.core_insecure;
//
//    Greeting *greeting = [Greeting message];
//    greeting.firstName = _firstNameTextInput.text;
//    greeting.lastName = _lastNameTextInput.text;
//    GreetRequest *request = [GreetRequest message];
//    request.greeting = greeting;
//
//    GRPCUnaryProtoCall *call = [[[YLGreetService sharedInstance] getClientStub] greetWithMessage:request responseHandler:self callOptions:options];
//    [call start];
//    GRPCMutableCallOptions *options = [[GRPCMutableCallOptions alloc] init];
//    RMTTestService *service = [RMTTestService serviceWithHost:@"grpc-test.sandbox.googleapis.com" callOptions:options];
//    RMTSimpleRequest *requestModel = [RMTSimpleRequest message];
//    requestModel.responseSize = 20;
//    requestModel.payload.body = [NSMutableData dataWithLength:10];
//    GRPCUnaryProtoCall *call = [service unaryCallWithMessage:requestModel responseHandler:self callOptions:nil];
//    [call start];
    
    [self unaryCallWithTest];
}

- (void)unaryCallWithTest {
    NSString *kRemoteHost = @"grpc-test.sandbox.googleapis.com";
    RMTSimpleRequest *requestModel = [RMTSimpleRequest message];
    requestModel.responseSize = 20;
    requestModel.payload.body = [NSMutableData dataWithLength:10];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    request.timeoutInterval = 60;
    request.HTTPMethod = @"POST";
//    [request setValue:@"application/x-protobuf" forHTTPHeaderField:@"content-type"];
//    [request setValue:@"grpc-objc/1.32.0-dev" forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"application/grpc" forHTTPHeaderField:@"content-type"];
    NSURLComponents *urlComponents = [[NSURLComponents alloc] init];
    urlComponents.scheme = @"https";
    urlComponents.host = kRemoteHost;
    urlComponents.path = @"/$rpc/grpc.testing.TestService/UnaryCall";
    request.URL = [urlComponents URL];
    request.HTTPBody = [requestModel data];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        RMTSimpleResponse *parsed = [RMTSimpleResponse parseFromData:data error:&error];
        NSLog(@"Received response: %@", parsed);
        NSLog(@"receive data");
    }];
    
    [task resume];
}

- (void)unaryCallWithNSURLSession {
    GRPCMutableCallOptions *options = [[GRPCMutableCallOptions alloc] init];
    Greeting *greeting = [Greeting message];
    greeting.firstName = _firstNameTextInput.text;
    greeting.lastName = _lastNameTextInput.text;
    GreetRequest *requestModel = [GreetRequest message];
    requestModel.greeting = greeting;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    request.timeoutInterval = 60;
    request.HTTPMethod = @"POST";
    
    if (options.initialMetadata) {
        for (NSString *key in options.initialMetadata) {
            [request setValue:options.initialMetadata[key] forHTTPHeaderField:key];
        }
    } else {
        [request setValue:@"application/grpc" forHTTPHeaderField:@"content-type"];
    }
    
//    NSString *userAgentString = [NSString stringWithFormat:@"grpc-objc/%@", @"1.32.0-dev"];
//    if (options.userAgentPrefix != nil) {
//        userAgentString = [userAgentString stringByAppendingFormat:@" %@", options.userAgentPrefix];
//    }
//    [request setValue:userAgentString forHTTPHeaderField:@"user-agent"];
    
    NSString *host = @"127.0.0.1:50051";
    NSArray<NSString *> *hostComponents = [host componentsSeparatedByString:@":"];
    NSURLComponents *urlComponents = [[NSURLComponents alloc] init];
    urlComponents.scheme = @"https";
    urlComponents.host = hostComponents[0];
    if (hostComponents.count > 1) {
        urlComponents.port = @([hostComponents[1] intValue]);
    }
    urlComponents.path = @"/greet.GreetingService/Greet";
    
    request.URL = [urlComponents URL];
    request.HTTPBody = [requestModel data];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"receive data");
    }];
    
    [task resume];
               
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    //证书的处理方式
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    //网络请求证书
    __block NSURLCredential *credential = nil;
    //判断服务器返回的证书是否是服务器信任的
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) { //受信任的
       //获取服务器返回的证书
        credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        if (credential) {
            disposition = NSURLSessionAuthChallengeUseCredential;
        } else {
            disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        }
    } else {
        disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
    }
    //安装证书
    if (completionHandler) {
        completionHandler(disposition, credential);
    }
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
