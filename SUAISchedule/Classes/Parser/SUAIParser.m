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
    NSArray <NSNumber *> *descriptors = @[[NSNumber numberWithInteger:Group],
                                        [NSNumber numberWithInteger:Teacher],
                                        [NSNumber numberWithInteger:Auditory]];
    HTMLDocument *document = [HTMLDocument documentWithString:dataString];
    NSArray *rasp = [document querySelectorAll:@".rasp"];
    
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
    NSMutableArray *pairs = [NSMutableArray array];
    NSMutableArray *days = [NSMutableArray array];
    SUAIPair *pair;
    for (HTMLElement *element in rasp) {
        for (HTMLElement *child in element.childNodes) {
            if ([child isMemberOfClass:[HTMLText class]])
                continue;
            if ([child.tagName isEqualToString:@"h3"]) {
                if ([pairs count] > 0) {
                    if (child.textContent != nil)
                        [days addObject:[[SUAIDay alloc] initWithDay:child.textContent
                                                            andPairs:pairs]];
                    [pairs removeAllObjects];
                    days = pairs;//??
                }
            }
            if ([child.tagName isEqualToString:@"h4"]) {
                pair = [[SUAIPair alloc] init];
                if (child.textContent != nil)
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
            if (pairContents.count > 0)
                pair.lessonType = [[pairContents[0] componentsSeparatedByString:@" "] lastObject];
            if (pairContents.count > 1)
                pair.name = pairContents[1];
        }
        if ([el.tagName isEqualToString:@"div"]) {
            HTMLElement *prep = [el querySelector:@".preps"];
            pair.teachers = [self contentsFromElement:prep];
            HTMLElement *groups = [el querySelector:@".groups"];
            pair.groups = [self contentsFromElement:groups];
        }
    }
}

+ (NSArray<NSString *> *)contentsFromElement:(HTMLElement *)element {
    return [[[[element.textContent componentsSeparatedByString:@": "] lastObject] stringByReplacingOccurrencesOfString:@";"
                                                                                                            withString:@""] componentsSeparatedByString:@", "];
}

@end
