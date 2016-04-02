//
//  ESApp+VendorServices.h
//  Sample
//
//  Created by Elf Sundae on 16/04/03.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <ESFramework/ESApp.h>

#define kAppChannel_AppStore    @"App Store"
#define kAppChannel_Debug       @"Debug"
#define kAppChannel_AdHoc       @"Ad Hoc"
#define kAppChannel_InHouse     @"In House"

#if !DEBUG
#define kAppChannel             kAppChannel_AppStore
#else
#define kAppChannel             kAppChannel_Debug
#endif

#define kAppStoreID                     @""
#define kApiClientBaseURL               @""

#define kUmengAppKey            @""
#define kTalkingDataAppKey      @""
#define kMobSMSAppKey           @""
#define kMobSMSAppSecret        @""
#define kXGPushAppID            0
#define kXGPushAppKey           @"IX5AU523XG2S"

@interface ESApp (VendorServices)

/**
 * Setup vendor services, you can call this method in your app delegate's 
 * `-application:didFinishLaunchingWithOptions:` method.
 */
- (void)setupVendorServices;

#ifdef kTalkingDataAppKey
+ (NSString *)talkingDataDeviceID;
#endif

@end

#if defined(kXGPushAppID) && defined(kXGPushAppKey)
#import <AppComponents/ACRemoteNotificationServiceRegister.h>

@interface ACRemoteNotificationXGPushService : NSObject <ACRemoteNotificationServiceProtocol>
+ (void)setTags:(NSArray *)tags;
@end
#endif