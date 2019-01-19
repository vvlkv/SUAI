//
//  SUAI.h
//  SUAI
//
//  Created by Виктор on 13/12/2018.
//

#import <Foundation/Foundation.h>
#import "SUAIScheduleProvider.h"
#import "SUAINewsProvider.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString *kSUAIReachabilityNotification;

@interface SUAI : NSObject

@property (strong, nonatomic, readonly) SUAIScheduleProvider *schedule;
@property (strong, nonatomic, readonly) SUAINewsProvider *news;
@property (assign, nonatomic, readonly) BOOL isReachable;

+ (instancetype)instance;

@end

NS_ASSUME_NONNULL_END
