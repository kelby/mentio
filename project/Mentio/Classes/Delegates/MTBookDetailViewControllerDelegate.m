//
//  MTBookDetailViewController.m
//  Mentio
//
//  Created by Martin Hartl on 08/02/14.
//  Copyright (c) 2014 Martin Hartl. All rights reserved.
//

#import "MTBookDetailViewControllerDelegate.h"
#import "MHSegmentedView.h"
#import "MHSimpleTableList.h"
#import "MTSharedDateFormatter.h"
#import <SZTextView/SZTextView.h>

@interface MTBookDetailViewControllerDelegate () <MHSegmentedViewDelegate, MTDetailViewControllerDelegate, UITextViewDelegate>

@property (strong, nonatomic) UITextView *descriptionTextView;
@property (strong, nonatomic) MHSimpleTableList *infoTable;
@property (strong, nonatomic) SZTextView *notesTextView;
@property (weak, nonatomic) Book *detailBookModel;

@end

@implementation MTBookDetailViewControllerDelegate

- (instancetype)initWIthBookModel:(Book *)bookModel {
    self = [super init];
    if (self) {
        _detailBookModel = bookModel;
        [self setup];
    }
    return self;
}

- (void)setUpView {
    [self setupInfoTable];
    
    self.descriptionTextView = [[UITextView alloc] init];
    self.descriptionTextView.editable = NO;
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[self.detailBookModel.bookDescription dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    self.descriptionTextView.attributedText = attributedString;
    
    self.notesTextView = [SZTextView new];
    self.notesTextView.placeholder = NSLocalizedString(@"mtdetailviewcontrollerdelegates.segmentedview.notes.placeholer", @"add some notes");
    self.notesTextView.delegate = self;
    self.notesTextView.text = self.detailBookModel.notes;
    

}

- (void)setupInfoTable {
    NSString *priceString = [NSString stringWithFormat:@"%@ %@", self.detailBookModel.price, self.detailBookModel.currency];
    if (!self.detailBookModel.price) {
        priceString = NSLocalizedString(@"Not available", @"Not available");
    }
    
    
    self.infoTable = [[MHSimpleTableList alloc] init];
    
    [self.infoTable addRowWithDescriptor:NSLocalizedString(@"Author:", @"author") value:self.detailBookModel.artistName];
    [self.infoTable addRowWithDescriptor:NSLocalizedString(@"Title:", @"Album Name") value:self.detailBookModel.title];
    [self.infoTable addRowWithDescriptor:NSLocalizedString(@"Price:", @"Price") value:priceString];
    [self.infoTable addRowWithDescriptor:NSLocalizedString(@"Release Date:", @"ReleaseDate") value:[[MTSharedDateFormatter sharedInstace] configuredFormatStringFromDate:self.detailBookModel.releaseDate]];
}

- (void)setup {
    [self setUpView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFonts:) name:UIContentSizeCategoryDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setAppearance) name:MTThemeChangedNotification object:nil];
    [self updateFonts:nil];
    [self setAppearance];
}

- (void)setAppearance {
    self.descriptionTextView.backgroundColor = [UIColor clearColor];
    self.notesTextView.backgroundColor = [UIColor clearColor];
    
    self.descriptionTextView.textColor = [MHFancyPants colorForKey:@"headingTextColor"];
    self.descriptionTextView.indicatorStyle = (UIScrollViewIndicatorStyle) [MHFancyPants integerForKey:@"scrollIndicatorStyle"];
    
    self.notesTextView.indicatorStyle = (UIScrollViewIndicatorStyle) [MHFancyPants integerForKey:@"scrollIndicatorStyle"];
    
    self.notesTextView.keyboardAppearance = [MHFancyPants integerForKey:@"keyboardAppearance"];
}



#pragma mark - MTSegementedViewDelegate

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

- (void)segmentedView:(MHSegmentedView *)segmentedView didSelectSegmentAtIndex:(NSInteger)index {
    [self.notesTextView resignFirstResponder];
}

#pragma mark - MTDetailViewControllerDelegate

- (NSURL *)largeCoverImageURL {
    NSString *modUrlString = self.detailBookModel.artworkUrl100;
    modUrlString = [modUrlString stringByReplacingOccurrencesOfString:@"225x225-75.jpg" withString:@"450x450-75.jpg"];
    NSURL *url = [NSURL URLWithString:modUrlString];
    return url;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.detailBookModel.notes = self.notesTextView.text;
}

#pragma mark - Dynamic Type

- (void)updateFonts:(NSNotification *)aNotification {
    self.descriptionTextView.font = [UIFont preferredAvenirFontForTextStyle:UIFontTextStyleBody];
    self.notesTextView.font = [UIFont preferredAvenirFontForTextStyle:UIFontTextStyleBody];
    self.infoTable.labelFont = [UIFont preferredAvenirFontForTextStyle:UIFontTextStyleBody];
}

@end
