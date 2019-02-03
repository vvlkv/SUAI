//
//  VVPair.h
//  SUAIParser
//
//  Created by Виктор on 05/07/2018.
//  Copyright © 2018 Victor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enums.h"

@class SUAIAuditory;
@class SUAITime;
@interface SUAIPair : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray<NSString *> *teachers;
@property (strong, nonatomic) NSArray<NSString *> *groups;
@property (assign, nonatomic) WeekType color;
@property (strong, nonatomic) NSString *lessonType;
@property (strong, nonatomic) SUAITime *time;
@property (strong, nonatomic) SUAIAuditory *auditory;

@end
