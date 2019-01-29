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

@interface SUAIScheduleTests : XCTestCase {
    SUAIScheduleProvider *provider;
}

@end

@implementation SUAIScheduleTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [super setUp];
    provider = [[SUAI instance] schedule];
    [provider loadCodes];
//    NSUInteger i = 0;
//    while (i < 1000000000000) {
//        i++;
//    }
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testEntityScheduleWrongEntity {
//    [[SUAI instance].schedule loadScheduleFor:@"asfdasf" ofType:Group success:^(SUAISchedule *schedule) {
//        NSLog(@"success");
//    } fail:^(SUAIError *error) {
//        NSLog(@"%@", error);
//    }];
}

- (void)testEntityEquals {
    __block SUAISchedule *obj1 = nil;
    __block SUAISchedule *obj2 = nil;

    XCTestExpectation *load1Exp = [self expectationWithDescription:@"load1"];
    XCTestExpectation *load2Exp = [self expectationWithDescription:@"load2"];
    NSLog(@"%@", provider);
    [provider loadScheduleFor:@"1435" ofType:Group success:^(SUAISchedule *schedule) {
        obj1 = schedule;
        [load1Exp fulfill];
    } fail:^(__kindof SUAIError *error) {
        NSLog(@"fail 1");
        XCTAssert("fail loading 1");
    }];
    [provider loadScheduleFor:@"1435" ofType:Group success:^(SUAISchedule *schedule) {
        obj2 = schedule;
        [load2Exp fulfill];
    } fail:^(__kindof SUAIError *error) {
        NSLog(@"fail 2");
        XCTAssert("fail loading 2");
    }];
    [self waitForExpectations:@[load1Exp, load2Exp] timeout:5.0];
    
    XCTAssertNil(obj1, "obj1 is nil");
    XCTAssertNil(obj2, "obj2 is nil");
    if ([obj2 isEqual:nil])
        XCTAssert("obj2 is nil");
}

@end
