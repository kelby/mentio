//
//  MTSharedDateFormatter.m
//  Mentio
//
//  Created by Martin Hartl on 03/12/13.
//  Copyright (c) 2013 Martin Hartl. All rights reserved.
//

#import "MTSharedDateFormatter.h"

@implementation MTSharedDateFormatter

+ (instancetype)sharedInstace {
    static MTSharedDateFormatter *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[MTSharedDateFormatter alloc] init];
        [_sharedInstance setDateFormat:@"YYYY'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    });
    
    return _sharedInstance ;
}

- (NSDate *)configuredFormatDateFromString:(NSString *)string {
    [self setDateFormat:@"YYYY'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    return [self dateFromString:string];
}

- (NSString *)configuredFormatStringFromDate:(NSDate *)date {
    [self setLocale: [NSLocale currentLocale]];
    [self setDateStyle:NSDateFormatterShortStyle];
    [self setTimeStyle:NSDateFormatterNoStyle];
    return [self stringFromDate:date];
}

@end
