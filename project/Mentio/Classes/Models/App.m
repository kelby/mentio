//
//  App.m
//  Mentio
//
//  Created by Martin Hartl on 16/12/13.
//  Copyright (c) 2013 Martin Hartl. All rights reserved.
//

#import "App.h"

@interface App ()

@property (nonatomic, strong) NSArray *screenshotsURLsArray;

@end

@implementation App

@synthesize protItemId, protArtworkUrl, protArtistName, protTitle, protCollectionViewUrl, protCopyright, protCurrency, protIconFileName, protNotes, protPrice, itunesUrl;

#pragma mark - FCModel overwrite

- (id)valueOfFieldName:(NSString *)fieldName byResolvingReloadConflictWithDatabaseValue:(id)valueInDatabase {
    return [self valueForKeyPath:fieldName];
}

#pragma mark - Property getter

- (int64_t)protItemId {
    return self.trackId;
}

- (BOOL)shouldInsert {
    self.createdAt = [NSDate date];
    self.updatedAt = self.createdAt;

    self.orderValue = [self calculateOrderValue];
    
    return YES;
}

- (BOOL)shouldUpdate {
    self.updatedAt= [NSDate date];
    return YES;
}

- (NSString *)protArtistName {
    return self.artistName;
}

- (void)setProtArtistName:(NSString *)artistName {
    self.artistName = artistName;
}

- (NSString *)protArtworkUrl {
    return self.artworkUrl100;
}

- (NSString *)protTitle {
    return self.trackName;
}

- (void)setProtTitle:(NSString *)title {
    self.trackName = title;
}
- (NSString *)protCopyright {
    return nil;
}

- (NSString *)protCollectionViewUrl {
    return self.trackViewUrl;
}

- (NSString *)protCurrency {
    return self.currency;
}

- (NSString *)itunesUrl {
   return self.trackViewUrl;
}

- (NSNumber *)protPrice {
    return self.price;
}

- (NSArray *)screenshotsURLs {
    
    if (self.screenshotsURLsArray == nil) {
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:[self.screenshots dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        NSMutableArray *mutarr = [NSMutableArray arrayWithCapacity:arr.count];
        [arr enumerateObjectsUsingBlock:^(NSString *urlString, NSUInteger idx, BOOL *stop) {
            [mutarr addObject:[NSURL URLWithString:urlString]];
        }];
        
        self.screenshotsURLsArray =[NSArray arrayWithArray:mutarr];
    }
    
    return self.screenshotsURLsArray;
}

- (NSString *)protIconFileName {
    return [NSString stringWithFormat:@"%@%lu",NSStringFromClass([self class]),(unsigned long)self.protItemId];
}

- (NSString *)protNotes {
    return self.notes;
}

- (void)setProtNotes:(NSString *)notes {
    self.notes = notes;
}

@end
