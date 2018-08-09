//
//  VVPair.h
//  SUAIParser
//
//  Created by Виктор on 05/07/2018.
//  Copyright © 2018 Victor. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum DayColor {
    DayColorRed,
    DayColorBlue,
    DayColorBoth
} DayColor;

@class SUAIAuditory;
@interface SUAIPair : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *teacherName;
@property (strong, nonatomic) NSArray<NSString *> *groups;
@property (assign, nonatomic) DayColor color;
@property (strong, nonatomic) NSString *lessonType;
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) SUAIAuditory *auditory;

@end
