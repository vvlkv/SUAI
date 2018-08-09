//
//  SUAIViewController.m
//  SUAISchedule
//
//  Created by vvlkv on 08/09/2018.
//  Copyright (c) 2018 vvlkv. All rights reserved.
//

#import "SUAIViewController.h"
#import "SUAISchedule.h"
#import "SUAIManager.h"

@interface SUAIViewController () <SUAIScheduleDelegate>

@end

@implementation SUAIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SUAIManager instance].delegate = self;
}

- (void)didChangeStatus:(Status)status {
    NSLog(@"status is %u", status);
    [[SUAIManager instance] loadScheduleFor:@"1441" ofEntityType:EntityGroup success:^(SUAISchedule *schedule) {
        NSLog(@"%@", schedule);
        NSLog(@"%@", schedule.name);
        NSLog(@"%@", schedule.session);
        NSLog(@"%@", schedule.semester);
    } fail:^(NSString *fail) {
        NSLog(fail);
    }];
}

@end
