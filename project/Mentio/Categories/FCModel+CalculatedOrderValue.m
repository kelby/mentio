//
//  FCModel+CalculatedOrderValue.m
//  Mentio
//
//  Created by Martin Hartl on 25/03/14.
//  Copyright (c) 2014 Martin Hartl. All rights reserved.
//

#import "FCModel+CalculatedOrderValue.h"

@implementation FCModel (CalculatedOrderValue)

- (int64_t)calculateOrderValue {
    __block int64_t max;
    __block int numberOfEntries;
    
    NSString *classString = NSStringFromClass([self class]);
    
    [FCModel inDatabaseSync:^(FMDatabase *db) {
        NSString *query = [NSString stringWithFormat:@"SELECT max(orderValue) FROM %@;", classString];
        FMResultSet *set = [db executeQuery:query];
        [set next];
        max = [set intForColumnIndex:0];
        [set close];
        
        NSString *query2 = [NSString stringWithFormat:@"SELECT COUNT(orderValue) FROM %@;", classString];
        FMResultSet *numberOfEntriesSet = [db executeQuery:query2];
        [numberOfEntriesSet next];
        numberOfEntries = [numberOfEntriesSet intForColumnIndex:0];
        [numberOfEntriesSet close];
    }];
    
    
    if (max == 0 && numberOfEntries == 0) {
        return max;
    }
    
    return max + 1;
}

@end
