//
//  MTIndexPathMutableDictionary.m
//  Mentio
//
//  Created by Martin Hartl on 25/10/13.
//  Copyright (c) 2013 Martin Hartl. All rights reserved.
//

#import "MTIndexPathMutableDictionary.h"
#import "App.h"
#import "Movie.h"
#import "Book.h"
#import "TVSeason.h"
#import "MusicAlbum.h"

@interface MTIndexPathMutableDictionary ()

@property (nonatomic, strong) NSMutableDictionary *dict;

@end

@implementation MTIndexPathMutableDictionary

- (id)init {
    self = [super init];
    if (self) {
        _dict = [NSMutableDictionary dictionary];
    }
    
    return self;
}

+ (instancetype)dictionary {
    return [[self alloc] init];
}

#pragma mark - Methods

- (NSInteger)numberOfSections {
    return [self.dict allKeys].count;
}

- (NSMutableArray *)arrayForIndexPathSection:(NSInteger)section {
    return [self.dict objectForKey:@(section)];
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = indexPath.row;
    NSArray *arrayForKey = [self.dict objectForKey:@(indexPath.section)];
    if (arrayForKey.count > row) {
        return arrayForKey[indexPath.row];
    }
    return nil;
}

- (void)reloadArrayForSection:(NSInteger)section archived:(BOOL)archived {
    
    NSString *queryString = [NSString stringWithFormat:@"archived = %d ORDER BY orderValue", archived];
    
    if (section == 0) {
        [self setArray:[MusicAlbum instancesWhere:queryString] forSection:section];
    } else if (section == 1) {
        [self setArray:[Movie instancesWhere:queryString] forSection:section];
    } else if (section == 2) {
        [self setArray:[App instancesWhere:queryString] forSection:section];
    } else if (section == 3) {
        [self setArray:[Book instancesWhere:queryString] forSection:section];
    } else if (section == 4) {
        [self setArray:[TVSeason instancesWhere:queryString] forSection:section];
    }
}

- (void)updateArrayOrders {
    for (NSMutableArray *array in [self.dict allValues]) {
        [array enumerateObjectsUsingBlock:^(FCModel<MTModelProtocol> *model, NSUInteger idx, BOOL *stop) {
            model.orderValue = idx;
        }];
    }
}

- (void)updateArrayOrderForSection:(NSInteger)section {
    [[self.dict objectForKey:@(section)] enumerateObjectsUsingBlock:^(FCModel<MTModelProtocol> *model, NSUInteger idx, BOOL *stop) {
        int64_t iidx = idx;
        if (model.orderValue != iidx) {
            model.orderValue = idx;
            [model save];
        }


    }];
}

- (void)setArray:(NSArray *)array forSection:(NSInteger)section {
    [self.dict setObject:array forKey:@(section)];
}

- (BOOL)nilOrEmptyArrayForSection:(NSInteger)section {
    NSArray *array = [self arrayForIndexPathSection:section];
    if (array == nil || array.count == 0) {
        return YES;
    }
    return NO;
}


@end
