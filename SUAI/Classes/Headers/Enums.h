//
//  Enums.h
//  SUAIParser
//
//  Created by Виктор on 05/07/2018.
//  Copyright © 2018 Victor. All rights reserved.
//

#ifndef Enums_h
#define Enums_h

typedef enum Status {
    Ok,
    Error
}Status;

typedef enum Schedule {
    Session,
    Semester
}Schedule;

typedef NS_ENUM(NSUInteger, Entity) {
    Group,
    Teacher,
    Auditory
};

#endif /* Enums_h */
