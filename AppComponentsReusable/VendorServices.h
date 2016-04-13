//
//  VendorServices.h
//  Sample
//
//  Created by Elf Sundae on 16/04/03.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

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
// Your secret password for encrypting Api Token.
#define kApiClientApiTokenEncryptionKey @""

//#define kUmengAppKey            @""
//#define kTalkingDataAppKey      @""
//#define kMobSMSAppKey           @""
//#define kMobSMSAppSecret        @""
//#define kMobSMSSignature        nil
//#define kXGPushAppID            0
//#define kXGPushAppKey           @""
//#define kShareSDKAppKey         @""
//#define kWeChatAppID            @""
//#define kWeChatAppSecret        @""
//#define kQQAppID                @""
//#define kQQAppKey               @""

#import <ESFramework/ESApp.h>
#if defined(kShareSDKAppKey)
#import <ShareSDK/ShareSDK.h>
#endif

@interface ESApp (VendorServices)

/**
 * Setup vendor services, you can call this method in your app delegate's 
 * `-application:didFinishLaunchingWithOptions:` method.
 */
- (void)setupVendorServices;

#if defined(kShareSDKAppKey)

/**
 * shareData: { platforms:[1,2,3], type, title, text, icon, img, url }
 *
 * platforms: 要分享的平台，必须。SSDKPlatformType
 *
 * type支持以下几种： text, web, app.
 * icon: NSString, NSURL, UIImage, 默认为AppIcon
 * img: NSString, NSURL, UIImage, 目前只在邮件里起作用。如果要分享图片消息，请使用web类型。
 *
 * @code
 * {
 *      platforms: [22, 23, 37, 24, 6, 18, 19, 21],
 *      type:  'web',
 *      title: '这里是标题',
 *      text:  '这里是文本',
 *      icon:  // NSString, NSURL, UIImage, 默认为AppIcon
 *      img:   // NSString, NSURL, UIImage
 *      url:   // NSString, NSURL
 *      mail_recv: 'admin@qq.com',
 *      sms_recv:  '10086'
 *}
 * @endcode
 */
- (BOOL)showShareWithData:(NSDictionary *)shareData shareStateChanged:(void (^)(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL isEnd))shareStateChanged;
#endif

@end

@interface UIDevice (VendorServices)

#ifdef kTalkingDataAppKey
+ (NSString *)talkingDataDeviceID;
#endif

@end
