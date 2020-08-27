//
//  YLGreetService.h
//  grpc-ios-client
//
//  Created by 梁煜麟 on 5/15/20.
//  Copyright © 2020 Yulin Liang. All rights reserved.
//

#import "google/protobuf/Greet.pbrpc.h"
#import "google/protobuf/Test.pbrpc.h"

@interface YLGreetService : NSObject

+ (YLGreetService *)sharedInstance;

/**return a client stub which is used to make RPC calls.*/
- (GreetingService *)getClientStub;

@end
