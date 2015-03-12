//
//  MHScreenshotsScrollView.h
//  MHScreenshotsScrollViewDemo
//
//  Created by Martin Hartl on 18/12/13.
//  Copyright (c) 2013 Martin Hartl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHAlbumView.h"

@class MHScreenshotsScrollView;

@protocol MHScreenshotsScrollViewDataSource <NSObject>

- (NSInteger)numberOfPictureInScreenshotsScrollView:(MHScreenshotsScrollView *)screenshotsScrollView;
- (BOOL)shouldOpenGallryViewInScreenshotsScrollView:(MHScreenshotsScrollView *)screenshotsScrollView;

@optional

- (UIImage *)imageForIndex:(NSInteger)index inScreenshotsScrollView:(MHScreenshotsScrollView *)screenshotsScrollView;

@end

@interface MHScreenshotsScrollView : UIView

@property (nonatomic, weak) id<MHScreenshotsScrollViewDataSource> dataSource;
@property (nonatomic, strong) UIColor *pageIndicatorTintColor;
@property (nonatomic, strong) UIColor *currentPageIndicatorTintColor;

- (MHAlbumView *)albumViewForIndex:(NSUInteger)index;

@end
