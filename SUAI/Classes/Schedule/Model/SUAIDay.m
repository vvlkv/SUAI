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

- (instancetype)initWithName:(NSString *)name andPairs:(NSArray<SUAIPair *> *)pairs {
    return [self initWithName:name weekday:0 andPairs:pairs];
}

- (instancetype)initWithName:(NSString *)name
                     weekday:(NSUInteger)weekday
                    andPairs:(NSArray<SUAIPair *> *)pairs {
    self = [super init];
    if (self) {
        _name = name;
        _weekday = weekday;
        _pairs = [NSMutableArray arrayWithArray:pairs];
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name {
    return [self initWithName:name weekday:0 andPairs:[NSArray array]];
}

- (instancetype)initWithName:(NSString *)name weekday:(NSUInteger)weekday {
    return [self initWithName:name weekday:weekday andPairs:[NSArray array]];
}

- (void)addPair:(SUAIPair *)pair {
    [_pairs addObject:pair];
}

- (NSArray<SUAIPair *> *)pairs {
    return [_pairs copy];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"day:%@\rpairs:%@\r", self.name, self.pairs];
}

- (BOOL)isEqual:(id)object {
    if (self == object)
        return YES;
    if ([self class] != [object class])
        return NO;
    
    SUAIDay *otherDay = (SUAIDay *)object;
    if (![_name isEqualToString:[otherDay name]])
        return NO;
    if (![_pairs isEqualToArray:[otherDay pairs]])
        return NO;
    
    return YES;
}

- (NSUInteger)hash {
    NSUInteger nameHash = [_name hash];
    NSUInteger pairsHash = [_pairs hash];
    return nameHash ^ pairsHash;
}

@end
