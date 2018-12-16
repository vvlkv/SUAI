//
//  SUAIParser+News.h
//  SUAI
//
//  Created by Виктор on 14/12/2018.
//

#import "SUAIParser.h"

NS_ASSUME_NONNULL_BEGIN

@class SUAINews;
@interface SUAIParser (News)

+ (NSArray<SUAINews *> *)allNewsFromData:(NSData *)data;
+ (SUAINews *)newsFromData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
