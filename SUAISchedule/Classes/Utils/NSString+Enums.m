//
//  NSString+Enums.m
//  SUAIParser
//
//  Created by Виктор on 10/07/2018.
//  Copyright © 2018 Victor. All rights reserved.
//

#import "NSString+Enums.h"

@implementation NSString (Enums)

+ (NSString *)convertToString:(Entity)entity {
    switch (entity) {
        case EntityGroup:
            return @"Group";
            break;
        case EntityTeacher:
            return @"Teacher";
        default:
            return nil;
            break;
    }
}

+ (Entity)convertToEntity:(NSString *)entity {
    if ([entity isEqualToString:@"Group"]) {
        return EntityGroup;
    }
    if ([entity isEqualToString:@"Teacher"]) {
        return EntityTeacher;
    }
    return 0;
}
@end
