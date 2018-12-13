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
        case Group:
            return @"Group";
            break;
        case Teacher:
            return @"Teacher";
        default:
            return nil;
            break;
    }
}

+ (Entity)convertToEntity:(NSString *)entity {
    if ([entity isEqualToString:@"Group"]) {
        return Group;
    }
    if ([entity isEqualToString:@"Teacher"]) {
        return Teacher;
    }
    return 0;
}
@end
