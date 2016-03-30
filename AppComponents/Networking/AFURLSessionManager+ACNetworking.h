//
//  AFURLSessionManager+ACNetworking.h
//  AppComponents
//
//  Created by Elf Sundae on 16/03/30.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <AFNetworking/AFURLSessionManager.h>

@interface AFURLSessionManager (ACNetworking)

/**
 * The `dataTaskWillCompleteBlock` will be invoked before original `completionHandler` which you
 * supplied to `-[AFURLSessionManager dataTaskWithRequest: ...]`,
 * `-[AFURLSessionManager uploadTaskWithRequest: ...]` or `AFHTTPSessionManager`'s `GET`, `POST`, 
 * `PUT` methods. It will be applied to all `NSURLSessionDataTask`s and `NSURLSessionUploadTask`s that
 * managed by this session manager.
 *
 * You can use this block to process general parser work for `responseObject`. For example, getting and
 * verifying X-API-Token from response's header fields; check status code of json responseObject and show
 * notification UI to user.
 *
 * @warning After executing in block, you must call original `completionHandler` to finish this dataTask.
 *
 * @note it only supports for `NSURLSessionDataTask` and `NSURLSessionUploadTask`, except `NSURLSessionDownloadTask`.
 */
@property (nonatomic, copy) void (^dataTaskWillCompleteBlock)(NSURLSessionDataTask *dataTask, NSURLResponse *response, id responseObject, NSError *error, void (^completionHandler)(NSURLResponse *response, id responseObject, NSError *error));

@end
