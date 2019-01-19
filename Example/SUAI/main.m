//
//  main.m
//  SUAISchedule
//
//  Created by vvlkv on 08/09/2018.
//  Copyright (c) 2018 vvlkv. All rights reserved.
//

@import UIKit;
#import "SUAIAppDelegate.h"
#import "SUAITestsAppDelegate.h"

int main(int argc, char * argv[])
{
    @autoreleasepool {
        Class appDelegateClass = (NSClassFromString(@"CXTestCase") ? [SUAITestsAppDelegate class] : [SUAIAppDelegate class]);
        return UIApplicationMain(argc, argv, nil, NSStringFromClass(appDelegateClass));
    }
}
