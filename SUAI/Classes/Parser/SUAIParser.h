//
//  SUAIParser.h
//  SUAIParser
//
//  Created by Виктор on 05/07/2018.
//  Copyright © 2018 Victor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enums.h"

@class SUAIParseError;
@interface SUAIParser : NSObject

+ (WeekType)weekTypeFromData:(NSData *)data;
+ (NSDictionary *)codesFromData:(NSData *)data;
+ (NSArray *)scheduleFromData:(NSData *)data;

@end
