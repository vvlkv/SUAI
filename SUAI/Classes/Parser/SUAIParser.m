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
#import "SUAIAuditory.h"
#import "Enums.h"
#import "NSString+Enums.h"

@implementation SUAIParser

+ (NSUInteger)weekTypeFromData:(NSData *)data {
    if (data == nil) {
        return -1;
    }
    
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    HTMLDocument *document = [HTMLDocument documentWithString:dataString];
    HTMLElement *rasp = [document querySelector:@".rasp"];
    if (rasp == nil) {
        return -1;
    }
    HTMLElement *today = [document querySelector:@"p"];
    if (today == nil)
        return -1;
    NSLog(@"%@", [today textContent]);
}

+ (NSDictionary *)codesFromData:(NSData *)data {
    
    if (data == nil) {
        return nil;
    }
    
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    HTMLDocument *document = [HTMLDocument documentWithString:dataString];
    NSArray *rasp = [document querySelectorAll:@".rasp"];
    //no elements - no party
    if ([rasp count] == 0) {
        return nil;
    }
    
    NSMutableDictionary *contents = [NSMutableDictionary dictionary];
    
    NSArray <NSNumber *> *descriptors = @[[NSNumber numberWithInteger:Group],
                                        [NSNumber numberWithInteger:Teacher],
                                        [NSNumber numberWithInteger:Auditory]];
    
    for (HTMLElement *element in rasp) {
        NSArray *spans = [element querySelectorAll:@"span"];
        
        for (HTMLElement *span in spans) {
            NSArray *options = [span querySelectorAll:@"option"];
            NSMutableDictionary *codes = [NSMutableDictionary dictionary];
            
            for (HTMLElement *option in options) {
                HTMLNode *firstChild = [option firstChild];
                if (firstChild != nil && firstChild.textContent != nil)
                    codes[firstChild.textContent] = option.attributes[@"value"];
            }
            if (codes.count > 0) {
                NSUInteger index = [spans indexOfObject:span] - 1;
                contents[descriptors[index]] = codes;
            }
        }
    }
    return contents;
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
    NSString *pairTime;
    for (HTMLNode *element in rasp) {
        for (HTMLElement *child in element.childNodes) {
            if ([child isKindOfClass:[HTMLText class]])
                continue;
            if ([child.tagName isEqualToString:@"h3"]) {
                // Create day and add pairs array
                day = [[SUAIDay alloc] initWithName:child.textContent];
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
                pair.time = pairTime;
                [self fillPair:pair fromElement:[child querySelector:@".study"]];
                [day addPair:pair];
            }
        }
    }
    return days;
}

+ (void)fillPair:(SUAIPair *)pair fromElement:(HTMLElement *)element {
    if ([element querySelector:@".dn"] != nil) {
        pair.color = DayColorBlue;
    } else if ([element querySelector:@".up"] != nil) {
        pair.color = DayColorRed;
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

@end
