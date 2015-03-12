//
//  Book.h
//  Mentio
//
//  Created by Martin Hartl on 08/02/14.
//  Copyright (c) 2014 Martin Hartl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTModelProtocol.h"
#import "FCModel+CalculatedOrderValue.h"

@interface Book : FCModel <MTModelProtocol>

@property (nonatomic) NSDate *createdAt;
@property (nonatomic) NSDate *updatedAt;
@property (nonatomic, assign) BOOL archived;
@property (nonatomic, assign) BOOL ownMedia;
@property (nonatomic, assign) int64_t orderValue;

@property (nonatomic, assign) int64_t artistId;
@property (nonatomic) NSString *artistName;
@property (nonatomic) NSString *title; //trackName
@property (nonatomic) NSString *titleCensoredName; //trackCensoredName
@property (nonatomic, assign) int64_t trackId;
@property (nonatomic) NSString *copyright;
@property (nonatomic) NSString *artworkUrl100;
@property (nonatomic) NSNumber *price; //price
@property (nonatomic) NSString *currency;
@property (nonatomic) NSString *trackViewUrl; //trackViewUrl
@property (nonatomic) NSString *bookDescription;
@property (nonatomic) NSDate *releaseDate;
@property (nonatomic) NSString *notes;

@end
