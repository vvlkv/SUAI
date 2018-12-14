//
//  SUAIAppDelegate.m
//  SUAISchedule
//
//  Created by vvlkv on 08/09/2018.
//  Copyright (c) 2018 vvlkv. All rights reserved.
//

#import "SUAIAppDelegate.h"
#import "SUAIEntityViewController.h"
#import "SUAINewsProvider.h"

@implementation SUAIAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    SUAIEntityViewController *startViewController = [[SUAIEntityViewController alloc] init];
    _window.rootViewController = [[UINavigationController alloc] initWithRootViewController:startViewController];
    _window.backgroundColor = [UIColor whiteColor];
    [_window makeKeyAndVisible];
    SUAINewsProvider *news = [[SUAINewsProvider alloc] init];
    [news loadAllNews:^(NSArray<SUAINews *> * _Nonnull news) {
        
    } fail:^(NSString * _Nonnull fail) {
        
    }];
    return YES;
}

@end
