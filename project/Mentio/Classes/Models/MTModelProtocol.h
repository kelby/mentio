//
//  MTModelProtocol.h
//  Mentio
//
//  Created by Martin Hartl on 06/10/13.
//  Copyright (c) 2013 Martin Hartl. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MTModelProtocol <NSObject>

@property (nonatomic, assign) int64_t orderValue;
@property (nonatomic, assign) BOOL ownMedia;
@property (nonatomic, assign) BOOL archived;

@property (nonatomic, assign) int64_t protItemId;
@property (nonatomic, strong) NSString *protArtistName;
@property (nonatomic, strong) NSString *protTitle;
@property (nonatomic, strong) NSString *protArtworkUrl;
@property (nonatomic, strong) NSString *protCopyright;
@property (nonatomic, strong) NSString *itunesUrl;
@property (nonatomic, strong) NSNumber *protPrice;
@property (nonatomic, strong) NSString *protCurrency;
@property (nonatomic, strong) NSString *protCollectionViewUrl;
@property (nonatomic, strong) NSString *protIconFileName;
@property (nonatomic, strong) NSString *protNotes;

@end
