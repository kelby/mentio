//
//  MTItunesClientTests.m
//  Mentio
//
//  Created by Martin Hartl on 29/04/14.
//  Copyright (c) 2014 Martin Hartl. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MTItunesClient.h"

@interface MTItunesClientTests : XCTestCase

@property (nonatomic, weak) MTItunesClient *client;

@end

@implementation MTItunesClientTests

- (void)setUp {
    [super setUp];
    self.client = [MTItunesClient sharedClient];
}

- (void)tearDown {

    [super tearDown];
}

- (void)waitForAsynchronousTask {
    CFRunLoopRun();
}

- (void)completeAsynchronousTask {
    CFRunLoopStop(CFRunLoopGetCurrent());
}

- (void)testSearchMediaWithType {
    [self.client searchMediaWithType:MTItunesMediaTypeMusic entity:MTItunesMediaEntityAlbum keyword:@"test" limit:1 completion:^(NSArray *results, NSError *error) {
        
        XCTAssertTrue([results count] == 1, @"count of results array is not 1");
        [self completeAsynchronousTask];
    }];
    
    [self waitForAsynchronousTask];
}

- (void)testLookupMediaWithType {
    [self.client lookupMediaWithType:MTItunesMediaTypeMusic entitiy:MTItunesMediaEntitySong byId:81837427 completion:^(NSArray *results, NSError *error) {
        XCTAssertTrue([results count] != 0, @"Count of results is 0");
        [self completeAsynchronousTask];
    }];
    
    [self waitForAsynchronousTask];
}

@end
