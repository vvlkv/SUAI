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
                        type:(EntityType)type {
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

- (BOOL)isEqual:(id)object {
    if (self == object)
        return YES;
    if ([self class] != [object class])
        return NO;
    
    SUAIEntity *otherEntity = (SUAIEntity *)object;
    if (![_name isEqualToString:[otherEntity name]])
        return NO;
    if (![_sessionCode isEqualToString:[otherEntity sessionCode]])
        return NO;
    if (![_semesterCode isEqualToString:[otherEntity semesterCode]])
        return NO;
    if (_type != [otherEntity type])
        return NO;
    
    return YES;
}

- (NSUInteger)hash {
    NSUInteger nameHash = [_name hash];
    NSUInteger sessHash = [_sessionCode hash];
    NSUInteger semHash = [_semesterCode hash];
    NSUInteger typeHash = (NSUInteger)_type;
    return nameHash ^ sessHash ^ semHash ^ typeHash;
}

@end
