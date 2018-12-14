//
//  SUAINewsProvider.m
//  SUAI
//
//  Created by Виктор on 14/12/2018.
//

#import "SUAINewsProvider.h"
#import "SUAILoader+News.h"
#import "SUAIParser+News.h"

@implementation SUAINewsProvider

- (void)loadAllNews:(void (^) (NSArray<SUAINews *> *news))success
               fail:(void (^) (NSString *fail))fail {
    [SUAILoader loadAllNewsWithSuccess:^(NSData * _Nonnull data) {
        NSLog(@"OK");
        NSArray const *news = [SUAIParser allNewsFromData:data];
    } fail:^(NSString * _Nonnull fail) {
        NSLog(@"ERROR");
    }];
}

@end
