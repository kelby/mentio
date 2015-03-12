//
//  MusicTrack.m
//  Mentio
//
//  Created by Martin Hartl on 12/10/13.
//  Copyright (c) 2013 Martin Hartl. All rights reserved.
//

#import "MusicTrack.h"

@implementation MusicTrack 


#pragma mark - FCModel overwrite

- (id)valueOfFieldName:(NSString *)fieldName byResolvingReloadConflictWithDatabaseValue:(id)valueInDatabase {
    return [self valueForKeyPath:fieldName];
}

- (BOOL)shouldInsert {
    self.createdAt = [NSDate date];
    self.updatedAt = self.createdAt;
    return YES;
}

- (BOOL)shouldUpdate {
    self.updatedAt= [NSDate date];
    return YES;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Track: %@ - %@", self.artistName, self.trackName];
}

#pragma mark - Model-Protocol

- (NSString *)protArtistName {
    return self.artistName;
}

- (NSString *)protTitle {
    return  self.trackName;
}

@end
