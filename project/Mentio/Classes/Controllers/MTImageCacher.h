//
//  MTImageCacher.h
//  Mentio
//
//  Created by Martin Hartl on 17/01/14.
//  Copyright (c) 2014 Martin Hartl. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MTImageChacheType) {
    MTImageCacheTypeForTemporarilyUsage,
    MTImageCacheTypeForPersistentUsage
};


@interface MTImageCacher : NSObject

+ (instancetype)sharedInstance;

- (void)loadImageNamed:(NSString *)name type:(MTImageChacheType)type completion:(void (^) (UIImage *image))completion;

- (void)saveImage: (UIImage*)image name:(NSString *)name type:(MTImageChacheType)type;
- (BOOL)clearTempFolder;
- (BOOL)clearImageFolder;
- (void)createImageFolder;

- (void)deleteImageNamed:(NSString *)name type:(MTImageChacheType)type;

@end
