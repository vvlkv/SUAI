//
//  VVSchedule.m
//  SUAIParser
//
//  Created by Виктор on 05/07/2018.
//  Copyright © 2018 Victor. All rights reserved.
//

#import "SUAISchedule.h"
#import "SUAIDay.h"
#import "SUAIPair.h"
#import "SUAIEntity.h"

@interface SUAISchedule() {
    NSArray <SUAIDay *> *_redSemester;
    NSArray <SUAIDay *> *_blueSemester;
}

@end

@implementation SUAISchedule

- (instancetype)initWithEntity:(SUAIEntity *)entity {
    self = [super init];
    if (self) {
        _entity = entity;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Name:\t%@\nSemester:\n%@Session:\n%@", _entity, _semester, _session];
}

- (NSArray<SUAIDay *> *)redSemester {
    if (_redSemester == nil) {
        _redSemester = [self sortSemesterUsing:WeekTypeRed];
    }
    return _redSemester;
}

- (NSArray<SUAIDay *> *)blueSemester {
    if (_blueSemester == nil) {
        _blueSemester = [self sortSemesterUsing:WeekTypeBlue];
    }
    return _blueSemester;
}

- (NSArray<SUAIDay *> *)sortSemesterUsing:(WeekType)color {
    NSMutableArray<SUAIDay *> *result = [NSMutableArray array];
    for (SUAIDay *day in _semester) {
        NSMutableArray<SUAIPair *> *pairs = [NSMutableArray array];
        for (SUAIPair *pair in day.pairs) {
            if (pair.color == WeekTypeBoth || pair.color == color) {
                [pairs addObject:pair];
            }
        }
        if ([pairs count] > 0) {
            [result addObject:[[SUAIDay alloc] initWithName:day.name
                                                   andPairs:[pairs copy]]];
        }
    }
    return [result copy];
}

- (NSArray<SUAIDay *> *)expandedScheduleToFullWeek:(NSArray<SUAIDay *> *)schedule {
    NSArray *days = @[@"Понедельник", @"Вторник", @"Среда", @"Четверг", @"Пятница", @"Суббота", @"Вне сетки расписания"];
    NSMutableArray<SUAIDay *> *expanded = [NSMutableArray array];
    
    for (int i = 0; i < [days count]; i++) {
        
        NSUInteger foundedIndex = [schedule indexOfObjectPassingTest:^BOOL(SUAIDay * _Nonnull day, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([[day name] containsString:days[i]]) {
                *stop = YES;
                return YES;
            }
            return NO;
        }];
        if (foundedIndex == NSNotFound) {
            [expanded addObject:[[SUAIDay alloc] initWithName:days[i] andPairs:[NSArray array]]];
        } else {
            [expanded addObject:schedule[foundedIndex]];
        }
    }
    return expanded;
}

- (BOOL)isEqual:(id)object {
    if (self == object)
        return YES;
    if ([self class] != [object class])
        return NO;
    SUAISchedule *otherSchedule = (SUAISchedule *)object;
    if (![_entity isEqual:[otherSchedule entity]])
        return NO;
    if (![_session isEqualToArray:[otherSchedule session]])
        return NO;
    if (![_semester isEqualToArray:[otherSchedule semester]])
        return NO;
    return YES;
}

- (NSUInteger)hash {
    NSUInteger entityHash = [_entity hash];
    NSUInteger sessHash = [_session hash];
    NSUInteger semHash = [_semester hash];
    return entityHash ^ sessHash ^ semHash;
}

@end
