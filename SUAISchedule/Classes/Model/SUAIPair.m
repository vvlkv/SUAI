//
//  VVPair.m
//  SUAIParser
//
//  Created by Виктор on 05/07/2018.
//  Copyright © 2018 Victor. All rights reserved.
//

#import "SUAIPair.h"
#import "SUAIAuditory.h"

@implementation SUAIPair

- (instancetype)init
{
    self = [super init];
    if (self) {
        _name = @"";
        _teachers = [NSArray array];
        _groups = [NSArray array];
        _color = DayColorBoth;
        _lessonType = @"";
        _time = @"";
        _auditory = [[SUAIAuditory alloc] initWithString:@""];
    }
    return self;
}
@end
