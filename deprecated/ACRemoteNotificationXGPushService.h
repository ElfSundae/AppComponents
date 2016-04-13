#import <AppComponents/ACRemoteNotificationServiceRegister.h>

@interface ACRemoteNotificationXGPushService : NSObject <ACRemoteNotificationServiceProtocol>
+ (void)setTags:(NSArray *)tags;
@end
