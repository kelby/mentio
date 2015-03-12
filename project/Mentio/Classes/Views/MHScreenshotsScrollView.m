//
//  MHScreenshotsScrollView.m
//  MHScreenshotsScrollViewDemo
//
//  Created by Martin Hartl on 18/12/13.
//  Copyright (c) 2013 Martin Hartl. All rights reserved.
//

#import "MHScreenshotsScrollView.h"
#import "MHAlbumView.h"
#import <URBMediaFocusViewController/URBMediaFocusViewController.h>

@interface MHScreenshotsScrollView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *albumViews;
@property (strong, nonatomic) URBMediaFocusViewController *fullScreenView;

@end

@implementation MHScreenshotsScrollView

- (id)init {
    self = [super init];
    if (self) {
        self.pageControl = [[UIPageControl alloc] init];
    }
    return self;
}

- (void)setupWithFrame:(CGRect)frame   {
    
    [self.pageControl setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    
    NSLayoutConstraint *const1 = [NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    
    NSLayoutConstraint *const2 = [NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    
    NSLayoutConstraint *const3 = [NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    
    NSLayoutConstraint *const4 = [NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:20];
    
    self.pageControl.numberOfPages = [self.dataSource numberOfPictureInScreenshotsScrollView:self];
    
    self.pageControl.currentPageIndicatorTintColor = self.currentPageIndicatorTintColor;
    self.pageControl.pageIndicatorTintColor = self.pageIndicatorTintColor;
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width* [self.dataSource numberOfPictureInScreenshotsScrollView:self], frame.size.height)];
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:frame];
    _scrollView.pagingEnabled = YES;
    
    [_scrollView addSubview:_contentView];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    
    _scrollView.contentSize = CGSizeMake(self.frame.size.width* [self.dataSource numberOfPictureInScreenshotsScrollView:self], self.frame.size.height);
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    [self addSubview:self.pageControl];
    
    [self addConstraints:@[const1, const2, const3]];
    [self.pageControl addConstraint:const4];
    
    self.albumViews = [NSMutableArray array];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setupImages {
    [self setupWithFrame:self.bounds];
        
    CGSize selfFrame = self.frame.size;
    
    for (NSInteger i = 0; i < [self.dataSource numberOfPictureInScreenshotsScrollView:self]; i++) {
        MHAlbumView *i1 = [[MHAlbumView alloc] initWithFrame:CGRectMake((selfFrame.width/5)/2 + (selfFrame.width * i), 10, selfFrame.width- selfFrame.width/5, selfFrame.height - 30)];
        i1.contentMode = UIViewContentModeScaleAspectFit;
        
        if ([self.dataSource respondsToSelector:@selector(imageForIndex:inScreenshotsScrollView:)])  {
            [i1 setImage:[self.dataSource imageForIndex:i inScreenshotsScrollView:self]];
        }
        
        if ([self.dataSource shouldOpenGallryViewInScreenshotsScrollView:self]) {
            [i1 setTapInsideActionBlock:^(UIImage *image, UITapGestureRecognizer *tapGestureRecognizer) {
                
                if (!self.fullScreenView) {
                    self.fullScreenView = [[URBMediaFocusViewController alloc] init];
                }
                [self.fullScreenView showImage:image fromView:self];
                self.fullScreenView.shouldDismissOnTap = YES;
                self.fullScreenView.shouldDismissOnImageTap = YES;
                self.fullScreenView.shouldRotateToDeviceOrientation = NO;
            }];
            
        }
        
        [self.contentView addSubview:i1];
        
        [self.albumViews addObject:i1];
    }

}

- (void)setDataSource:(id<MHScreenshotsScrollViewDataSource>)dataSource {
    _dataSource = dataSource;
    [self setupImages];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.pageControl setCurrentPage:(NSInteger)(self.scrollView.contentOffset.x / self.frame.size.width)];
}

#pragma mark - Custom Setters

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {
    self.pageControl.pageIndicatorTintColor = pageIndicatorTintColor;
}

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor {
    self.pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
}

#pragma mark - Getters

- (MHAlbumView *)albumViewForIndex:(NSUInteger)index {
    if (self.albumViews.count < index + 1) {
        return nil;
    }
    return [self.albumViews objectAtIndex:index];
}


@end
