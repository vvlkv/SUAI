//
//  VVLoader.m
//  SUAIParser
//
//  Created by Виктор on 05/07/2018.
//  Copyright © 2018 Victor. All rights reserved.
//

#import "SUAILoader.h"
#import "Links.h"
#import "AFNetworking.h"

@implementation SUAILoader

+ (void)loadGroupsWithType:(Schedule)scheduleType
                success:(void (^) (NSData *data))success
                   fail:(void (^) (NSString *fail))fail {
    NSURL *url = (scheduleType == ScheduleSession) ? [NSURL URLWithString:sessionLink] : [NSURL URLWithString:semesterLink];
    [SUAILoader performRequestWithUrl:url success:success fail:fail];
}

+ (void)loadScheduleOfType:(Schedule)scheduleType
                    entity:(Entity)entityType
                  entityId:(NSString *)identificator
                   success:(void (^) (NSData *data))success
                      fail:(void (^) (NSString *fail))fail {
    
    NSMutableString *url = [[NSMutableString alloc] init];
    
    if (scheduleType == ScheduleSession) {
        [url appendString:sessionLink];
    } else {
        [url appendString:semesterLink];
    }
    
    if (entityType == EntityGroup) {
        [url appendFormat:@"/?g=%@", identificator];
    } else {
        [url appendFormat:@"/?p=%@", identificator];
    }
    [SUAILoader performRequestWithUrl:[NSURL URLWithString:url] success:success fail:fail];
}

+ (void)performRequestWithUrl:(NSURL *)url
                      success:(void (^) (NSData *data))success
                         fail:(void (^) (NSString *fail))fail  {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFCompoundResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"text/html", nil];
    [manager POST:url.absoluteString
       parameters:nil
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              if (success) {
                  success(responseObject);
                  [manager invalidateSessionCancelingTasks:YES];
              }
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              if (fail) {
                  fail(error.localizedDescription);
                  [manager invalidateSessionCancelingTasks:YES];
              }
          }];
}

@end
