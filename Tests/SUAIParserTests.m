//
//  SUAIParserTests.m
//  SUAI_Tests
//
//  Created by Виктор on 19/01/2019.
//  Copyright © 2019 vvlkv. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SUAIParser.h"

@interface SUAIParserTests : XCTestCase

@end

@implementation SUAIParserTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    [super tearDown];
}

- (void)testParserNilData {
    NSDictionary *result = [SUAIParser codesFromData:nil];
    XCTAssertNil(result, @"codesFromData return not nil");
}

- (void)testParserFakeData {
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://habr.com/en/post/258953/"]];
    NSDictionary *result = [SUAIParser codesFromData:data];
    XCTAssertNil(result, @"Returns not nil");
}

@end
