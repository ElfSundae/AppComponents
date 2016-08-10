//
//  GithubClient.m
//  Sample
//
//  Created by Elf Sundae on 16/04/01.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "GithubClient.h"

@implementation GithubClient

ES_SINGLETON_IMP_AS(client, __GithubClient);

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
                    dataTask.responseMessage = dict[@"message"];
                }
            }

            if (dataTask.alertFailedResponseCodeUsingTips) {
                [ESApp showTips:dataTask.responseMessage detail:nil addToView:nil timeInterval:0 animated:YES];
            } else {
                [UIAlertView showWithTitle:dataTask.responseMessage message:nil];
            }
        }
    }

    if (completionHandler) {
        completionHandler(response, responseObject, error);
    }
}

@end
