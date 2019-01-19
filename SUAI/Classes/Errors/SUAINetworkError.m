//
//  SUAINetworkError.m
//  SUAI
//
//  Created by Виктор on 15/01/2019.
//

#import "SUAINetworkError.h"

NSString *const SUAINetworkErrorDomain = @"SUAINetworkErrorDomain";

@implementation SUAINetworkError

+ (instancetype)errorWithCode:(NSInteger)code userInfo:(NSDictionary<NSErrorUserInfoKey,id> *)dict {
    return [SUAINetworkError errorWithDomain:SUAINetworkErrorDomain code:code userInfo:dict];
}

@end
