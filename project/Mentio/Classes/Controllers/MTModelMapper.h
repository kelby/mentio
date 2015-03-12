//
//  MTModelMapper.h
//  Mentio
//
//  Created by Martin Hartl on 04/10/13.
//  Copyright (c) 2013 Martin Hartl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTModelMapper : NSObject

+ (id)createModelWithDictionary:(NSDictionary *)dict;
+ (id<MTModelProtocol>)modelForPrimaryKeyInDictionary:(NSDictionary *)dict;


@end
