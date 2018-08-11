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
#import "NSString+Enums.h"

@interface SUAIManager() {
    __block NSDictionary *semesterCodes;
    __block NSDictionary *sessionCodes;
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
        [self prepare];
    }
    return self;
}

- (void)prepare {
    for (int i = 0; i < 2; i++) {
        [SUAILoader loadGroupsWithType:(Schedule)i success:^(NSData *data) {
            [self setCodes:[SUAIParser codesFromData:data] forType:(Schedule)i];
        } fail:^(NSString *fail) {
        }];
    }
}

- (void)loadScheduleFor:(NSString *)name
           ofEntityType:(Entity)entity
                success:(void (^)(SUAISchedule *))schedule
                   fail:(void (^)(NSString *))fail {
    
    SUAISchedule *sched = [[SUAISchedule alloc] initWithName:name];
    __weak SUAISchedule *weakSched = sched;
    __weak NSString *sessionId = sessionCodes[[NSString convertToString:entity]][name];
    __weak NSString *semesterId = semesterCodes[[NSString convertToString:entity]][name];
    
    if (semesterId != nil) {
        [SUAILoader loadScheduleOfType:ScheduleSemester entity:entity entityId:semesterId success:^(NSData *data) {
            weakSched.semester = [SUAIParser scheduleFromData:data];
            if (sessionId != nil) {
                [SUAILoader loadScheduleOfType:ScheduleSession entity:entity entityId:sessionId success:^(NSData *data) {
                    weakSched.session = [SUAIParser scheduleFromData:data];
                    schedule(sched);
                } fail:^(NSString *fail) {
                    NSLog(@"%@", fail);
                }];
            }
            else {
                schedule(sched);
            }
        } fail:^(NSString *fail) {
            NSLog(@"%@", fail);
        }];
    } else {
        NSLog(@"FAIL");
    }
}

- (NSArray <NSString *> *)groups {
    NSDictionary *groupsDict = semesterCodes[[NSString convertToString:EntityGroup]];
    return [[groupsDict allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

- (NSArray <NSString *> *)teachers {
    NSDictionary *teachersDict = semesterCodes[[NSString convertToString:EntityTeacher]];
    return [[teachersDict allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

- (void)setStatus:(Status)status {
    _status = status;
    [self.delegate didChangeStatus:_status];
}

- (void)setCodes:(NSDictionary *)codes forType:(Schedule)s {
    if (s == ScheduleSession) {
        sessionCodes = codes;
    } else {
        semesterCodes = codes;
    }
    if (semesterCodes != nil && sessionCodes != nil) {
        self.status = Ok;
    }
}

@end
