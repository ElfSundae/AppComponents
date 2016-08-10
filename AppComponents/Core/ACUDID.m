//
//  ACUDID.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/20.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ACUDID.h"
#import <AdSupport/AdSupport.h>

const NSInteger kACUDIDLength                    = 40;

NSString *const kACUDIDBasedUUIDTag              = @"a";
NSString *const kACUDIDBasedRandomTag            = @"b";
NSString *const kACUDIDBasedIDFAPossibleTag      = @"f";

NSString *const kACUDIDKeychainService           = @"ACUDIDService";
NSString *const kACUDIDKeychainKey               = @"ACUDIDKey";


static UICKeyChainStore *__gACUDIDKeychainStore = nil;
static NSString *__gACUDID = nil;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

static NSString *_ACUDIDCachedFilePath(void)
{
    return ESPathForLibraryResource(@".DS_Store.acudid");
}

static BOOL _ACUDIDSaveToKeychain(NSString *UDID)
{
    return (ESIsStringWithAnyText(UDID) ?
            [ACUDIDKeychainStore() setString:UDID forKey:kACUDIDKeychainKey] :
            [ACUDIDKeychainStore() removeItemForKey:kACUDIDKeychainKey]);
}

static NSString *_ACUDIDGetFromKeychain(void)
{
    NSString *udid = [ACUDIDKeychainStore() stringForKey:kACUDIDKeychainKey];
    if (ACIsUDIDValid(udid, NULL)) {
        return udid;
    } else {
        _ACUDIDSaveToKeychain(nil);
        return nil;
    }
}

static BOOL _ACUDIDSaveToFile(NSString *UDID)
{
    NSString *filePath = _ACUDIDCachedFilePath();
    return (ESIsStringWithAnyText(UDID) ?
            [NSKeyedArchiver archiveRootObject:@[UDID] toFile:filePath] :
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL]);
}

static NSString *_ACUDIDGetFromFile(void)
{
    NSString *filePath = _ACUDIDCachedFilePath();
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    if (ESIsArrayWithItems(array)) {
        NSString *udid = ESStringValue(array.firstObject);
        if (ACIsUDIDValid(udid, NULL)) {
            return udid;
        }
    }

    if (array) {
        _ACUDIDSaveToFile(nil);
    }
    return nil;
}

static NSString *_ACUDIDCreate(void)
{
    NSString *baseString = nil;
    NSString *basedTag = nil;
    if (!ESBoolValue(ACConfigGet(kACConfigKey_ACUDID_IDFADisabled))) {
        baseString = [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString;
    }

    if (!ESIsStringWithAnyText(baseString)) {
        baseString = ESUUID();
        basedTag = kACUDIDBasedUUIDTag;
    }

    if (!ESIsStringWithAnyText(baseString)) {
        baseString = ESRandomStringOfLength(36);
        basedTag = kACUDIDBasedRandomTag;
    }

    const NSString *baseStringMD5 = [baseString es_md5HashString];

    if (!basedTag) {
        basedTag = [baseStringMD5 substringWithRange:NSMakeRange(15, 1)];
        if ([basedTag isEqualToString:kACUDIDBasedUUIDTag] || [basedTag isEqualToString:kACUDIDBasedRandomTag]) {
            basedTag = kACUDIDBasedIDFAPossibleTag;
        }
    }

    NSString *resetString = [baseString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    resetString = [[@"abcdwxyz0123456789" stringByAppendingString:resetString] es_md5HashString];
    resetString = [resetString substringWithRange:NSMakeRange(17, kACUDIDLength - baseStringMD5.length - basedTag.length)];

    NSString *result = [NSString stringWithFormat:@"%@%@%@", baseStringMD5, basedTag, resetString];
    return (NSString *)result;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

NSString *ACGetUDID(void)
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _ACUDIDSaveToKeychain(nil);

        NSString *udidFromKeychain = _ACUDIDGetFromKeychain();
        NSString *udidFromFile = _ACUDIDGetFromFile();
        NSString *udid = ((udidFromKeychain ?: udidFromFile) ?: _ACUDIDCreate());
        __gACUDID = udid.copy;

        ESDispatchOnDefaultQueue(^{
            if (!udidFromKeychain || ![udidFromKeychain isEqualToString:udid]) {
                _ACUDIDSaveToKeychain(udid);
            }
            if (!udidFromFile || ![udidFromFile isEqualToString:udid]) {
                _ACUDIDSaveToFile(udid);
            }
            ACUDIDSetKeychainStore(nil);
        });
    });

    return __gACUDID;
}

BOOL ACSetUDID(NSString *newUDID)
{
    if (ACIsUDIDValid(newUDID, NULL)) {
        __gACUDID = [newUDID copy];
        return (_ACUDIDSaveToKeychain(newUDID) && _ACUDIDSaveToFile(newUDID));
    }
    return NO;
}

BOOL ACIsUDIDValid(NSString *UDID, NSString **outBasedTag)
{
    if ([UDID isKindOfClass:[NSString class]] &&
        [UDID isMatch:NSStringWith(@"^[0-9a-f]{%d}$", (int)kACUDIDLength)])
    {
        if (outBasedTag) {
            *outBasedTag = [UDID substringWithRange:NSMakeRange(33, 1)];
        }
        return YES;
    }
    return NO;
}

UICKeyChainStore *ACUDIDKeychainStore(void)
{
    if (!__gACUDIDKeychainStore) {
        __gACUDIDKeychainStore = [UICKeyChainStore keyChainStoreWithService:kACUDIDKeychainService
                                                                accessGroup:ACConfigGet(kACConfigKey_ACUDID_KeychainAccessGroup)];
    }
    return __gACUDIDKeychainStore;
}

BOOL ACUDIDSetKeychainStore(UICKeyChainStore *store)
{
    if (!store || [store isKindOfClass:[UICKeyChainStore class]]) {
        __gACUDIDKeychainStore = store;
        return YES;
    }
    return NO;
}
