//
//  AFHTTPRequestSerializer+ACNetworking.m
//  AppComponents
//
//  Created by Elf Sundae on 16/03/30.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "AFHTTPRequestSerializer+ACNetworking.h"
#import <ESFramework/ESFrameworkCore.h>

ESDefineAssociatedObjectKey(extraRequestSerializer);

@implementation AFHTTPRequestSerializer (ACNetworking)

+ (void)load
{
        ESSwizzleInstanceMethod(self, @selector(requestBySerializingRequest:withParameters:error:), @selector(ac_requestBySerializingRequest:withParameters:error:));
}

- (NSURLRequest *)ac_requestBySerializingRequest:(NSURLRequest *)request
                                  withParameters:(id)parameters
                                           error:(NSError **)error
{
        NSError *__autoreleasing originalError = nil;
        NSURLRequest *originalRequest = [self ac_requestBySerializingRequest:request withParameters:parameters error:&originalError];
        
        if (!originalError && originalRequest && self.extraRequestSerializer) {
                NSMutableURLRequest *mutableRequest = ([originalRequest isKindOfClass:[NSMutableURLRequest class]] ? (NSMutableURLRequest *)originalRequest : [originalRequest mutableCopy]);
                self.extraRequestSerializer(self, mutableRequest, parameters, &originalError);
                originalRequest = mutableRequest;
        }
        
        if (originalError) {
                if (error) {
                        *error = originalError;
                }
                return nil;
        }
        
        return originalRequest;
}

- (void (^)(AFHTTPRequestSerializer *serializer, NSMutableURLRequest *request, id parameters, NSError *__autoreleasing *error))extraRequestSerializer
{
        return ESGetAssociatedObject(self, extraRequestSerializerKey);
}

- (void)setExtraRequestSerializer:(void (^)(AFHTTPRequestSerializer *serializer, NSMutableURLRequest *request, id parameters, NSError *__autoreleasing *error))extraRequestSerializer
{
        ESSetAssociatedObject(self, extraRequestSerializerKey, extraRequestSerializer, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
