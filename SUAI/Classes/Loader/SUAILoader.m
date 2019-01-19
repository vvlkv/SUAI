//
//  VVLoader.m
//  SUAIParser
//
//  Created by Виктор on 05/07/2018.
//  Copyright © 2018 Victor. All rights reserved.
//

#import "SUAILoader.h"
#import "Links.h"
#import "SUAINetworkError.h"

@implementation SUAILoader

+ (void)loadCodesWithSuccess:(void (^) (NSArray<NSData *> *data))success
                        fail:(void (^) (SUAINetworkError *error))error {
    
    NSMutableArray<NSData *> *codes = [NSMutableArray arrayWithObjects:[NSData data], [NSData data], nil];
    NSURL *sessionUrl = [NSURL URLWithString:sessionLink];
    NSURL *semesterUrl = [NSURL URLWithString:semesterLink];
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("codes load", DISPATCH_QUEUE_CONCURRENT);
    
    __weak typeof(codes) weakCodes = codes;
    
    dispatch_group_async(group, queue, ^{
        dispatch_group_enter(group);
        [SUAILoader performRequestWithUrl:sessionUrl inQueue:queue success:^(NSData *data) {
            weakCodes[0] = data;
            dispatch_group_leave(group);
        } fail:^(SUAINetworkError *error) {
            dispatch_group_leave(group);
        }];
    });
    dispatch_group_async(group, queue, ^{
        dispatch_group_enter(group);
        [SUAILoader performRequestWithUrl:semesterUrl inQueue:queue success:^(NSData *data) {
            weakCodes[1] = data;
            dispatch_group_leave(group);
        } fail:^(SUAINetworkError *error) {
            dispatch_group_leave(group);
        }];
    });
    dispatch_group_notify(group, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            success(codes);
        });
    });
}

+ (void)loadScheduleOfType:(Schedule)scheduleType
                    entity:(Entity)entityType
                  entityId:(NSString *)identificator
                   success:(void (^) (NSData *data))success
                      fail:(void (^) (SUAINetworkError *error))error {
    
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
                                 fail:error];
}

+ (void)loadSchedulesWithSemesterCode:(NSString *)semCode
                          sessionCode:(NSString *)sesCode
                           entityType:(Entity)type
                              success:(void (^) (NSArray<NSData *> *data))success
                                 fail:(void (^) (SUAINetworkError *error))error {
    NSMutableString *semesterUrl = [NSMutableString stringWithString:semesterLink];
    NSMutableString *sessionUrl = [NSMutableString stringWithFormat:@"%@", sessionLink];
    
    NSString *placeholder;
    
    switch (type) {
        case Group:
            placeholder = @"/?g=%@";
            break;
        case Teacher:
            placeholder = @"/?p=%@";
            break;
        case Auditory:
            placeholder = @"/?r=%@";
            break;
        default:
            break;
    }
    [semesterUrl appendFormat:placeholder, semCode];
    [sessionUrl appendFormat:placeholder, sesCode];
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("loading schedule", DISPATCH_QUEUE_CONCURRENT);
    
    NSMutableArray<NSData *> *schedules = [NSMutableArray arrayWithObjects:[NSData data], [NSData data], nil];
    dispatch_group_async(group, queue, ^{
        dispatch_group_enter(group);
        [SUAILoader performRequestWithUrl:[NSURL URLWithString:semesterUrl]
                                  inQueue:queue
                                  success:^(NSData *data) {
            schedules[0] = data;
            dispatch_group_leave(group);
        } fail:^(SUAINetworkError *description) {
            error(description);
            dispatch_group_leave(group);
        }];
    });
    dispatch_group_async(group, queue, ^{
        dispatch_group_enter(group);
        [SUAILoader performRequestWithUrl:[NSURL URLWithString:sessionUrl]
                                  inQueue:queue
                                  success:^(NSData *data) {
            schedules[1] = data;
            dispatch_group_leave(group);
        } fail:^(SUAINetworkError *description) {
            error(description);
            dispatch_group_leave(group);
        }];
    });
    dispatch_group_notify(group, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            success(schedules);
        });
    });
}

+ (void)performRequestWithUrl:(NSURL *)url
                      inQueue:(dispatch_queue_t)queue
                      success:(void (^) (NSData *data))success
                         fail:(void (^) (SUAINetworkError *error))error {
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionTask *task = [session dataTaskWithRequest:request
                                        completionHandler:^(NSData * _Nullable data,
                                                            NSURLResponse * _Nullable response,
                                                            NSError * _Nullable hError) {
                                            dispatch_async(queue, ^{
                                                if (hError != nil) {
                                                    SUAINetworkError *err = [SUAINetworkError errorWithCode:SUAIErrorNetworkFault userInfo:@{NSLocalizedDescriptionKey: hError.localizedDescription}];
                                                    error(err);
                                                }
                                                if (data != nil) {
                                                    success(data);
                                                } else {
                                                    SUAINetworkError *err = [SUAINetworkError errorWithCode:SUAIErrorNetworkFault userInfo:@{NSLocalizedDescriptionKey: @"data is nil"}];
                                                    error(err);
                                                }
                                            });
                                        }];
    [task resume];
}

+ (void)performRequestWithUrl:(NSURL *)url
                      success:(void (^) (NSData *data))success
                         fail:(void (^) (SUAINetworkError *error))error {
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request
                                        completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable hError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (hError != nil) {
                SUAINetworkError *err = [SUAINetworkError errorWithCode:SUAIErrorNetworkFault userInfo:@{NSLocalizedDescriptionKey: hError.localizedDescription}];
                error(err);
            }
            if (data != nil) {
                success(data);
            } else {
                SUAINetworkError *err = [SUAINetworkError errorWithCode:SUAIErrorNetworkFault userInfo:@{NSLocalizedDescriptionKey: @"data is nil"}];
                error(err);
            }
        });
    }];
    [task resume];
}

@end
