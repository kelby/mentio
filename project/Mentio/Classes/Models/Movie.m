//
//  Movie.m
//  Mentio
//
//  Created by Martin Hartl on 24/10/13.
//  Copyright (c) 2013 Martin Hartl. All rights reserved.
//

#import "Movie.h"


@implementation Movie

@synthesize protItemId, protArtworkUrl, protArtistName, protTitle, protCollectionViewUrl, protCopyright, protCurrency, protIconFileName, protNotes, protPrice, itunesUrl;

#pragma mark - FCModel overwrite

- (id)valueOfFieldName:(NSString *)fieldName byResolvingReloadConflictWithDatabaseValue:(id)valueInDatabase {
    return [self valueForKeyPath:fieldName];
}

#pragma mark - Property getter

- (int64_t)protItemId {
    return self.collectionId;
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

- (NSString *)protCopyright {
    return self.copyright;
}

- (NSString *)protTitle {
    return self.title;
}

- (void)setProtTitle:(NSString *)title {
    self.title = title;
}

- (NSString *)itunesUrl {
    return self.collectionViewUrl;
}

- (NSNumber *)protPrice {
    return self.collectionPrice;
}

- (NSString *)protCurrency {
    return self.currency;
}

- (NSString *)protCollectionViewUrl {
    return self.collectionViewUrl;
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
