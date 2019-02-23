//
//  NSString+Enums.m
//  SUAIParser
//
//  Created by Виктор on 10/07/2018.
//  Copyright © 2018 Victor. All rights reserved.
//

#import "NSString+Enums.h"

@implementation NSString (Enums)

+ (NSString *)convertToString:(EntityType)entity {
    switch (entity) {
        case EntityTypeGroup:
            return @"Group";
            break;
        case EntityTypeTeacher:
            return @"Teacher";
        default:
            return @"";
            break;
    }
}

+ (EntityType)convertToEntity:(NSString *)entity {
    if ([entity isEqualToString:@"Group"]) {
        return EntityTypeGroup;
    }
    if ([entity isEqualToString:@"Teacher"]) {
        return EntityTypeTeacher;
    }
    return 0;
}

@end
