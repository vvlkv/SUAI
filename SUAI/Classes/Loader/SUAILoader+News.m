//
//  SUAILoader+News.m
//  SUAI
//
//  Created by Виктор on 14/12/2018.
//

#import "SUAILoader+News.h"
#import "Links.h"

@implementation SUAILoader (News)

+ (void)loadAllNewsWithSuccess:(void (^) (NSData *data))success
                       fail:(void (^) (NSString *fail))fail {
    NSURL *newsUrl = [NSURL URLWithString:newsLink];
    [SUAILoader performRequestWithUrl:newsUrl success:success fail:fail];
}

+ (void)loadNewsWithID:(NSString *)newsId
               success:(void (^) (NSData *data))success
                  fail:(void (^) (NSString *fail))fail {
    
}


@end
