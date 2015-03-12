//
//  MTAppDetailViewController.h
//  Mentio
//
//  Created by Martin Hartl on 17/12/13.
//  Copyright (c) 2013 Martin Hartl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTDetailViewController.h"
#import "App.h"

@interface MTAppDetailViewControllerDelegate : NSObject <MTDetailViewControllerDelegate, MHSegmentedViewDelegate>

- (instancetype)initWithAppModel:(App *)appModel;
- (void)loadScreenshots;

@end
