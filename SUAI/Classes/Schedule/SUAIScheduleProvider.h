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

@protocol SUAIScheduleDelegate <NSObject>
@required
- (void)didChangeStatus:(Status)status;

@end

@interface SUAIScheduleProvider : NSObject

@property (assign, nonatomic, readonly) Status status;
@property (strong, nonatomic, readonly) NSArray <SUAIEntity *> *groups;
@property (strong, nonatomic, readonly) NSArray <SUAIEntity *> *teachers;
@property (strong, nonatomic, readonly) NSArray <SUAIEntity *> *auditories;

@property (weak, nonatomic) id <SUAIScheduleDelegate> delegate;

+ (instancetype)instance;

- (void)loadScheduleFor:(SUAIEntity *)entity
                success:(void (^) (SUAISchedule *schedule))schedule
                   fail:(void (^) (NSString *fail))fail;

@end
