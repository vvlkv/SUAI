//
//  SUAIError.h
//  SUAI
//
//  Created by Виктор on 15/01/2019.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const SUAIErrorDomain;

typedef NS_ENUM(NSInteger, SUAIErrorCode) {
    SUAIErrorParseUnknown = -1,
    SUAIErrorParseFault = 1,
    SUAIErrorNetworkFault,
    SUAIErrorEntityNotAvailable,
    SUAIErrorGlobalFault
};

@interface SUAIError : NSError

+ (instancetype)errorWithCode:(SUAIErrorCode)code userInfo:(nullable NSDictionary<NSErrorUserInfoKey, id> *)dict;

@end

NS_ASSUME_NONNULL_END
