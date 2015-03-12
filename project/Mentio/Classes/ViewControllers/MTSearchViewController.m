//
//  MTSearchViewController.m
//  Mentio
//
//  Created by Martin Hartl on 05/10/13.
//  Copyright (c) 2013 Martin Hartl. All rights reserved.
//


#import "MTSearchViewController.h"
#import "FCModel.h"
#import "MTModelProtocol.h"
#import "UIImageView+AFNetworking.h"
#import "MTDetailViewController.h"
#import "MTStatusCell.h"
#import "App.h"
#import "MTScrollCell.h"
#import "MTImageCacher.h"
#import "UISearchBar+AlwaysEnableCancelButton.h"
#import "MHAlbumView+RoundCorners.h"
#import "MTItunesClient.h"
#import "UIAlertView+MTHelpers.h"
#import "MTDetailViewController.h"
#import "MTMusicDetailViewControllerDelegate.h"
#import "MTOwnMediaViewController.h"
#import "MTSegueConstants.h"
#import "MTStatusBarConstants.h"

@interface MTSearchViewController () <UISearchDisplayDelegate, UISearchBarDelegate, MTScrollCellDelegate>

@property (weak, nonatomic) MTStatusCell *statusCell;

@property (nonatomic, weak) NSTimer *searchDelayTimer;

@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *edgePanGestureRecognizer;

@end

@implementation MTSearchViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.ibTableView registerNib:[UINib nibWithNibName:@"MTScrollCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Cell"];
    
    [self.ibTableView setContentInset:UIEdgeInsetsMake(24, 0, 0, 0)];
    [self.ibSearchBar becomeFirstResponder];
    self.ibSearchBar.delegate = self;
    
    self.ibTableView.backgroundColor = [MHFancyPants colorForKey:@"backgroundColor"];
    self.ibTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.ibTableView.rowHeight = 90;
    [self.ibTableView setShowsHorizontalScrollIndicator:NO];
    [self.ibTableView setShowsVerticalScrollIndicator:NO];
    
    [[MTThemer sharedInstance] themeMTSearchViewController:self];
    
    self.edgePanGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(dismissViewController)];
    self.edgePanGestureRecognizer.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:self.edgePanGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MTShowStatusBarView object:nil];
    
    self.navigationController.view.tintColor = [MHFancyPants colorForKey:@"tintColor"];
    self.view.tintColor = [MHFancyPants colorForKey:@"tintColor"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchResults == nil || self.searchResults.count == 0) {
        return 1;
    }
    
    return  self.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.searchResults == nil) {
        static NSString *CellIdentifier = @"StatusCell";
        MTStatusCell *cell = [self.ibTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        [[MTThemer sharedInstance] themeMTStatusCell:cell];
        self.statusCell = cell;
        [cell showSearchPromtWithText:[self.delegate emptyStatePromtString]];
        return cell;
    } else if (self.searchResults.count == 0) {
        static NSString *CellIdentifier = @"StatusCell";
        MTStatusCell *cell = [self.ibTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        [[MTThemer sharedInstance] themeMTStatusCell:cell];
        self.statusCell = cell;
        NSString *formatString = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"mtsearchviewcontroller.add",@"add"),self.ibSearchBar.text];
        [cell showNoDataFoundWithText:[NSString stringWithString:formatString]];
        return cell;
    }
    
    static NSString *CellIdentifier = @"Cell";
    MTScrollCell *cell = [self.ibTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [self tableView:tableView configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView configureCell:(MTScrollCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    id<MTModelProtocol> model = (id<MTModelProtocol>)self.searchResults[indexPath.row];
    
    cell.scrollCellAccessoryType = MTScrollCellAccessoryDetailDisclosureButton;
    cell.disclouseIndicatorTappable = YES;
    
    NSString *priceString = [NSString stringWithFormat:@"%@ %@", model.protPrice, model.protCurrency];
    
    if ([model.protPrice isEqualToNumber:@0]) {
        priceString = NSLocalizedString(@"Free", @"free");
    }
    
    if (!model.protPrice) {
        priceString = @"";
    }
    
    cell.priceLabel.text = priceString;
    
    cell.collectionNameLabel.text = model.protTitle;
    cell.artistNameLabel.text = model.protArtistName;
    
    [cell.albumView cancelImageRequestOperation];
    cell.albumView.image = nil;
    
    NSString *filename = [NSString stringWithFormat:@"%lu",(unsigned long)model.protItemId];
    
    cell.scrollDelegate = self;
    
    [[MTImageCacher sharedInstance] loadImageNamed:filename type:MTImageCacheTypeForTemporarilyUsage completion:^(UIImage *image) {
        if (image) {
            cell.albumView.image = image;
        } else {
            //success
            [cell.albumView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:model.protArtworkUrl]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *downloadedImage) {
                //success
                [[MTImageCacher sharedInstance] saveImage:downloadedImage name:filename type:MTImageCacheTypeForTemporarilyUsage];
                
                cell.albumView.image = downloadedImage;
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                //failure
            }];
        }
    }];
    
//    cell.rightUtilityButtons = nil;
    [cell layoutIfNeeded];
    
    [[MTThemer sharedInstance] themeMTScrollCell:cell];
    cell.disclousureIndicatorImageView.tintColor = self.view.tintColor;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger countInt = self.searchResults.count;
    
    if (countInt == 0) {
        [self performSegueWithIdentifier:MTShowOwnMediaSegueIdentifier sender:self];
        return;
    }
    
    if (countInt > indexPath.row) {
        FCModel<MTModelProtocol> *model  = (FCModel<MTModelProtocol> *)self.searchResults[indexPath.row];
        [model save];
        
        UIViewController *parent = self.presentingViewController;
        [self dismissViewControllerAnimated:YES completion:^{
            [parent dismissViewControllerAnimated:YES completion:nil];
        }];
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    NSInteger countInt = self.searchResults.count;
    if (countInt > indexPath.row) {
        [self performSegueWithIdentifier:MTShowDetailSegueIdentifier sender:indexPath];
    }
    
}

#pragma mark - ScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.ibTableView && [self.ibSearchBar isFirstResponder]) {
        [self.ibSearchBar resignFirstResponder];
        [self.ibSearchBar enableCancelButton];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar enableCancelButton];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void )searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.statusCell showLoading];
    [self.ibTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    [self handleSearchButtonPressedIn:searchBar];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (self.searchDelayTimer) {
        if (self.searchDelayTimer.isValid) {
            [self.searchDelayTimer invalidate];
        }
        self.searchDelayTimer = nil;
    }
    
    self.searchDelayTimer = [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(searchAfterTimerFired) userInfo:nil repeats:NO];
}

#pragma mark - SearchBar Handling

- (void)handleSearchButtonPressedIn:(UISearchBar *)searchBar {
    [self searchResultsFromSearchBar:searchBar resignFirstResponder:YES];
}

- (void)handleSearchBarSearchQueryDidChange:(UISearchBar *)searchBar {
    [self searchResultsFromSearchBar:searchBar resignFirstResponder:NO];
}

- (void)searchResultsFromSearchBar:(UISearchBar *)searchBar resignFirstResponder:(BOOL)hideKeyboard {
    __weak MTSearchViewController *weakself = self;
    
    
    NSString *mediaType = [self.delegate mediaTypeToSearch];
    NSString *mediaEntity = [self.delegate mediaEntityToSearch];
    
    
    [[[MTItunesClient sharedClient] operationQueue] cancelAllOperations];
    
    [[MTItunesClient sharedClient] searchMediaWithType:mediaType entity:mediaEntity keyword:searchBar.text limit:25 completion:^(NSArray *results, NSError *error) {
        
        if (error) {
            if (hideKeyboard) {
                [UIAlertView showNoInternetWarning];
            }
        } else {
            weakself.searchResults = results;
        }
        
        [weakself.ibTableView reloadData];
        [searchBar enableCancelButton];
        if (hideKeyboard) {
            [searchBar resignFirstResponder];
        }
    }];
}


#pragma mark - MTScrollCellDelgate

- (void)accessoryButtonTappedForScrollCell:(MTScrollCell *)cell {
    NSIndexPath *indexPath = [self.ibTableView indexPathForCell:cell];
    [self.ibTableView.delegate tableView:self.ibTableView accessoryButtonTappedForRowWithIndexPath:indexPath];
}

#pragma mark - Helper

- (void)searchAfterTimerFired {
    [self.statusCell showLoading];
    [self handleSearchBarSearchQueryDidChange:self.ibSearchBar];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:MTShowDetailSegueIdentifier]) {
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        
        FCModel<MTModelProtocol> *selectedModel = [self.searchResults objectAtIndex:indexPath.row];
        MTDetailViewController *searchDetail = (MTDetailViewController *)segue.destinationViewController;
        searchDetail.detailModel = selectedModel;
        searchDetail.fromSearchViewController = YES;
    } else if ([segue.identifier isEqualToString:MTShowOwnMediaSegueIdentifier]) {
        MTOwnMediaViewController *viewController = (MTOwnMediaViewController *)segue.destinationViewController;
        viewController.detailModel = [self.delegate newOwnMediaModel];
        [viewController.detailModel setProtTitle:self.ibSearchBar.text];
        viewController.fromSearchViewController = YES;
    }
}

#pragma mark - UIScreenEdgePanGestureRecognizerAction
                                                                                                                   
- (void)dismissViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}
                                                                                                                   
#pragma mark - dealloc

- (void)dealloc {
    self.ibSearchBar.delegate = nil;
    self.ibTableView.delegate = nil;
    self.ibTableView.dataSource = nil;
}

@end
