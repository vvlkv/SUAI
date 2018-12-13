//
//  SUAIParser.m
//  SUAIParser
//
//  Created by Виктор on 05/07/2018.
//  Copyright © 2018 Victor. All rights reserved.
//

#import "SUAIManager.h"
#import "SUAILoader.h"
#import "SUAIParser.h"
#import "SUAISchedule.h"
#import "SUAIEntity.h"
#import "NSString+Enums.h"
#import "NSString+NameFormation.h"

typedef NSString*(*clr_func)(id, SEL);

@interface SUAIManager() {
//    __block NSDictionary *semesterCodes;
//    __block NSDictionary *sessionCodes;
    NSMutableArray <SUAIEntity *> *_groups;
    NSMutableArray <SUAIEntity *> *_teachers;
    NSMutableArray <SUAIEntity *> *_auditories;
}

@end

@implementation SUAIManager

+ (instancetype)instance {
    static SUAIManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SUAIManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
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

- (void)prepare {
    [SUAILoader loadCodesWithSuccess:^(NSArray<NSData *> *data) {
        [self saveCodes:data];
        [self setStatus:Ok];
    } fail:^(NSString *fail) {
        //TODO
    }];
}

- (void)saveCodes:(NSArray<NSData *> *)data {
    
    let *sessionCodes = [SUAIParser codesFromData:data[0]];
    let *semesterCodes = [SUAIParser codesFromData:data[1]];
    
    let *descriptors = @[[NSNumber numberWithInteger:Group],
                         [NSNumber numberWithInteger:Teacher],
                         [NSNumber numberWithInteger:Auditory]];
    
    let *entities = @[_groups, _teachers, _auditories];
    
    let *clearMethods = @[NSStringFromSelector(@selector(refactoredGroup)),
                          NSStringFromSelector(@selector(refactoredTeacher)),
                          NSStringFromSelector(@selector(refactoredAuditory))];
    
    for (NSNumber *descriptor in descriptors) {
        var *entityDictionary = [NSMutableDictionary dictionary];
        NSDictionary *semesterDict = [semesterCodes objectForKey:descriptor];
        NSDictionary *sessionDict = [sessionCodes objectForKey:descriptor];

        let index = [descriptors indexOfObject:descriptor];

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
    
    var *sched = [[SUAISchedule alloc] initWithName:[entity name]];
    __weak SUAISchedule *weakSched = sched;
    
    let group = dispatch_group_create();
    let queue = dispatch_queue_create("load sched", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_group_async(group, queue, ^{
        dispatch_group_enter(group);
        [SUAILoader loadScheduleOfType:Semester for:entity success:^(NSData *data) {
            weakSched.semester = [SUAIParser scheduleFromData:data];
            dispatch_group_leave(group);
        } fail:^(NSString *fail) {
            NSLog(@"ERROR1");
            dispatch_group_leave(group);
        }];
    });
    dispatch_group_async(group, queue, ^{
        dispatch_group_enter(group);
        [SUAILoader loadScheduleOfType:Session for:entity success:^(NSData *data) {
            NSLog(@"%@", [SUAIParser scheduleFromData:data]);
            weakSched.session = [SUAIParser scheduleFromData:data];
            dispatch_group_leave(group);
        } fail:^(NSString *fail) {
            NSLog(@"ERROR2");
            dispatch_group_leave(group);
        }];
    });
    dispatch_group_notify(group, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            schedule(sched);
        });
    });
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
    [self.delegate didChangeStatus:self->_status];
//    dispatch_async(dispatch_get_main_queue(), ^{
//    });
}

@end
