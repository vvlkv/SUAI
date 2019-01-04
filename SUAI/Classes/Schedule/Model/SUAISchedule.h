//
//  VVSchedule.h
//  SUAIParser
//
//  Created by Виктор on 05/07/2018.
//  Copyright © 2018 Victor. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SUAIDay;
@interface SUAISchedule : NSObject

@property (strong, nonatomic, readonly) NSString *name;
@property (strong, nonatomic) NSArray<SUAIDay *> *session;
@property (strong, nonatomic) NSArray<SUAIDay *> *semester;
@property (strong, nonatomic, readonly) NSArray<SUAIDay *> *redSemester;
@property (strong, nonatomic, readonly) NSArray<SUAIDay *> *blueSemester;

- (instancetype)initWithName:(NSString *)name;
- (instancetype)initWithName:(NSString *)name
                     session:(NSArray<SUAIDay *> *)session
                 andSemester:(NSArray<SUAIDay *> *)semester;
- (NSArray<SUAIDay *> *)expandedScheduleToFullWeek:(NSArray<SUAIDay *> *)schedule;

@end
