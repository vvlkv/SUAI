//
//  SUAIEntity.m
//  SUAIParser
//
//  Created by Виктор on 10/07/2018.
//  Copyright © 2018 Victor. All rights reserved.
//

#import "SUAIEntity.h"

@implementation SUAIEntity

- (instancetype)initWithName:(NSString *)name
                 sessionCode:(NSString *)sessionCode
                semesterCode:(NSString *)semesterCode
                        type:(Entity)type {
    self = [super init];
    if (self) {
        _name = name;
        _sessionCode = sessionCode;
        _semesterCode = semesterCode;
        _type = type;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"\n\nname:%@\nsesCode:%@\nsemCode:%@\ntype:%lu", _name, _sessionCode, _semesterCode, (unsigned long)_type];
}

@end
