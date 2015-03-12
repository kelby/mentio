//
//  MTDetailViewControllerDelegateFactory.m
//  Mentio
//
//  Created by Martin Hartl on 28/03/14.
//  Copyright (c) 2014 Martin Hartl. All rights reserved.
//

#import "MTDetailViewControllerDelegateFactory.h"
#import "App.h"
#import "Movie.h"
#import "Book.h"
#import "TVSeason.h"
#import "MusicAlbum.h"
#import "MTMusicDetailViewControllerDelegate.h"
#import "MTMovieDetailViewControllerDelegate.h"
#import "MTAppDetailViewControllerDelegate.h"
#import "MTBookDetailViewControllerDelegate.h"
#import "MTTVShowDetailViewControllerDelegate.h"

@implementation MTDetailViewControllerDelegateFactory

+ (id<MHSegmentedViewDelegate, MTDetailViewControllerDelegate>)delegateWithModel:(FCModel<MTModelProtocol> *)model {
    id<MTDetailViewControllerDelegate, MHSegmentedViewDelegate> delegate;
    
    if ([model isKindOfClass:[MusicAlbum class]]) {
        delegate = [[MTMusicDetailViewControllerDelegate alloc] initWithDetailMusicModel:(MusicAlbum *)model];
    } else if ([model isKindOfClass:[Movie class]]) {
        delegate = [[MTMovieDetailViewControllerDelegate alloc] initWithMovieModel:(Movie *)model];
    } else if ([model isKindOfClass:[App class]]) {
        delegate = [[MTAppDetailViewControllerDelegate alloc] initWithAppModel:(App *)model];
    } else if ([model isKindOfClass:[Book class]]) {
        delegate = [[MTBookDetailViewControllerDelegate alloc] initWIthBookModel:(Book *)model];
    } else if ([model isKindOfClass:[TVSeason class]]) {
        delegate = [[MTTVShowDetailViewControllerDelegate alloc] initWithTVSeasonMode:(TVSeason *)model];
    }
    
    return delegate;
}

@end
