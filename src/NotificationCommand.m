#import "NotificationCommand.h"

#import "JSON.h"
#import "FranklyProtocolHelper.h"
#import "NotificationCollector.h"

static NSString *const kOperationKey = @"operation";
static NSString *const kNotificationName = @"name";

static NSString *const kRegisterOperation = @"register";
static NSString *const kDeregisterOperation = @"deregister";
static NSString *const kDumpOperation = @"dump";

@implementation NotificationCommand

- (NSString *)handleCommandWithRequestBody:(NSString *)requestBody {
    NSDictionary *requestCommand = FROM_JSON(requestBody);
    NSString *operation = [requestCommand valueForKey:kOperationKey];
    NSString *name = [requestCommand valueForKey:kNotificationName];

    if (!operation && !name) {
        return [FranklyProtocolHelper generateErrorResponseWithReason:@"Require notification operation & name" 
                                                           andDetails:@""];
    }

    if ([operation isEqualToString:kRegisterOperation]) {
        [[NotificationCollector sharedInstance] startForName:name];
        return [FranklyProtocolHelper generateSuccessResponseWithoutResults];
    } else if ([operation isEqualToString:kDeregisterOperation]) {
        [[NotificationCollector sharedInstance] stopForName:name];
        return [FranklyProtocolHelper generateSuccessResponseWithoutResults];
    } else if ([operation isEqualToString:kDumpOperation]) {
        NSArray *collectedValues = [[NotificationCollector sharedInstance] dumpForName:name];
        return [FranklyProtocolHelper generateSuccessResponseWithResults:collectedValues];
    } else {
        return [FranklyProtocolHelper generateErrorResponseWithReason:@"Invalid operation"
                                                           andDetails:@"should be either [ 'register', 'deregister', 'dump' ]"];
    }
}

@end
