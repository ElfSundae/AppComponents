//
//  ACSettings.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/22.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ACSettings.h"
#import <ESFramework/ESFrameworkCore.h>

NSString *const ACSettingsIdentifierKey = @"__ACSettingsIdentifier__";

@interface ACSettings ()
@property (nonatomic, strong) NSMutableDictionary *dictionary;
@end

@implementation ACSettings

- (instancetype)initWithIdentifier:(NSString *)identifier defaultValues:(NSDictionary *)defaultValues
{
    self = [super init];
    if (self) {
        self.dictionary = [NSMutableDictionary dictionary];
        if (ESIsDictionaryWithItems(defaultValues)) {
            [self.dictionary setDictionary:defaultValues];
        }
        NSString *key = [[self class] keyForIdentifier:identifier];
        NSDictionary *stored = [[self class] savedDictionaryForKey:key];
        if (ESIsDictionaryWithItems(stored)) {
            [self.dictionary setValuesForKeysWithDictionary:stored];
        }
        [self _setIdentifier:identifier];
    }
    return self;
}

- (NSString *)identifier
{
    return self.dictionary[ACSettingsIdentifierKey];
}

- (void)_setIdentifier:(NSString *)identifier
{
    if (identifier) {
        self.dictionary[ACSettingsIdentifierKey] = identifier;
    } else {
        [self.dictionary removeObjectForKey:ACSettingsIdentifierKey];
    }
}

- (NSString *)key
{
    return [[self class] keyForIdentifier:self.identifier];
}

- (void)cleanUp
{
    NSString *identifier = self.identifier;
    [self.dictionary removeAllObjects];
    [self _setIdentifier:identifier];
}

- (void)save
{
    NSString *key = [self key];
    if (self.dictionary.count == 0) {
        [[self class] deleteDictionaryForKey:key];
        return;
    }

    if (self.identifier && self.dictionary.count == 1) {
        NSString *firstKey = self.dictionary.allKeys.firstObject;
        if ([firstKey isKindOfClass:[NSString class]] && [firstKey isEqualToString:self.identifier]) {
            [[self class] deleteDictionaryForKey:key];
            return;
        }
    }

    [[self class] saveDictionary:self.dictionary forKey:key];
}

+ (void)deleteWithIdentifier:(NSString *)identifier
{
    [self deleteDictionaryForKey:[self keyForIdentifier:identifier]];
}

+ (NSString *)keyForIdentifier:(NSString *)identifier
{
    return [NSString stringWithFormat:@"%@-%@", NSStringFromClass(self), identifier ?: @"" ];
}

- (NSString *)description
{
    return [[super description] stringByAppendingFormat:@"\n%@", self.dictionary];
}

@end

@implementation ACSettings (Subclassing)

+ (NSDictionary<NSString *, id> *)savedDictionaryForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] dictionaryForKey:key];
}

+ (void)saveDictionary:(NSDictionary *)dictionary forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:dictionary forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)deleteDictionaryForKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
