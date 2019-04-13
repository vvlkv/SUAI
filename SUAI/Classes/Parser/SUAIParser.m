//
//  SUAIParser.m
//  SUAIParser
//
//  Created by Виктор on 05/07/2018.
//  Copyright © 2018 Victor. All rights reserved.
//

#import "SUAIParser.h"
#import "HTMLKit.h"
#import "SUAIPair.h"
#import "SUAIDay.h"
#import "SUAITime.h"
#import "SUAIAuditory.h"
#import "Enums.h"
#import "NSString+Enums.h"

@implementation SUAIParser

+ (WeekType)weekTypeFromData:(NSData *)data {
    if (data == nil) {
        return WeekTypeUndefined;
    }
    
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    HTMLDocument *document = [HTMLDocument documentWithString:dataString];
    HTMLElement *rasp = [document querySelector:@".rasp"];
    if (rasp == nil)
        return WeekTypeUndefined;
    
    HTMLElement *today = [document querySelector:@"p"];
    if (today == nil)
        return WeekTypeUndefined;
    
    if ([[today textContent] containsString:@"нижн"])
        return WeekTypeBlue;
    return WeekTypeRed;
}

+ (NSDictionary *)codesFromData:(NSData *)data {
    
    NSArray<NSString *> *prohibitedEntityNames = @[@"нет", @"--", @"/."];
    
    if (data == nil) {
        return nil;
    }
    
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    HTMLDocument *document = [HTMLDocument documentWithString:dataString];
    NSArray *rasp = [document querySelectorAll:@".rasp"];
    //no elements - no party
    if ([rasp count] == 0)
        return nil;
    
    NSMutableDictionary *contents = [NSMutableDictionary dictionary];
    
    NSArray <NSNumber *> *descriptors = @[[NSNumber numberWithInteger:EntityTypeGroup],
                                        [NSNumber numberWithInteger:EntityTypeTeacher],
                                        [NSNumber numberWithInteger:EntityTypeAuditory]];
    
    for (HTMLElement *element in rasp) {
        NSArray *spans = [element querySelectorAll:@"span"];
        
        for (HTMLElement *span in spans) {
            NSArray *options = [span querySelectorAll:@"option"];
            NSMutableDictionary *codes = [NSMutableDictionary dictionary];
            
            for (HTMLElement *option in options) {
                HTMLNode *firstChild = [option firstChild];
                if (firstChild != nil && firstChild.textContent != nil) {
                    if (![self p_containsName:firstChild.textContent inArray:prohibitedEntityNames])
                        codes[firstChild.textContent] = option.attributes[@"value"];
                }
            }
            if (codes.count > 0) {
                NSUInteger index = [spans indexOfObject:span] - 1;
                contents[descriptors[index]] = codes;
            }
        }
    }
    return contents;
}

+ (BOOL)p_containsName:(NSString *)name inArray:(NSArray<NSString *> *)array {
    for (NSString *value in array) {
        if ([name containsString:value])
            return YES;
    }
    return NO;
}

+ (NSArray *)scheduleFromData:(NSData *)data {
    
    if (data == nil)
        return [NSArray array];
    
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    HTMLDocument *document = [HTMLDocument documentWithString:dataString];
    
    NSArray *rasp = [document querySelectorAll:@".result"];
    if ([rasp count] == 0)
        return [NSArray array];
    
    NSMutableArray *days = [NSMutableArray array];
    SUAIPair *pair;
    SUAIDay *day;
    NSString *pairTime = @"";
    for (HTMLNode *element in rasp) {
        for (HTMLElement *child in element.childNodes) {
            if ([child isKindOfClass:[HTMLText class]])
                continue;
            if ([child.tagName isEqualToString:@"h3"]) {
                // Create day and add pairs array
                NSString *dayName = [child textContent];
                day = [[SUAIDay alloc] initWithName:dayName weekday:[self p_weekdayFromName:dayName]];
                [days addObject:day];
            }
            //Each pair time with h4 tag
            if ([child.tagName isEqualToString:@"h4"]) {
                // Save pair time
                if (child.textContent != nil)
                    pairTime = child.textContent;
            }
            //Each pair starts from div
            if ([child.tagName isEqualToString:@"div"]) {
                pair = [[SUAIPair alloc] init];
                pair.time = [[SUAITime alloc] initWithTimeString:pairTime];
                [self fillPair:pair fromElement:[child querySelector:@".study"]];
                [day addPair:pair];
            }
        }
    }
    return days;
}

+ (void)fillPair:(SUAIPair *)pair fromElement:(HTMLElement *)element {
    if ([element querySelector:@".dn"] != nil) {
        pair.color = WeekTypeBlue;
    } else if ([element querySelector:@".up"] != nil) {
        pair.color = WeekTypeRed;
    }
    for (HTMLElement *el in element.childNodes) {
        if ([el isKindOfClass:[HTMLElement class]]) {
            if ([el.tagName isEqualToString:@"span"]) {
                NSString *text = el.textContent;
                NSArray *pairContents = [text componentsSeparatedByString:@" – "];
                pair.auditory = [[SUAIAuditory alloc] initWithString:pairContents.lastObject];
                if ([pairContents count] == 3) { //Semester pair
                    if (pairContents.count > 0)
                        pair.lessonType = [[pairContents[0] componentsSeparatedByString:@" "] lastObject];
                    if (pairContents.count > 1)
                        pair.name = pairContents[1];
                } else {
                    pair.name = pairContents[0];
                }
            }
            if ([el.tagName isEqualToString:@"div"]) {
                HTMLElement *prep = [el querySelector:@".preps"];
                pair.teachers = [self contentsFromElement:prep];
                HTMLElement *groups = [el querySelector:@".groups"];
                pair.groups = [self contentsFromElement:groups];
            }
        }
    }
}

+ (NSArray<NSString *> *)contentsFromElement:(HTMLElement *)element {
    return [[[element.textContent componentsSeparatedByString:@": "] lastObject] componentsSeparatedByString:@"; "];
}

+ (NSUInteger)p_weekdayFromName:(NSString *)name {
    NSArray *weekdays = @[@"вне", @"понедельник", @"вторник", @"среда", @"четверг", @"пятница", @"суббота"];
    for (int i = 0; i < [weekdays count]; i++) {
        NSString *weekday = weekdays[i];
        if ([[name lowercaseString] containsString:weekday])
            return i + 1;
    }
    return 0;
}

@end
