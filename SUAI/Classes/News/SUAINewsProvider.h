//
//  SUAINewsProvider.h
//  SUAI
//
//  Created by Виктор on 14/12/2018.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class SUAINews;
@class SUAIError;
@interface SUAINewsProvider : NSObject

- (void)loadAllNews:(void (^) (NSArray<SUAINews *>* news))success
               fail:(void (^) (SUAIError *err))error;

- (void)loadNews:(NSString *)newsID
         success:(void (^) (SUAINews *news))success
            fail:(void (^) (SUAIError *err))error;

@end

NS_ASSUME_NONNULL_END
