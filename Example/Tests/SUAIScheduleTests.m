//
//  SUAIScheduleTests.m
//  SUAI_Tests
//
//  Created by Виктор on 19/01/2019.
//  Copyright © 2019 vvlkv. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SUAI.h"

@interface SUAIScheduleTests : XCTestCase

@end

@implementation SUAIScheduleTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testEntityScheduleWrongEntity {
    [[SUAI instance].schedule loadScheduleFor:@"asfdasf" ofType:Group success:^(SUAISchedule *schedule) {
        NSLog(@"success");
    } fail:^(SUAIError *error) {
        NSLog(@"%@", error);
    }];
}

@end
