//
//  AFURLSessionManager+ACNetworking.m
//  AppComponents
//
//  Created by Elf Sundae on 16/03/30.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "AFURLSessionManager+ACNetworking.h"
#import <ESFramework/ESFrameworkCore.h>

static SEL ac_taskDelegateNewSelector_SetCompletionHandler = NULL;

static void ac_taskDelegateNewSelector_SetCompletionHandler_IMP(id self, SEL _cmd, void (^originalCompletionHandler)(NSURLResponse *, id, NSError *))
{
        void (^completionHandler)(NSURLResponse *response, id responseObject, NSError *error) = ^(NSURLResponse *response, id responseObject, NSError *error) {
                if (originalCompletionHandler) {
                        originalCompletionHandler(response, responseObject, error);
                }
        };
        
        ESInvokeSelector(self, ac_taskDelegateNewSelector_SetCompletionHandler, NULL, completionHandler);
}

/**
 * Replaces AFURLSessionManagerTaskDelegate's selector `setCompletionHandler:` to 
 * `ac_taskDelegateNewSelector_SetCompletionHandler_IMP`, to let us have a chance to 
 * process all final responseObject.
 */
static void ac_swizzleURLSessionManagerTaskDelegate(void)
{
        Class AFURLSessionManagerTaskDelegateClass = NSClassFromString(@"AFURLSessionManagerTaskDelegate");
        if (!AFURLSessionManagerTaskDelegateClass) {
                return;
        }
        
        SEL oldSelector = @selector(setCompletionHandler:);
        Method oldMethod = class_getInstanceMethod(AFURLSessionManagerTaskDelegateClass, oldSelector);
        SEL newSelector = NSSelectorFromString(@"ac_taskDelegateNewSelector_SetCompletionHandler:");
        
        if (class_addMethod(AFURLSessionManagerTaskDelegateClass,
                            newSelector,
                            (IMP)ac_taskDelegateNewSelector_SetCompletionHandler_IMP,
                            method_getTypeEncoding(oldMethod))) {
                
                ac_taskDelegateNewSelector_SetCompletionHandler = newSelector;
                ESSwizzleInstanceMethod(AFURLSessionManagerTaskDelegateClass, oldSelector, newSelector);
        }
}

@implementation AFURLSessionManager (ACNetworking)

+ (void)load
{
        @autoreleasepool {
                ac_swizzleURLSessionManagerTaskDelegate();
        }
}

@end
