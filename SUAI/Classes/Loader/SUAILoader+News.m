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
                       fail:(void (^) (SUAINetworkError *fail))fail {
    NSURL *newsUrl = [NSURL URLWithString:publicationsLink];
    [SUAILoader performRequestWithUrl:newsUrl success:success fail:fail];
}

+ (void)loadImages:(NSArray<NSString *> *)imagesUrl
           success:(void (^) (NSArray<UIImage *> *images))success
              fail:(void (^) (SUAINetworkError *fail))fail {
    
    NSUInteger const imagesCount = [imagesUrl count];
    NSMutableArray *loadedImages = [NSMutableArray arrayWithCapacity:imagesCount];
    
    for (int i = 0; i < imagesCount;i++)
        [loadedImages addObject:[[UIImage alloc] init]];
    
    dispatch_queue_t queue = dispatch_queue_create("load img", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    for (int i = 0; i < imagesCount; i++) {
        dispatch_group_enter(group);
        dispatch_async(queue, ^{
            NSURL *imgUrl = [NSURL URLWithString:imagesUrl[i]];
            NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:[NSURLRequest requestWithURL:imgUrl]
                                                                     completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                                         if (error == nil && data != nil) {
                                                                             UIImage *img = [UIImage imageWithData:data];
                                                                             if (img != nil)
                                                                                 [loadedImages replaceObjectAtIndex:i withObject:[UIImage imageWithData:data]];
                                                                         }
                                                                         dispatch_group_leave(group);
            }];
            [task resume];
        });
    }
    dispatch_group_notify(group, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            success(loadedImages);
        });
    });
}

+ (void)loadNews:(NSString *)newsID
         success:(void (^) (NSData *data))success
            fail:(void (^) (SUAINetworkError *fail))fail {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", newsLink, newsID];
    [SUAILoader performRequestWithUrl:[NSURL URLWithString:urlStr] success:success fail:fail];
}

@end
