//
//  NSHTTPURLResponse+ACNetworking.h
//  AppComponents
//
//  Created by Elf Sundae on 16/03/30.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSHTTPURLResponse (ACNetworking)

/**
 * Returns date from response header field "Date".
 *
 * It supports RFC1123 full date format.
 * http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.3.1
 *
 * @code
 * Sun, 06 Nov 1994 08:49:37 GMT  ; RFC 822, updated by RFC 1123
 * Sunday, 06-Nov-94 08:49:37 GMT ; RFC 850, obsoleted by RFC 1036
 * Sun Nov  6 08:49:37 1994       ; ANSI C's asctime() format
 * @endcode
 *
 * @see +[NSDate dateWithRFC1123String:]
 */
- (NSDate *)dateOfHeaderField;

@end
