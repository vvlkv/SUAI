//
//  SUAIParser.m
//  SUAIParser
//
//  Created by Виктор on 05/07/2018.
//  Copyright © 2018 Victor. All rights reserved.
//

#import "SUAIScheduleProvider.h"
#import "SUAILoader.h"
#import "SUAIParser.h"
#import "SUAISchedule.h"
#import "SUAIEntity.h"
#import "NSString+Enums.h"
#import "NSString+NameFormation.h"

typedef NSString*(*clr_func)(id, SEL);

@interface SUAIScheduleProvider() {
    NSMutableArray <SUAIEntity *> *_groups;
    NSMutableArray <SUAIEntity *> *_teachers;
    NSMutableArray <SUAIEntity *> *_auditories;
}

@end

@implementation SUAIScheduleProvider

+ (instancetype)instance {
    static SUAIScheduleProvider *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SUAIScheduleProvider alloc] initPrivate];
    });
    return sharedInstance;
}

- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        _status = Error;
        _groups = [[NSMutableArray alloc] init];
        _teachers = [[NSMutableArray alloc] init];
        _auditories = [[NSMutableArray alloc] init];
        [self prepare];
    }
    return self;
}

- (instancetype)init {
    assert("Use instance instead!");
    return nil;
}

- (void)prepare {
    __weak typeof(self) welf = self;
    [SUAILoader loadCodesWithSuccess:^(NSArray<NSData *> *data) {
        [welf saveCodes:data];
        [welf setStatus:Ok];
    } fail:^(NSString *fail) {
        
    }];
}

- (void)saveCodes:(NSArray<NSData *> *)data {
    
    NSDictionary *sessionCodes = [SUAIParser codesFromData:data[0]];
    NSDictionary *semesterCodes = [SUAIParser codesFromData:data[1]];
    
    NSArray *descriptors = @[[NSNumber numberWithInteger:Group],
                         [NSNumber numberWithInteger:Teacher],
                         [NSNumber numberWithInteger:Auditory]];
    
    NSArray *entities = @[_groups, _teachers, _auditories];
    
    NSArray *clearMethods = @[NSStringFromSelector(@selector(refactoredGroup)),
                          NSStringFromSelector(@selector(refactoredTeacher)),
                          NSStringFromSelector(@selector(refactoredAuditory))];
    
    for (NSNumber *descriptor in descriptors) {
        NSMutableDictionary *entityDictionary = [NSMutableDictionary dictionary];
        NSDictionary *semesterDict = [semesterCodes objectForKey:descriptor];
        NSDictionary *sessionDict = [sessionCodes objectForKey:descriptor];

        NSUInteger index = [descriptors indexOfObject:descriptor];

        SEL clearMethod = NSSelectorFromString(clearMethods[index]);
        //REFACTOR IT
        for (NSString *name in [semesterDict allKeys]) {
            SUAIEntity *entity = entityDictionary[name];
            if (entity == nil) {
                entity = [[SUAIEntity alloc] init];
                entity.type = [descriptor integerValue];
                entity.name = name;
                entity.semesterCode = semesterDict[name];
                clr_func func = (clr_func)[name methodForSelector:clearMethod];
                NSString *refName = func(name, clearMethod);
                entityDictionary[refName] = entity;
            }
        }

        for (NSString *name in [sessionDict allKeys]) {
            clr_func func = (clr_func)[name methodForSelector:clearMethod];
            NSString *refName = func(name, clearMethod);
            SUAIEntity *entity = entityDictionary[refName];
            if (entity == nil) {
                entity = [[SUAIEntity alloc] init];
                entity.type = [descriptor integerValue];
                entity.name = name;
                entity.sessionCode = sessionDict[name];;
                entityDictionary[name] = entity;
            } else {
                entity.sessionCode = sessionDict[name];
            }
        }

        NSMutableArray *container = entities[index];
        [container addObjectsFromArray:[[entityDictionary allValues] sortedArrayUsingComparator:^NSComparisonResult(SUAIEntity  * _Nonnull obj1, SUAIEntity * _Nonnull obj2) {
            return [obj1.name compare:obj2.name];
        }]];
    }
}

- (void)loadScheduleFor:(SUAIEntity *)entity
                success:(void (^) (SUAISchedule *schedule))schedule
                   fail:(void (^) (NSString *fail))fail {
    
    SUAISchedule *sched = [[SUAISchedule alloc] initWithName:[entity name]];
    __weak SUAISchedule *weakSched = sched;

    [SUAILoader loadSchedulesWithSemesterCode:[entity semesterCode] sessionCode:[entity sessionCode] entityType:[entity type] success:^(NSArray<NSData *> *data) {
        weakSched.semester = [SUAIParser scheduleFromData:data[0]];
        weakSched.session = [SUAIParser scheduleFromData:data[1]];
        schedule(sched);
    } fail:^(NSString *fail) {
        //TODO
    }];
}

- (void)loadScheduleFor:(NSString *)entityName
                 ofType:(Entity)type
                success:(void (^) (SUAISchedule *schedule))schedule
                   fail:(void (^) (NSString *fail))fail {
    NSArray *searchEntities;
    switch (type) {
        case Group:
            searchEntities = _groups;
            break;
        case Teacher:
            searchEntities = _teachers;
            break;
        case Auditory:
            searchEntities = _auditories;
            break;
        default:
            fail(@"FAIL");
            break;
    }
    
    SUAIEntity *entity = nil;
    for (SUAIEntity *e in searchEntities) {
        NSLog(@"%@", e.name);
        if ([e.name isEqualToString:entityName]) {
            entity = e;
            break;
        }
    }
    
    if (entity == nil) {
        fail(@"FAIL");
    } else {
        [self loadScheduleFor:entity success:schedule fail:fail];
    }
}

- (NSArray <SUAIEntity *> *)groups {
    return _groups;
}

- (NSArray <SUAIEntity *> *)teachers {
    return _teachers;
}

- (NSArray <SUAIEntity *> *)auditories {
    return _auditories;
}

- (void)setStatus:(Status)status {
    _status = status;
    [self.delegate didChangeStatus:_status];
}

@end
