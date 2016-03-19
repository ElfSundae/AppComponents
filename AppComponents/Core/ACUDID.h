//
//  ACUDID.h
//  AppComponents
//
//  Created by Elf Sundae on 16/1/20.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <ESFramework/ESFrameworkCore.h>
#import <ESFramework/ESFrameworkAdditions.h>
#import <UICKeyChainStore/UICKeyChainStore.h>
#import <AppComponents/ACConfig.h>

FOUNDATION_EXTERN const NSInteger kACUDIDLength; // 40

/**
 * 标记UDID最前面的32位串是什么值的md5。
 */

FOUNDATION_EXTERN NSString *const kACUDIDBasedUUIDTag;          // "a"
FOUNDATION_EXTERN NSString *const kACUDIDBasedRandomTag;        // "b"
FOUNDATION_EXTERN NSString *const kACUDIDBasedIDFAPossibleTag;  // 除了 kACUDIDBasedUUIDTag 和 kACUDIDBasedRandomTag 之外的0-9a-f 字符, 默认为"f"

FOUNDATION_EXTERN NSString *const kACUDIDKeychainService;       // "ACUDIDService"
FOUNDATION_EXTERN NSString *const kACUDIDKeychainKey;           // "ACUDIDKey"

/*!
 * 生成设备UDID.
 *
 * 如果kACUDIDIsIDFAEnabled为true，则基于IDFA创建UDID.
 * 基于IDFA的生成的UDID，在设备IDFA不变的情况下每个app都会生成相同的串。
 * 强烈建议开启IDFA。但是因为苹果政策限制IDFA只能用于广告追踪，如果开启了IDFA，在app审核时加一个广告。
 *
 * UDID生成规则：
 *      + 40位小写的[0-9a-f]字符串
 *      + 前32位是 baseString (IDFA或者UUID或者随机串) 的md5值
 *      + 第33位是 basedTag: 表达了baseString是什么类型.
 *        基于UUID的UDID的basedTag是 "a" (kACUDIDBasedUUIDTag).
 *        基于随机串的UDID的basedTag是 "b" (kACUDIDBasedRandomTag).
 *        基于IDFA的UDID的basedTag是上一步生成的baseString的md5的第15位，如果这个字符是a或者b, 那么basedTag就是"f"(kACUDIDBasedIDFAPossibleTag).
 *      + 最后7位是：拼接 "abcdwxyz0123456789" 和 baseString ，然后对其进行md5，从md5结果的第17位开始取7位
 *        这样可以在IDFA不变的情况下不同app可以生成同样的串。
 *
 * 示例：
 *
 *       CD0BBBDC-3D28-46A8-AA77-344441747532 => 0e9a893d1b0d3bc95dddb98b1da461a09b2c3b7e
 *       F7CED694-DB3B-423E-9F69-1BD0359CB415 => 4b4410902be7e92827a7b151fa629c8f8b3a1cd6
 *       D94AC030-5EBA-4E1F-958F-05A7E2632223 => c9d5192352e5e715e60f017ca67a30ca561ce472
 *       8A6D2BFC-7C34-49EC-B4CF-21363B7D7348 => 08aa6c9572917a6dc8880e4ab2d5a40bdbcdae98
 *       C97AC23D-D376-4191-9847-235DC116B26E => 2f03b32cfdbe803649dd49d5f8b7e5da67300dff
 *       5B348FDC-2C92-4307-946A-091D9D6E35E2 => 0048b4d896ad0172495c823f0562eabb2b51e982
 *       26A9B6DB-F168-4157-8E4F-3F40C08DD5FE => 80fc9c40ccc950f00168666027c7416f0996c5c4
 *       46BBB41F-7483-428E-BD7B-C0B6E55BC3AA => d9d116fd666a18370dc499113d2e80987be10169
 *       92809F7C-C819-4662-ACF7-649D2F7AEE0C => 5e944bc1a5df3dcf60c1add6de7e74c7f25dcedb
 *       39BE6EBD-D28D-493C-B265-82541B05B730 => 320cffc5ee0b5c6871dc6db6adaa89c48984cc21
 *       1C6EB703-35A7-4EBE-A683-F0789703C7B3 => 0a0a064b12ee03831b3acb762ae3b2643d50137e
 *
 */

/**
 * 获取设备UDID.
 */
FOUNDATION_EXTERN NSString *ACGetUDID(void);

/**
 * 重写设备UDID.
 *
 * 设备号如果变化了（新安装、用户重置了系统、用户其他hack行为、用户变换了idfa等），可以由服务端通过idfa或者
 * push token来判断当前设备是不是已经存在了，如果是同一个设备的话，可以由服务端把这个设备号返回并写进客户端缓存。
 *
 * @warning newUDID 必须通过 ACIsUDIDValid() 的验证才能重写成功。
 */
FOUNDATION_EXTERN BOOL ACSetUDID(NSString *newUDID);

/**
 * Validates a given deviceIdentifier whether is valid.
 */
FOUNDATION_EXTERN BOOL ACIsUDIDValid(NSString *UDID, NSString **outBasedTag);

/**
 * Returns the shared and lazy loaded Keychain Store which used to store UDID to Keychain.
 *
 * @warning After saving new UDID to the Keychain, this shared UDIDKeychainStore will be set to nil, and it will re-created if you call this again.
 */
FOUNDATION_EXTERN UICKeyChainStore *ACUDIDKeychainStore(void);

/**
 * Set the shared UDIDKeychainStore instance to nil or other instance of UICKeyChainStore.
 */
FOUNDATION_EXTERN BOOL ACUDIDSetKeychainStore(UICKeyChainStore *store);

