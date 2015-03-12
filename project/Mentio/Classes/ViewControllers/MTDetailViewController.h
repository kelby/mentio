//
//  MTDetailViewController.h
//  Mentio
//
//  Created by Martin Hartl on 22/10/13.
//  Copyright (c) 2013 Martin Hartl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTModelProtocol.h"
#import "FCModel.h"
#import "MHSegmentedView.h"
#import "MHAlbumView.h"


@protocol MTDetailViewControllerDelegate <NSObject>

- (NSURL *)largeCoverImageURL;
- (void)setup;

@end

@interface MTDetailViewController : UIViewController

@property (nonatomic, strong) FCModel<MTModelProtocol> *detailModel;

@property (weak, nonatomic) IBOutlet MHSegmentedView *ibSegmentedView;
@property (weak, nonatomic) IBOutlet MHAlbumView *ibAlbumView;

@property (strong, nonatomic) id<MTDetailViewControllerDelegate, MHSegmentedViewDelegate> detailViewDelegate;

@property (nonatomic, assign) BOOL fromSearchViewController;
@property (nonatomic, assign) BOOL fromArchiveViewController;

@end
