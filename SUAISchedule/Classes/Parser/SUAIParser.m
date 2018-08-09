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

+ (NSDictionary *)codesFromData:(NSData *)data {
    NSMutableDictionary *contents = [[NSMutableDictionary alloc] init];
    
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    HTMLDocument *document = [HTMLDocument documentWithString:dataString];
    NSArray *rasp = [document querySelectorAll:@".rasp"];
    NSArray<NSString *> *descriptors = @[[NSString convertToString:EntityGroup],
                                         [NSString convertToString:EntityTeacher],
                                         @"Auditories"];
    for (HTMLElement *element in rasp) {
        NSArray *spans = [element querySelectorAll:@"span"];
        for (HTMLElement *span in spans) {
            NSArray *options = [span querySelectorAll:@"option"];
            NSMutableDictionary *codes = [NSMutableDictionary dictionary];
            for (HTMLElement *option in options) {
                codes[option.firstChild.textContent] = option.attributes[@"value"];
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
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    HTMLDocument *document = [HTMLDocument documentWithString:dataString];
    
    NSArray *rasp = [document querySelectorAll:@".result"];
    NSMutableArray *pairs = [NSMutableArray array];
    NSMutableArray *days = [NSMutableArray array];
    SUAIPair *pair;
    for (HTMLElement *element in rasp) {
        for (HTMLElement *child in element.childNodes) {
            if ([child.tagName isEqualToString:@"h3"]) {
                if ([pairs count] > 0) {
                    [days addObject:[[SUAIDay alloc] initWithDay:child.textContent andPairs:pairs]];
                    [pairs removeAllObjects];
                }
            }
            if ([child.tagName isEqualToString:@"h4"]) {
                pair = [[SUAIPair alloc] init];
                pair.time = child.textContent;
            }
            if ([child.tagName isEqualToString:@"div"]) {
                if (pair != nil) {
                    [self fillPair:pair fromElement:[child querySelector:@".study"]];
                    [pairs addObject:pair];
                }
            }
        }
    }
    return days;
}

+ (void)fillPair:(SUAIPair *)pair fromElement:(HTMLElement *)element {
    for (HTMLElement *el in element.childNodes) {
        if ([el.tagName isEqualToString:@"span"]) {
            NSString *text = el.textContent;
            NSArray *pairContents = [text componentsSeparatedByString:@" – "];
            pair.auditory = [[SUAIAuditory alloc] initWithString:pairContents.lastObject];
            pair.name = pairContents[1];
            pair.lessonType = pairContents[0];
        }
        if ([el.tagName isEqualToString:@"div"]) {
            HTMLElement *prep = [el querySelector:@".preps"];
            pair.teacherName = [self teacherFromElement:prep];
            HTMLElement *groups = [el querySelector:@".groups"];
            pair.groups = [self groupsFromElement:groups];
        }
    }
}

+ (NSString *)teacherFromElement:(HTMLElement *)element {
    return [[element.textContent componentsSeparatedByString:@": "] lastObject];
}

+ (NSArray<NSString *> *)groupsFromElement:(HTMLElement *)element {
    return [[[element.textContent componentsSeparatedByString:@": "] lastObject] componentsSeparatedByString:@", "];
}

@end
