//
//  SUAIAppDelegate.m
//  SUAISchedule
//
//  Created by vvlkv on 08/09/2018.
//  Copyright (c) 2018 vvlkv. All rights reserved.
//

#import "SUAIAppDelegate.h"
#import "SUAIAllNewsViewController.h"
#import "SUAIEntityViewController.h"
#import "SUAI.h"
#import "SUAIError.h"

@implementation SUAIAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
    UINavigationController *newsNavVC = [[UINavigationController alloc]
                                           initWithRootViewController:[[SUAIAllNewsViewController alloc] init]];
    UINavigationController *scheduNavVC = [[UINavigationController alloc]
                                           initWithRootViewController:[[SUAIEntityViewController alloc] init]];
    
    UITabBarController *tabBar = [[UITabBarController alloc] init];
    tabBar.viewControllers = @[newsNavVC, scheduNavVC];
    _window.rootViewController = tabBar;
    [_window makeKeyAndVisible];
    [[[SUAI instance] schedule] loadScheduleFor:@"1740М" ofType:Group success:^(SUAISchedule *schedule) {
        NSLog(@"OK");
    } fail:^(__kindof SUAIError *error) {
        NSLog(@"%@", error.localizedDescription);
    }];
    return YES;
}

@end
