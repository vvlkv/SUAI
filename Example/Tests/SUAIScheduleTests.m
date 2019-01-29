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

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testLoadAllGroups {
    __block NSArray<SUAIEntity *> *groups;
    XCTestExpectation *exp = [self expectationWithDescription:@"load"];
    [provider loadCodes:^(NSArray<SUAIEntity *> *g, NSArray<SUAIEntity *> *t, NSArray<SUAIEntity *> *a) {
        groups = g;
        [exp fulfill];
    } fail:^(__kindof SUAIError *error) {
        XCTFail("codes not loaded %@", error);
    }];
    [self waitForExpectations:@[exp] timeout:5.0];
    XCTestExpectation *exp2 = [self expectationWithDescription:@"check sched"];
    exp2.inverted = YES;
    for (SUAIEntity *entity in groups) {
        [provider loadScheduleFor:entity success:^(SUAISchedule *schedule) {
            NSLog(@"%@ OK", [entity name]);
        } fail:^(__kindof SUAIError *error) {
            XCTFail("error!, %@", error);
            [exp2 fulfill];
        }];
    }
    [self waitForExpectations:@[exp2] timeout:120];
}

- (void)testLoadAllTeachers {
    __block NSArray<SUAIEntity *> *teachers;
    XCTestExpectation *exp = [self expectationWithDescription:@"load"];
    [provider loadCodes:^(NSArray<SUAIEntity *> *g, NSArray<SUAIEntity *> *t, NSArray<SUAIEntity *> *a) {
        teachers = t;
        [exp fulfill];
    } fail:^(__kindof SUAIError *error) {
        XCTFail("codes not loaded %@", error);
    }];
    [self waitForExpectations:@[exp] timeout:5.0];
    XCTestExpectation *exp2 = [self expectationWithDescription:@"check sched"];
    exp2.inverted = YES;
    for (SUAIEntity *entity in teachers) {
        [provider loadScheduleFor:entity success:^(SUAISchedule *schedule) {
            NSLog(@"%@ OK", [entity name]);
        } fail:^(__kindof SUAIError *error) {
            NSLog(@"Error: %@, %@", error, [entity name]);
        }];
    }
    [self waitForExpectations:@[exp2] timeout:300];
}

- (void)testLoadAllAuditories {
    __block NSArray<SUAIEntity *> *auditories;
    XCTestExpectation *exp = [self expectationWithDescription:@"load"];
    [provider loadCodes:^(NSArray<SUAIEntity *> *g, NSArray<SUAIEntity *> *t, NSArray<SUAIEntity *> *a) {
        auditories = a;
        [exp fulfill];
    } fail:^(__kindof SUAIError *error) {
        XCTFail("codes not loaded %@", error);
    }];
    [self waitForExpectations:@[exp] timeout:5.0];
    XCTestExpectation *exp2 = [self expectationWithDescription:@"check sched"];
    exp2.inverted = YES;
    for (SUAIEntity *entity in auditories) {
        [provider loadScheduleFor:entity success:^(SUAISchedule *schedule) {
            NSLog(@"%@ OK", [entity name]);
        } fail:^(__kindof SUAIError *error) {
            XCTFail("error!, %@", error);
            [exp2 fulfill];
        }];
    }
    [self waitForExpectations:@[exp2] timeout:120];
}

- (void)testLoadAllEntities {
    
    __block NSArray<NSArray<SUAIEntity *> *> *codes;
    XCTestExpectation *exp = [self expectationWithDescription:@"load"];
    [provider loadCodes:^(NSArray<SUAIEntity *> *g, NSArray<SUAIEntity *> *t, NSArray<SUAIEntity *> *a) {
        codes = @[g, t, a];
        [exp fulfill];
    } fail:^(__kindof SUAIError *error) {
        XCTFail("codes not loaded %@", error);
    }];
    [self waitForExpectations:@[exp] timeout:5.0];
    XCTestExpectation *exp2 = [self expectationWithDescription:@"check sched"];
    for (NSArray *arr in codes) {
        for (SUAIEntity *entity in arr) {
            [provider loadScheduleFor:entity success:^(SUAISchedule *schedule) {
                NSLog(@"%@ OK", [entity name]);
            } fail:^(__kindof SUAIError *error) {
                XCTFail("error!, %@", error);
            }];
        }
    }
    [self waitForExpectations:@[exp2] timeout:300];
    
}

- (void)testEntityScheduleWrongEntity {
    XCTestExpectation *exp = [self expectationWithDescription:@"load"];
    [provider loadScheduleFor:@"1wdsa" ofType:Teacher success:^(SUAISchedule *schedule) {
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
    [provider loadScheduleFor:@"1542" ofType:Group success:^(SUAISchedule *schedule) {
        obj1 = schedule;
        [load1Exp fulfill];
    } fail:^(__kindof SUAIError *error) {
        XCTFail("fail loading 1");
    }];
    [provider loadScheduleFor:@"1542" ofType:Group success:^(SUAISchedule *schedule) {
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
