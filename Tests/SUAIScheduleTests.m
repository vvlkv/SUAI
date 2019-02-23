//
//  SUAIScheduleTests.m
//  SUAI_Tests
//
//  Created by Виктор on 19/01/2019.
//  Copyright © 2019 vvlkv. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SUAI.h"
#import "SUAISchedule.h"
#import "SUAIEntity.h"

@interface SUAIScheduleTests : XCTestCase {
    SUAIScheduleProvider *provider;
}

@end

@implementation SUAIScheduleTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [super setUp];
    provider = [[SUAI instance] schedule];
}

- (void)testEntityScheduleWrongEntity {
    XCTestExpectation *exp = [self expectationWithDescription:@"load"];
    [provider loadScheduleFor:@"1wdsa" ofType:EntityTypeTeacher success:^(SUAISchedule *schedule) {
        XCTFail("no!");
    } fail:^(__kindof SUAIError *error) {
        NSLog(@"%@", error);
        [exp fulfill];
    }];
    [self waitForExpectations:@[exp] timeout:5.0];
}

- (void)testEntityEquals {
    __block SUAISchedule *obj1 = nil;
    __block SUAISchedule *obj2 = nil;

    XCTestExpectation *load1Exp = [self expectationWithDescription:@"load1"];
    XCTestExpectation *load2Exp = [self expectationWithDescription:@"load2"];
    [provider loadScheduleFor:@"1542" ofType:EntityTypeGroup success:^(SUAISchedule *schedule) {
        obj1 = schedule;
        [load1Exp fulfill];
    } fail:^(__kindof SUAIError *error) {
        XCTFail("fail loading 1");
    }];
    [provider loadScheduleFor:@"1542" ofType:EntityTypeGroup success:^(SUAISchedule *schedule) {
        obj2 = schedule;
        [load2Exp fulfill];
    } fail:^(__kindof SUAIError *error) {
        XCTFail("fail loading 2");
    }];
    [self waitForExpectations:@[load1Exp, load2Exp] timeout:5.0];

    XCTAssertNotNil(obj1, "obj1 is nil");
    XCTAssertNotNil(obj2, "obj2 is nil");
    if (![obj1 isEqual:obj2]) {
        XCTFail("obj1 is not equal obj 2");
    }
}

@end
