//
//  UIAlertView+MTHelpers.m
//  Mentio
//
//  Created by Martin Hartl on 13/01/14.
//  Copyright (c) 2014 Martin Hartl. All rights reserved.
//

#import "UIAlertView+MTHelpers.h"

@implementation UIAlertView (MTHelpers)

+ (void)showNoInternetWarning {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"noInternetWarningTitle", @"noInternetWarningTitle") message:NSLocalizedString(@"noInternetWarningMessage", @"noInternetWarningMessage") delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", @"Ok") otherButtonTitles: nil];
    [alert show];
}

@end
