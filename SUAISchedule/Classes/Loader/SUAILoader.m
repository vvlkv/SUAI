//
//  VVLoader.m
//  SUAIParser
//
//  Created by Виктор on 05/07/2018.
//  Copyright © 2018 Victor. All rights reserved.
//

#import "SUAILoader.h"
#import "Links.h"
#import "SUAIEntity.h"

@implementation SUAILoader

+ (void)loadCodesWithSuccess:(void (^) (NSArray<NSData *> *data))success
                        fail:(void (^) (NSString *fail))fail {
    
    NSMutableArray<NSData *> *codes = [NSMutableArray arrayWithCapacity:2];
    let sessionUrl = [NSURL URLWithString:sessionLink];
    let semesterUrl = [NSURL URLWithString:semesterLink];
    
    let group = dispatch_group_create();
    let queue = dispatch_queue_create("codes load", DISPATCH_QUEUE_CONCURRENT);
    
    __weak typeof(codes) weakCodes = codes;
    
    dispatch_group_async(group, queue, ^{
        dispatch_group_enter(group);
        [SUAILoader performRequestWithUrl:sessionUrl inQueue:queue success:^(NSData *data) {
            weakCodes[0] = data;
            dispatch_group_leave(group);
        } fail:^(NSString *description) {
            dispatch_group_leave(group);
        }];
    });
    dispatch_group_async(group, queue, ^{
        dispatch_group_enter(group);
        [SUAILoader performRequestWithUrl:semesterUrl inQueue:queue success:^(NSData *data) {
            weakCodes[1] = data;
            dispatch_group_leave(group);
        } fail:^(NSString *description) {
            dispatch_group_leave(group);
        }];
    });
    dispatch_group_notify(group, queue, ^{
        //Обработка запроса
        dispatch_async(dispatch_get_main_queue(), ^{
            success(codes);
        });
    });
}

+ (void)loadScheduleOfType:(Schedule)scheduleType
                    entity:(Entity)entityType
                  entityId:(NSString *)identificator
                   success:(void (^) (NSData *data))success
                      fail:(void (^) (NSString *fail))fail {
    
    NSMutableString *url = [[NSMutableString alloc] init];
    
    if (scheduleType == Session) {
        [url appendString:sessionLink];
    } else {
        [url appendString:semesterLink];
    }
    
    switch (entityType) {
        case Group:
            [url appendFormat:@"/?g=%@", identificator];
            break;
        case Teacher:
            [url appendFormat:@"/?p=%@", identificator];
            break;
        case Auditory:
            [url appendFormat:@"/?r=%@", identificator];
        default:
            break;
    }
    [SUAILoader performRequestWithUrl:[NSURL URLWithString:url]
                              success:success
                                 fail:fail];
}

+ (void)loadScheduleOfType:(Schedule)scheduleType
                       for:(SUAIEntity *)entity
                   success:(void (^) (NSData *data))success
                      fail:(void (^) (NSString *fail))fail {
    
    NSMutableString *url = [[NSMutableString alloc] init];
    NSString *identificator = nil;
    
    if (scheduleType == Session) {
        [url appendString:sessionLink];
        identificator = [entity sessionCode];
    } else {
        [url appendString:semesterLink];
        identificator = [entity semesterCode];
    }
    
    if (identificator == nil) {
        success(nil);
        return;
    }
    
    switch ([entity type]) {
            case Group:
            [url appendFormat:@"/?g=%@", identificator];
            break;
            case Teacher:
            [url appendFormat:@"/?p=%@", identificator];
            break;
            case Auditory:
            [url appendFormat:@"/?r=%@", identificator];
        default:
            break;
    }
    [SUAILoader performRequestWithUrl:[NSURL URLWithString:url]
                              success:success
                                 fail:fail];
}

+ (void)performRequestWithUrl:(NSURL *)url
                      inQueue:(dispatch_queue_t)queue
                      success:(void (^) (NSData *data))success
                         fail:(void (^) (NSString *description))fail {
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request
                                        completionHandler:^(NSData * _Nullable data,
                                                            NSURLResponse * _Nullable response,
                                                            NSError * _Nullable error) {
                                            dispatch_async(queue, ^{
                                                if (data != nil) {
                                                    success(data);
                                                } else {
                                                    fail(error.localizedDescription);
                                                }
                                            });
                                        }];
    [task resume];
}

+ (void)performRequestWithUrl:(NSURL *)url
                      success:(void (^) (NSData *data))success
                         fail:(void (^) (NSString *description))fail {
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request
                                        completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data != nil) {
                success(data);
            } else {
                fail(error.localizedDescription);
            }
        });
    }];
    [task resume];
}

@end
