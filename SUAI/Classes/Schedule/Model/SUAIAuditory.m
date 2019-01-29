//
//  SUAIAuditory.m
//  SUAIParser
//
//  Created by Виктор on 07/07/2018.
//  Copyright © 2018 Victor. All rights reserved.
//

#import "SUAIAuditory.h"

@implementation SUAIAuditory

- (instancetype)initWithString:(NSString *)str
{
    self = [super init];
    if (self) {
        NSArray *parts = [str componentsSeparatedByString:@" "];
        if (parts.count == 2) {
            _building = [self buildingFrom:parts[0]];
            _number = parts[1];
            _fullDescription = str;
        } else {
            _building = Undefined;
            _number = @"";
            _fullDescription = [str stringByReplacingOccurrencesOfString:@" КАФЕДРА" withString:@""];
        }
    }
    return self;
}

- (Building)buildingFrom:(NSString *)string {
    if ([string isEqualToString:@"Б.М."]) {
        return BM;
    } else if ([string isEqualToString:@"Ленс"]) {
        return Lens;
    } else if ([string isEqualToString:@"Гаст."]) {
        return Gast;
    }
    return Undefined;
}

- (BOOL)isEqual:(id)object {
    if (self == object)
        return YES;
    if ([self class] != [object class])
        return NO;
    
    SUAIAuditory *otherAud = (SUAIAuditory *)object;
    if (![_number isEqualToString:[otherAud number]])
        return NO;
    if (_building != [otherAud building])
        return NO;
    return YES;
}

- (NSUInteger)hash {
    NSUInteger numberHash = [_number hash];
    NSUInteger buildingHash = (NSUInteger)_building;
    return numberHash ^ buildingHash;
}

@end
