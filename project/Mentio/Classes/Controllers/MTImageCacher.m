//
//  MTImageCacher.m
//  Mentio
//
//  Created by Martin Hartl on 17/01/14.
//  Copyright (c) 2014 Martin Hartl. All rights reserved.
//

#import "MTImageCacher.h"

NSString *const imagesFolderPath = @"/images/";
NSString *const tempFolderPath = @"/temp/";

@implementation MTImageCacher

+ (instancetype)sharedInstance {
    static MTImageCacher *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[MTImageCacher alloc] init];
        [_sharedInstance createImageFolder];
        [_sharedInstance clearTempFolder];
        [_sharedInstance createTempFolder];
    });
    
    return _sharedInstance;
}

- (void)saveImage: (UIImage*)image name:(NSString *)name type:(MTImageChacheType)type {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        if (image != nil) {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                 NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString* path;
            
            if (type == MTImageCacheTypeForTemporarilyUsage) {
                path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", tempFolderPath,name]];
            } else {
                path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", imagesFolderPath,name]];
            }
            NSData* data = UIImagePNGRepresentation(image);
            [data writeToFile:path atomically:YES];
        }
    });
}

- (void)deleteImageNamed:(NSString *)name type:(MTImageChacheType)type {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSFileManager *fm = [NSFileManager defaultManager];
        NSString* path;
        if (type == MTImageCacheTypeForTemporarilyUsage) {
            path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", tempFolderPath,name]];
        } else {
            path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", imagesFolderPath,name]];
        }
        NSError *error = nil;
        [fm removeItemAtPath:path error:&error];
    });
}

- (void)loadImageNamed:(NSString *)name type:(MTImageChacheType)type completion:(void (^) (UIImage *image))completion  {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path;
        if (type == MTImageCacheTypeForTemporarilyUsage) {
            path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", tempFolderPath,name]];
        } else {
            path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", imagesFolderPath,name]];
        }

        UIImage* image = [UIImage imageWithContentsOfFile:path];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            //main thread
            completion(image);
        });
    });
    
}

- (BOOL)clearTempFolder {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *directory = [documentsDirectoryPath stringByAppendingPathComponent:tempFolderPath];
    NSError *error = nil;
    BOOL succes = [fm removeItemAtPath:directory error:&error];
    return succes;
}

- (void)createTempFolder {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:tempFolderPath];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil]; //Create folder
}

- (BOOL)clearImageFolder {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *directory = [documentsDirectoryPath stringByAppendingPathComponent:imagesFolderPath];
    NSError *error = nil;
    BOOL succes = [fm removeItemAtPath:directory error:&error];
    return succes;
}

- (void)createImageFolder {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:imagesFolderPath];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil]; //Create folder
}

@end
