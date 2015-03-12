//
//  MHAlbumViewTests.m
//  Mentio
//
//  Created by Martin Hartl on 23/04/14.
//  Copyright (c) 2014 Martin Hartl. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MHAlbumView.h"

@interface MHAlbumView (Private)


@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;
- (void)fireBlock;

@end

@interface MHAlbumViewTests : XCTestCase

@property (nonatomic, strong) MHAlbumView *albumView;

@end

@implementation MHAlbumViewTests

- (void)setUp
{
    [super setUp];
    self.albumView = [[MHAlbumView alloc] init];
}

- (void)tearDown
{
    [super tearDown];
    self.albumView = nil;
}

- (void)testSpinngByNil {
    XCTAssertNil(self.albumView.image, @"Image is not nil");
    XCTAssertTrue([self.albumView.activityIndicatorView isAnimating], @"Activity indicator is not spinning");
    XCTAssertFalse(self.albumView.hidden, @"AlbumView is hidden");
}

- (void)testStartSpinningAfterImageGotNil {
    self.albumView.image = [UIImage imageNamed:@"list"];
    self.albumView.image = nil;
    XCTAssertNil(self.albumView.image, @"Image is not nil");
    XCTAssertTrue([self.albumView.activityIndicatorView isAnimating], @"Activity indicator is not spinning");
    XCTAssertFalse(self.albumView.hidden, @"AlbumView is hidden");
}

- (void)testStopSpinningAfterImageIsSet {
    self.albumView.image = [UIImage imageNamed:@"list"];
    XCTAssertNotNil(self.albumView.image, @"image is nil");
    XCTAssertFalse([self.albumView.activityIndicatorView isAnimating], @"Activity indicator is spinnig");
    XCTAssertTrue(self.albumView.activityIndicatorView.hidden, @"Acitivty indicator is not hidden");
}

- (void)testFiringTheActionBlock {
    self.albumView.image = [UIImage imageNamed:@"list"];
    __block BOOL actionBlockDidFire = NO;
    
    [self.albumView setTapInsideActionBlock:^(UIImage *image, UITapGestureRecognizer *gestureRecognizer) {
        actionBlockDidFire = YES;
    }];
    
    XCTAssertNotNil(self.albumView.tapInsideActionBlock, @"Tap inside action block is nil");
    
    [self.albumView fireBlock];
    
    XCTAssertTrue(actionBlockDidFire, @"Action block did not fire");
}

@end
