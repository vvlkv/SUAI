//
//  SUAITime.m
//  SUAI
//
//  Created by Виктор on 03/02/2019.
//

#import "SUAITime.h"

@interface SUAITime() {
    NSString *_str;
}

@property (nonatomic, assign, readwrite) NSUInteger hour;
@property (nonatomic, assign, readwrite) NSUInteger minute;

@end

@implementation SUAITime

- (instancetype)init {
    return [self initWithTimeString:@""];
}

- (instancetype)initWithTimeString:(NSString *)timeStr {
    self = [super init];
    if (self) {
        _str = timeStr;
        _hour = 0;
        _minute = 0;
        [self p_parseTime];
    }
    return self;
}

- (void)p_parseTime {
    NSString *components = [[_str componentsSeparatedByString:@" "] lastObject];
    if (components == nil)
        return;
    NSString *start = [[components componentsSeparatedByString:@"-"] firstObject];
    NSArray<NSString *> *timeComponents = [start componentsSeparatedByString:@":"];
    if ([timeComponents count] != 2)
        return;
    NSString *possibleHour;
    NSScanner *scanner = [NSScanner scannerWithString:timeComponents[0]];
    NSCharacterSet *characters = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    [scanner scanUpToCharactersFromSet:characters intoString:nil];
    [scanner scanCharactersFromSet:characters intoString:&possibleHour];
    
    _hour = [possibleHour integerValue];
    _minute = [timeComponents[1] integerValue];
}

- (NSString *)stringValue {
    return _str;
}

- (BOOL)isEqual:(id)object {
    if (self == object)
        return YES;
    if ([self class] != [object class])
        return NO;
    
    SUAITime *otherTime = (SUAITime *)object;
    if (![_str isEqualToString:[otherTime stringValue]])
        return NO;
    return YES;
}

- (NSUInteger)minutesSinceMidnight {
    return _hour * 60 + _minute;
}

- (NSUInteger)hash {
    return [_str hash];
}

@end
