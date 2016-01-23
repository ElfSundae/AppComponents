//
//  ACAuthVerifyPhoneViewController.h
//  AppComponents
//
//  Created by Elf Sundae on 16/1/22.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ACAuthBaseViewController.h"
#import <ESFramework/ESButton.h>
@class ACAuthVerifyPhoneViewController;

/**
 * 验证手机号的验证码类型
 */
typedef NS_ENUM(NSInteger, ACAuthVerifyPhoneCodeType) {
        /// 短信验证码
        ACAuthVerifyPhoneCodeTypeSMS = 0,
        /// 语音验证码
        ACAuthVerifyPhoneCodeTypePhoneCall
};

@interface ACAuthVerifyPhoneViewController : ACAuthBaseViewController

@property (nonatomic, copy) void (^verifyHandler)(ACAuthVerifyPhoneViewController *controller, NSDictionary *data);

/**
 * 短信签名
 */
@property (nonatomic, copy) NSString *MobSMSSignature;
/**
 * 默认为@"验证手机号"
 */
@property (nonatomic, copy) NSString *commitButtonTitle;
/**
 * 重试的时间间隔（秒）。默认为 40.0
 */
@property (nonatomic) NSTimeInterval timeIntervalForRetrySendingCode;
/**
 * 发送验证码后，等多久显示第二验证码(如果supportedCodeTypes支持第二验证码).
 * 默认为 12.0
 */
@property (nonatomic) NSTimeInterval timeIntervalBeforeShowingSendSecondaryCodeButton;
/**
 * 支持的代码类型，数组索引代表优先级. 最多支持两种代码类型.
 */
@property (nonatomic, strong) NSArray *supportedCodeTypes;
/**
 * 每种代码类型对应的发送按钮在 controlStateNormal 情况下的title
 * { @(codeType) : @"sendCodeButtonTitle" }
 *
 * buttonTitle支持NSString和NSAttributedString
 */
@property (nonatomic, strong) NSDictionary *sendCodeButtonTitles;

+ (NSString *)phoneNumberRegexPattern;
+ (void)setPhoneNumberRegexPattern:(NSString *)pattern;

/**
 * 外部成功处理后调用，清理全局临时变量。
 */
+ (void)cleanUp;

@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) ESButton *sendCodeButton; // 在phoneTextField右边
@property (nonatomic, strong) UITextField *codeTextFiled;
@property (nonatomic, strong) ESButton *sendSecondaryCodeButton; // 在codeTextFiled右边
@property (nonatomic, strong) ESButton *commitButton;
@property (nonatomic, strong) NSTimer *retrySendingCodeTimer;

/**
 * Helper: 验证大陆手机号码是否正确, 支持NSString，NSNumber
 * 验证规则：对传入的phone进行trim后正则匹配纯数字11位.
 * 验证成功后返回解析后的手机号，否则返回nil
 */
+ (NSString *)validatePhoneNumber:(id)phone;
/**
 * Helper: 验证手机号码是否正确, 支持NSString，NSNumber
 *
 * @param phone    电话号码
 * @param zone     区号
 * @param strictly 严格模式， 为NO时只检查号码位数
 */
//+ (NSString *)validatePhoneNumber:(id)phone zone:(NSString *)zone strictly:(BOOL)strictly;

/// 共享的属性，子类可以实现自己的共享属性.
/// 比如修改手机号的验证，可以继承UAVerifyPhoneViewController并修改共享属性

+ (NSString *)sharedPhoneNumber;
+ (void)setSharedPhoneNumber:(NSString *)phoneNumber;

+ (NSString *)sharedPhoneZone;
+ (void)setSharedPhoneZone:(NSString *)zone;

+ (NSDate *)sharedDateOfPreviousSendingCode;
+ (void)setSharedDateOfPreviousSendingCode:(NSDate *)date;

@end
