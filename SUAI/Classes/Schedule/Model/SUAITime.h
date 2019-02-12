//
//  SUAITime.h
//  SUAI
//
//  Created by Виктор on 03/02/2019.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SUAITime : NSObject

@property (nonatomic, assign, readonly) NSUInteger hour;
@property (nonatomic, assign, readonly) NSUInteger minute;
@property (nonatomic, assign, readonly) NSUInteger minutesSinceMidnight;

- (instancetype)initWithTimeString:(NSString *)timeStr;

- (NSString *)stringValue;

@end

NS_ASSUME_NONNULL_END
