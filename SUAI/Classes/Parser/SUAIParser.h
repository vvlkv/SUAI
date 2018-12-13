//
//  SUAIParser.h
//  SUAIParser
//
//  Created by Виктор on 05/07/2018.
//  Copyright © 2018 Victor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SUAIParser : NSObject

+ (NSDictionary *)codesFromData:(NSData *)data;
+ (NSArray *)scheduleFromData:(NSData *)data;

@end
