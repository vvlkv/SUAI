//
//  SUAILoader+News.h
//  SUAI
//
//  Created by Виктор on 14/12/2018.
//

#import "SUAILoader.h"

NS_ASSUME_NONNULL_BEGIN

@interface SUAILoader (News)

+ (void)loadAllNewsWithSuccess:(void (^) (NSData *data))success
                       fail:(void (^) (SUAINetworkError *fail))fail;

+ (void)loadImages:(NSArray<NSString *> *)imagesUrl
           success:(void (^) (NSArray<UIImage *> *images))success
              fail:(void (^) (SUAINetworkError *fail))fail;

+ (void)loadNews:(NSString *)newsID
         success:(void (^) (NSData *data))success
            fail:(void (^) (SUAINetworkError *fail))fail;


@end

NS_ASSUME_NONNULL_END
