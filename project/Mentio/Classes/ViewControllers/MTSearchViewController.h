//
//  MTSearchViewController.h
//  Mentio
//
//  Created by Martin Hartl on 05/10/13.
//  Copyright (c) 2013 Martin Hartl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCModel.h"
#import "MTModelProtocol.h"

@protocol MTSearchViewControllerDelegate <NSObject>

- (NSString *)detailSegueIdentifier;
- (NSString *)emptyStatePromtString;
- (NSString *)emptyStateNoDataFoundString;
- (NSString *)mediaEntityToSearch;
- (NSString *)mediaTypeToSearch;
- (FCModel<MTModelProtocol> *)newOwnMediaModel;


@end

@interface MTSearchViewController : UIViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *ibSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;

@property (weak, nonatomic) id<MTSearchViewControllerDelegate> delegate;

@property (nonatomic, strong) NSArray *searchResults;

@end
