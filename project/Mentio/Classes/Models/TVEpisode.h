//
//  TVEpisode.h
//  Mentio
//
//  Created by Martin Hartl on 09/02/14.
//  Copyright (c) 2014 Martin Hartl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCModel.h"

@interface TVEpisode : FCModel

@property (nonatomic) NSDate *createdAt;
@property (nonatomic) NSDate *updatedAt;
@property (nonatomic, assign) int64_t collectionId;

@property (nonatomic) NSString *artistName;
@property (nonatomic) NSString *trackName;
@property (nonatomic, assign) int64_t trackNumber;
@property (nonatomic) NSString *trackViewUrl; //trackViewUrl
@property (nonatomic) NSNumber *price; //trackPrice
@property (nonatomic) NSString *currency;
@property (nonatomic) NSString *episodeDescription; //longDescription
@property (nonatomic, assign) int64_t trackId;


@end
