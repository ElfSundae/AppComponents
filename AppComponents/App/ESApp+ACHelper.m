//
//  ESApp+ACHelper.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/22.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ESApp+ACHelper.h"
#import <ESFramework/ESFrameworkCore.h>
#import <ESFramework/ESFrameworkAdditions.h>
#import "ESApp+ACAlertAdditions.h"

#define kSaveImageToPhotoLibraryCompletionKey           @"completion"
#define kSaveImageToPhotoLibraryUserInfoKey             @"userInfo"
#define kSaveImageToPhotoLibraryShowsProgressKey        @"showsProgress"

@implementation ESApp (ACHelper)

- (NSDateFormatter *)appWebServerDateFormatterWithFullStyle
{
        static NSDateFormatter *__appWebServerDateFormatter = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                __appWebServerDateFormatter = [[NSDateFormatter alloc] init];
                __appWebServerDateFormatter.timeZone = self.appWebServerTimeZone;
                __appWebServerDateFormatter.dateFormat = @"yyyy'-'MM'-'dd HH':'mm':'ss";
        });
        return __appWebServerDateFormatter;
}

- (NSDateFormatter *)appWebServerDateFormatterWithShortStyle
{
        static NSDateFormatter *__appWebServerDateFormatterWithShortStyle = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                __appWebServerDateFormatterWithShortStyle = [[NSDateFormatter alloc] init];
                __appWebServerDateFormatterWithShortStyle.timeZone = self.appWebServerTimeZone;
                __appWebServerDateFormatterWithShortStyle.dateFormat = @"MM'-'dd HH':'mm";
        });
        return __appWebServerDateFormatterWithShortStyle;
}

- (NSDateFormatter *)appWebServerDateFormatterWithShortSecondsStyle
{
        static NSDateFormatter *__appWebServerDateFormatterWithShortSecondsStyle = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                __appWebServerDateFormatterWithShortSecondsStyle = [[NSDateFormatter alloc] init];
                __appWebServerDateFormatterWithShortSecondsStyle.timeZone = self.appWebServerTimeZone;
                __appWebServerDateFormatterWithShortSecondsStyle.dateFormat = @"MM'-'dd HH':'mm':'ss";
        });
        return __appWebServerDateFormatterWithShortSecondsStyle;
}

- (void)saveImageToPhotoLibrary:(UIImage *)image showsProgress:(BOOL)showsProgress userInfo:(id)userInfo completion:(void (^)(id userInfo, NSError *error))completion
{
        ESDispatchOnMainThreadAsynchrony(^{
                if (![image isKindOfClass:[UIImage class]]) {
                        if (completion) {
                                completion(userInfo, [NSError errorWithDomain:ESAppErrorDomain code:-1 description:@"image is not a kind of UIImage."]);
                        }
                        return;
                }
                NSMutableDictionary *context = [NSMutableDictionary dictionary];
                if (completion) {
                        context[kSaveImageToPhotoLibraryCompletionKey] = [completion copy];
                }
                if (userInfo) {
                        context[kSaveImageToPhotoLibraryUserInfoKey] = userInfo;
                }
                context[kSaveImageToPhotoLibraryShowsProgressKey] = @(showsProgress);
                
                if (showsProgress) {
                        [self showProgressHUDWithTitle:nil animated:YES];
                }
                
                UIImageWriteToSavedPhotosAlbum(image,
                                               self,
                                               @selector(ac_saveImageToPhotoLibraryDidFinishHandler:error:contextInfo:),
                                               (__bridge_retained void *)context);
        });
        
}

- (void)ac_saveImageToPhotoLibraryDidFinishHandler:(UIImage *)image error:(NSError *)error contextInfo:(void *)contextInfo
{
        NSMutableDictionary *context = (__bridge_transfer NSMutableDictionary *)contextInfo;
        void (^completion)(id, NSError *) = context[kSaveImageToPhotoLibraryCompletionKey];
        [context removeObjectForKey:kSaveImageToPhotoLibraryCompletionKey];
        
        if (ESBoolValue(context[kSaveImageToPhotoLibraryShowsProgressKey])) {
                if (error) {
                        [self hideProgressHUD:YES];
                } else {
                        [self showCheckmarkHUDWithTitle:nil timeInterval:1.0 animated:YES];       
                }
        }
        if (completion) {
                completion(context[kSaveImageToPhotoLibraryUserInfoKey], error);
        }
}

@end
