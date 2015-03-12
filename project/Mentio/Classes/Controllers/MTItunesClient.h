//
//  MTItunesClient.h
//  Mentio
//
//  Created by Martin Hartl on 04/10/13.
//  Copyright (c) 2013 Martin Hartl. All rights reserved.
//

#import "FCModel.h"
#import <AFNetworking/AFHTTPSessionManager.h>

extern NSString *const MTItunesMediaTypeAll;
extern NSString *const MTItunesMediaTypeMusic;
extern NSString *const MTItunesMediaTypeMovie;
extern NSString *const MTItunesMediaTypeMusicVideo;
extern NSString *const MTItunesMediaTypeTVShow;
extern NSString *const MTItunesMediaTypeAudiobook;
extern NSString *const MTItunesMediaTypeEBook;
extern NSString *const MTItunesMediaTypePodcast;
extern NSString *const MTItunesMediaTypeShortFilm;
extern NSString *const MTItunesMediaTypeSoftware;
extern NSString *const MTItunesMediaTypeBook;

extern NSString *const MTItunesMediaEntityAlbum;
extern NSString *const MTItunesMediaEntityMovie;
extern NSString *const MTItunesMediaEntitySong;
extern NSString *const MTItunesMediaEntityApp;
extern NSString *const MTItunesMediaEntityBook;
extern NSString *const MTItunesMediaEntityTVShow;
extern NSString *const MTItunesMediaEntityTVEpisode;
extern NSString *const MTItunesMediaEntityTVSeason;

extern NSString *const MTItunesSelectedCountryCode;

typedef void (^MHItunesCompletionBlock)(NSArray *results, NSError *error);
typedef void (^MHDotOhFixCompletionBlock)(NSString *collectionViewUrl, int64_t collectionId, NSString *trackCensoredName, NSError *error);

@interface MTItunesClient : AFHTTPSessionManager

+ (MTItunesClient *)sharedClient;

@property (nonatomic, strong) NSString *selectedCountryCode;

- (id)searchMediaWithType:(NSString *)type entity:(NSString *)entity keyword:(NSString *)keywords limit:(NSUInteger)limit completion:(MHItunesCompletionBlock)completion;

- (id)lookupMediaWithType:(NSString *)type entitiy:(NSString *)entitiy byId:(int64_t)mediaId completion:(MHItunesCompletionBlock)completion;

- (id)updateMedia:(NSArray *)mediaArray completion:(MHItunesCompletionBlock)completion;

- (void)refreshAllMedia:(MHItunesCompletionBlock)completion;

@end
