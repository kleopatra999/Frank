#import "NotificationCommand.h"

#import "JSON.h"
#import "FranklyProtocolHelper.h"

@implementation NotificationCommand

- (NSString *)handleCommandWithRequestBody:(NSString *)requestBody {
    NSDictionary *requestCommand = FROM_JSON(requestBody);
    NSLog(@"--------------------- RECEIVED NOTIFICATION REQUEST: %@", requestCommand);
    return [FranklyProtocolHelper generateSuccessResponseWithResults:@[ @"This", @"gave", @"request:", requestCommand]];
}

@end
