//
//  MTSearchMusicViewController.m
//  Mentio
//
//  Created by Martin Hartl on 21/10/13.
//  Copyright (c) 2013 Martin Hartl. All rights reserved.
//

#import "MTSearchMusicViewControllerDelegate.h"
#import "MTItunesClient.h"
#import "UIAlertView+MTHelpers.h"
#import "MusicAlbum.h"

static NSString *const MTMusicDetailSegueIdentifier = @"showMusicDetail";

@interface MTSearchMusicViewControllerDelegate ()

@end

@implementation MTSearchMusicViewControllerDelegate


#pragma mark - MTSearchViewControllerDelegate


- (NSString *)detailSegueIdentifier {
    return MTMusicDetailSegueIdentifier;
}

- (NSString *)emptyStatePromtString {
    return NSLocalizedString(@"mtsearchmusicviewcontroller.searchsomething", @"search something");
}

- (NSString *)emptyStateNoDataFoundString {
    return NSLocalizedString(@"mtsearchmusicviewcontroller.nomusicfound", @"no app found");
}

- (NSString *)mediaEntityToSearch {
    return MTItunesMediaEntityAlbum;
}

- (NSString *)mediaTypeToSearch {
    return MTItunesMediaTypeMusic;
}

- (FCModel<MTModelProtocol> *)newOwnMediaModel {
    MusicAlbum *newAlbum = [MusicAlbum new];
    newAlbum.ownMedia = YES;
    return newAlbum;
}




@end
