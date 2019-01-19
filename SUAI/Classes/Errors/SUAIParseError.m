//
//  SUAIParseError.m
//  SUAI
//
//  Created by Виктор on 15/01/2019.
//

#import "SUAIParseError.h"

NSString *const SUAIParseErrorDomain = @"SUAIParseErrorDomain";

@implementation SUAIParseError

+ (instancetype)errorWithCode:(NSInteger)code userInfo:(NSDictionary<NSErrorUserInfoKey,id> *)dict {
    return [SUAIParseError errorWithDomain:SUAIParseErrorDomain code:code userInfo:dict];
}

@end
