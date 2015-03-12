//
//  TVSeason.h
//  Mentio
//
//  Created by Martin Hartl on 09/02/14.
//  Copyright (c) 2014 Martin Hartl. All rights reserved.
//

#import "FCModel+CalculatedOrderValue.h"
#import "MTModelProtocol.h"
#import "FCModel.h"

@interface TVSeason : FCModel <MTModelProtocol>

@property (nonatomic) NSDate *createdAt;
@property (nonatomic) NSDate *updatedAt;
@property (nonatomic, assign) BOOL archived;
@property (nonatomic, assign) BOOL ownMedia;
@property (nonatomic, assign) int64_t orderValue;

@property (nonatomic, assign) int64_t artistId;
@property (nonatomic) NSString *artistName;
@property (nonatomic) NSString *collectionName;
@property (nonatomic) NSString *collectionCensoredName;
@property (nonatomic, assign) int64_t collectionId;
@property (nonatomic) NSString *copyright;
@property (nonatomic) NSString *artworkUrl100;
@property (nonatomic) NSNumber *collectionPrice;
@property (nonatomic) NSString *currency;
@property (nonatomic) NSString *collectionViewUrl;
@property (nonatomic) NSString *seasonDescription; //longDescription
@property (nonatomic) NSDate *releaseDate;
@property (nonatomic) NSString *notes;

@end
