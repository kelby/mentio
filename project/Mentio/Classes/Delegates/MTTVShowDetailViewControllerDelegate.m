//
//  MTTVShowDetailViewController.m
//  Mentio
//
//  Created by Martin Hartl on 09/02/14.
//  Copyright (c) 2014 Martin Hartl. All rights reserved.
//

#import "MTTVShowDetailViewControllerDelegate.h"
#import "TVSeason.h"
#import "TVEpisode.h"
#import "MHSegmentedView.h"
#import "MTItunesClient.h"
#import "MHSimpleTableList.h"
#import "UIAlertView+MTHelpers.h"
#import "MTMusicDetailSongCell.h"
#import "MTSharedDateFormatter.h"
#import <SZTextView/SZTextView.h>

@interface MTTVShowDetailViewControllerDelegate () <MHSegmentedViewDelegate, UITableViewDataSource, UITableViewDelegate, MTDetailViewControllerDelegate, UITextViewDelegate>

@property (weak, nonatomic) TVSeason *detailTVSeasonModel;
@property (strong, nonatomic) UITextView *descriptionTextView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) MHSimpleTableList *infoTable;
@property (strong, nonatomic) SZTextView *notesTextView;


@property (strong, nonatomic) NSArray *episodes;

@end

@implementation MTTVShowDetailViewControllerDelegate

- (instancetype)initWithTVSeasonMode:(TVSeason *)seasonModel {
    self = [super init];
    if (self) {
        _detailTVSeasonModel = seasonModel;
        [self setup];
    }
    return self;
}

- (void)setUpView {
    [self setupInfoTable];
    self.descriptionTextView = [[UITextView alloc] init];

    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[self.detailTVSeasonModel.seasonDescription dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    self.descriptionTextView.attributedText = attributedString;
    
    self.tableView = [[UITableView alloc] init];
    [self.tableView registerClass:[MTMusicDetailSongCell class] forCellReuseIdentifier:@"TitleCell"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 32;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.notesTextView = [SZTextView new];
    self.notesTextView.placeholder = NSLocalizedString(@"mtdetailviewcontrollerdelegates.segmentedview.notes.placeholer", @"add some notes");
    self.notesTextView.delegate = self;
    self.notesTextView.text = self.detailTVSeasonModel.notes;
}

- (void)setupInfoTable {
    NSString *priceString = [NSString stringWithFormat:@"%@ %@", self.detailTVSeasonModel.collectionPrice, self.detailTVSeasonModel.currency];
    if (!self.detailTVSeasonModel.collectionPrice) {
        priceString = NSLocalizedString(@"Not available", @"Not available");
    }
    
    self.infoTable = [[MHSimpleTableList alloc] init];
    
    [self.infoTable addRowWithDescriptor:NSLocalizedString(@"Show:", @"show") value:self.detailTVSeasonModel.artistName];
    [self.infoTable addRowWithDescriptor:NSLocalizedString(@"Title:", @"Album Name") value:self.detailTVSeasonModel.collectionName];
    [self.infoTable addRowWithDescriptor:NSLocalizedString(@"Price:", @"Price") value:priceString];
    [self.infoTable addRowWithDescriptor:NSLocalizedString(@"Release Date:", @"ReleaseDate") value:[[MTSharedDateFormatter sharedInstace] configuredFormatStringFromDate:self.detailTVSeasonModel.releaseDate]];
    [self.infoTable addRowWithDescriptor:NSLocalizedString(@"Copyright:", @"Copyright:") value:self.detailTVSeasonModel.copyright];
}

- (void)setup {
    [self setUpView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFonts:) name:UIContentSizeCategoryDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setAppearance) name:MTThemeChangedNotification object:nil];
    [self updateFonts:nil];
    
    [self handleEpisodeLoading];
    [self setAppearance];
}

- (void)setAppearance {
    self.descriptionTextView.backgroundColor = [UIColor clearColor];
    self.descriptionTextView.textColor = [MHFancyPants colorForKey:@"headingTextColor"];
    self.descriptionTextView.indicatorStyle = (UIScrollViewIndicatorStyle) [MHFancyPants integerForKey:@"scrollIndicatorStyle"];
    self.tableView.indicatorStyle = (UIScrollViewIndicatorStyle) [MHFancyPants integerForKey:@"scrollIndicatorStyle"];
    
    self.notesTextView.indicatorStyle = (UIScrollViewIndicatorStyle) [MHFancyPants integerForKey:@"scrollIndicatorStyle"];
    self.notesTextView.backgroundColor = [UIColor clearColor];
    self.notesTextView.keyboardAppearance = [MHFancyPants integerForKey:@"keyboardAppearance"];
}

- (void)handleEpisodeLoading {
    self.episodes = [TVEpisode instancesWhere:@"collectionId = ? ORDER BY trackNumber", [NSString stringWithFormat:@"%lu",(unsigned long)self.detailTVSeasonModel.collectionId]];
    
    if (!self.episodes || (self.episodes.count == 0)) {
        
        [[MTItunesClient sharedClient] lookupMediaWithType:MTItunesMediaTypeTVShow entitiy:MTItunesMediaEntityTVEpisode byId:self.detailTVSeasonModel.collectionId completion:^(NSArray *results, NSError *error) {
            
            if (error) {
                [UIAlertView showNoInternetWarning];
            } else {
                self.episodes = results;
                if ([self.detailTVSeasonModel existsInDatabase]) {
                    for (TVEpisode *episode in self.episodes) {
                        episode.collectionId = self.detailTVSeasonModel.collectionId;
                        [episode save];
                    }
                }
                [self.tableView reloadData];
            }
        }];
    } else {
        [self.tableView reloadData];
    }
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - TableViewDelegate and DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.episodes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TitleCell";
    
    MTMusicDetailSongCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [self configureCell:cell forRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)configureCell:(MTMusicDetailSongCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    TVEpisode *episode = self.episodes[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [MHFancyPants colorForKey:@"headingTextColor"];
    cell.textLabel.text = [NSString stringWithFormat:@"%lu: %@", (unsigned long)episode.trackNumber, episode.trackName];
    cell.textLabel.font = [UIFont preferredAvenirFontForTextStyle:UIFontTextStyleBody];
}


#pragma mark - SegmentedViewDelegate

- (NSInteger)numberOfSegmentsInSegmentedView:(MHSegmentedView *)segmentedView {
    return 4;
}

- (NSString *)titleForSegmentAtIndex:(NSInteger)index inSegmentedView:(MHSegmentedView *)segmentedView {
    switch (index) {
        case 0:
            return NSLocalizedString(@"Description", @"Description:");
            break;
        case 1:
            return NSLocalizedString(@"Episodes", @"Episodes");
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

- (UIView *)viewForSegmentIndex:(NSInteger)index inSegmentedView:(MHSegmentedView *)segmentedView {
    switch (index) {
        case 0:
            return self.descriptionTextView;
            break;
        case 1:
            return self.tableView;
            break;
        case 2:
            return self.infoTable;
            break;
        case 3:
            return self.notesTextView;
            break;
        default:
            break;
    }
    return self.descriptionTextView;
}

- (void)segmentedView:(MHSegmentedView *)segmentedView didSelectSegmentAtIndex:(NSInteger)index {
    [self.notesTextView resignFirstResponder];
}

#pragma mark - MTDetailViewControllerDelegate

- (NSURL *)largeCoverImageURL {
    NSString *modUrlString = self.detailTVSeasonModel.artworkUrl100;
    modUrlString = [modUrlString stringByReplacingOccurrencesOfString:@"225x225-75.jpg" withString:@"450x450-75.jpg"];
    NSURL *url = [NSURL URLWithString:modUrlString];
    return url;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.detailTVSeasonModel.notes = self.notesTextView.text;
}

#pragma mark - Dynamic Type

- (void)updateFonts:(NSNotification *)aNotification {
    self.descriptionTextView.font = [UIFont preferredAvenirFontForTextStyle:UIFontTextStyleBody];
    self.notesTextView.font = [UIFont preferredAvenirFontForTextStyle:UIFontTextStyleBody];
    self.infoTable.labelFont = [UIFont preferredAvenirFontForTextStyle:UIFontTextStyleBody];    
}

@end
