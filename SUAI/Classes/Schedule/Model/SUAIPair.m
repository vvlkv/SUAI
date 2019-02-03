//
//  VVPair.m
//  SUAIParser
//
//  Created by Виктор on 05/07/2018.
//  Copyright © 2018 Victor. All rights reserved.
//

#import "SUAIPair.h"
#import "SUAIAuditory.h"
#import "SUAITime.h"

@implementation SUAIPair

- (instancetype)init
{
    self = [super init];
    if (self) {
        _name = @"";
        _teachers = [NSArray array];
        _groups = [NSArray array];
        _color = WeekTypeBoth;
        _lessonType = @"";
        _time = [[SUAITime alloc] init];
        _auditory = [[SUAIAuditory alloc] initWithString:@""];
    }
    return self;
}

- (void)setTeachers:(NSArray<NSString *> *)teachers {
    if (teachers != nil)
        _teachers = [teachers copy];
}

- (void)setGroups:(NSArray<NSString *> *)groups {
    if (groups != nil)
        _groups = [groups copy];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Name:\t%@\nTeachers:\t%@", _name, _teachers];
}

- (BOOL)isEqual:(id)object {
    if (self == object)
        return YES;
    if ([self class] != [object class])
        return NO;
    
    SUAIPair *otherPair = (SUAIPair *)object;
    if (![_name isEqualToString:[otherPair name]])
        return NO;
    if (![_teachers isEqualToArray:[otherPair teachers]])
        return NO;
    if (![_groups isEqualToArray:[otherPair groups]])
        return NO;
    if (_color != [otherPair color])
        return NO;
    if (![_lessonType isEqualToString:[otherPair lessonType]])
        return NO;
    if (![_time isEqual:[otherPair time]])
        return NO;
    if (![_auditory isEqual:[otherPair auditory]])
        return NO;
    return YES;
}

- (NSUInteger)hash {
    NSUInteger nameHash = [_name hash];
    NSUInteger teachersHash = [_teachers hash];
    NSUInteger groupsHash = [_groups hash];
    NSUInteger colorHash = (NSUInteger)_color;
    NSUInteger lessTypeHash = [_lessonType hash];
    NSUInteger timeHash = [_time hash];
    NSUInteger audHash = [_auditory hash];
    return nameHash ^ teachersHash ^ groupsHash ^ colorHash ^ lessTypeHash ^ timeHash ^ audHash;
}

@end
