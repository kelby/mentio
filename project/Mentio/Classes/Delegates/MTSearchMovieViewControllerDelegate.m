//
//  MTSearchMovieViewController.m
//  Mentio
//
//  Created by Martin Hartl on 24/10/13.
//  Copyright (c) 2013 Martin Hartl. All rights reserved.
//

#import "MTSearchMovieViewControllerDelegate.h"
#import "MTItunesClient.h"
#import "UIAlertView+MTHelpers.h"
#import "Movie.h"

static NSString *const MTMovieDetailSegueIdentifier = @"showMovieDetail";

@interface MTSearchMovieViewControllerDelegate ()

@end

@implementation MTSearchMovieViewControllerDelegate


#pragma mark - MTSearchViewControllerDelegate 

- (NSString *)detailSegueIdentifier {
    return MTMovieDetailSegueIdentifier;
}

- (NSString *)emptyStatePromtString {
    return NSLocalizedString(@"mtsearchmovieviewcontroller.searchsomething", @"search something");
}

- (NSString *)emptyStateNoDataFoundString {
    return NSLocalizedString(@"mtsearchmovieviewcontroller.nomoviefound", @"no app found");
}

- (NSString *)mediaTypeToSearch {
    return MTItunesMediaTypeMusic;
}

- (NSString *)mediaEntityToSearch {
    return MTItunesMediaEntityMovie;
}

- (FCModel<MTModelProtocol> *)newOwnMediaModel {
    Movie *newMovie = [Movie new];
    newMovie.ownMedia = YES;
    return newMovie;
}

@end
