//
//  VVLoader.h
//  SUAIParser
//
//  Created by Виктор on 05/07/2018.
//  Copyright © 2018 Victor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enums.h"

@class SUAINetworkError;

@interface SUAILoader : NSObject

+ (void)loadCodesWithSuccess:(void (^) (NSArray<NSData *> *data))success
                        fail:(void (^) (SUAINetworkError *error))error;

+ (void)loadSchedulesWithSemesterCode:(NSString *)semCode
                          sessionCode:(NSString *)sesCode
                           entityType:(EntityType)type
                              success:(void (^) (NSArray<NSData *> *data))success
                                 fail:(void (^) (SUAINetworkError *error))error;

+ (void)performRequestWithUrl:(NSURL *)url
                      success:(void (^) (NSData *data))success
                         fail:(void (^) (SUAINetworkError *error))error;

@end

