//
//  VVLoader.h
//  SUAIParser
//
//  Created by Виктор on 05/07/2018.
//  Copyright © 2018 Victor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enums.h"

@interface SUAILoader : NSObject

+ (void)loadGroupsWithType:(Schedule)scheduleType
                success:(void (^) (NSData *data))success
                   fail:(void (^) (NSString *fail))fail;

+ (void)loadScheduleOfType:(Schedule)scheduleType
                    entity:(Entity)entityType
                  entityId:(NSString *)identificator
                   success:(void (^) (NSData *data))success
                      fail:(void (^) (NSString *fail))fail;

@end
