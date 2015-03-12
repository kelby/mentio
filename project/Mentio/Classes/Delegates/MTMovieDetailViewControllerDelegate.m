//
//  MTMovieDetailViewController.m
//  Mentio
//
//  Created by Martin Hartl on 26/10/13.
//  Copyright (c) 2013 Martin Hartl. All rights reserved.
//

#import "MTMovieDetailViewControllerDelegate.h"
#import "MHAlbumView.h"
#import "Movie.h"
#import "MHSimpleTableList.h"
#import "MTSharedDateFormatter.h"
#import "MTItunesClient.h"
#import "UIFont+CustomFontsContentSizes.h"
#import "UIAlertView+MTHelpers.h"
#import <SZTextView/SZTextView.h>

@interface MTMovieDetailViewControllerDelegate () <UITextViewDelegate>

@property (strong, nonatomic) UITextView *descriptionTextView;
@property (strong, nonatomic) MHSimpleTableList *infoTable;
@property (strong, nonatomic) SZTextView *notesTextView;

@property (nonatomic, strong) Movie *detailMovieModel;

@end

@implementation MTMovieDetailViewControllerDelegate

- (instancetype)initWithMovieModel:(Movie *)movieModel {
    self = [super init];
    if (self) {
        _detailMovieModel = movieModel;
        [self setup];
    }
    return self;
    
}

- (void)setUpView {
    [self setupInfoTable];

    self.descriptionTextView.text = self.detailMovieModel.longDescription;
    
    self.notesTextView = [SZTextView new];
    self.notesTextView.placeholder = NSLocalizedString(@"mtdetailviewcontrollerdelegates.segmentedview.notes.placeholer", @"add some notes");
    self.notesTextView.delegate = self;
    self.notesTextView.text = self.detailMovieModel.notes;
}

- (void)setupInfoTable {
    NSString *priceString = [NSString stringWithFormat:@"%@ %@", self.detailMovieModel.collectionPrice, self.detailMovieModel.currency];
    if (!self.detailMovieModel.collectionPrice) {
        priceString = NSLocalizedString(@"Not available", @"Not available");
    }
    
    self.infoTable = [[MHSimpleTableList alloc] init];
    
    [self.infoTable addRowWithDescriptor:NSLocalizedString(@"Director:", @"director") value:self.detailMovieModel.artistName];
    [self.infoTable addRowWithDescriptor:NSLocalizedString(@"Title:", @"Album Name") value:self.detailMovieModel.title];
    [self.infoTable addRowWithDescriptor:NSLocalizedString(@"Price:", @"Price") value:priceString];
    [self.infoTable addRowWithDescriptor:NSLocalizedString(@"Release Date:", @"ReleaseDate") value:[[MTSharedDateFormatter sharedInstace] configuredFormatStringFromDate:self.detailMovieModel.releaseDate]];
    
}

- (void)setup {
    self.descriptionTextView = [[UITextView alloc] init];
    self.descriptionTextView.font = [self.descriptionTextView.font fontWithSize:22];
    self.descriptionTextView.editable = NO;
    
    
    [self setUpView];
    [self setAppearance];
    [self updateFonts:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFonts:) name:UIContentSizeCategoryDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setAppearance) name:MTThemeChangedNotification object:nil];
}


- (void)setAppearance {
    
    self.descriptionTextView.backgroundColor = [UIColor clearColor];
    self.descriptionTextView.textColor = [MHFancyPants colorForKey:@"headingTextColor"];
    self.descriptionTextView.indicatorStyle = [MHFancyPants integerForKey:@"scrollIndicatorStyle"];
    self.notesTextView.indicatorStyle = (UIScrollViewIndicatorStyle) [MHFancyPants integerForKey:@"scrollIndicatorStyle"];
    
    self.notesTextView.backgroundColor = [UIColor clearColor];
    self.notesTextView.textColor = [MHFancyPants colorForKey:@"headingTextColor"];
    self.notesTextView.placeholderTextColor = [MHFancyPants colorForKey:@"bodyTextColor"];
    self.notesTextView.keyboardAppearance = [MHFancyPants integerForKey:@"keyboardAppearance"];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - MTSegementedViewDelegate

- (UIView *)viewForSegmentIndex:(NSInteger)index inSegmentedView:(MHSegmentedView *)segmentedView {
    
    switch (index) {
        case 0:
            return self.descriptionTextView;
            break;
        case 1:
            return self.infoTable;
            break;
        case 2:
            return self.notesTextView;
            break;
        default:
            return nil;
            break;
    }
}

- (NSInteger)numberOfSegmentsInSegmentedView:(MHSegmentedView *)segmentedView {
    return 3;
}

- (NSString *)titleForSegmentAtIndex:(NSInteger)index inSegmentedView:(MHSegmentedView *)segmentedView {
    switch (index) {
        case 0:
            return NSLocalizedString(@"Description", @"Description:");
            break;
        case 1:
            return NSLocalizedString(@"Info", @"Info:");
            break;
        case 2:
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

#pragma mark - Dynamic Type

- (void)updateFonts:(NSNotification *)aNotification {
    self.descriptionTextView.font = [UIFont preferredAvenirFontForTextStyle:UIFontTextStyleBody];
    self.notesTextView.font = [UIFont preferredAvenirFontForTextStyle:UIFontTextStyleBody];
    self.infoTable.labelFont = [UIFont preferredAvenirFontForTextStyle:UIFontTextStyleBody];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.detailMovieModel.notes = self.notesTextView.text;
}

#pragma mark - MTDetailViewControllerDelegate

- (NSURL *)largeCoverImageURL {
    NSString *modUrlString = self.detailMovieModel.artworkUrl100;
    modUrlString = [modUrlString stringByReplacingOccurrencesOfString:@"200x200-75.jpg" withString:@"600x600-75.jpg"];
    NSURL *url = [NSURL URLWithString:modUrlString];
    return url;
}


@end
