//
//  MTSearchAppViewController.m
//  Mentio
//
//  Created by Martin Hartl on 17/12/13.
//  Copyright (c) 2013 Martin Hartl. All rights reserved.
//

#import "MTSearchAppViewControllerDelegate.h"
#import "MTItunesClient.h"
#import "UIAlertView+MTHelpers.h"
#import "App.h"

@interface MTSearchAppViewControllerDelegate ()

@end

@implementation MTSearchAppViewControllerDelegate

#pragma mark - MTSearchViewControllerDelegate

- (NSString *)detailSegueIdentifier {
    return @"showAppDetail";
}

- (NSString *)emptyStatePromtString {
   return NSLocalizedString(@"mtsearchappviewcontroller.searchsomething", @"search something");
}

- (NSString *)emptyStateNoDataFoundString {
    return NSLocalizedString(@"mtsearchappviewcontroller.noappfound", @"no app found");
}

- (NSString *)mediaTypeToSearch {
    return MTItunesMediaTypeSoftware;
}

- (NSString *)mediaEntityToSearch {
    return MTItunesMediaEntityApp;
}

- (FCModel<MTModelProtocol> *)newOwnMediaModel {
    App *newApp = [App new];
    newApp.ownMedia = YES;
    return newApp;
}

#pragma mark - Helper



@end
