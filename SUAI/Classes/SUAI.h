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

@interface SUAI : NSObject

@property (strong, nonatomic, readonly) SUAIScheduleProvider *schedule;
@property (strong, nonatomic, readonly) SUAINewsProvider *news;

+ (instancetype)instance;

@end

NS_ASSUME_NONNULL_END
