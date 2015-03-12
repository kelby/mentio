//
//  MTSearchDetailViewController.h
//  Mentio
//
//  Created by Martin Hartl on 11/10/13.
//  Copyright (c) 2013 Martin Hartl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicAlbum.h"
#import "MTDetailViewController.h"

@interface MTMusicDetailViewControllerDelegate : NSObject <MTDetailViewControllerDelegate, MHSegmentedViewDelegate>

- (instancetype)initWithDetailMusicModel:(MusicAlbum *)musicAlbum;;

- (void)setup;

@end
