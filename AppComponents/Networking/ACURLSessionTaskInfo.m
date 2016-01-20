//
//  ACURLSessionTaskInfo.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/21.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ACURLSessionTaskInfo.h"

@implementation ACURLSessionTaskInfo

- (id)copyWithZone:(NSZone *)zone
{
        ACURLSessionTaskInfo *info = [[self class] allocWithZone:zone];
        info.dontParseResponseObject = self.dontParseResponseObject;
        info.dontAlertWhenResponseCodeIsNotSuccess = self.dontAlertWhenResponseCodeIsNotSuccess;
        info.alertUseTipsWhenResponseCodeIsNotSuccess = self.alertUseTipsWhenResponseCodeIsNotSuccess;
        info.dontAlertNetworkError = self.dontAlertNetworkError;
        info.alertNetworkErrorUseAlertView = self.alertNetworkErrorUseAlertView;
        info.responseCode = self.responseCode;
        info.responseMessage = self.responseMessage;
        info.responseErrors = self.responseErrors;
        return info;
}

@end
