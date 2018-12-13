//
//  VVDay.m
//  SUAIParser
//
//  Created by Виктор on 05/07/2018.
//  Copyright © 2018 Victor. All rights reserved.
//

#import "SUAIDay.h"

@implementation SUAIDay

- (instancetype)initWithDay:(NSString *)day andPairs:(NSArray<SUAIPair *> *)pairs
{
    self = [super init];
    if (self) {
        _day = day;
        _pairs = [pairs copy];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"day:%@\rpairs:%@\r", self.day, self.pairs];
}

@end
