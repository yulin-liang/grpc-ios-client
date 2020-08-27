#if !defined(GPB_GRPC_PROTOCOL_ONLY) || !GPB_GRPC_PROTOCOL_ONLY
#import "google/protobuf/Test.pbrpc.h"
#import "google/protobuf/Test.pbobjc.h"
#import <ProtoRPC/ProtoRPCLegacy.h>
#import <RxLibrary/GRXWriter+Immediate.h>


@implementation RMTTestService

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-designated-initializers"

// Designated initializer
- (instancetype)initWithHost:(NSString *)host callOptions:(GRPCCallOptions *_Nullable)callOptions {
  return [super initWithHost:host
                 packageName:@"grpc.testing"
                 serviceName:@"TestService"
                 callOptions:callOptions];
}

- (instancetype)initWithHost:(NSString *)host {
  return [super initWithHost:host
                 packageName:@"grpc.testing"
                 serviceName:@"TestService"];
}

#pragma clang diagnostic pop

// Override superclass initializer to disallow different package and service names.
- (instancetype)initWithHost:(NSString *)host
                 packageName:(NSString *)packageName
                 serviceName:(NSString *)serviceName {
  return [self initWithHost:host];
}

- (instancetype)initWithHost:(NSString *)host
                 packageName:(NSString *)packageName
                 serviceName:(NSString *)serviceName
                 callOptions:(GRPCCallOptions *)callOptions {
  return [self initWithHost:host callOptions:callOptions];
}

#pragma mark - Class Methods

+ (instancetype)serviceWithHost:(NSString *)host {
  return [[self alloc] initWithHost:host];
}

+ (instancetype)serviceWithHost:(NSString *)host callOptions:(GRPCCallOptions *_Nullable)callOptions {
  return [[self alloc] initWithHost:host callOptions:callOptions];
}

#pragma mark - Method Implementations

#pragma mark EmptyCall(Empty) returns (Empty)

- (void)emptyCallWithRequest:(RMTEmpty *)request handler:(void(^)(RMTEmpty *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToEmptyCallWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (GRPCProtoCall *)RPCToEmptyCallWithRequest:(RMTEmpty *)request handler:(void(^)(RMTEmpty *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"EmptyCall"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[RMTEmpty class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
- (GRPCUnaryProtoCall *)emptyCallWithMessage:(RMTEmpty *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions {
  return [self RPCToMethod:@"EmptyCall"
                   message:message
           responseHandler:handler
               callOptions:callOptions
             responseClass:[RMTEmpty class]];
}

#pragma mark UnaryCall(SimpleRequest) returns (SimpleResponse)

- (void)unaryCallWithRequest:(RMTSimpleRequest *)request handler:(void(^)(RMTSimpleResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToUnaryCallWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (GRPCProtoCall *)RPCToUnaryCallWithRequest:(RMTSimpleRequest *)request handler:(void(^)(RMTSimpleResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"UnaryCall"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[RMTSimpleResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
- (GRPCUnaryProtoCall *)unaryCallWithMessage:(RMTSimpleRequest *)message responseHandler:(id<GRPCProtoResponseHandler>)handler callOptions:(GRPCCallOptions *_Nullable)callOptions {
  return [self RPCToMethod:@"UnaryCall"
                   message:message
           responseHandler:handler
               callOptions:callOptions
             responseClass:[RMTSimpleResponse class]];
}

@end
#endif
