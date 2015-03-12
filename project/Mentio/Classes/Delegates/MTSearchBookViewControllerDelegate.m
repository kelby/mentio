//
//  MTSearchBookViewController.m
//  Mentio
//
//  Created by Martin Hartl on 08/02/14.
//  Copyright (c) 2014 Martin Hartl. All rights reserved.
//

#import "MTSearchBookViewControllerDelegate.h"
#import "MTItunesClient.h"
#import "UIAlertView+MTHelpers.h"
#import "Book.h"

static NSString *const MTBookDetailSegueIdentifier = @"showBookDetail";

@interface MTSearchBookViewControllerDelegate ()

@end

@implementation MTSearchBookViewControllerDelegate


#pragma mark - MTSearchViewControllerDelegate

- (NSString *)detailSegueIdentifier {
    return MTBookDetailSegueIdentifier;
}

- (NSString *)emptyStatePromtString {
    return NSLocalizedString(@"mtsearchbookviewcontroller.searchsomething", @"search something");
}

- (NSString *)emptyStateNoDataFoundString {
    return NSLocalizedString(@"mtsearchbookviewcontroller.nobookfound", @"no app found");
}

- (NSString *)mediaEntityToSearch {
    return MTItunesMediaEntityBook;
}

- (NSString *)mediaTypeToSearch {
    return MTItunesMediaTypeBook;
}

- (FCModel<MTModelProtocol> *)newOwnMediaModel {
    Book *newBook = [Book new];
    newBook.ownMedia = YES;
    return newBook;
}


@end
