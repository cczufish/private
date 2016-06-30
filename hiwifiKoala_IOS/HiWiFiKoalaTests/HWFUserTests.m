//
//  HWFUserTests.m
//  HiWiFiKoala
//
//  Created by dp on 14-9-21.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "HWFService+User.h"

@interface HWFUserTests : XCTestCase

@end

@implementation HWFUserTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

//- (void)testExample {
//    // This is an example of a functional test case.
//    XCTAssert(YES, @"Pass");
//}
//
//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

- (void)testLogin {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Login"];
    
    [[HWFService defaultService] loginWithIdentity:@"栖风" password:@"123!@#" completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        [expectation fulfill];
        XCTAssertEqual(code, CODE_SUCCESS);
    }];
    
    [self waitForExpectationsWithTimeout:REQUEST_TIMEOUT_INTERVAL handler:^(NSError *error) {
        
    }];
}

@end
