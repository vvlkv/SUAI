//
//  VVSchedule.h
//  SUAIParser
//
//  Created by Виктор on 05/07/2018.
//  Copyright © 2018 Victor. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SUAIDay;
@class SUAIEntity;
@interface SUAISchedule : NSObject

@property (strong, nonatomic, readonly) SUAIEntity *entity;
@property (strong, nonatomic) NSArray<SUAIDay *> *session;
@property (strong, nonatomic) NSArray<SUAIDay *> *semester;
@property (strong, nonatomic, readonly) NSArray<SUAIDay *> *redSemester;
@property (strong, nonatomic, readonly) NSArray<SUAIDay *> *blueSemester;

- (instancetype)initWithEntity:(SUAIEntity *)entity;

- (NSArray<SUAIDay *> *)expandedScheduleToFullWeek:(NSArray<SUAIDay *> *)schedule;

@end
