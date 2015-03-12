//
//  MTSearchDetailViewController.m
//  Mentio
//
//  Created by Martin Hartl on 11/10/13.
//  Copyright (c) 2013 Martin Hartl. All rights reserved.


#import "MTMusicDetailViewControllerDelegate.h"
#import "MTItunesClient.h"
#import "MHAlbumView.h"
#import "MusicTrack.h"
#import "MTMusicDetailSongCell.h"
#import "MHSimpleTableList.h"
#import "MTSharedDateFormatter.h"
#import "UIAlertView+MTHelpers.h"
#import "UIFont+CustomFontsContentSizes.h"
#import <SZTextView/SZTextView.h>

@interface MTMusicDetailViewControllerDelegate () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) MHSimpleTableList *infoTable;
@property (strong, nonatomic) SZTextView *notesTextView;

@property (strong, nonatomic) NSArray *albumTitles;
@property (strong, nonatomic) MusicAlbum *detailMusicModel;

@end

@implementation MTMusicDetailViewControllerDelegate

- (instancetype)initWithDetailMusicModel:(MusicAlbum *)musicAlbum {
    self = [super init];
    if (self) {
        _detailMusicModel = musicAlbum;
        [self setup];
    }
    return self;
}


- (void)setUpInfoTable {
    
    NSString *priceString = [NSString stringWithFormat:@"%@ %@", self.detailMusicModel.collectionPrice, self.detailMusicModel.currency];
    
    if (!self.detailMusicModel.collectionPrice) {
        priceString = NSLocalizedString(@"Not available", @"Not available");
    }
    
    self.infoTable = [[MHSimpleTableList alloc] init];
    
    [self.infoTable addRowWithDescriptor:NSLocalizedString(@"Artist:", @"artist") value:self.detailMusicModel.artistName];
    [self.infoTable addRowWithDescriptor:NSLocalizedString(@"Title:", @"Album Name") value:self.detailMusicModel.collectionName];
    [self.infoTable addRowWithDescriptor:NSLocalizedString(@"Price:", @"Price") value:priceString];
    [self.infoTable addRowWithDescriptor:NSLocalizedString(@"Release Date:", @"ReleaseDate") value:[[MTSharedDateFormatter sharedInstace] configuredFormatStringFromDate:self.detailMusicModel.releaseDate]];
    
}


- (void)setup {
    
    self.tableView = [[UITableView alloc] init];
    [self.tableView registerClass:[MTMusicDetailSongCell class] forCellReuseIdentifier:@"TitleCell"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 32;
    
    [self setUpInfoTable];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    
    [self handleTrackLoading];
    
    self.notesTextView = [SZTextView new];
    self.notesTextView.placeholder = NSLocalizedString(@"mtdetailviewcontrollerdelegates.segmentedview.notes.placeholer", @"add some notes");
    self.notesTextView.delegate = self;
    
    self.notesTextView.text = self.detailMusicModel.notes;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFonts:) name:UIContentSizeCategoryDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setAppearance) name:MTThemeChangedNotification object:nil];
    [self updateFonts:nil];
    
    [self setAppearance];

}

- (void)setAppearance {
    self.tableView.indicatorStyle = (UIScrollViewIndicatorStyle) [MHFancyPants integerForKey:@"scrollIndicatorStyle"];
    self.notesTextView.indicatorStyle = (UIScrollViewIndicatorStyle) [MHFancyPants integerForKey:@"scrollIndicatorStyle"];
    
    self.notesTextView.backgroundColor = [UIColor clearColor];
    self.notesTextView.textColor = [MHFancyPants colorForKey:@"headingTextColor"];
    self.notesTextView.placeholderTextColor = [MHFancyPants colorForKey:@"bodyTextColor"];
    self.notesTextView.keyboardAppearance = [MHFancyPants integerForKey:@"keyboardAppearance"];
}


- (void)handleTrackLoading {
    self.albumTitles = [MusicTrack instancesWhere:@"collectionId = ? ORDER BY trackNumber", [NSString stringWithFormat:@"%lu",(unsigned long)self.detailMusicModel.collectionId]];
    
    if (!self.albumTitles || (self.albumTitles.count == 0)) {
        
        __weak MTMusicDetailViewControllerDelegate *weakSelf = self;
        
        [[MTItunesClient sharedClient] lookupMediaWithType:MTItunesMediaTypeMusic entitiy:MTItunesMediaEntitySong byId:self.detailMusicModel.collectionId completion:^(NSArray *results, NSError *error) {
            
            if (error) {
                [UIAlertView showNoInternetWarning];
            } else {
                weakSelf.albumTitles = results;
                if ([weakSelf.detailMusicModel existsInDatabase]) {
                    for (MusicTrack *track in weakSelf.albumTitles) {
                        track.collectionId = weakSelf.detailMusicModel.collectionId;
                        [track save];
                    }
                }
                [weakSelf.tableView reloadData];
            }
        }];
    } else {
        [self.tableView reloadData];
    }
}


#pragma mark - TableViewDelegate and DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.albumTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TitleCell";
    
    MTMusicDetailSongCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [self configureCell:cell forRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)configureCell:(MTMusicDetailSongCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    MusicTrack *music = self.albumTitles[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [MHFancyPants colorForKey:@"headingTextColor"];
    cell.textLabel.text = [NSString stringWithFormat:@"%lu: %@", (unsigned long)music.trackNumber, music.trackName];
    cell.textLabel.font = [UIFont preferredAvenirFontForTextStyle:UIFontTextStyleBody];
}

#pragma mark - MTSegementedViewDelegate

- (UIView *)viewForSegmentIndex:(NSInteger)index inSegmentedView:(MHSegmentedView *)segmentedView {
    switch (index) {
        case 0:
            return self.tableView;
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
            return NSLocalizedString(@"Songs", @"Songs");
            break;
        case 1:
            return NSLocalizedString(@"Info", @"Info");
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

#pragma mark - MTDetailViewControllerDelegate

- (NSURL *)largeCoverImageURL {
    NSString *modUrlString = self.detailMusicModel.artworkUrl100;
    modUrlString = [modUrlString stringByReplacingOccurrencesOfString:@"225x225-75.jpg" withString:@"450x450-75.jpg"];
    NSURL *url = [NSURL URLWithString:modUrlString];
    return url;
}

#pragma mark - dealloc

- (void)dealloc {
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.detailMusicModel.notes = self.notesTextView.text;
}

#pragma mark - Dynamic Type

- (void)updateFonts:(NSNotification *)notification {
    [self.tableView reloadData];
    self.infoTable.labelFont = [UIFont preferredAvenirFontForTextStyle:UIFontTextStyleBody];
    self.notesTextView.font = [UIFont preferredAvenirFontForTextStyle:UIFontTextStyleBody];
}


@end
