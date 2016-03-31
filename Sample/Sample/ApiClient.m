//
//  ApiClient.m
//  Sample
//
//  Created by Elf Sundae on 16/03/31.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ApiClient.h"

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ApiClient

@implementation ApiClient

- (instancetype)init
{
        return [self initWithBaseURL:[NSURL URLWithString:@"https://api.example.com/v2/"] timeoutIntervalForRequest:45 maxConcurrentRequestCount:3];
}

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - GithubClient

@implementation GithubClient

ES_SINGLETON_IMP_AS(client, __githubClient);

- (instancetype)init
{
        self = [self initWithBaseURL:[NSURL URLWithString:@"https://api.github.com"] timeoutIntervalForRequest:60 maxConcurrentRequestCount:3];
        return self;
}

- (void)_dataTaskWillCompleteBlockHandler:(NSURLSessionDataTask *)dataTask response:(NSURLResponse *)response responseObject:(id)responseObject error:(NSError *)error completionHandler:(void (^)(NSURLResponse *, id, NSError *))completionHandler
{
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                if (error && httpResponse.statusCode >= 400) {
                        dataTask.responseCode = httpResponse.statusCode;
                        dataTask.responseMessage = httpResponse.allHeaderFields[@"Status"];
                        NSData *responseData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                        if (responseData) {
                                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:NULL];
                                if ([dict isKindOfClass:[NSDictionary class]] && dict[@"message"]) {
                                        dataTask.responseErrors = dict[@"message"];
                                }
                        }
                        
                        if (dataTask.alertFailedResponseCodeUsingTips) {
                                [ESApp showTips:dataTask.responseMessage detail:dataTask.responseErrors addToView:nil timeInterval:0 animated:YES];
                        } else {
                                [UIAlertView showWithTitle:dataTask.responseMessage message:dataTask.responseErrors];
                        }
                }
        }
        
        if (completionHandler) {
                completionHandler(response, responseObject, error);
        }
}

@end
