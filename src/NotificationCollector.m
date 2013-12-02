#import "NotificationCollector.h"

@interface NotificationCollector ()
@property (nonatomic, readonly) NSMutableDictionary *observedNotificationValues;
@end

@implementation NotificationCollector

#pragma mark Singleton

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static NotificationCollector *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark Initialization/Dealloc

- (instancetype)init
{
    self = [super init];
    if (self) {
        _observedNotificationValues = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [_observedNotificationValues release];
    [super dealloc];
}

#pragma mark Public


- (void)startForName:(NSString *)name
{
    NSParameterAssert(name);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationTriggered:) name:name object:nil];
    [self.observedNotificationValues setObject:[NSMutableArray array] forKey:name];
}

- (void)stopForName:(NSString *)name
{
    NSParameterAssert(name);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:name object:nil];
}

- (NSArray *)dumpForName:(NSString *)name
{
    NSParameterAssert(name);
    return [self.observedNotificationValues valueForKey:name];
}

#pragma mark Private

- (void)notificationTriggered:(NSNotification *)notification
{
    [[self.observedNotificationValues valueForKey:notification.name] addObject:notification.userInfo];
}

@end
