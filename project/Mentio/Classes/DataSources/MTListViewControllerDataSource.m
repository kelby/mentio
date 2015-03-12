//
//  MTListViewControllerDataSource.m
//  Mentio
//
//  Created by Martin Hartl on 25/10/13.
//  Copyright (c) 2013 Martin Hartl. All rights reserved.
//

#import "MTListViewControllerDataSource.h"
#import "MTStatusCell.h"
#import "FCModel.h"
#import "MTImageCacher.h"
#import "MTModelProtocol.h"
#import "MTImageCacher.h"
#import <AFNetworking/UIKit+AFNetworking.h>
#import "App.h"
#import "MHAlbumView+RoundCorners.h"

@interface MTListViewControllerDataSource ()

@property (nonatomic, weak) MTIndexPathMutableDictionary *dict;
@property (nonatomic, copy) ConfigureCellBlock configureCellBlock;
@property (nonatomic, strong) MTThemer *themer;
@property (nonatomic, assign) BOOL archive;

@end

@implementation MTListViewControllerDataSource


- (instancetype)initWithIndexPathMutableDict:(MTIndexPathMutableDictionary *)dict archive:(BOOL)archive {
    self = [super init];
    if (self) {
        self.dict = dict;
        self.archive = archive;
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  [self.dict numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([self.dict nilOrEmptyArrayForSection:section]) {
        return 1;
    }
    
    return [self.dict arrayForIndexPathSection:section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.dict nilOrEmptyArrayForSection:indexPath.section]) {
        static NSString *CellIdentifier = @"StatusCell";
        MTStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        [self.themer themeMTStatusCell:cell];
        
        [cell showIcon:[self mediaImageForSection:indexPath.section]];
        return cell;
    }
    
    
    static NSString *CellIdentifier = @"Cell";
    MTScrollCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [self tableView:tableView configureCell:cell forRowAtIndexPath:indexPath];
    return cell;
}

- (void) tableView:(UITableView *)tableView configureCell:(MTScrollCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    id<MTModelProtocol> model = [self.dict objectAtIndexPath:indexPath];
    
    cell.scrollCellAccessoryType = MTScrollCellAccessoryDisclosureIndicator;
    
    cell.disclousureIndicatorImageView.hidden = tableView.editing;
    
    cell.collectionNameLabel.text = model.protTitle;
    [self.themer themeMTScrollCell:cell];
    cell.artistNameLabel.text = model.protArtistName;
    [cell.albumView cancelImageRequestOperation];
    cell.albumView.image = nil;
    cell.albumView.contentMode = UIViewContentModeScaleAspectFit;
    
    
    NSString *priceString = [NSString stringWithFormat:@"%@ %@", model.protPrice, model.protCurrency];
    
    if ([model.protPrice isEqualToNumber:@0]) {
        priceString = NSLocalizedString(@"Free", @"free");
    }
    
    if (!model.protPrice) {
        priceString = @"";
    }
    
    cell.priceLabel.text = priceString;
    
    //if model to represent is own entry
    if (model.ownMedia) {
        UIImage *image = [[self mediaImageForSection:indexPath.section] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        cell.albumView.image = image;
        cell.albumView.contentMode = UIViewContentModeCenter;
    }
    
    [[MTImageCacher sharedInstance] loadImageNamed:model.protIconFileName type:MTImageCacheTypeForPersistentUsage completion:^(UIImage *image) {
        if (image) {
            cell.albumView.image = image;
        } else {
            [cell.albumView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:model.protArtworkUrl]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image2) {
                //success
                cell.albumView.image = image2;
                [[MTImageCacher sharedInstance] saveImage:image2 name:model.protIconFileName type:MTImageCacheTypeForPersistentUsage];
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                //failure
            }];
        }
        [cell.albumView applyRoundCorners:[model isKindOfClass:[App class]]];
    }];
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return NSLocalizedString(@"mtlistviewcontroller.categorie.music", @"Music");
            break;
        case 1:
            return NSLocalizedString(@"mtlistviewcontroller.categorie.movies", @"Movie");
            break;
        case 2:
            return NSLocalizedString(@"mtlistviewcontroller.categorie.apps", @"App");
            break;
        case 3:
            return NSLocalizedString(@"mtlistviewcontroller.categorie.books", @"Book");
            break;
        case 4:
            return NSLocalizedString(@"mtlistviewcontroller.categorie.tvshows", @"App");
            break;
        default:
            return nil;
            break;
    }
    
    
    return nil;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.dict nilOrEmptyArrayForSection:indexPath.section]) {
        return NO;
    }
    
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    NSMutableArray *sectionArray = [self.dict arrayForIndexPathSection:sourceIndexPath.section];
    
    id moveObject = sectionArray[sourceIndexPath.row];
    [sectionArray removeObjectAtIndex:sourceIndexPath.row];
    [sectionArray insertObject:moveObject atIndex:destinationIndexPath.row];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.dict nilOrEmptyArrayForSection:indexPath.section]) {
        return NO;
    }
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self tableView:tableView deleteRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView deleteRowAtIndexPath:(NSIndexPath *)indexPath {
    FCModel <MTModelProtocol> *model = [self.dict objectAtIndexPath:indexPath];
    [[MTImageCacher sharedInstance] deleteImageNamed:model.protIconFileName type:MTImageCacheTypeForPersistentUsage];
    
    [model delete];
    [self.dict reloadArrayForSection:indexPath.section archived:self.archive];
    
    [tableView beginUpdates];
    
    if ([self.dict nilOrEmptyArrayForSection:indexPath.section]) {
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
        return;
    }
    
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [tableView endUpdates];
    
}

#pragma mark - Helper

- (void)tableView:(UITableView *)tableView archiveOrUnarchive:(BOOL)archive rowAtIndexPath:(NSIndexPath *)indexPath {
    
    FCModel <MTModelProtocol> *model = [self.dict objectAtIndexPath:indexPath];
    
    model.archived = archive;
    [model save];
    
    [self.dict reloadArrayForSection:indexPath.section archived: self.archive];
    
    [tableView beginUpdates];
    
    if ([self.dict nilOrEmptyArrayForSection:indexPath.section]) {
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
        return;
    }
    
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [tableView endUpdates];
    
}

- (UIImage *)mediaImageForSection:(NSInteger)section {
    UIImage *image;
    switch (section) {
        case MTSectionTypeMusic:
            image = [UIImage imageNamed:@"music"];
            break;
        case MTSectionTypeMovie:
            image =[UIImage imageNamed:@"movie"];
            break;
        case MTSectionTypeApp:
            image = [UIImage imageNamed:@"app"];
            break;
        case MTSectionTypeBook:
            image = [UIImage imageNamed:@"book"];
            break;
        case MTSectionTypeTVShow:
            image = [UIImage imageNamed:@"tv"];
            break;
        default:
            break;
    }
    
    return image;
}

#pragma mark - Database save

- (void)saveSectionToDatabase:(NSInteger)section {
    [self.dict updateArrayOrderForSection:section];
}

#pragma mark - Setter/Getter

- (MTThemer *)themer {
    if (!_themer) {
        _themer = [[MTThemer alloc] init];
    }
    return _themer;
}



@end
