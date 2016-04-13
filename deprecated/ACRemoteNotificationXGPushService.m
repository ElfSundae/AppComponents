@implementation ACRemoteNotificationXGPushService

+ (void)load
{
        [ACRemoteNotificationServiceRegister registerClass:self forServiceType:ACRemoteNotificationServiceTypeXGPush];
}

- (void)registerDevice:(NSData *)deviceToken deviceTokenString:(NSString *)deviceTokenString account:(NSString *)account tags:(NSArray *)tags completion:(void (^)(BOOL succeed))completion
{
        [XGPush initForReregister:^{
                [XGPush setAccount:account];
                [XGPush registerDevice:deviceToken successCallback:^{
                        [[self class] setTags:tags];
                        completion(YES);
                } errorCallback:^{
                        completion(NO);
                }];
        }];
}

- (void)unregisterDevice:(void (^)(BOOL succeed))completion
{
        [XGPush unRegisterDevice:^{
                if (completion) completion(YES);
        } errorCallback:^{
                if (completion) completion(NO);
        }];
}

+ (void)setTags:(NSArray *)tags
{
        [tags enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[NSString class]] && [(NSString *)obj length] > 0) {
                        NSString *t = (NSString *)obj;
                        [XGPush setTag:t successCallback:^{
                                printf("%s setTag \"%s\" succeed.\n", NSStringFromClass([self class]).UTF8String, t.UTF8String);
                        } errorCallback:^{
                                printf("%s setTag \"%s\" failed.\n", NSStringFromClass([self class]).UTF8String, t.UTF8String);
                        }];
                }
        }];
}

@end
