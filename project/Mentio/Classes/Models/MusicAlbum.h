//
//  Person.h
//  Mentio
//
//  Created by Martin Hartl on 04/10/13.
//  Copyright (c) 2013 Martin Hartl. All rights reserved.
//

#import "FCModel+CalculatedOrderValue.h"
#import "MTModelProtocol.h"

@interface MusicAlbum : FCModel <MTModelProtocol>

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
@property (nonatomic) NSDate *releaseDate;
@property (nonatomic) NSString *notes;


@end
