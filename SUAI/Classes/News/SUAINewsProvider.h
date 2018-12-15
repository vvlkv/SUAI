//
//  SUAINewsProvider.h
//  SUAI
//
//  Created by Виктор on 14/12/2018.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class SUAINews;
@interface SUAINewsProvider : NSObject

- (void)loadAllNews:(void (^) (NSArray<SUAINews *>* news))success
               fail:(void (^) (NSString *fail))fail;

@end

NS_ASSUME_NONNULL_END
