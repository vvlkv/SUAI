//
//  SUAIError.m
//  SUAI
//
//  Created by Виктор on 15/01/2019.
//

#import "SUAIError.h"

NSString *const SUAIErrorDomain = @"SUAIErrorDomain";

@implementation SUAIError

+ (instancetype)errorWithCode:(SUAIErrorCode)code
                     userInfo:(nullable NSDictionary<NSErrorUserInfoKey, id> *)dict {
    return [SUAIError errorWithDomain:SUAIErrorDomain code:code userInfo:dict];
}

@end
