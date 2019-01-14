//
//  VVDay.m
//  SUAIParser
//
//  Created by Виктор on 05/07/2018.
//  Copyright © 2018 Victor. All rights reserved.
//

#import "SUAIDay.h"

@interface SUAIDay() {
    NSMutableArray<SUAIPair *> *_pairs;
}

@end

@implementation SUAIDay

- (instancetype)initWithName:(NSString *)name andPairs:(NSArray<SUAIPair *> *)pairs
{
    self = [super init];
    if (self) {
        _name = name;
        _pairs = [NSMutableArray arrayWithArray:pairs];
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name {
    return [self initWithName:name andPairs:[NSArray array]];
}

- (void)addPair:(SUAIPair *)pair {
    [_pairs addObject:pair];
}

- (NSArray<SUAIPair *> *)pairs {
    return [_pairs copy];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"day:%@\rpairs:%@\r", self.name, self.pairs];
}

@end
