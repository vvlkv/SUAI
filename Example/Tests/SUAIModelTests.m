//
//  SUAIModelTests.m
//  SUAI_Tests
//
//  Created by Виктор on 03/02/2019.
//  Copyright © 2019 vvlkv. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SUAI.h"
#import "SUAITime.h"

@interface SUAIModelTests : XCTestCase

@end

@implementation SUAIModelTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testInitTime {
    SUAITime *time1 = [[SUAITime alloc] initWithTimeString:@"1 пара (9:00-10:30)"];
    XCTAssertTrue(time1.hour == 9);
    XCTAssertTrue(time1.minute == 0);
    SUAITime *time2 = [[SUAITime alloc] initWithTimeString:@"Someasdasd (10:40-10:30)"];
    XCTAssertTrue(time2.hour == 10);
    XCTAssertTrue(time2.minute == 40);
    SUAITime *time3 = [[SUAITime alloc] initWithTimeString:@"1 смена (Понедельник)"];
    XCTAssertTrue(time3.hour == 0);
    XCTAssertTrue(time3.minute == 0);
    SUAITime *time4 = [[SUAITime alloc] initWithTimeString:@"(17:30-10:30)"];
    XCTAssertTrue(time4.hour == 17);
    XCTAssertTrue(time4.minute == 30);
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

@end
