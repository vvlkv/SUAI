//
//  SUAI.m
//  SUAI
//
//  Created by Виктор on 13/12/2018.
//

#import "SUAI.h"
#import "SUAIScheduleProvider.h"

@interface SUAI() {
    SUAIScheduleProvider *_schedule;
}

@end

@implementation SUAI

+ (instancetype)instance {
    static SUAI *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SUAI alloc] initPrivate];
    });
    return sharedInstance;
}

- (id)initPrivate {
    self = [super init];
    if (self) {
        _schedule = [SUAIScheduleProvider instance];
    }
    return self;
}

- (instancetype)init
{
    assert("Use instance!");
    return nil;
}

- (SUAIScheduleProvider *)schedule {
    return _schedule;
}

@end
