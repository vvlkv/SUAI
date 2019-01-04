//
//  VVSchedule.m
//  SUAIParser
//
//  Created by Виктор on 05/07/2018.
//  Copyright © 2018 Victor. All rights reserved.
//

#import "SUAISchedule.h"

@implementation SUAISchedule

- (instancetype)initWithName:(NSString *)name
{
    self = [super init];
    if (self) {
        _name = name;
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name
                     session:(NSArray<SUAIDay *> *)session
                 andSemester:(NSArray<SUAIDay *> *)semester {
    self = [super init];
    if (self) {
        _name = name;
        _session = [session copy];
        _semester = [semester copy];
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Name:\t%@\nSemester:\n%@Session:\n%@", _name, _semester, _session];
}

@end
