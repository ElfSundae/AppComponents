//
//  ESApp+ACHelper.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/22.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ESApp+ACHelper.h"
#import <ESFramework/ESFrameworkCore.h>
#import "ESApp+ACAlertAdditions.h"

#define kSaveImageToPhotoLibraryCompletionKey           @"completion"
#define kSaveImageToPhotoLibraryUserInfoKey             @"userInfo"
#define kSaveImageToPhotoLibraryShowsProgressKey        @"showsProgress"

@implementation ESApp (ACHelper)

- (void)saveImageToPhotoLibrary:(UIImage *)image showsProgress:(BOOL)showsProgress userInfo:(id)userInfo completion:(void (^)(id userInfo, NSError *error))completion
{
        ESDispatchOnMainThreadAsynchrony(^{
                if (![image isKindOfClass:[UIImage class]]) {
                        if (completion) {
                                completion(userInfo, [NSError errorWithDomain:@"com.0x123.ESAppErrorDomain" code:-1 description:@"image is not a kind of UIImage."]);
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
                                               @selector(_ac_saveImageToPhotoLibraryDidFinishHandler:error:contextInfo:),
                                               (__bridge_retained void *)context);
        });
        
}

- (void)_ac_saveImageToPhotoLibraryDidFinishHandler:(UIImage *)image error:(NSError *)error contextInfo:(void *)contextInfo
{
        NSMutableDictionary *context = (__bridge_transfer NSMutableDictionary *)contextInfo;
        void (^completion)(id, NSError *) = context[kSaveImageToPhotoLibraryCompletionKey];
        [context removeObjectForKey:kSaveImageToPhotoLibraryCompletionKey];
        
        if ([context[kSaveImageToPhotoLibraryShowsProgressKey] boolValue]) {
                if (error) {
                        [self hideProgressHUD:YES];
                        [UIAlertView showWithTitle:error.localizedDescription message:error.localizedFailureReason];
                } else {
                        [self showCheckmarkHUDWithTitle:nil timeInterval:0.7 animated:YES];
                }
        }
        if (completion) {
                completion(context[kSaveImageToPhotoLibraryUserInfoKey], error);
        }
}

@end
