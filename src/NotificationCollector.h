@interface NotificationCollector : NSObject
+ (instancetype)sharedInstance;

- (void)startForName:(NSString *)name;
- (void)stopForName:(NSString *)name;

- (NSArray *)dumpForName:(NSString *)name;
@end
