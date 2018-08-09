//
//  SUAIParser.h
//  SUAIParser
//
//  Created by Виктор on 05/07/2018.
//  Copyright © 2018 Victor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enums.h"

typedef enum Status {
    Ready,
    Refused
}Status;

@class SUAISchedule;
@class SUAIEntity;
@protocol SUAIScheduleDelegate <NSObject>
@required
- (void)didChangeStatus:(Status)status;

@end

@interface SUAIManager : NSObject

@property (assign, nonatomic, readonly) Status status;
@property (weak, nonatomic) id <SUAIScheduleDelegate> delegate;

+ (instancetype)instance;

- (void)loadScheduleFor:(NSString *)identificator
           ofEntityType:(Entity)entity
                success:(void (^) (SUAISchedule *schedule))schedule
                   fail:(void (^) (NSString *fail))fail;
@end
