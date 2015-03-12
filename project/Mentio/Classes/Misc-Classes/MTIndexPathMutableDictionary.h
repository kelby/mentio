//
//  MTIndexPathMutableDictionary.h
//  Mentio
//
//  Created by Martin Hartl on 25/10/13.
//  Copyright (c) 2013 Martin Hartl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTIndexPathMutableDictionary : NSObject

+ (instancetype)dictionary;

- (NSInteger)numberOfSections;
- (void)reloadArrayForSection:(NSInteger)section archived:(BOOL)archived;
- (NSMutableArray *)arrayForIndexPathSection:(NSInteger)section;
- (void)updateArrayOrders;
- (void)updateArrayOrderForSection:(NSInteger)section;
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)nilOrEmptyArrayForSection:(NSInteger)section;

@end
