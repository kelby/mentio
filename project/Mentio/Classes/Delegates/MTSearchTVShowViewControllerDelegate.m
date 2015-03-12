//
//  MTSearchTVShowViewController.m
//  Mentio
//
//  Created by Martin Hartl on 09/02/14.
//  Copyright (c) 2014 Martin Hartl. All rights reserved.
//

#import "MTSearchTVShowViewControllerDelegate.h"
#import "MTItunesClient.h"
#import "UIAlertView+MTHelpers.h"
#import "TVSeason.h"

static NSString *const MTTVShowDetailSegueIdentifier = @"showTVShowDetail";

@interface MTSearchTVShowViewControllerDelegate ()

@end

@implementation MTSearchTVShowViewControllerDelegate


#pragma mark - MTSearchViewControllerDelegate


- (NSString *)detailSegueIdentifier {
    return MTTVShowDetailSegueIdentifier;
}

- (NSString *)emptyStatePromtString {
    return NSLocalizedString(@"mtsearchtvshowviewcontroller.searchsomething", @"search something");
}

- (NSString *)emptyStateNoDataFoundString {
    return NSLocalizedString(@"mtsearchtvshowviewcontroller.notvshowfound", @"no app found");
}

- (NSString *)mediaTypeToSearch {
    return MTItunesMediaTypeTVShow;
}

- (NSString *)mediaEntityToSearch {
    return MTItunesMediaEntityTVSeason;
}

- (FCModel<MTModelProtocol> *)newOwnMediaModel {
    TVSeason *newSeason = [TVSeason new];
    newSeason.ownMedia = YES;
    return newSeason;
}

@end
