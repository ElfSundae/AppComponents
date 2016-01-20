//
//  ACHTTPRequestSerializer.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/21.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ACHTTPRequestSerializer.h"
#import "ACNetworkingHelper.h"

@implementation ACHTTPRequestSerializer

- (NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request
                               withParameters:(id)parameters
                                        error:(NSError *__autoreleasing *)error
{
        NSMutableURLRequest *mutableRequest = [[super requestBySerializingRequest:request withParameters:parameters error:error] mutableCopy];
        [ACNetworkingHelper setUserAgentForURLRequest:mutableRequest];
        [ACNetworkingHelper setCSRFTokenForURLRequest:mutableRequest];
        [ACNetworkingHelper setAPIToken:[ACNetworkingHelper generateAPIToken] forURLRequest:mutableRequest];
        return mutableRequest;
}

@end
