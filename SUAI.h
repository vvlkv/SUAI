//
//  SUAI.h
//  SUAI
//
//  Created by Виктор on 13/12/2018.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class SUAIScheduleProvider;
@interface SUAI : NSObject

@property (strong, nonatomic, readonly) SUAIScheduleProvider *schedule;

+ (instancetype)instance;

@end

NS_ASSUME_NONNULL_END
