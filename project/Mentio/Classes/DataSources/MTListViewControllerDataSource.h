//
//  MTListViewControllerDataSource.h
//  Mentio
//
//  Created by Martin Hartl on 25/10/13.
//  Copyright (c) 2013 Martin Hartl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTIndexPathMutableDictionary.h"
#import "MTScrollCell.h"

/// Definition of the sections in the MTListViewController
typedef NS_ENUM(NSInteger, MTIndexPathSectionhMediaType) {
    MTSectionTypeMusic,
    MTSectionTypeMovie,
    MTSectionTypeApp,
    MTSectionTypeBook,
    MTSectionTypeTVShow
};

typedef void (^ConfigureCellBlock)(MTScrollCell*, id);

@interface MTListViewControllerDataSource : NSObject <UITableViewDataSource>

- (instancetype)initWithIndexPathMutableDict:(MTIndexPathMutableDictionary *)dict archive:(BOOL)archive;

- (void)tableView:(UITableView *)tableView deleteRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView archiveOrUnarchive:(BOOL)archive rowAtIndexPath:(NSIndexPath *)indexPath;
- (void)saveSectionToDatabase:(NSInteger)section;

@end
