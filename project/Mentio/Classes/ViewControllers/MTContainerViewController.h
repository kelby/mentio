//
//  MTContainerViewController.h
//  Mentio
//
//  Created by Martin Hartl on 27/03/14.
//  Copyright (c) 2014 Martin Hartl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTSearchViewController.h"

@interface MTContainerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) id<MTSearchViewControllerDelegate> searchViewControllerDelegate;

@end
