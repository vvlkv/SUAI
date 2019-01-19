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
#import "SUAINetworkError.h"

typedef NSString*(*clr_func)(id, SEL);

@interface SUAIScheduleProvider() {
    NSMutableArray <SUAIEntity *> *_groups;
    NSMutableArray <SUAIEntity *> *_teachers;
    NSMutableArray <SUAIEntity *> *_auditories;
}

@property (assign, nonatomic) BOOL codesAvailable;

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
        _codesAvailable = NO;
        _groups = [[NSMutableArray alloc] init];
        _teachers = [[NSMutableArray alloc] init];
        _auditories = [[NSMutableArray alloc] init];
    }
    return self;
}

- (instancetype)init {
    assert("Use instance instead!");
    return nil;
}

- (void)p_loadCodes:(dispatch_group_t )group {
    __weak typeof(self) welf = self;
    dispatch_group_enter(group);
    [SUAILoader loadCodesWithSuccess:^(NSArray<NSData *> *data) {
        [welf saveCodes:data];
        welf.codesAvailable = YES;
        dispatch_group_leave(group);
    } fail:^(SUAINetworkError *fail) {
        dispatch_group_leave(group);
    }];
    NSLog(@"eof");
}

- (void)loadScheduleFor:(SUAIEntity *)entity
                success:(void (^) (SUAISchedule *schedule))schedule
                   fail:(void (^) (__kindof SUAIError *error))error {
    SUAISchedule *sched = [[SUAISchedule alloc] initWithName:[entity name]];
    __weak SUAISchedule *weakSched = sched;

    [SUAILoader loadSchedulesWithSemesterCode:[entity semesterCode]
                                  sessionCode:[entity sessionCode]
                                   entityType:[entity type]
                                      success:^(NSArray<NSData *> *data) {
        weakSched.semester = [SUAIParser scheduleFromData:data[0]];
        weakSched.session = [SUAIParser scheduleFromData:data[1]];
        schedule(sched);
    } fail:^(SUAINetworkError *fail) {
        error(fail);
    }];
}

- (void)loadScheduleFor:(NSString *)entityName
                 ofType:(Entity)type
                success:(void (^) (SUAISchedule *schedule))schedule
                   fail:(void (^) (__kindof SUAIError *error))error {
    
    if (!_codesAvailable) {
        dispatch_group_t group = dispatch_group_create();
        dispatch_queue_t queue = dispatch_queue_create("schedule preload", DISPATCH_QUEUE_CONCURRENT);
        __weak typeof(self) welf = self;
        dispatch_group_async(group, queue, ^{
            [welf p_loadCodes:group];
        });
        dispatch_group_notify(group, queue, ^{
            [welf p_loadScheduleFor:entityName ofType:type success:schedule fail:error];
        });
    } else {
        [self p_loadScheduleFor:entityName ofType:type success:schedule fail:error];
    }
}

- (void)p_loadScheduleFor:(NSString *)entityName
                 ofType:(Entity)type
                success:(void (^) (SUAISchedule *schedule))schedule
                     fail:(void (^) (__kindof SUAIError *error))error {
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
            break;
    }
    
    SUAIEntity *entity = nil;
    for (SUAIEntity *e in searchEntities) {
        if ([e.name isEqualToString:entityName]) {
            entity = e;
            break;
        }
    }
    
    if (entity == nil) {
        SUAIError *lost = [SUAIError errorWithCode:SUAIErrorParseUnknown userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"entity %@ of type %lu not found", entityName, (unsigned long)type]}];
        error(lost);
    } else {
        [self loadScheduleFor:entity success:schedule fail:error];
    }
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

- (NSArray <SUAIEntity *> *)groups {
    return _groups;
}

- (NSArray <SUAIEntity *> *)teachers {
    return _teachers;
}

- (NSArray <SUAIEntity *> *)auditories {
    return _auditories;
}

@end
