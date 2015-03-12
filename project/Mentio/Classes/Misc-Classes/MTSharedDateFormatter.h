//
//  MTSharedDateFormatter.h
//  Mentio
//
//  Created by Martin Hartl on 03/12/13.
//  Copyright (c) 2013 Martin Hartl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTSharedDateFormatter : NSDateFormatter

+ (instancetype)sharedInstace;

- (NSString *)configuredFormatStringFromDate:(NSDate *)date;
- (NSDate *)configuredFormatDateFromString:(NSString *)string;

@end
