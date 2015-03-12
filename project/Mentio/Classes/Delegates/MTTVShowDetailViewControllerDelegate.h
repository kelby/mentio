//
//  MTTVShowDetailViewController.h
//  Mentio
//
//  Created by Martin Hartl on 09/02/14.
//  Copyright (c) 2014 Martin Hartl. All rights reserved.
//

#import "MTDetailViewController.h"
#import "TVSeason.h"

@interface MTTVShowDetailViewControllerDelegate : NSObject <MHSegmentedViewDelegate, MTDetailViewControllerDelegate>

- (instancetype)initWithTVSeasonMode:(TVSeason *)seasonModel;

@end
