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
             andSemesterCode:(NSString *)semesterCode
{
    self = [super init];
    if (self) {
        _name = name;
        _sessionCode = sessionCode;
        _semesterCode = semesterCode;
    }
    return self;
}

@end
