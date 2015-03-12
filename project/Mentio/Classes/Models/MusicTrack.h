//
//  MusicTrack.h
//  Mentio
//
//  Created by Martin Hartl on 12/10/13.
//  Copyright (c) 2013 Martin Hartl. All rights reserved.
//

#import "FCModel+CalculatedOrderValue.h"
#import "MTModelProtocol.h"

@interface MusicTrack : FCModel

@property (nonatomic) NSDate *createdAt;
@property (nonatomic) NSDate *updatedAt;
@property (nonatomic, assign) int64_t collectionId;

@property (nonatomic) NSString *artistName;
@property (nonatomic) NSString *trackName;
@property (nonatomic, assign) int64_t trackNumber;
@property (nonatomic, assign) int64_t trackId;

@end
