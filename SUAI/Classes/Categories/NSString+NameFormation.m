//
//  NSString+NameFormation.m
//  HTMLKit
//
//  Created by Виктор on 12/12/2018.
//

#import "NSString+NameFormation.h"

@implementation NSString (NameFormation)

- (NSString *)refactored {
    NSCharacterSet *characters = [NSCharacterSet characterSetWithCharactersInString:@" ."];
    NSArray *components = [self componentsSeparatedByCharactersInSet:characters];
    return [components componentsJoinedByString:@""];
}

- (NSString *)refactoredTeacher {
    //delete spaces, uppercase, dots, separate by -
    NSString *formattedName = [self componentsSeparatedByString:@" - "][0];
    return [formattedName refactored];
}

- (NSString *)refactoredGroup {
    //delete spaces, uppercase, dots
    return [[self refactored] uppercaseString];
}

- (NSString *)refactoredAuditory {
    //delete spaces, uppercase, dots
    return [self refactored];
}

- (NSString *)removeSlashes {
    NSCharacterSet *trim = [NSCharacterSet characterSetWithCharactersInString:@"\t\n\r"];
    NSString *result = [[self componentsSeparatedByCharactersInSet:trim] componentsJoinedByString:@""];
    return result;
}

@end
