//
//  MTAppDetailViewController.m
//  Mentio
//
//  Created by Martin Hartl on 17/12/13.
//  Copyright (c) 2013 Martin Hartl. All rights reserved.
//

#import "MTAppDetailViewControllerDelegate.h"
#import "App.h"
#import "MHAlbumView.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "MHScreenshotsScrollView.h"
#import "MHSimpleTableList.h"
#import "MTSharedDateFormatter.h"
#import "UIFont+CustomFontsContentSizes.h"
#import <URBMediaFocusViewController/URBMediaFocusViewController.h>
#import <SZTextView/SZTextView.h>

@interface MTAppDetailViewControllerDelegate () <MHScreenshotsScrollViewDataSource, MTDetailViewControllerDelegate, UITextViewDelegate>

@property (strong, nonatomic) App *detailAppModel;

@property (strong, nonatomic) MHScreenshotsScrollView *screenshotsScrollView;
@property (strong, nonatomic) MHSimpleTableList *infoTable;
@property (strong, nonatomic) UITextView *descriptionTextView;
@property (strong, nonatomic) SZTextView *notesTextView;

@end

@implementation MTAppDetailViewControllerDelegate

- (instancetype)initWithAppModel:(App *)appModel {
    self = [super init];
    if (self) {
        _detailAppModel = appModel;
        [self setup];
    }
    return self;
}

- (void)setUpView {
    self.screenshotsScrollView = [[MHScreenshotsScrollView alloc] init];
    [[MTThemer sharedInstance] themeMHScreenshotsScrollView:self.screenshotsScrollView];

    NSString *priceString = [NSString stringWithFormat:@"%@ %@", self.detailAppModel.price, self.detailAppModel.currency];
    
    if ([self.detailAppModel.price isEqualToNumber:@0]) {
        priceString = NSLocalizedString(@"Free", @"free");
    }
    
    if (!self.detailAppModel.price) {
        priceString = NSLocalizedString(@"Not available", @"Not available");
    }
    
    self.infoTable = [[MHSimpleTableList alloc] init];
    
    [self.infoTable addRowWithDescriptor:NSLocalizedString(@"Title:", @"Title:") value:self.detailAppModel.trackName];
    [self.infoTable addRowWithDescriptor:NSLocalizedString(@"Developer:", @"Developer:") value:self.detailAppModel.artistName];
    [self.infoTable addRowWithDescriptor:NSLocalizedString(@"Price:", @"Price") value:priceString];
    
    
    self.descriptionTextView = [[UITextView alloc] init];
    self.descriptionTextView.editable = NO;
    self.descriptionTextView.text = self.detailAppModel.appDescription;
    
    self.notesTextView = [SZTextView new];
    self.notesTextView.placeholder = NSLocalizedString(@"mtdetailviewcontrollerdelegates.segmentedview.notes.placeholer", @"add some notes");
    self.notesTextView.delegate = self;
    
    self.notesTextView.text = self.detailAppModel.notes;
}

- (void)setup {
    [self setUpView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFonts:) name:UIContentSizeCategoryDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setAppearance) name:MTThemeChangedNotification object:nil];
    
    
    [self setAppearance];
    [self updateFonts:nil];
}

- (void)loadScreenshots {
    
    if (self.screenshotsScrollView.dataSource == nil) {
        self.screenshotsScrollView.dataSource = self;
    }
    
    [self.detailAppModel.screenshotsURLs enumerateObjectsUsingBlock:^(NSURL *obj, NSUInteger idx, BOOL *stop) {
        [[self.screenshotsScrollView albumViewForIndex:idx] setImageWithURL:obj] ;
        self.screenshotsScrollView.currentPageIndicatorTintColor = [MHFancyPants colorForKey:@"tintColor"];
        self.screenshotsScrollView.pageIndicatorTintColor = [MHFancyPants colorForKey:@"headingTextColor"];
    }];
}

- (void)setAppearance {
    self.descriptionTextView.backgroundColor = [UIColor clearColor];
    self.descriptionTextView.textColor = [MHFancyPants colorForKey:@"headingTextColor"];
    self.descriptionTextView.indicatorStyle = (UIScrollViewIndicatorStyle) [MHFancyPants integerForKey:@"scrollIndicatorStyle"];
    self.notesTextView.indicatorStyle = (UIScrollViewIndicatorStyle) [MHFancyPants integerForKey:@"scrollIndicatorStyle"];
    
    
    self.notesTextView.backgroundColor = [UIColor clearColor];
    self.notesTextView.keyboardAppearance = [MHFancyPants integerForKey:@"keyboardAppearance"];
    
}


#pragma mark - MTSegementedViewDelegate

- (UIView *)viewForSegmentIndex:(NSInteger)index inSegmentedView:(MHSegmentedView *)segmentedView {
    
    switch (index) {
        case 0:
            return self.screenshotsScrollView;
            break;
        case 1:
            return self.descriptionTextView;
            break;
        case 2:
            return self.infoTable;
            break;
        case 3:
            return self.notesTextView;
            break;
        default:
            return nil;
            break;
    }
}

- (NSInteger)numberOfSegmentsInSegmentedView:(MHSegmentedView *)segmentedView {
    return 4;
}

- (NSString *)titleForSegmentAtIndex:(NSInteger)index inSegmentedView:(MHSegmentedView *)segmentedView {
    switch (index) {
        case 0:
            return NSLocalizedString(@"Screenshots", @"Screenshots:");
            break;
        case 1:
            return NSLocalizedString(@"Description", @"Description");
            break;
        case 2:
            return NSLocalizedString(@"Info", @"Info");
            break;
        case 3:
            return NSLocalizedString(@"mtdetailviewcontrollerdelegates.segmentedview.notes", @"notes");
            break;
        default:
            return nil;
            break;
    }
}

- (void)segmentedView:(MHSegmentedView *)segmentedView didSelectSegmentAtIndex:(NSInteger)index {
    [self.notesTextView resignFirstResponder];
}

#pragma mark - MHScreenshotsScrollViewDelegate

- (NSInteger)numberOfPictureInScreenshotsScrollView:(MHScreenshotsScrollView *)screenshotsScrollView {
    return [self.detailAppModel screenshotsURLs].count;
}

- (BOOL)shouldOpenGallryViewInScreenshotsScrollView:(MHScreenshotsScrollView *)screenshotsScrollView {
    return YES;
}

#pragma mark - DetailViewControllerDelegate

- (NSURL *)largeCoverImageURL {
    NSString *modUrlString = self.detailAppModel.artworkUrl100;
    modUrlString = [modUrlString stringByReplacingOccurrencesOfString:@"200x200-75.png" withString:@"png"];
    NSURL *url = [NSURL URLWithString:modUrlString];
    return url;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.detailAppModel.notes = self.notesTextView.text;
}


#pragma mark - Dynamic Type

- (void)updateFonts:(NSNotification *)aNotification {
    self.descriptionTextView.font = [UIFont preferredAvenirFontForTextStyle:UIFontTextStyleBody];
    self.notesTextView.font = [UIFont preferredAvenirFontForTextStyle:UIFontTextStyleBody];
    self.infoTable.labelFont = [UIFont preferredAvenirFontForTextStyle:UIFontTextStyleBody];    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
