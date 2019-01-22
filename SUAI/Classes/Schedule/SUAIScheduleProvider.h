//
//  SUAIParser.h
//  SUAIParser
//
//  Created by Виктор on 05/07/2018.
//  Copyright © 2018 Victor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enums.h"

@class SUAISchedule;
@class SUAIEntity;
@class SUAIError;

extern NSString *kSUAIEntityLoadedNotification;

@interface SUAIScheduleProvider : NSObject

@property (strong, nonatomic, readonly) NSArray <SUAIEntity *> *groups;
@property (strong, nonatomic, readonly) NSArray <SUAIEntity *> *teachers;
@property (strong, nonatomic, readonly) NSArray <SUAIEntity *> *auditories;

+ (instancetype)instance;

- (void)loadScheduleFor:(SUAIEntity *)entity
                success:(void (^) (SUAISchedule *schedule))schedule
                   fail:(void (^) (__kindof SUAIError *error))error;

- (void)loadScheduleFor:(NSString *)entityName
                 ofType:(Entity)type
                success:(void (^) (SUAISchedule *schedule))schedule
                   fail:(void (^) (__kindof SUAIError *error))error;

@end

