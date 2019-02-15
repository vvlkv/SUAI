//
//  SUAIParser.h
//  SUAIParser
//
//  Created by Виктор on 05/07/2018.
//  Copyright © 2018 Victor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enums.h"

NS_ASSUME_NONNULL_BEGIN

@class SUAISchedule;
@class SUAIEntity;
@class SUAIError;

extern NSString *kSUAIEntityLoadedNotification;
extern NSString *kSUAIWeekTypeObtainedNotification;

@interface SUAIScheduleProvider : NSObject

@property (nonatomic, strong, readonly) NSArray <SUAIEntity *> *groups;
@property (nonatomic, strong, readonly) NSArray <SUAIEntity *> *teachers;
@property (nonatomic, strong, readonly) NSArray <SUAIEntity *> *auditories;
@property (nonatomic, assign, readonly) BOOL codesAvailable;
@property (nonatomic, assign, readonly) WeekType currentWeekType;

+ (instancetype)instance;

- (void)loadCodes:(void (^) (NSArray<SUAIEntity *> *g, NSArray<SUAIEntity *> *t, NSArray<SUAIEntity *> *a))codes
             fail:(void (^) (__kindof SUAIError *error))error;

- (void)loadScheduleFor:(SUAIEntity *)entity
                success:(void (^) (SUAISchedule *schedule))schedule
                   fail:(void (^) (__kindof SUAIError *error))error;

- (void)loadScheduleFor:(NSString *)entityName
                 ofType:(EntityType)type
                success:(void (^) (SUAISchedule *schedule))schedule
                   fail:(void (^) (__kindof SUAIError *error))error;

@end

NS_ASSUME_NONNULL_END

