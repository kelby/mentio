//
//  MTMovieDetailViewController.h
//  Mentio
//
//  Created by Martin Hartl on 26/10/13.
//  Copyright (c) 2013 Martin Hartl. All rights reserved.
//

#import "MTDetailViewController.h"
#import "Movie.h"
#import "MHSegmentedView.h"

@interface MTMovieDetailViewControllerDelegate : NSObject <MTDetailViewControllerDelegate, MHSegmentedViewDelegate>

- (instancetype)initWithMovieModel:(Movie *)movieModel;

@end
