//
//  Enums.h
//  SUAIParser
//
//  Created by Виктор on 05/07/2018.
//  Copyright © 2018 Victor. All rights reserved.
//

#ifndef Enums_h
#define Enums_h

typedef NS_ENUM(NSUInteger, ScheduleType) {
    ScheduleTypeSemester,
    ScheduleTypeSession
};

typedef NS_ENUM(NSUInteger, EntityType) {
    EntityTypeGroup,
    EntityTypeTeacher,
    EntityTypeAuditory
};

typedef NS_ENUM(NSUInteger, WeekType) {
    WeekTypeBlue,
    WeekTypeRed,
    WeekTypeBoth,
    WeekTypeUndefined
};

#endif /* Enums_h */
