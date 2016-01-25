//
//  JTSImageInfo+ACAdditions.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/25.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "JTSImageInfo+ACAdditions.h"
#import <ESFramework/NSObject+ESAssociatedObjectHelper.h>

ESDefineAssociatedObjectKey(canSaveToPhotoLibrary);
ESDefineAssociatedObjectKey(canCopy);

@implementation JTSImageInfo (ACAdditions)

- (BOOL)canSaveToPhotoLibrary
{
        return [self es_getAssociatedBooleanWithKey:canSaveToPhotoLibraryKey defaultValue:YES];
}

- (void)setCanSaveToPhotoLibrary:(BOOL)can
{
        [self es_setAssociatedBooleanWithKey:canSaveToPhotoLibraryKey value:can];
}

- (BOOL)canCopy
{
        return [self es_getAssociatedBooleanWithKey:canCopyKey defaultValue:NO];
}

- (void)setCanCopy:(BOOL)can
{
        [self es_setAssociatedBooleanWithKey:canCopyKey value:can];
}

@end
