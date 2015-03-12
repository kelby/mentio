//
//  MTContainerViewController.m
//  Mentio
//
//  Created by Martin Hartl on 27/03/14.
//  Copyright (c) 2014 Martin Hartl. All rights reserved.
//

#import "MTContainerViewController.h"
#import "MTSegueConstants.h"

@interface MTContainerViewController ()

@end

@implementation MTContainerViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:MTShowSearchIdentifier]) {
        MTSearchViewController *dest = segue.destinationViewController;
        dest.delegate = self.searchViewControllerDelegate;
    }
}

@end
