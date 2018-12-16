//
//  SUAINewsProvider.m
//  SUAI
//
//  Created by Виктор on 14/12/2018.
//

#import "SUAINewsProvider.h"
#import "SUAILoader+News.h"
#import "SUAIParser+News.h"
#import "SUAINews.h"

@implementation SUAINewsProvider

- (void)loadAllNews:(void (^) (NSArray<SUAINews *> *news))success
               fail:(void (^) (NSString *fail))fail {
    [SUAILoader loadAllNewsWithSuccess:^(NSData * _Nonnull data) {
        NSArray<SUAINews *> *news = [SUAIParser allNewsFromData:data];
        NSMutableArray *imgUrls = [NSMutableArray arrayWithCapacity:[news count]];
        NSMutableArray *images = [NSMutableArray arrayWithCapacity:[news count]];
        for (SUAINews *newsModel in news) {
            [imgUrls addObject:newsModel.imageSource];
            [images addObject:newsModel.image];
        }
        
        [SUAILoader loadImages:imgUrls success:^(NSArray<UIImage *> * _Nonnull images) {
            for (int i = 0; i < [news count]; i++) {
                (news[i]).image = images[i];
            }
            success(news);
        } fail:^(NSString * _Nonnull fail) {
        }];
    } fail:^(NSString * _Nonnull fail) {
        NSLog(@"ERROR");
    }];
}

- (void)loadNews:(NSString *)newsID
         success:(void (^) (SUAINews *news))success
            fail:(void (^) (NSString *fail))fail {
    [SUAILoader loadNews:newsID success:^(NSData * _Nonnull data) {
        [SUAIParser newsFromData:data];
    } fail:^(NSString * _Nonnull fail) {
        
    }];
}

@end
