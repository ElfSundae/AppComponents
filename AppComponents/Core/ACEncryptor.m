//
//  ACEncryptor.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/19.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ACEncryptor.h"
#import <ESFramework/ESFrameworkCore.h>

@implementation ACEncryptor

+ (NSString *)sampleEncrypt:(NSString *)string password:(NSString *)password
{
    NSMutableData *data = [NSMutableData data];

    // 1. 原串前面加四个随机字符
    NSString *text = [ESRandomStringOfLength(4) stringByAppendingString:string];

    // 2. 间隔每个字符插入随机串：随机串 + 随机串^原文
    NSString *randomString = ESRandomStringOfLength(text.length);
    for (NSUInteger i = 0; i < text.length; i++) {
        unichar uchar1 = [text characterAtIndex:i];
        unichar uchar2 = [randomString characterAtIndex:i % randomString.length];
        unichar xor = uchar1 ^ uchar2;
        [data appendBytes:&uchar2 length:1];
        [data appendBytes:&xor length:1];
    }

    // 3. 对result和password中的每个字符进行异或运算
    if (ESIsStringWithAnyText(password)) {
        for (NSUInteger i = 0; i < data.length; i++) {
            const void *bytes = [data subdataWithRange:NSMakeRange(i, 1)].bytes;
            const unichar uchar1 = *((const unichar *)bytes);
            unichar uchar2 = [password characterAtIndex:i % password.length];
            unichar xor = uchar1 ^ uchar2;
            [data replaceBytesInRange:NSMakeRange(i, 1) withBytes:&xor length:1];
        }
    }

    // 4. 对result data进行base64得到ASCII字符串
    NSString *result = [data es_base64EncodedString];
    // 5. 删除base64结尾的等号
    result = [result stringByReplacingOccurrencesOfString:@"=" withString:@""];
    // 6. 加密后的字符串前面追加四个随机串
    result = [ESRandomStringOfLength(4) stringByAppendingString:result];

    return result;
}

@end
