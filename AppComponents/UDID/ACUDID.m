//
//  ACUDID.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/20.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ACUDID.h"
#import <AdSupport/AdSupport.h>

const NSInteger ACUDIDLength                    = 40;

NSString *const ACUDIDBasedUUIDTag              = @"a";
NSString *const ACUDIDBasedRandomTag            = @"b";
NSString *const ACUDIDBasedIDFAPossibleTag      = @"f";

NSString *const ACUDIDKeychainService           = @"ACUDIDService";
NSString *const ACUDIDKeychainKey               = @"ACUDIDKey";


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
                [ACUDIDKeychainStore() setString:UDID forKey:ACUDIDKeychainKey] :
                [ACUDIDKeychainStore() removeItemForKey:ACUDIDKeychainKey]);
}

static NSString *_ACUDIDGetFromKeychain(void)
{
        NSString *udid = [ACUDIDKeychainStore() stringForKey:ACUDIDKeychainKey];
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
                basedTag = ACUDIDBasedUUIDTag;
        }
        
        if (!ESIsStringWithAnyText(baseString)) {
                baseString = ESRandomStringOfLength(36);
                basedTag = ACUDIDBasedRandomTag;
        }
        
        const NSString *baseStringMD5 = [baseString es_md5HashString];
        
        if (!basedTag) {
                basedTag = [baseStringMD5 substringWithRange:NSMakeRange(15, 1)];
                if ([basedTag isEqualToString:ACUDIDBasedUUIDTag] || [basedTag isEqualToString:ACUDIDBasedRandomTag]) {
                        basedTag = ACUDIDBasedIDFAPossibleTag;
                }
        }
        
        NSString *resetString = [baseString stringByReplacingOccurrencesOfString:@"-" withString:@""];
        resetString = [[@"abcdwxyz0123456789" stringByAppendingString:resetString] es_md5HashString];
        resetString = [resetString substringWithRange:NSMakeRange(17, ACUDIDLength - baseStringMD5.length - basedTag.length)];
        
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
                BOOL shouldSaveToKeychain = NO;
                BOOL shouldSaveToFile = NO;
                
                NSString *udid = _ACUDIDGetFromKeychain();
                udid || (shouldSaveToKeychain = YES);
                NSString *udidFromFile = _ACUDIDGetFromFile();
                udidFromFile || (shouldSaveToFile = YES);
                
                if (!shouldSaveToFile && !(udid && udidFromFile && [udid isEqualToString:udidFromFile])) {
                        shouldSaveToFile = YES;
                }
                
                udid || (udid = udidFromFile);
                
                if (!udid) {
                        udid = _ACUDIDCreate();
                }
                __gACUDID = udid.copy;
                
                ESDispatchOnDefaultQueue(^{
                        if (shouldSaveToKeychain) {
                                BOOL saved = _ACUDIDSaveToKeychain(udid);
                                if (!saved) {
                                        printf("ACUDID: Could not save UDID to Keychain, make sure Entitlements.plist and kACUDIDKeychainAccessGroup are correctly configured.\n");
                                }
                        }
                        if (shouldSaveToFile) {
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
            [UDID isMatch:NSStringWith(@"^[0-9a-f]{%d}$", (int)ACUDIDLength)]) {
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
                __gACUDIDKeychainStore = [UICKeyChainStore keyChainStoreWithService:ACUDIDKeychainService
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
