//
//  SUAI.m
//  SUAI
//
//  Created by Виктор on 13/12/2018.
//

#import "SUAI.h"

@interface SUAI() {
    SUAIScheduleProvider *_schedule;
    SUAINewsProvider     *_news;
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
        _news = [[SUAINewsProvider alloc] init];
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

- (SUAINewsProvider *)news {
    return _news;
}

@end
