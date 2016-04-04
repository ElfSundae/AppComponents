//
//  ESApp+ACHelper.h
//  AppComponents
//
//  Created by Elf Sundae on 16/1/22.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <ESFramework/ESApp.h>

@interface ESApp (ACHelper)

/**
 * Invokes UIImageWriteToSavedPhotosAlbum() and callbacks completion on the main thread after finished writing.
 */
- (void)saveImageToPhotoLibrary:(UIImage *)image showsProgress:(BOOL)showsProgress userInfo:(id)userInfo completion:(void (^)(id userInfo, NSError *error))completion;

@end
