//
//  App.h
//  Mentio
//
//  Created by Martin Hartl on 16/12/13.
//  Copyright (c) 2013 Martin Hartl. All rights reserved.
//

#import "FCModel+CalculatedOrderValue.h"
#import "MTModelProtocol.h"

@interface App : FCModel <MTModelProtocol>

@property (nonatomic) NSDate *createdAt;
@property (nonatomic) NSDate *updatedAt;
@property (nonatomic, assign) BOOL archived;
@property (nonatomic, assign) BOOL ownMedia;
@property (nonatomic, assign) int64_t orderValue;

@property (nonatomic, assign) int64_t trackId;
@property (nonatomic, assign) int64_t artistId;
@property (nonatomic) NSString *artistName;
@property (nonatomic) NSString *trackName;
@property (nonatomic) NSString *artworkUrl100;
@property (nonatomic) NSString *trackViewUrl;
@property (nonatomic) NSString *currency;
@property (nonatomic) NSNumber *price;
@property (nonatomic) NSString *screenshots;
@property (nonatomic) NSDate *releaseDate;
@property (nonatomic) NSString *appDescription;
@property (nonatomic) NSString *appVersion;
@property (nonatomic) NSString *primaryGenreName;
@property (nonatomic) NSString *notes;

- (NSArray *)screenshotsURLs;


@end
